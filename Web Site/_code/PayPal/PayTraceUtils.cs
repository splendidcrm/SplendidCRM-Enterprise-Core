/**********************************************************************************************************************
 * SplendidCRM is a Customer Relationship Management program created by SplendidCRM Software, Inc. 
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 * SplendidCRM owns all proprietary rights, including all copyrights, patents, trade secrets, and 
 * trademarks, in and to the contents of this file.  You will not link to or in any way combine the 
 * contents of this file or any derivatives with any Open Source Code in any manner that would require 
 * the contents of this file to be made available to any third party. 
 * 
 * IN NO EVENT SHALL SPLENDIDCRM BE RESPONSIBLE FOR ANY DAMAGES OF ANY KIND, INCLUDING ANY DIRECT, 
 * SPECIAL, PUNITIVE, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES.  Other limitations of liability 
 * and disclaimers set forth in the License. 
 * 
 *********************************************************************************************************************/
using System;
using System.IO;
using System.Net;
using System.Web;
using System.Data;
using System.Data.Common;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Diagnostics;

using Microsoft.Extensions.Caching.Memory;

namespace SplendidCRM
{
	/// <summary>
	/// Summary description for PayTraceUtils.
	/// </summary>
	public class PayTraceUtils
	{
		private IMemoryCache         Cache              ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private Currency             Currency           = new Currency();
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private PayPalCache          PayPalCache        ;

		public PayTraceUtils(IMemoryCache memoryCache, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, PayPalCache PayPalCache)
		{
			this.Cache               = memoryCache        ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.PayPalCache         = PayPalCache        ;
		}

		private string CleanseData(string sValue)
		{
			sValue = sValue.Replace("|", String.Empty);
			sValue = sValue.Replace("~", String.Empty);
			sValue = sValue.Replace("+", String.Empty);
			sValue = sValue.Replace("=", String.Empty);
			return sValue;
		}

		private string PayTraceRequest(Dictionary<string, string> dictParams, string sLineItems)
		{
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create("https://paytrace.com/api/default.pay");
			objRequest.Headers.Add("cache-control", "no-cache");
			objRequest.KeepAlive         = false;
			objRequest.AllowAutoRedirect = false;
			objRequest.Timeout           = 120000;  // 120 seconds
			objRequest.ContentType       = "application/x-www-form-urlencoded";
			objRequest.Method            = "POST";
			
			StringBuilder sbParamList = new StringBuilder();
			foreach ( string sKey in dictParams.Keys )
			{
				if ( sbParamList.Length > 0 )
					sbParamList.Append("|");
				sbParamList.Append(sKey + "~" + dictParams[sKey]);
			}
			// 09/19/2013 Paul.  All the URL data must be URL Encoded in order for the line item data to be processed. 
			string sParamList = "PARMLIST=" + HttpUtility.UrlEncode(sbParamList.ToString() + sLineItems);
			objRequest.ContentLength = sParamList.Length;
			using ( StreamWriter stm = new StreamWriter(objRequest.GetRequestStream(), System.Text.Encoding.ASCII) )
			{
				stm.Write(sParamList);
			}
			
			string sResponse = String.Empty;
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse != null )
				{
					if ( objResponse.StatusCode != HttpStatusCode.OK && objResponse.StatusCode != HttpStatusCode.Found )
					{
						throw(new Exception("PayTrace API: " + objResponse.StatusCode + " " + objResponse.StatusDescription));
					}
					else
					{
						using ( StreamReader stm = new StreamReader(objResponse.GetResponseStream()) )
						{
							sResponse = stm.ReadToEnd();
							if ( Sql.IsEmptyString(sResponse) )
							{
								throw(new Exception("PayTrace API: Response was empty."));
							}
						}
					}
				}
			}
			return sResponse;
		}

		public string ValidateLogin(string sUserName, string sPassword)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			
			// http://help.paytrace.com/api-exporting-customer-profiles
			// UN, PSWD, TERMS, METHOD, TRANXID
			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string UN            = sUserName;
			string PSWD          = sPassword;
			string TERMS         = "Y"              ;  // Must be to 'Y' in order to process any methods through the PayTrace API. 
			string METHOD        = "ExportCustomers";  // Function that you are requesting PayTrace perform. 
			
			PSWD = Security.DecryptPassword(PSWD, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			dictParams.Add("UN"         , UN        );
			dictParams.Add("PSWD"       , PSWD      );
			dictParams.Add("TERMS"      , TERMS     );
			dictParams.Add("METHOD"     , METHOD    );
			
			string sSTATUS = String.Empty;
			try
			{
				string sResponse = PayTraceRequest(dictParams, String.Empty);
				string[] arrResponse = sResponse.Split('|');
				if ( sResponse.StartsWith("ERROR~") )
				{
					Dictionary<string, string> dictResponse = new Dictionary<string, string>();
					for ( int i = 0; i < arrResponse.Length; i++ )
					{
						string[] arrValue = arrResponse[i].Split('~');
						if ( arrValue.Length == 2 )
						{
							dictResponse.Add(arrValue[0].ToUpper(), arrValue[1]);
						}
					}
					if ( dictResponse.ContainsKey("ERROR") )
					{
						// 09/19/2013 Paul.  Don't throw an exception when there is no data so that the table will rebind. 
						// ERROR~185. No customers were found with these criteria.
						if ( !sResponse.StartsWith("ERROR~185") )
							sSTATUS = dictResponse["ERROR"];
					}
				}
			}
			catch(Exception ex)
			{
				sSTATUS = ex.Message;
			}
			return sSTATUS;
		}

		// 12/15/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
		public void UpdateCustomerProfile(ref Guid gID, string sNAME, string sCREDIT_CARD_NUMBER, string sSECURITY_CODE, int nEXPIRATION_MONTH, int nEXPIRATION_YEAR, string sADDRESS_STREET, string sADDRESS_CITY, string sADDRESS_STATE, string sADDRESS_POSTALCODE, string sADDRESS_COUNTRY, string sEMAIL, string sPHONE)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			sNAME               = CleanseData(sNAME              );
			sCREDIT_CARD_NUMBER = CleanseData(sCREDIT_CARD_NUMBER);
			sSECURITY_CODE      = CleanseData(sSECURITY_CODE     );
			sADDRESS_STREET     = CleanseData(sADDRESS_STREET    );
			sADDRESS_CITY       = CleanseData(sADDRESS_CITY      );
			sADDRESS_STATE      = CleanseData(sADDRESS_STATE     );
			sADDRESS_POSTALCODE = CleanseData(sADDRESS_POSTALCODE);
			sADDRESS_COUNTRY    = CleanseData(sADDRESS_COUNTRY   );
			sEMAIL              = CleanseData(sEMAIL             );
			sPHONE              = CleanseData(sPHONE             );
			
			// http://help.paytrace.com/api-create-customer-profile
			// http://help.paytrace.com/api-update-customer-profile
			// http://help.paytrace.com/paytrace-api-name-value-pairs-data-definitions
			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string UN        = Sql.ToString(Application["CONFIG.PayTrace.UserName"]);
			string PSWD      = Sql.ToString(Application["CONFIG.PayTrace.Password"]);
			string TERMS     = "Y"                 ;  // Must be to 'Y' in order to process any methods through the PayTrace API. 
			string METHOD    = "UpdateCustomer"    ;  // Assume update, unless gID is empty.  Then use CreateCustomer. 
			string CUSTID    = String.Empty        ;  // Unique identifier for a customer profile. Each customer must have their own unique ID. 
			string BNAME     = sNAME               ;  // Name that appears of the credit card. 
			string CC        = sCREDIT_CARD_NUMBER ;  // Customer's credit card number must be a valid credit card number that your PayTrace account is set up to accept. 
			string CSC       = sSECURITY_CODE      ;  // CSC is the 3 or 4 digit code found on the signature line of the credit card. 
			string EXPMNTH   = nEXPIRATION_MONTH.ToString("00"  );                  // Expiration month must be the two-digit month of the credit cards expiration date. 
			string EXPYR     = nEXPIRATION_YEAR .ToString("0000").Substring(2, 2);  // Expiration year must be the two digit year of the credit cards expiration date. 
			string BADDRESS  = sADDRESS_STREET     ;  // Address that the credit card statement is delivered. 
			string BADDRESS2 = String.Empty        ;  // Second line of the address the credit card statement is delivered. 
			string BCITY     = sADDRESS_CITY       ;  // City that the credit card statement is delivered. 
			string BSTATE    = sADDRESS_STATE      ;  // State that the credit card statement is delivered. 
			string BZIP      = sADDRESS_POSTALCODE ;  // Zip code that the credit card statement is delivered. 
			string BCOUNTRY  = sADDRESS_COUNTRY    ;  // Country code where the billing address is located. 
			string SNAME     = String.Empty        ;  // Name of the person where the product is delivered. 
			string SADDRESS  = String.Empty        ;  // Address where the product is delivered. 
			string SADDRESS2 = String.Empty        ;  // Second line of the address where the product is delivered. 
			string SCITY     = String.Empty        ;  // City where the product is delivered. 
			string SCOUNTY   = String.Empty        ;  // County where the product is delivered. 
			string SSTATE    = String.Empty        ;  // State where the product is delivered. 
			string SZIP      = String.Empty        ;  // Zip code where the product is delivered. 
			string SCOUNTRY  = String.Empty        ;  // County where the product is delivered. 
			string EMAIL     = sEMAIL              ;  // Customer's email address where the sales receipt may be sent. 
			string PHONE     = sPHONE              ;  // Customer's phone number. 
			string FAX       = String.Empty        ;  // Customer's fax number. 
			string CUSTPSWD  = String.Empty        ;  // Password that customer uses to log into customer profile in shopping cart. Only required if you are using the PayTrace shopping cart. 
			string DDA       = String.Empty        ;  // Checking account number for processing check transactions or managing customer profiles. 
			string TR        = String.Empty        ;  // Transit routing number for processing check transactions or managing customer profiles. 
			
			PSWD = Security.DecryptPassword(PSWD, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			string[] arrBADDRESS = BADDRESS.Split(ControlChars.CrLf.ToCharArray());
			if ( arrBADDRESS.Length > 0 )
			{
				BADDRESS = arrBADDRESS[0];
				if ( arrBADDRESS.Length > 1 )
					BADDRESS2 = arrBADDRESS[1];
			}
			
			StringDictionary dictStates    = PayPalCache.States();
			StringDictionary dictCountries = PayPalCache.Countries();
			if ( BSTATE.Length > 2 )
			{
				if ( dictStates.ContainsKey(BSTATE) )
					BSTATE = dictStates[BSTATE];
			}
			if ( BCOUNTRY.Length > 2 )
			{
				if ( dictCountries.ContainsKey(BCOUNTRY) )
					BCOUNTRY = dictCountries[BCOUNTRY];
			}
			if ( BNAME.Length     > 50 ) BNAME     = BNAME    .Substring(0, 50);
			if ( BADDRESS.Length  > 50 ) BADDRESS  = BADDRESS .Substring(0, 50);
			if ( BADDRESS2.Length > 50 ) BADDRESS2 = BADDRESS2.Substring(0, 50);
			if ( BCITY.Length     > 50 ) BCITY     = BCITY    .Substring(0, 50);
			if ( BSTATE.Length    > 50 ) BSTATE    = BSTATE   .Substring(0, 50);
			if ( BZIP.Length      >  9 ) BZIP      = BZIP     .Substring(0,  9);
			if ( BCOUNTRY.Length  > 50 ) BCOUNTRY  = BCOUNTRY .Substring(0, 50);
			// 09/13/2013 Paul.  Use the Guid of the credit card as the CUSTID.  If a new credit card, then generate the ID. 
			// 09/13/2013 Paul.  Assume update, unless gID is empty.  Then use CreateCustomer. 
			if ( Sql.IsEmptyGuid(gID) )
			{
				gID = Guid.NewGuid();
				METHOD = "CreateCustomer";
			}
			CUSTID = gID.ToString();
			
			// 09/13/2013 Paul.  Required fields. 
			dictParams.Add("UN"         , UN       );
			dictParams.Add("PSWD"       , PSWD     );
			dictParams.Add("TERMS"      , TERMS    );
			dictParams.Add("METHOD"     , METHOD   );
			dictParams.Add("CUSTID"     , CUSTID   );
			dictParams.Add("BNAME"      , BNAME    );
			dictParams.Add("EXPMNTH"    , EXPMNTH  );
			dictParams.Add("EXPYR"      , EXPYR    );
			// 09/13/2013 Paul.  Optional fields. 
			if ( !Sql.IsEmptyString(CC       ) ) dictParams.Add("CC"         , CC       );
			if ( !Sql.IsEmptyString(CSC      ) ) dictParams.Add("CSC"        , CSC      );
			if ( !Sql.IsEmptyString(BADDRESS ) ) dictParams.Add("BADDRESS"   , BADDRESS );
			if ( !Sql.IsEmptyString(BADDRESS2) ) dictParams.Add("BADDRESS2"  , BADDRESS2);
			if ( !Sql.IsEmptyString(BCITY    ) ) dictParams.Add("BCITY"      , BCITY    );
			if ( !Sql.IsEmptyString(BSTATE   ) ) dictParams.Add("BSTATE"     , BSTATE   );
			if ( !Sql.IsEmptyString(BZIP     ) ) dictParams.Add("BZIP"       , BZIP     );
			if ( !Sql.IsEmptyString(BCOUNTRY ) ) dictParams.Add("BCOUNTRY"   , BCOUNTRY );
			if ( !Sql.IsEmptyString(SNAME    ) ) dictParams.Add("SNAME"      , SNAME    );
			if ( !Sql.IsEmptyString(SADDRESS ) ) dictParams.Add("SADDRESS"   , SADDRESS );
			if ( !Sql.IsEmptyString(SADDRESS2) ) dictParams.Add("SADDRESS2"  , SADDRESS2);
			if ( !Sql.IsEmptyString(SCITY    ) ) dictParams.Add("SCITY"      , SCITY    );
			if ( !Sql.IsEmptyString(SCOUNTY  ) ) dictParams.Add("SCOUNTY"    , SCOUNTY  );
			if ( !Sql.IsEmptyString(SSTATE   ) ) dictParams.Add("SSTATE"     , SSTATE   );
			if ( !Sql.IsEmptyString(SZIP     ) ) dictParams.Add("SZIP"       , SZIP     );
			if ( !Sql.IsEmptyString(SCOUNTRY ) ) dictParams.Add("SCOUNTRY"   , SCOUNTRY );
			if ( !Sql.IsEmptyString(EMAIL    ) ) dictParams.Add("EMAIL"      , EMAIL    );
			if ( !Sql.IsEmptyString(PHONE    ) ) dictParams.Add("PHONE"      , PHONE    );
			if ( !Sql.IsEmptyString(FAX      ) ) dictParams.Add("FAX"        , FAX      );
			if ( !Sql.IsEmptyString(CUSTPSWD ) ) dictParams.Add("CUSTPSWD"   , CUSTPSWD );
			if ( !Sql.IsEmptyString(DDA      ) ) dictParams.Add("DDA"        , DDA      );
			if ( !Sql.IsEmptyString(TR       ) ) dictParams.Add("TR"         , TR       );
			
			string sResponse = PayTraceRequest(dictParams, String.Empty);
			string[] arrResponse = sResponse.Split('|');
			// ERROR, RESPONSE, CUSTOMERID, CUSTID
			// RESPONSE~160. The customer profile for 3ab41d7d-6ecd-4b36-bc82-c52d20d8995e/Test5 was successfully created.|CUSTID~3ab41d7d-6ecd-4b36-bc82-c52d20d8995e|CUSTOMERID~3ab41d7d-6ecd-4b36-bc82-c52d20d8995e|
			Dictionary<string, string> dictResponse = new Dictionary<string, string>();
			for ( int i = 0; i < arrResponse.Length; i++ )
			{
				string[] arrValue = arrResponse[i].Split('~');
				if ( arrValue.Length == 2 )
					dictResponse.Add(arrValue[0].ToUpper(), arrValue[1]);
			}
			if ( dictResponse.ContainsKey("ERROR") )
			{
				throw(new Exception("PayTrace API Error: " + dictResponse["ERROR"]));
			}
			if ( dictResponse.ContainsKey("CUSTOMERID") )
			{
				// 09/13/2013 Paul.  Returned CUSTOMERID should be the same as the input CUSTID. 
				//sCARD_NUMBER = Security.EncryptPassword(dictResponse["CUSTOMERID"], gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			}
			// http://help.paytrace.com/api-response-codes
			if ( dictResponse.ContainsKey("RESPONSE") )
			{
				string sRESPONSE = dictResponse["RESPONSE"];
				// 160. The customer profile for 3ab41d7d-6ecd-4b36-bc82-c52d20d8995e/Test5 was successfully created.
				//if ( sRESPONSE.StartsWith("160.") )
				//	sSTATUS = "Success";
//#if DEBUG
//				Debug.WriteLine(sRESPONSE);
//#endif
			}
		}

		public string Charge(Guid gCURRENCY_ID, Guid gINVOICE_ID, Guid gPAYMENT_ID, Guid gCREDIT_CARD_ID, string sClientIP, string sDESCRIPTION)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			StringDictionary dictCountries = PayPalCache.Countries();
			Currency C10n = Currency.CreateCurrency(gCURRENCY_ID);
			if ( C10n.ISO4217 != "USD" )
				throw(new Exception(C10n.ISO4217 + " is not a supported currency on PayTrace."));
			
			// http://help.paytrace.com/api-authorizations
			// http://help.paytrace.com/api-adding-level-3-data-to-a-visa-sale
			// http://help.paytrace.com/paytrace-api-name-value-pairs-data-definitions
			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string UN            = Sql.ToString(Application["CONFIG.PayTrace.UserName"]);
			string PSWD          = Sql.ToString(Application["CONFIG.PayTrace.Password"]);
			string TERMS         = "Y"           ;  // Must be to 'Y' in order to process any methods through the PayTrace API. 
			string METHOD        = "ProcessTranx";  // Function that you are requesting PayTrace perform. 
			string TRANXTYPE     = "Sale"        ;  // Sale, Authorization, Str/Fwd, Refund, Void, Capture,Force and Deleteauthkey (Secure Checkout Only). 
			string CUSTID        = String.Empty  ;  // Unique identifier for a customer profile. 
			string AMOUNT        = String.Empty  ;  // Dollar amount of the transaction. Must be a positive number up to two decimal places. 
			string TRANXID       = String.Empty  ;  // A unique identifier for each transaction in the PayTrace system. This value is returned in the TRANSACTIONID parameter of an API response and will consequently be included in requests to email receipts, void transactions, add level 3 data, etc. 
			string CARD_TYPE     = String.Empty  ;
			
			// Visa and MasterCard Level 3 data. 
			string INVOICE       = String.Empty  ;  // Invoice is the identifier for this transaction in your accounting or inventory management system. 
			string CUSTREF       = String.Empty  ;  // Customer reference ID is only used for transactions that are identified as corporate or purchasing credit cards. 
			string TAX           = String.Empty  ;  // Portion of the original transaction amount that is tax. 
			string NTAX          = String.Empty  ;  // Portion of the original transaction amount that is national tax. 
			string MERCHANTTAXID = String.Empty  ;  // Merchant�s tax identifier used for tax reporting purposes. 
			string CUSTOMERTAXID = String.Empty  ;  // Customer�s tax identifier used for tax reporting purposes. 
			string CCODE         = String.Empty  ;  // Commodity code that generally applies to each product included in the order. 
			string DISCOUNT      = String.Empty  ;  // Discount value should represent the amount discounted from the original transaction amount. 
			string FREIGHT       = String.Empty  ;  // Freight value should represent the portion of the transaction amount that was generated from shipping costs. 
			string DUTY          = String.Empty  ;  // Duty should represent any costs associated with shipping through a country�s customs. 
			string SOURCEZIP     = String.Empty  ;  // Zip code that the package will be sent from. 
			string SZIP          = String.Empty  ;  // Zip code where the product is delivered. 
			string SCOUNTRY      = String.Empty  ;  // County where the product is delivered. 
			string ADDTAX        = String.Empty  ;  // Any tax generated from freight or other services associated with the transaction. 
			string ADDTAXRATE    = String.Empty  ;  // Rate at which additional tax was assessed. 
			List<string> arrLineItems = new List<string>();
			
			PSWD = Security.DecryptPassword(PSWD, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			string sSTATUS = "Prevalidation";
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL = String.Empty;
				sSQL = "select *                  " + ControlChars.CrLf
				     + "  from vwCREDIT_CARDS_Edit" + ControlChars.CrLf
				     + " where ID = @ID           " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gCREDIT_CARD_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							CARD_TYPE = Sql.ToString(rdr["CARD_TYPE"  ]);
							CUSTID    = Sql.ToString(rdr["CARD_NUMBER"]);
							if ( Sql.ToBoolean(rdr["IS_ENCRYPTED"]) )
							{
								CUSTID = Security.DecryptPassword(CUSTID, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
							}
							string sCARD_TYPE = Sql.ToString(rdr["CARD_TYPE"]);
							if ( sCARD_TYPE.StartsWith("Bank Draft") )
							{
								throw(new Exception("Bank Drafts are not supported at this time. "));
							}
						}
					}
				}
				
				decimal dAMOUNT     = Decimal.Zero;
				Guid    gACCOUNT_ID = Guid.Empty;
				sSQL = "select *         " + ControlChars.CrLf
				     + "  from vwINVOICES" + ControlChars.CrLf
				     + " where ID = @ID  " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gINVOICE_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							gACCOUNT_ID = Sql.ToGuid   (rdr["BILLING_ACCOUNT_ID"         ]);
							INVOICE     = Sql.ToString (rdr["INVOICE_NUM"                ]);
							SZIP        = Sql.ToString (rdr["SHIPPING_ADDRESS_POSTALCODE"]);
							SCOUNTRY    = Sql.ToString (rdr["SHIPPING_ADDRESS_COUNTRY"   ]);
							dAMOUNT     = Sql.ToDecimal(rdr["TOTAL_USDOLLAR"             ]);
							DISCOUNT    = Sql.ToDecimal(rdr["DISCOUNT_USDOLLAR"          ]).ToString("0.00");
							FREIGHT     = Sql.ToDecimal(rdr["SHIPPING_USDOLLAR"          ]).ToString("0.00");
							TAX         = Sql.ToDecimal(rdr["TAX_USDOLLAR"               ]).ToString("0.00");
							// Dollar amount of the transaction. Must be a positive number up to two decimal places.
							INVOICE     = CleanseData(INVOICE );
							SZIP        = CleanseData(SZIP    );
							SCOUNTRY    = CleanseData(SCOUNTRY);
							AMOUNT      = dAMOUNT.ToString("0.00");
							if ( Sql.IsEmptyGuid(gACCOUNT_ID) )
								gACCOUNT_ID = Sql.ToGuid(rdr["BILLING_CONTACT_ID"]);
							if ( SCOUNTRY.Length > 2 )
							{
								if ( dictCountries.ContainsKey(SCOUNTRY) )
									SCOUNTRY = dictCountries[SCOUNTRY];
							}
						}
					}
				}
				
				sSQL = "select *                       " + ControlChars.CrLf
				     + "  from vwINVOICES_LINE_ITEMS   " + ControlChars.CrLf
				     + " where INVOICE_ID = @INVOICE_ID" + ControlChars.CrLf
				     + " order by POSITION             " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@INVOICE_ID", gINVOICE_ID);
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dt = new DataTable() )
						{
							da.Fill(dt);
							if ( dt.Rows.Count > 0 )
							{
								for ( int i = 0; i < dt.Rows.Count; i++ )
								{
									DataRow row = dt.Rows[i];
									string CCODELI      = Sql.ToString(row["VENDOR_PART_NUM"]);  // The complete commodity code unique to the product referenced in this specific line item record.
									string PRODUCTID    = Sql.ToString(row["MFT_PART_NUM"   ]);  // Your unique identifier for the product. 
									string DESCRIPTION  = Sql.ToString(row["NAME"           ]);  // Optional text describing the transaction, products, customers, or other attributes of the transaction. 
									string QUANTITY     = Sql.ToString(row["QUANTITY"       ]);  // Item count of the product in this order. 
									string MEASURE      = String.Empty                        ;  // Unit of measure applied to the product and its quantity. 
									string ADDTAXLI     = String.Empty                        ;  // Additional tax amount applied to the transaction applicable to this line item record. 
									string ADDTAXRATELI = String.Empty                        ;  // Rate at which additional tax was calculated in reference to this specific line item record. 
									string UNITCOST     = Sql.ToDecimal(row["UNIT_USDOLLAR"    ]).ToString("0.00");  // Product amount per quantity
									string DISCOUNTLI   = Sql.ToDecimal(row["DISCOUNT_USDOLLAR"]).ToString("0.00");  // unt amount applied to the transaction amount in reference to this line item record
									string AMOUNTLI     = Sql.ToDecimal(row["EXTENDED_PRICE"   ]).ToString("0.00");  // Total amount included in the transaction amount generated from this line item record.
									CCODELI     = CleanseData(CCODELI    );
									PRODUCTID   = CleanseData(PRODUCTID  );
									DESCRIPTION = CleanseData(DESCRIPTION);
									
									Dictionary<string, string> dictLineItems = new Dictionary<string, string>();
									dictLineItems.Add("QUANTITY"  , QUANTITY  );
									dictLineItems.Add("UNITCOST"  , UNITCOST  );
									dictLineItems.Add("DISCOUNTLI", DISCOUNTLI);
									dictLineItems.Add("AMOUNTLI"  , AMOUNTLI  );
									if ( !Sql.IsEmptyString(CCODELI    ) ) dictLineItems.Add("CCODELI"    , CCODELI    );
									if ( !Sql.IsEmptyString(PRODUCTID  ) ) dictLineItems.Add("PRODUCTID"  , PRODUCTID  );
									if ( !Sql.IsEmptyString(DESCRIPTION) ) dictLineItems.Add("DESCRIPTION", DESCRIPTION);
									
									StringBuilder sbLineItems = new StringBuilder();
									foreach ( string sKey in dictLineItems.Keys )
									{
										// Name/value pairs included in the LINEITEM parameter are separated by the = symbol and followed by a + symbol.
										if ( sbLineItems.Length > 0 )
											sbLineItems.Append("+");
										sbLineItems.Append(sKey + "=" + dictLineItems[sKey]);
									}
									// 09/19/2013 Paul.  The line item should have a terminating +. 
									arrLineItems.Add(sbLineItems.ToString() + "+");
								}
							}
						}
					}
				}
				
				// 09/13/2013 Paul.  Required fields. UN, PSWD, TERMS, METHOD, TRANXTYPE, AMOUNT, CUSTID
				dictParams.Add("UN"         , UN       );
				dictParams.Add("PSWD"       , PSWD     );
				dictParams.Add("TERMS"      , TERMS    );
				dictParams.Add("METHOD"     , METHOD   );
				dictParams.Add("TRANXTYPE"  , TRANXTYPE);
				dictParams.Add("CUSTID"     , CUSTID   );
				dictParams.Add("AMOUNT"     , AMOUNT   );
				
				Guid gPAYMENTS_TRANSACTION_ID = Guid.Empty;
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						SqlProcs.spPAYMENTS_TRANSACTIONS_InsertOnly
							( ref gPAYMENTS_TRANSACTION_ID
							, gPAYMENT_ID
							, "PayTrace"
							, "Sale"
							, dAMOUNT
							, gCURRENCY_ID
							, INVOICE
							, sDESCRIPTION
							, gCREDIT_CARD_ID
							, gACCOUNT_ID
							, sSTATUS
							, trn
							);
						trn.Commit();
					}
					catch
					{
						trn.Rollback();
						throw;
					}
				}
				string sAvsCode       = String.Empty;
				string sErrorMessage  = String.Empty;
				string sApprovalCode  = String.Empty;
				try
				{
					string sResponse = PayTraceRequest(dictParams, String.Empty);
					string[] arrResponse = sResponse.Split('|');
					// ERROR, RESPONSE, TRANSACTIONID, APPCODE, APPMSG, AVSRESPONSE, CSCRESPONSE
					// RESPONSE~101. Your transaction was successfully approved.|TRANSACTIONID~43023513|APPCODE~TAS736|APPMSG~  NO  MATCH      - Approved and completed|AVSRESPONSE~No Match|CSCRESPONSE~|
					Dictionary<string, string> dictResponse = new Dictionary<string, string>();
					for ( int i = 0; i < arrResponse.Length; i++ )
					{
						string[] arrValue = arrResponse[i].Split('~');
						if ( arrValue.Length == 2 )
							dictResponse.Add(arrValue[0].ToUpper(), arrValue[1]);
					}
					if ( dictResponse.ContainsKey("ERROR") )
					{
						sErrorMessage = dictResponse["ERROR"];
						sSTATUS = "Failed";
					}
					// 09/13/2013 Paul.  Error or Approved, but not both. 
					else if ( dictResponse.ContainsKey("APPCODE") )
					{
						// Approval code is generated by credit card issuer and returned when a successful call to ProcessTranx is requested
						sApprovalCode = dictResponse["APPCODE"];
					}
					if ( dictResponse.ContainsKey("TRANSACTIONID") )
					{
						// ID assigned by PayTrace to each transaction at the time the transaction is processed.
						TRANXID = dictResponse["TRANSACTIONID"];
					}
					if ( dictResponse.ContainsKey("AVSRESPONSE") )
					{
						// The address verification system response is generated by the credit card issuer when a successful call to ProcessTranx is requested. 
						sAvsCode = dictResponse["AVSRESPONSE"];
					}
					// http://help.paytrace.com/api-response-codes
					if ( dictResponse.ContainsKey("RESPONSE") )
					{
						string sRESPONSE = dictResponse["RESPONSE"];
						// 101. Your transaction was successfully approved.
						if ( sRESPONSE.StartsWith("101.") )
							sSTATUS = "Success";
//#if DEBUG
//						Debug.WriteLine(sRESPONSE);
//#endif
					}
				}
				catch(Exception ex)
				{
					sErrorMessage = ex.Message;
					sSTATUS = "Failed";
				}
				finally
				{
					// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spPAYMENTS_TRANSACTIONS_Update
								( gPAYMENTS_TRANSACTION_ID
								, sSTATUS
								, TRANXID
								, String.Empty
								, sApprovalCode
								, sAvsCode
								, String.Empty
								, sErrorMessage
								, trn
								);
							trn.Commit();
						}
						catch
						{
							trn.Rollback();
						}
					}
				}
				if ( sSTATUS == "Failed" )
					throw(new Exception(sErrorMessage));
				// 09/13/2013 Paul.  Only add Level 3 data if transaction was successful. 
				try
				{
					if ( CARD_TYPE == "Visa" || CARD_TYPE == "MasterCard" )
					{
						// http://help.paytrace.com/api-adding-level-3-data-to-a-visa-sale
						// http://help.paytrace.com/api-adding-level-3-data-to-a-mastercard-sale
						dictParams = new Dictionary<string, string>();
						// Required fields. UN, PSWD, TERMS, METHOD, TRANXID
						METHOD = (CARD_TYPE == "Visa") ? "Level3Visa" : "Level3MCRD";
						dictParams.Add("UN"     , UN     );
						dictParams.Add("PSWD"   , PSWD   );
						dictParams.Add("TERMS"  , TERMS  );
						dictParams.Add("METHOD" , METHOD );
						dictParams.Add("TRANXID", TRANXID);
						// Optional fields. 
						if ( !Sql.IsEmptyString(INVOICE      ) ) dictParams.Add("INVOICE"      , INVOICE      );
						if ( !Sql.IsEmptyString(CUSTREF      ) ) dictParams.Add("CUSTREF"      , CUSTREF      );
						if ( !Sql.IsEmptyString(TAX          ) ) dictParams.Add("TAX"          , TAX          );
						if ( !Sql.IsEmptyString(NTAX         ) ) dictParams.Add("NTAX"         , NTAX         );
						if ( !Sql.IsEmptyString(MERCHANTTAXID) ) dictParams.Add("MERCHANTTAXID", MERCHANTTAXID);
						if ( !Sql.IsEmptyString(CUSTOMERTAXID) ) dictParams.Add("CUSTOMERTAXID", CUSTOMERTAXID);
						if ( !Sql.IsEmptyString(CCODE        ) ) dictParams.Add("CCODE"        , CCODE        );
						if ( !Sql.IsEmptyString(DISCOUNT     ) ) dictParams.Add("DISCOUNT"     , DISCOUNT     );
						if ( !Sql.IsEmptyString(FREIGHT      ) ) dictParams.Add("FREIGHT"      , FREIGHT      );
						if ( !Sql.IsEmptyString(DUTY         ) ) dictParams.Add("DUTY"         , DUTY         );
						if ( !Sql.IsEmptyString(SOURCEZIP    ) ) dictParams.Add("SOURCEZIP"    , SOURCEZIP    );
						if ( !Sql.IsEmptyString(SZIP         ) ) dictParams.Add("SZIP"         , SZIP         );
						if ( !Sql.IsEmptyString(SCOUNTRY     ) ) dictParams.Add("SCOUNTRY"     , SCOUNTRY     );
						if ( !Sql.IsEmptyString(ADDTAX       ) ) dictParams.Add("ADDTAX"       , ADDTAX       );
						if ( !Sql.IsEmptyString(ADDTAXRATE   ) ) dictParams.Add("ADDTAXRATE"   , ADDTAXRATE   );
						StringBuilder sbLineItems = new StringBuilder();
						if ( arrLineItems.Count > 0 )
						{
							foreach ( string sLineItem in arrLineItems )
							{
								sbLineItems.Append("|LINEITEM~" + sLineItem);
							}
						}
						
						string sResponse = PayTraceRequest(dictParams, sbLineItems.ToString());
						string[] arrResponse = sResponse.Split('|');
						// ERROR, RESPONSE
						// RESPONSE~170. Visa/MasterCard enhanced data was successfully added to Transaction ID 43023513. 0 line item records were created.|
						Dictionary<string, string> dictResponse = new Dictionary<string, string>();
						for ( int i = 0; i < arrResponse.Length; i++ )
						{
							string[] arrValue = arrResponse[i].Split('~');
							if ( arrValue.Length == 2 )
								dictResponse.Add(arrValue[0].ToUpper(), arrValue[1]);
						}
						if ( dictResponse.ContainsKey("ERROR") )
						{
							sErrorMessage = dictResponse["ERROR"];
							SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Failed to add PayTrace Level 3 data: " + sErrorMessage);
						}
						// http://help.paytrace.com/api-response-codes
						if ( dictResponse.ContainsKey("RESPONSE") )
						{
							string sRESPONSE = dictResponse["RESPONSE"];
							// 170. Visa/MasterCard enhanced data was successfully added to Transaction ID
							if ( !(sRESPONSE.StartsWith("170.") || sRESPONSE.StartsWith("171.")) )
								SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Failed to add PayTrace Level 3 data: " + sRESPONSE);
//#if DEBUG
//							Debug.WriteLine(sRESPONSE);
//#endif
						}
					}
				}
				catch(Exception ex)
				{
					SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Failed to add PayTrace Level 3 data: " + ex.Message);
				}
			}
			return sSTATUS;
		}

		public string Refund(string sTRANSACTION_NUMBER)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			
			// http://help.paytrace.com/api-refunds
			// UN, PSWD, TERMS, METHOD, TRANXTYPE, TRANXID
			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string UN            = Sql.ToString(Application["CONFIG.PayTrace.UserName"]);
			string PSWD          = Sql.ToString(Application["CONFIG.PayTrace.Password"]);
			string TERMS         = "Y"                ;  // Must be to 'Y' in order to process any methods through the PayTrace API. 
			string METHOD        = "ProcessTranx"     ;  // Function that you are requesting PayTrace perform. 
			string TRANXTYPE     = "Refund"           ;  // Sale, Authorization, Str/Fwd, Refund, Void, Capture, Force and Deleteauthkey (Secure Checkout Only). 
			string TRANXID       = sTRANSACTION_NUMBER;  // A unique identifier for each transaction in the PayTrace system. This value is returned in the TRANSACTIONID parameter of an API response and will consequently be included in requests to email receipts, void transactions, add level 3 data, etc. 
			
			PSWD = Security.DecryptPassword(PSWD, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			string sSTATUS = "Prevalidation";
			// 09/13/2013 Paul.  Required fields. 
			dictParams.Add("UN"         , UN       );
			dictParams.Add("PSWD"       , PSWD     );
			dictParams.Add("TERMS"      , TERMS    );
			dictParams.Add("METHOD"     , METHOD   );
			dictParams.Add("TRANXTYPE"  , TRANXTYPE);
			dictParams.Add("TRANXID"    , TRANXID  );
			
			string sErrorMessage  = String.Empty;
			string sTransactionID = String.Empty;
			try
			{
				string sResponse = PayTraceRequest(dictParams, String.Empty);
				if ( sResponse.StartsWith("ERROR~817.") )
				{
					TRANXTYPE = "Void";
					dictParams["TRANXTYPE"] = TRANXTYPE;
					// 09/15/2013 Paul.  If the transaction has not been settled, then change to Void. 
					sResponse = PayTraceRequest(dictParams, String.Empty);
				}
				// ERROR, RESPONSE, TRANSACTIONID
				// ERROR~35. Please provide a valid Credit Card Number.|ERROR~43. Please provide a valid Expiration Month.|ERROR~51. Please provide a valid Amount.|
				// ERROR~817. The Transaction ID that you provided could not be refunded. Only settled transactions can be refunded.  Please try to void the transaction instead.|
				// RESPONSE~109. Your transaction was successfully voided.|TRANSACTIONID~43023513|
				string[] arrResponse = sResponse.Split('|');
				Dictionary<string, string> dictResponse = new Dictionary<string, string>();
				for ( int i = 0; i < arrResponse.Length; i++ )
				{
					string[] arrValue = arrResponse[i].Split('~');
					if ( arrValue.Length == 2 )
						dictResponse.Add(arrValue[0].ToUpper(), arrValue[1]);
				}
				if ( dictResponse.ContainsKey("ERROR") )
				{
					sErrorMessage = dictResponse["ERROR"];
					sSTATUS = "Failed";
				}
				if ( dictResponse.ContainsKey("TRANSACTIONID") )
				{
					sTransactionID = dictResponse["TRANSACTIONID"];
					//sSTATUS = "Success";
				}
				// http://help.paytrace.com/api-response-codes
				if ( dictResponse.ContainsKey("RESPONSE") )
				{
					string sRESPONSE = dictResponse["RESPONSE"];
					// 109. Your transaction was successfully voided.
					if ( sRESPONSE.StartsWith("109.") )
						sSTATUS = "Success";
//#if DEBUG
//					Debug.WriteLine(sRESPONSE);
//#endif
				}
			}
			catch(Exception ex)
			{
				sErrorMessage = ex.Message;
				sSTATUS = "Failed";
			}
			if ( sSTATUS == "Failed" )
				throw(new Exception(sErrorMessage));
			return sSTATUS;
		}

		public string Refund(Guid gPAYMENT_ID, Guid gCURRENCY_ID, Guid gACCOUNT_ID, Guid gCREDIT_CARD_ID, string sINVOICE_NUMBER, Decimal dAMOUNT, string sTRANSACTION_NUMBER)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			
			// http://help.paytrace.com/api-refunds
			// UN, PSWD, TERMS, METHOD, TRANXTYPE, TRANXID
			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string UN            = Sql.ToString(Application["CONFIG.PayTrace.UserName"]);
			string PSWD          = Sql.ToString(Application["CONFIG.PayTrace.Password"]);
			string TERMS         = "Y"                ;  // Must be to 'Y' in order to process any methods through the PayTrace API. 
			string METHOD        = "ProcessTranx"     ;  // Function that you are requesting PayTrace perform. 
			string TRANXTYPE     = "Refund"           ;  // Sale, Authorization, Str/Fwd, Refund, Void, Capture,Force and Deleteauthkey (Secure Checkout Only). 
			string TRANXID       = sTRANSACTION_NUMBER;  // A unique identifier for each transaction in the PayTrace system. This value is returned in the TRANSACTIONID parameter of an API response and will consequently be included in requests to email receipts, void transactions, add level 3 data, etc. 
			
			PSWD = Security.DecryptPassword(PSWD, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			string sSTATUS = "Prevalidation";
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				Guid gPAYMENTS_TRANSACTION_ID = Guid.Empty;
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						// 10/28/2010 Paul.  Include the login in the PAYMENT_GATEWAY for better tracking. 
						SqlProcs.spPAYMENTS_TRANSACTIONS_InsertOnly
							( ref gPAYMENTS_TRANSACTION_ID
							, gPAYMENT_ID       // gPAYMENT_ID
							, "PayTrace"        // PAYMENT_GATEWAY
							, "Refund"          // TRANSACTION_TYPE
							, dAMOUNT           // AMOUNT
							, gCURRENCY_ID      // CURRENCY_ID
							, sINVOICE_NUMBER   // INVOICE_NUMBER
							, String.Empty      // DESCRIPTION
							, gCREDIT_CARD_ID   // CREDIT_CARD_ID
							, gACCOUNT_ID       // ACCOUNT_ID
							, sSTATUS           // STATUS
							, trn
							);
						trn.Commit();
					}
					catch(Exception ex)
					{
						trn.Rollback();
						throw(new Exception(ex.Message, ex.InnerException));
					}
				}
				
				// 09/13/2013 Paul.  Required fields. 
				dictParams.Add("UN"         , UN       );
				dictParams.Add("PSWD"       , PSWD     );
				dictParams.Add("TERMS"      , TERMS    );
				dictParams.Add("METHOD"     , METHOD   );
				dictParams.Add("TRANXTYPE"  , TRANXTYPE);
				dictParams.Add("TRANXID"    , TRANXID  );
				
				string sErrorMessage  = String.Empty;
				string sTransactionID = String.Empty;
				try
				{
					string sResponse = PayTraceRequest(dictParams, String.Empty);
					if ( sResponse.StartsWith("ERROR~817.") )
					{
						TRANXTYPE = "Void";
						dictParams["TRANXTYPE"] = TRANXTYPE;
						// 09/15/2013 Paul.  If the transaction has not been settled, then change to Void. 
						sResponse = PayTraceRequest(dictParams, String.Empty);
					}
					// ERROR, RESPONSE, TRANSACTIONID
					// ERROR~35. Please provide a valid Credit Card Number.|ERROR~43. Please provide a valid Expiration Month.|ERROR~51. Please provide a valid Amount.|
					// ERROR~817. The Transaction ID that you provided could not be refunded. Only settled transactions can be refunded.  Please try to void the transaction instead.|
					// RESPONSE~109. Your transaction was successfully voided.|TRANSACTIONID~43023513|
					string[] arrResponse = sResponse.Split('|');
					Dictionary<string, string> dictResponse = new Dictionary<string, string>();
					for ( int i = 0; i < arrResponse.Length; i++ )
					{
						string[] arrValue = arrResponse[i].Split('~');
						if ( arrValue.Length == 2 )
							dictResponse.Add(arrValue[0].ToUpper(), arrValue[1]);
					}
					if ( dictResponse.ContainsKey("ERROR") )
					{
						sErrorMessage = dictResponse["ERROR"];
						sSTATUS = "Failed";
					}
					if ( dictResponse.ContainsKey("TRANSACTIONID") )
					{
						sTransactionID = dictResponse["TRANSACTIONID"];
						//sSTATUS = "Success";
					}
					// http://help.paytrace.com/api-response-codes
					if ( dictResponse.ContainsKey("RESPONSE") )
					{
						string sRESPONSE = dictResponse["RESPONSE"];
						// 109. Your transaction was successfully voided.
						// 106. Your transaction was successfully refunded.|TRANSACTIONID~43614023|
						if ( sRESPONSE.StartsWith("109.") || sRESPONSE.StartsWith("106.") )
							sSTATUS = "Success";
						else
							sSTATUS = sRESPONSE;
//#if DEBUG
//						Debug.WriteLine(sRESPONSE);
//#endif
					}
				}
				catch(Exception ex)
				{
					sErrorMessage = ex.Message;
					sSTATUS = "Failed";
				}
				finally
				{
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spPAYMENTS_TRANSACTIONS_Update
								( gPAYMENTS_TRANSACTION_ID
								, sSTATUS         // STATUS
								, sTransactionID  // TRANSACTION_NUMBER
								, String.Empty    // REFERENCE_NUMBER
								, String.Empty    // AUTHORIZATION_CODE
								, String.Empty    // AVS_CODE
								, String.Empty    // ERROR_CODE
								, sErrorMessage   // ERROR_MESSAGE
								, trn
								);
							trn.Commit();
						}
						catch
						{
							trn.Rollback();
						}
					}
				}
			}
			return sSTATUS;
		}

		public DataSet Transactions(DateTime dtStartDate, DateTime dtEndDate, string sTransactionType, string sSearchText, string sTransactionID)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			
			// http://help.paytrace.com/api-exporting-customer-profiles
			// http://help.paytrace.com/api-export-transaction-information
			// UN, PSWD, TERMS, METHOD, TRANXID
			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string UN            = Sql.ToString(Application["CONFIG.PayTrace.UserName"]);
			string PSWD          = Sql.ToString(Application["CONFIG.PayTrace.Password"]);
			string TERMS         = "Y"           ;  // Must be to 'Y' in order to process any methods through the PayTrace API. 
			string METHOD        = "ExportTranx" ;  // Function that you are requesting PayTrace perform. 
			string TRANXTYPE     = String.Empty  ;  // Please note the TRANXTYPE name may also include the values "SETTLED", "PENDING", and "DECLINED". (Sale, Authorization, Str/Fwd, Refund, Void, Capture, Force). 
			string SDATE         = String.Empty  ;  // Start date is used for export functions to indicate when to start searching for transactions to export. Must be a valid date formatted as MM/DD/YYYY. 
			string EDATE         = String.Empty  ;  // End date is used for export functions to indicate when to end searching for transactions to export. Must be a valid date formatted as MM/DD/YYYY. 
			string SEARCHTEXT    = String.Empty  ;  // Text that will be searched to narrow down transaction and check results for ExportTranx and ExportCheck requests. 
			string TRANXID       = sTransactionID;  // A unique identifier for each transaction in the PayTrace system. This value is returned in the TRANSACTIONID parameter of an API response and will consequently be included in requests to email receipts, void transactions, add level 3 data, etc. 
			
			PSWD = Security.DecryptPassword(PSWD, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			dictParams.Add("UN"         , UN        );
			dictParams.Add("PSWD"       , PSWD      );
			dictParams.Add("TERMS"      , TERMS     );
			dictParams.Add("METHOD"     , METHOD    );
			if ( Sql.IsEmptyString(TRANXID) )
			{
				if ( dtStartDate == DateTime.MinValue )
					SDATE = DateTime.Today.ToString("MM/dd/yyyy");
				else
					SDATE = dtStartDate.ToString("MM/dd/yyyy");
				if ( dtEndDate == DateTime.MinValue )
					EDATE = DateTime.Today.ToString("MM/dd/yyyy");
				else
					EDATE = dtEndDate.ToString("MM/dd/yyyy");
				TRANXTYPE  = sTransactionType;
				SEARCHTEXT = sSearchText;
				// 09/13/2013 Paul.  Required fields. 
				dictParams.Add("SDATE"      , SDATE     );
				dictParams.Add("EDATE"      , EDATE     );
				dictParams.Add("TRANXTYPE"  , TRANXTYPE );
				dictParams.Add("SEARCHTEXT" , SEARCHTEXT);
			}
			else
			{
				// 09/13/2013 Paul.  Required fields. 
				dictParams.Add("TRANXID"    , TRANXID   );
			}
			
			DataSet ds = new DataSet();
			DataTable dtTransactions = ds.Tables.Add("TRANSACTIONS");
			dtTransactions.Columns.Add("TRANXID"          , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("CC"               , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("EXPMNTH"          , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("EXPYR"            , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("TRANXTYPE"        , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("DESCRIPTION"      , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("AMOUNT"           , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("INVOICE"          , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SNAME"            , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SADDRESS"         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SADDRESS2"        , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SCITY"            , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SCOUNTY"          , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SSTATE"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SZIP"             , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SCOUNTRY"         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("BNAME"            , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("BADDRESS"         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("BADDRESS2"        , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("BCITY"            , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("BSTATE"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("BZIP"             , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("BCOUNTRY"         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("EMAIL"            , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PHONE"            , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("TAX"              , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("CUSTREF"          , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("APPROVAL"         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("APPMSG"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("AVSRESPONSE"      , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("CSCRESPONSE"      , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("STATUS"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("STATUSDESCRIPTION", Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("METHOD"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("WHEN"             , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("SETTLED"          , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("USER"             , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("IP"               , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("CUSTID"           , Type.GetType("System.String"  ));

			DataTable dtLineItems = ds.Tables.Add("LINE_ITEMS");
			dtLineItems.Columns.Add("TRANSACTION_ID"   , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("AMOUNT_CURRENCY"  , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("AMOUNT"           , Type.GetType("System.Decimal" ));
			dtLineItems.Columns.Add("NAME"             , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("NUMBER"           , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("OPTIONS"          , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("QUANTITY"         , Type.GetType("System.Decimal" ));
			dtLineItems.Columns.Add("SALES_TAX"        , Type.GetType("System.Decimal" ));

			string sResponse = PayTraceRequest(dictParams, String.Empty);
			string[] arrResponse = sResponse.Split('|');
			if ( sResponse.StartsWith("ERROR~") )
			{
				Dictionary<string, string> dictResponse = new Dictionary<string, string>();
				for ( int i = 0; i < arrResponse.Length; i++ )
				{
					string[] arrValue = arrResponse[i].Split('~');
					if ( arrValue.Length == 2 )
					{
						dictResponse.Add(arrValue[0].ToUpper(), arrValue[1]);
//#if DEBUG
//						Debug.WriteLine(arrValue[0] + " = " + arrValue[1]);
//#endif
					}
				}
				if ( dictResponse.ContainsKey("ERROR") )
				{
					// 09/19/2013 Paul.  Don't throw an exception when there is no data so that the table will rebind. 
					if ( !sResponse.StartsWith("ERROR~180") )
						throw(new Exception("PayTrace.Transactions: " + dictResponse["ERROR"]));
				}
			}
			else
			{
				for ( int i = 0; i < arrResponse.Length; i++ )
				{
					string[] arrValue = arrResponse[i].Split('~');
					if ( arrValue.Length == 2 && arrValue[0] == "TRANSACTIONRECORD" )
					{
//#if DEBUG
//						Debug.WriteLine(arrValue[0]);
//#endif
						DataRow row = dtTransactions.NewRow();
						dtTransactions.Rows.Add(row);
						string[] arrTransaction = arrValue[1].Split('+');
						for ( int j = 0; j < arrTransaction.Length; j++ )
						{
							arrValue = arrTransaction[j].Split('=');
							if ( arrValue.Length == 2 )
							{
								string sName  = arrValue[0];
								string sValue = arrValue[1];
//#if DEBUG
//								Debug.WriteLine(sName.PadRight(20) + " = " + sValue);
//#endif
								if ( dtTransactions.Columns.Contains(sName) )
								{
									if ( sName == "AMOUNT" || sName == "TAX" )
										row[sName] = Sql.ToDecimal(sValue);
									else if ( sName == "WHEN" || sName == "SETTLED" )
										row[sName] = Sql.ToDateTime(sValue);
									else
										row[sName] = sValue;
								}
							}
						}
					}
				}
			}
			return ds;
		}

		public DataTable CustomerProfiles(string sCustomerID)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			
			// http://help.paytrace.com/api-exporting-customer-profiles
			// UN, PSWD, TERMS, METHOD, TRANXID
			Dictionary<string, string> dictParams = new Dictionary<string, string>();
			string UN            = Sql.ToString(Application["CONFIG.PayTrace.UserName"]);
			string PSWD          = Sql.ToString(Application["CONFIG.PayTrace.Password"]);
			string TERMS         = "Y"              ;  // Must be to 'Y' in order to process any methods through the PayTrace API. 
			string METHOD        = "ExportCustomers";  // Function that you are requesting PayTrace perform. 
			string CUSTID       = sCustomerID       ;  // // Unique identifier for a customer profile. Each customer must have their own unique ID. 
			
			PSWD = Security.DecryptPassword(PSWD, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			dictParams.Add("UN"         , UN        );
			dictParams.Add("PSWD"       , PSWD      );
			dictParams.Add("TERMS"      , TERMS     );
			dictParams.Add("METHOD"     , METHOD    );
			if ( !Sql.IsEmptyString(CUSTID) )
				dictParams.Add("CUSTID"     , CUSTID    );
			
			DataTable dtCustomer = new DataTable("CUSTOMERS");
			dtCustomer.Columns.Add("CUSTID"    , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("CUSTOMERID", Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("CC"        , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("EXPMNTH"   , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("EXPYR"     , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("SNAME"     , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("SADDRESS"  , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("SADDRESS2" , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("SCITY"     , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("SCOUNTY"   , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("SSTATE"    , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("SZIP"      , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("SCOUNTRY"  , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("BNAME"     , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("BADDRESS"  , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("BADDRESS2" , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("BCITY"     , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("BSTATE"    , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("BZIP"      , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("BCOUNTRY"  , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("EMAIL"     , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("PHONE"     , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("FAX"       , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("WHEN"      , Type.GetType("System.DateTime"));
			dtCustomer.Columns.Add("USER"      , Type.GetType("System.String"  ));
			dtCustomer.Columns.Add("IP"        , Type.GetType("System.String"  ));

			string sResponse = PayTraceRequest(dictParams, String.Empty);
			string[] arrResponse = sResponse.Split('|');
			if ( sResponse.StartsWith("ERROR~") )
			{
				Dictionary<string, string> dictResponse = new Dictionary<string, string>();
				for ( int i = 0; i < arrResponse.Length; i++ )
				{
					string[] arrValue = arrResponse[i].Split('~');
					if ( arrValue.Length == 2 )
					{
						dictResponse.Add(arrValue[0].ToUpper(), arrValue[1]);
//#if DEBUG
//						Debug.WriteLine(arrValue[0] + " = " + arrValue[1]);
//#endif
					}
				}
				if ( dictResponse.ContainsKey("ERROR") )
				{
					// 09/19/2013 Paul.  Don't throw an exception when there is no data so that the table will rebind. 
					// ERROR~185. No customers were found with these criteria.
					if ( !sResponse.StartsWith("ERROR~185") )
						throw(new Exception("PayTrace.CustomerProfiles: " + dictResponse["ERROR"]));
				}
			}
			else
			{
				for ( int i = 0; i < arrResponse.Length; i++ )
				{
					string[] arrValue = arrResponse[i].Split('~');
					if ( arrValue.Length == 2 && arrValue[0] == "CUSTOMERRECORD" )
					{
//#if DEBUG
//						Debug.WriteLine(arrValue[0]);
//#endif
						DataRow row = dtCustomer.NewRow();
						dtCustomer.Rows.Add(row);
						string[] arrTransaction = arrValue[1].Split('+');
						for ( int j = 0; j < arrTransaction.Length; j++ )
						{
							arrValue = arrTransaction[j].Split('=');
							if ( arrValue.Length == 2 )
							{
								string sName  = arrValue[0];
								string sValue = arrValue[1];
//#if DEBUG
//								Debug.WriteLine(sName.PadRight(20) + " = " + sValue);
//#endif
								if ( dtCustomer.Columns.Contains(sName) )
								{
									if ( sName == "WHEN" )
										row[sName] = Sql.ToDateTime(sValue);
									else
										row[sName] = sValue;
								}
							}
						}
					}
				}
			}
			return dtCustomer;
		}

		public DataSet Transaction(string sTransactionID)
		{
			DataSet ds = Cache.Get("PayTrace.Transaction." + sTransactionID) as DataSet;
			if ( ds == null )
			{
				ds = this.Transactions(DateTime.MinValue, DateTime.MinValue, String.Empty, String.Empty, sTransactionID);
				DataTable dt = ds.Tables["TRANSACTIONS"];
				if ( !dt.Columns.Contains("CREDIT_CARD_ID") )
				{
					dt.Columns.Add("CREDIT_CARD_ID", Type.GetType("System.Guid"));
				}
				if ( dt.Rows.Count > 0 )
				{
					// 09/20/2013 Paul.  If the Customer ID is 36 characters, try to convert to a Guid so that the DetailView can link to the credit card record. 
					string sCustomerID = Sql.ToString(dt.Rows[0]["CUSTID"]);
					if ( sCustomerID.Length == 36 )
					{
						try
						{
							Guid gCREDIT_CARD_ID = Sql.ToGuid(sCustomerID);
							dt.Rows[0]["CREDIT_CARD_ID"] = gCREDIT_CARD_ID;
						}
						catch
						{
						}
					}
					// 09/20/2013 Paul.  Also get customer profile and include in the dataset. 
					// 09/20/2013 Paul.  The only customer fields not available in the transaction are PHONE and FAX, so just skip the Customer lookup. 
					if ( !Sql.IsEmptyString(sCustomerID) )
					{
						//DataTable dtCustomers = CustomerProfiles(sCustomerID);
						//ds.Tables.Add(dtCustomers);
					}
				}
				Cache.Set("PayTrace.Transaction." + sTransactionID, ds, DateTime.Now.AddMinutes(1));
			}
			return ds;
		}

		public void ImportTransaction(DataSet ds)
		{
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL;

				DataTable dt = ds.Tables["TRANSACTIONS"];
				if ( dt.Rows.Count > 0 )
				{
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							DataRow row = dt.Rows[0];
							string   sCARD_NUMBER_DISPLAY      = Sql.ToString  (row["CC"               ]);
							string   sCARD_EXPIRATION_MONTH    = Sql.ToString  (row["EXPMNTH"          ]);
							string   sCARD_EXPIRATION_YEAR     = Sql.ToString  (row["EXPYR"            ]);
							string   sTXN_ID                   = Sql.ToString  (row["TRANXID"          ]);
							string   sTXN_TYPE                 = Sql.ToString  (row["TRANXTYPE"        ]);
							string   sMEMO                     = Sql.ToString  (row["DESCRIPTION"      ]);
							Decimal  dPAYMENT_GROSS            = Sql.ToDecimal (row["AMOUNT"           ]);
							string   sINVOICE                  = Sql.ToString  (row["INVOICE"          ]);
							string   sSHIPPING_ADDRESS_NAME    = Sql.ToString  (row["BNAME"            ]);
							string   sSHIPPING_ADDRESS_STREET  = Sql.ToString  (row["SADDRESS"         ]) + ControlChars.CrLf + Sql.ToString  (row["SADDRESS2"]);
							string   sSHIPPING_ADDRESS_CITY    = Sql.ToString  (row["SCITY"            ]);
							string   sSHIPPING_ADDRESS_STATE   = Sql.ToString  (row["SSTATE"           ]);
							string   sSHIPPING_ADDRESS_ZIP     = Sql.ToString  (row["SZIP"             ]);
							string   sSHIPPING_ADDRESS_COUNTRY = Sql.ToString  (row["SCOUNTRY"         ]);
							string   sSHIPPING_ADDRESS_COUNTY  = Sql.ToString  (row["SCOUNTRY"         ]);
							string   sBILLING_ADDRESS_NAME     = Sql.ToString  (row["BNAME"            ]);
							string   sBILLING_ADDRESS_STREET   = Sql.ToString  (row["BADDRESS"         ]) + ControlChars.CrLf + Sql.ToString  (row["BADDRESS2"]);
							string   sBILLING_ADDRESS_CITY     = Sql.ToString  (row["BCITY"            ]);
							string   sBILLING_ADDRESS_STATE    = Sql.ToString  (row["BSTATE"           ]);
							string   sBILLING_ADDRESS_ZIP      = Sql.ToString  (row["BZIP"             ]);
							string   sBILLING_ADDRESS_COUNTRY  = Sql.ToString  (row["BCOUNTRY"         ]);
							string   sPAYER_EMAIL              = Sql.ToString  (row["EMAIL"            ]);
							Decimal  dTAX                      = Sql.ToDecimal (row["TAX"              ]);
							string   sREFERENCE_NUMBER         = Sql.ToString  (row["CUSTREF"          ]);
							string   sAUTHORIZATION_CODE       = Sql.ToString  (row["APPROVAL"         ]);
							string   sAVS_CODE                 = Sql.ToString  (row["AVSRESPONSE"      ]);
							string   sREASON_CODE              = Sql.ToString  (row["STATUS"           ]);
							string   sPAYMENT_STATUS           = Sql.ToString  (row["STATUSDESCRIPTION"]);
							DateTime dtPAYMENT_DATE            = Sql.ToDateTime(row["WHEN"             ]);
							string   sCREDIT_CARD_ID           = Sql.ToString  (row["CUSTID"           ]);
							string   sPENDING_REASON           = Sql.ToString  (row["APPMSG"           ]);
							string   sSALUTATION               = String.Empty;
							string   sFIRST_NAME               = String.Empty;
							string   sLAST_NAME                = Sql.ToString  (row["BNAME"            ]);
							string   sPAYER_BUSINESS_NAME      = Sql.ToString  (row["BNAME"            ]);
							string   sCONTACT_PHONE            = Sql.ToString  (row["PHONE"            ]);
							string   sRECEIPT_ID               = String.Empty;
							// "CSCRESPONSE"      
							// "SETTLED"          
							// "USER"             
							// "IP"               
							
							bool    bB2C                     = Sql.ToString(Application["CONFIG.BusinessMode"]) == "B2C";
							Guid    gUSD_CURRENCY            = new Guid("E340202E-6291-4071-B327-A34CB4DF239B");
							Guid    gCREDIT_CARD_ID          = Guid.Empty;
							Guid    gCONTACT_ID              = Guid.Empty;
							Guid    gACCOUNT_ID              = Guid.Empty;
							Guid    gORDER_ID                = Guid.Empty;
							Guid    gINVOICE_ID              = Guid.Empty;
							Guid    gPAYMENT_ID              = Guid.Empty;
							Guid    gPAYMENTS_TRANSACTION_ID = Guid.Empty;
							Guid    gCREDIT_CARD_KEY         = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
							Guid    gCREDIT_CARD_IV          = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
							string sCARD_NUMBER              = Security.EncryptPassword(sCREDIT_CARD_ID, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
							try
							{
								if ( sCREDIT_CARD_ID.Length == 36 )
									gCREDIT_CARD_ID = Sql.ToGuid(sCREDIT_CARD_ID);
							}
							catch
							{
							}
							if ( !Sql.IsEmptyGuid(gCREDIT_CARD_ID) )
							{
								sSQL = "select CONTACT_ID      " + ControlChars.CrLf
								     + "     , ACCOUNT_ID      " + ControlChars.CrLf
								     + "  from vwCREDIT_CARDS  " + ControlChars.CrLf
								     + " where ID = @ID" + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.Transaction = trn;
									cmd.CommandText = sSQL;
									Sql.AddParameter(cmd, "@ID", gCREDIT_CARD_ID);
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											gCONTACT_ID = Sql.ToGuid(rdr["CONTACT_ID"]);
											gACCOUNT_ID = Sql.ToGuid(rdr["ACCOUNT_ID"]);
										}
										else
										{
											gCREDIT_CARD_ID = Guid.Empty;
										}
									}
								}
							}
							else if ( !Sql.IsEmptyString(sCREDIT_CARD_ID) )
							{
								sSQL = "select ID                        " + ControlChars.CrLf
								     + "     , CONTACT_ID                " + ControlChars.CrLf
								     + "     , ACCOUNT_ID                " + ControlChars.CrLf
								     + "  from vwCREDIT_CARDS_Edit       " + ControlChars.CrLf
								     + " where CARD_NUMBER = @CARD_NUMBER" + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.Transaction = trn;
									cmd.CommandText = sSQL;
									Sql.AddParameter(cmd, "@CARD_NUMBER", sCARD_NUMBER);
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											gCREDIT_CARD_ID = Sql.ToGuid(rdr["ID"        ]);
											gCONTACT_ID     = Sql.ToGuid(rdr["CONTACT_ID"]);
											gACCOUNT_ID     = Sql.ToGuid(rdr["ACCOUNT_ID"]);
										}
									}
								}
							}
							sSQL = "select vwPAYMENTS_TRANSACTIONS.ID              " + ControlChars.CrLf
							     + "     , vwPAYMENTS_TRANSACTIONS.ACCOUNT_ID      " + ControlChars.CrLf
							     + "     , vwPAYMENTS_TRANSACTIONS.CONTACT_ID      " + ControlChars.CrLf
							     + "     , vwPAYMENTS_TRANSACTIONS.PAYMENT_ID      " + ControlChars.CrLf
							     + "     , vwINVOICES_PAYMENTS.INVOICE_ID          " + ControlChars.CrLf
							     + "     , vwINVOICES_PAYMENTS.ORDER_ID            " + ControlChars.CrLf
							     + "  from            vwPAYMENTS_TRANSACTIONS      " + ControlChars.CrLf
							     + "  left outer join vwINVOICES_PAYMENTS          " + ControlChars.CrLf
							     + "               on vwINVOICES_PAYMENTS.PAYMENT_ID = vwPAYMENTS_TRANSACTIONS.PAYMENT_ID" + ControlChars.CrLf
							     + " where vwPAYMENTS_TRANSACTIONS.PAYMENT_GATEWAY    = N'PayTrace'        " + ControlChars.CrLf
							     + "   and vwPAYMENTS_TRANSACTIONS.TRANSACTION_NUMBER = @TRANSACTION_NUMBER" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.Transaction = trn;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@TRANSACTION_NUMBER", sTXN_ID);
								using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
								{
									if ( rdr.Read() )
									{
										gPAYMENTS_TRANSACTION_ID = Sql.ToGuid(rdr["ID"        ]);
										gPAYMENT_ID              = Sql.ToGuid(rdr["PAYMENT_ID"]);
										if ( Sql.IsEmptyGuid(gACCOUNT_ID) )
											gACCOUNT_ID = Sql.ToGuid(rdr["ACCOUNT_ID"]);
										if ( Sql.IsEmptyGuid(gCONTACT_ID) )
											gCONTACT_ID = Sql.ToGuid(rdr["CONTACT_ID"]);
										if ( Sql.IsEmptyGuid(gINVOICE_ID) )
											gINVOICE_ID = Sql.ToGuid(rdr["INVOICE_ID"]);
										if ( Sql.IsEmptyGuid(gORDER_ID) )
											gORDER_ID = Sql.ToGuid(rdr["ORDER_ID"  ]);
									}
								}
							}
							// 09/20/2013 Paul.  Only create the contact if B2C. 
							if ( Sql.IsEmptyGuid(gCONTACT_ID) && !Sql.IsEmptyString(sPAYER_EMAIL) && bB2C )
							{
								sSQL = "select ID              " + ControlChars.CrLf
								     + "     , ACCOUNT_ID      " + ControlChars.CrLf
								     + "  from vwCONTACTS      " + ControlChars.CrLf
								     + " where EMAIL1 = @EMAIL1" + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.Transaction = trn;
									cmd.CommandText = sSQL;
									Sql.AddParameter(cmd, "@EMAIL1", sPAYER_EMAIL);
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											gCONTACT_ID = Sql.ToGuid(rdr["ID"        ]);
											gACCOUNT_ID = Sql.ToGuid(rdr["ACCOUNT_ID"]);
										}
									}
								}
							}
							// 09/20/2013 Paul.  Only create the account if B2B. 
							if ( Sql.IsEmptyGuid(gACCOUNT_ID) && !Sql.IsEmptyString(sPAYER_EMAIL)  && !bB2C )
							{
								sSQL = "select 1               " + ControlChars.CrLf
								     + "     , ID              " + ControlChars.CrLf
								     + "  from vwACCOUNTS      " + ControlChars.CrLf
								     + " where EMAIL1 = @EMAIL1" + ControlChars.CrLf
								     + "union                  " + ControlChars.CrLf
								     + "select 2               " + ControlChars.CrLf
								     + "     , ID              " + ControlChars.CrLf
								     + "  from vwACCOUNTS      " + ControlChars.CrLf
								     + " where NAME = @NAME    " + ControlChars.CrLf
								     + " order by 1            " + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.Transaction = trn;
									cmd.CommandText = sSQL;
									Sql.AddParameter(cmd, "@EMAIL1", sPAYER_EMAIL        );
									Sql.AddParameter(cmd, "@NAME"  , sPAYER_BUSINESS_NAME);
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											gACCOUNT_ID = Sql.ToGuid(rdr["ID"]);
										}
									}
								}
							}
							// 09/20/2013 Paul.  Only create the account if B2B. 
							if ( Sql.IsEmptyGuid(gACCOUNT_ID)  && !bB2C )
							{
								if ( Sql.IsEmptyString(sPAYER_BUSINESS_NAME) )
									sPAYER_BUSINESS_NAME = sFIRST_NAME + " " + sLAST_NAME;
								string sDESCRIPTION = "PayTrace ID: " + sCREDIT_CARD_ID + ControlChars.CrLf;
								SqlProcs.spACCOUNTS_Update
									( ref gACCOUNT_ID
									, Guid.Empty    // ASSIGNED_USER_ID
									, sPAYER_BUSINESS_NAME
									, "Customer"
									, Guid.Empty    // PARENT_ID
									, String.Empty  // INDUSTRY
									, String.Empty  // ANNUAL_REVENUE
									, String.Empty  // PHONE_FAX
									, sBILLING_ADDRESS_STREET
									, sBILLING_ADDRESS_CITY
									, sBILLING_ADDRESS_STATE
									, sBILLING_ADDRESS_ZIP
									, sBILLING_ADDRESS_COUNTRY
									, sDESCRIPTION
									, String.Empty  // RATING
									, sCONTACT_PHONE
									, String.Empty  // PHONE_ALTERNATE
									, sPAYER_EMAIL  // EMAIL1
									, String.Empty  // EMAIL2
									, String.Empty  // WEBSITE
									, String.Empty  // OWNERSHIP
									, String.Empty  // EMPLOYEES
									, sCREDIT_CARD_ID // Store the Payer ID in the SIC_CODE field. 
									, String.Empty  // TICKER_SYMBOL
									, sSHIPPING_ADDRESS_STREET
									, sSHIPPING_ADDRESS_CITY
									, sSHIPPING_ADDRESS_STATE
									, sSHIPPING_ADDRESS_ZIP
									, sSHIPPING_ADDRESS_COUNTRY
									, String.Empty  // ACCOUNT_NUMBER
									, Guid.Empty    // TEAM_ID
									, String.Empty  // TEAM_SET_LIST
									, false         // EXCHANGE_FOLDER
									// 08/07/2015 Paul.  Add picture. 
									, String.Empty  // PICTURE
									// 05/12/2016 Paul.  Add Tags module. 
									, String.Empty  // TAG_SET_NAME
									// 06/07/2017 Paul.  Add NAICSCodes module. 
									, String.Empty  // NAICS_SET_NAME
									// 10/27/2017 Paul.  Add Accounts as email source. 
									, false         // DO_NOT_CALL
									, false         // EMAIL_OPT_OUT
									, false         // INVALID_EMAIL
									// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
									, String.Empty  // ASSIGNED_SET_LIST
									, trn
									);
								if ( !Sql.IsEmptyGuid(gCONTACT_ID) )
									SqlProcs.spACCOUNTS_CONTACTS_Update(gACCOUNT_ID, gCONTACT_ID, trn);
							}
							// 09/20/2013 Paul.  Only create the account if B2B. 
							if ( Sql.IsEmptyGuid(gCONTACT_ID) && bB2C )
							{
								string sDESCRIPTION = "PayTrace ID: " + sCREDIT_CARD_ID + ControlChars.CrLf;
								SqlProcs.spCONTACTS_Update
									( ref gCONTACT_ID
									, Guid.Empty    // ASSIGNED_USER_ID
									, sSALUTATION
									, sFIRST_NAME
									, sLAST_NAME
									, gACCOUNT_ID
									, String.Empty  // LEAD_SOURCE
									, String.Empty  // TITLE
									, String.Empty  // DEPARTMENT
									, Guid.Empty    // REPORTS_TO_ID
									, DateTime.MinValue  // BIRTHDATE
									, false         // DO_NOT_CALL
									, String.Empty  // PHONE_HOME
									, String.Empty  // PHONE_MOBILE
									, sCONTACT_PHONE // PHONE_WORK
									, String.Empty  // PHONE_OTHER
									, String.Empty  // PHONE_FAX
									, sPAYER_EMAIL  // EMAIL1
									, String.Empty  // EMAIL2
									, String.Empty  // ASSISTANT
									, String.Empty  // ASSISTANT_PHONE
									, false         // EMAIL_OPT_OUT
									, false         // INVALID_EMAIL
									, sBILLING_ADDRESS_STREET
									, sBILLING_ADDRESS_CITY
									, sBILLING_ADDRESS_STATE
									, sBILLING_ADDRESS_ZIP
									, sBILLING_ADDRESS_COUNTRY
									, sSHIPPING_ADDRESS_STREET
									, sSHIPPING_ADDRESS_CITY
									, sSHIPPING_ADDRESS_STATE
									, sSHIPPING_ADDRESS_ZIP
									, sSHIPPING_ADDRESS_COUNTRY
									, sDESCRIPTION
									, String.Empty  // PARENT_TYPE
									, Guid.Empty    // PARENT_ID
									, false         // SYNC_CONTACT
									, Guid.Empty    // TEAM_ID
									, String.Empty  // TEAM_SET_LIST
									// 09/27/2013 Paul.  SMS messages need to be opt-in. 
									, String.Empty  // SMS_OPT_IN
									// 10/22/2013 Paul.  Provide a way to map Tweets to a parent. 
									, String.Empty  // TWITTER_SCREEN_NAME
									// 08/07/2015 Paul.  Add picture. 
									, String.Empty  // PICTURE
									// 08/07/2015 Paul.  Add Leads/Contacts relationship. 
									, Guid.Empty    // LEAD_ID
									// 09/27/2015 Paul.  Separate SYNC_CONTACT and EXCHANGE_FOLDER. 
									, false         // EXCHANGE_FOLDER
									// 05/12/2016 Paul.  Add Tags module. 
									, String.Empty  // TAG_SET_NAME
									// 06/20/2017 Paul.  Add number fields to Contacts, Leads, Prospects, Opportunities and Campaigns. 
									, String.Empty  // CONTACT_NUMBER
									// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
									, String.Empty  // ASSIGNED_SET_LIST
									// 06/23/2018 Paul.  Add DP_BUSINESS_PURPOSE and DP_CONSENT_LAST_UPDATED for data privacy. 
									, String.Empty       // DP_BUSINESS_PURPOSE
									, DateTime.MinValue  // DP_CONSENT_LAST_UPDATED
									, trn
									);
							}
							if ( Sql.IsEmptyGuid(gCREDIT_CARD_ID) )
							{
								try
								{
									if ( sCREDIT_CARD_ID.Length == 36 )
										gCREDIT_CARD_ID = Sql.ToGuid(sCREDIT_CARD_ID);
								}
								catch
								{
								}
								string   sNAME             = Sql.IsEmptyGuid(gCREDIT_CARD_ID) ? sCREDIT_CARD_ID + " " + sBILLING_ADDRESS_NAME : sBILLING_ADDRESS_NAME;
								DateTime dtEXPIRATION_DATE = DateTime.MinValue;
								try
								{
									dtEXPIRATION_DATE = new DateTime(2000 + Sql.ToInteger(sCARD_EXPIRATION_YEAR), Sql.ToInteger(sCARD_EXPIRATION_MONTH), 1);
									dtEXPIRATION_DATE = dtEXPIRATION_DATE.AddMonths(1).AddDays(-1);
								}
								catch
								{
								}
								// 08/16/2015 Paul.  Add CARD_TOKEN for use with PayPal REST API. 
								// 12/15/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
								SqlProcs.spCREDIT_CARDS_Update
								( ref gCREDIT_CARD_ID       // ID
								, gACCOUNT_ID               // ACCOUNT_ID
								, sNAME                     // NAME
								, "PayTrace"                // CARD_TYPE
								, sCARD_NUMBER              // CARD_NUMBER
								, sCARD_NUMBER_DISPLAY      // CARD_NUMBER_DISPLAY
								, String.Empty              // SECURITY_CODE
								, dtEXPIRATION_DATE         // EXPIRATION_DATE
								, String.Empty              // BANK_NAME
								, String.Empty              // BANK_ROUTING_NUMBER
								, false                     // IS_PRIMARY
								, false                     // IS_ENCRYPTED
								, sBILLING_ADDRESS_STREET   // ADDRESS_STREET
								, sBILLING_ADDRESS_CITY     // ADDRESS_CITY
								, sBILLING_ADDRESS_STATE    // ADDRESS_STATE
								, sBILLING_ADDRESS_ZIP      // ADDRESS_POSTALCODE
								, sBILLING_ADDRESS_COUNTRY  // ADDRESS_COUNTRY
								, gCONTACT_ID               // CONTACT_ID
								, sCREDIT_CARD_ID           // CARD_TOKEN
								, sPAYER_EMAIL              // EMAIL
								, sCONTACT_PHONE            // PHONE
								, trn
								);
							}
							
							Guid gSHIPPER_ID = Guid.Empty;
							if ( Sql.IsEmptyString(sINVOICE) )
								sINVOICE = "PayTrace " + sTXN_TYPE + " " + sTXN_ID;
							
							// 09/19/2013 Paul.  Creating an order is nearly identical to creating an invoice. 
							// http://help.paytrace.com/paytrace-api-name-value-pairs-data-definitions
							string sORDER       = sINVOICE;
							string sORDER_STAGE = sPAYMENT_STATUS;
							switch ( sPAYMENT_STATUS )
							{
								case "Pending Settlement":  sORDER_STAGE = "Pending"   ;  break;
								case "Authorization Only":  sORDER_STAGE = "Pending"   ;  break;
								case "Not Approved"      :  sORDER_STAGE = "Cancelled" ;  break;
								case "VOIDED"            :  sORDER_STAGE = "Cancelled" ;  break;
							}
							if ( sPAYMENT_STATUS.StartsWith("GB") )
								sORDER_STAGE = "Ordered";
							if ( sTXN_TYPE == "Refund" )
								sORDER_STAGE = "Cancelled";
							
							DataTable dtLINE_ITEMS = ds.Tables["LINE_ITEMS"];
							int nNUM_CART_ITEMS = dtLINE_ITEMS.Rows.Count;
							Decimal dSUBTOTAL = Decimal.Zero;
							foreach ( DataRow rowItem in dtLINE_ITEMS.Rows )
							{
								Decimal dUNIT_USDOLLAR = Sql.ToDecimal(rowItem["AMOUNT"]);
								dSUBTOTAL += dUNIT_USDOLLAR;
							}
							// 09/20/2013 Paul.  Don't create the order if an invoice exists. 
							if ( Sql.IsEmptyGuid(gORDER_ID) && Sql.IsEmptyGuid(gINVOICE_ID) )
							{
								SqlProcs.spORDERS_Update
									( ref gORDER_ID
									, Guid.Empty        // ASSIGNED_USER_ID
									, sORDER            // NAME
									, Guid.Empty        // QUOTE_ID
									, Guid.Empty        // OPPORTUNITY_ID
									, "Due on Receipt"  // PAYMENT_TERMS
									, sORDER_STAGE
									, sRECEIPT_ID       // PURCHASE_ORDER_NUM
									, dtPAYMENT_DATE    // ORIGINAL_PO_DATE
									, dtPAYMENT_DATE    // DATE_ORDER_DUE
									, DateTime.MinValue // DATE_ORDER_SHIPPED
									, false             // SHOW_LINE_NUMS
									, false             // CALC_GRAND_TOTAL
									, 1.0f              // EXCHANGE_RATE
									, gUSD_CURRENCY     // CURRENCY_ID
									, Guid.Empty        // TAXRATE_ID
									, gSHIPPER_ID       // SHIPPER_ID
									, dSUBTOTAL         // SUBTOTAL
									, Decimal.Zero      // DISCOUNT
									, Decimal.Zero      // SHIPPING
									, dTAX              // TAX
									, dPAYMENT_GROSS    // TOTAL
									, gACCOUNT_ID       // BILLING_ACCOUNT_ID
									, gCONTACT_ID       // BILLING_CONTACT_ID
									, sBILLING_ADDRESS_STREET
									, sBILLING_ADDRESS_CITY
									, sBILLING_ADDRESS_STATE
									, sBILLING_ADDRESS_ZIP
									, sBILLING_ADDRESS_COUNTRY
									, Guid.Empty        // SHIPPING_ACCOUNT_ID
									, Guid.Empty        // SHIPPING_CONTACT_ID
									, sSHIPPING_ADDRESS_STREET
									, sSHIPPING_ADDRESS_CITY
									, sSHIPPING_ADDRESS_STATE
									, sSHIPPING_ADDRESS_ZIP
									, sSHIPPING_ADDRESS_COUNTRY
									, sMEMO             // DESCRIPTION
									, String.Empty      // ORDER_NUM
									, Guid.Empty        // TEAM_ID
									, String.Empty      // TEAM_SET_LIST
									// 05/12/2016 Paul.  Add Tags module. 
									, String.Empty      // TAG_SET_NAME
									// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
									, String.Empty      // ASSIGNED_SET_LIST
									, trn
									);
					
								if ( nNUM_CART_ITEMS > 0 )
								{
									sSQL = "select *                          " + ControlChars.CrLf
									    + "  from vwPRODUCT_CATALOG           " + ControlChars.CrLf
									    + " where MFT_PART_NUM = @MFT_PART_NUM" + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.Transaction = trn;
										cmd.CommandText = sSQL;
										IDbDataParameter parMFT_PART_NUM = Sql.AddParameter(cmd, "@MFT_PART_NUM", String.Empty);
										int nPOSITION = 1;
										foreach ( DataRow rowItem in dtLINE_ITEMS.Rows )
										{
											Guid    gPRODUCT_TEMPLATE_ID = Guid.Empty;
											string  sPRODUCT_NAME        = Sql.ToString (rowItem["NAME"     ]);
											string  sMFT_PART_NUM        = Sql.ToString (rowItem["NUMBER"   ]);
											Decimal dITEM_TAX            = Sql.ToDecimal(rowItem["SALES_TAX"]);
											int     nITEM_QUANTITY       = Sql.ToInteger(rowItem["QUANTITY" ]);
											string  sVENDOR_PART_NUM     = String.Empty;
											string  sTAX_CLASS           = String.Empty;
											Decimal dCOST_PRICE          = Decimal.Zero;
											Decimal dCOST_USDOLLAR       = Decimal.Zero;
											Decimal dLIST_PRICE          = Decimal.Zero;
											Decimal dLIST_USDOLLAR       = Decimal.Zero;
											Decimal dUNIT_PRICE          = Sql.ToDecimal(rowItem["AMOUNT"   ]);
											Decimal dUNIT_USDOLLAR       = Sql.ToDecimal(rowItem["AMOUNT"   ]);
											if ( nITEM_QUANTITY > 0 )
											{
												dUNIT_PRICE    /= nITEM_QUANTITY;
												dUNIT_USDOLLAR /= nITEM_QUANTITY;
											}
											parMFT_PART_NUM.Value = sMFT_PART_NUM;
											using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
											{
												if ( rdr.Read() )
												{
													gPRODUCT_TEMPLATE_ID = Sql.ToGuid   (rdr["ID"             ]);
													sPRODUCT_NAME        = Sql.ToString (rdr["NAME"           ]);
													sMFT_PART_NUM        = Sql.ToString (rdr["MFT_PART_NUM"   ]);
													sVENDOR_PART_NUM     = Sql.ToString (rdr["VENDOR_PART_NUM"]);
													sTAX_CLASS           = Sql.ToString (rdr["TAX_CLASS"      ]);
													dCOST_PRICE          = Sql.ToDecimal(rdr["COST_PRICE"     ]);
													dCOST_USDOLLAR       = Sql.ToDecimal(rdr["COST_USDOLLAR"  ]);
													dLIST_PRICE          = Sql.ToDecimal(rdr["LIST_PRICE"     ]);
													dLIST_USDOLLAR       = Sql.ToDecimal(rdr["LIST_USDOLLAR"  ]);
												}
											}
											Guid gLINE_ITEM_ID = Guid.Empty;
											sTAX_CLASS = (dITEM_TAX > Decimal.Zero) ? "Taxable" : "Non-Taxable";
											// 12/13/2013 Paul.  Allow each line item to have a separate tax rate. 
											SqlProcs.spORDERS_LINE_ITEMS_Update
												( ref gLINE_ITEM_ID   
												, gORDER_ID         
												, Guid.Empty          // LINE_GROUP_ID
												, String.Empty        // LINE_ITEM_TYPE
												, nPOSITION           
												, sPRODUCT_NAME       // NAME
												, sMFT_PART_NUM
												, sVENDOR_PART_NUM    
												, gPRODUCT_TEMPLATE_ID
												, sTAX_CLASS          
												, nITEM_QUANTITY      // QUANTITY
												, dCOST_PRICE         
												, dLIST_PRICE         
												, dUNIT_PRICE         
												, String.Empty        // DESCRIPTION
												, Guid.Empty          // PARENT_TEMPLATE_ID
												, Guid.Empty          // DISCOUNT_ID
												, Decimal.Zero        // DISCOUNT_PRICE
												, String.Empty        // PRICING_FORMULA
												, 0                   // PRICING_FACTOR
												, Guid.Empty          // TAXRATE_ID
												, trn
												);
											nPOSITION++;
										}
									}
								}
							}
							// 09/20/2013 Paul.  Don't create the order if an invoice exists. 
							else if ( Sql.IsEmptyGuid(gINVOICE_ID) )
							{
								string sDESCRIPTION = String.Empty;
								sSQL = "select TAX            " + ControlChars.CrLf
								     + "     , SUBTOTAL       " + ControlChars.CrLf
								     + "     , SHIPPER_ID     " + ControlChars.CrLf
								     + "     , DESCRIPTION    " + ControlChars.CrLf
								     + "  from vwORDERS_Edit  " + ControlChars.CrLf
								     + " where ID = @ID       " + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.Transaction = trn;
									cmd.CommandText = sSQL;
									Sql.AddParameter(cmd, "@ID", gORDER_ID);
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											dTAX         = Sql.ToDecimal(rdr["TAX"        ]);
											dSUBTOTAL    = Sql.ToDecimal(rdr["SUBTOTAL"   ]);
											gSHIPPER_ID  = Sql.ToGuid   (rdr["SHIPPER_ID" ]);
											sDESCRIPTION = Sql.ToString (rdr["DESCRIPTION"]);
											if ( !Sql.IsEmptyString(sDESCRIPTION) )
											{
												if ( !Sql.IsEmptyString(sMEMO) )
													sMEMO = sDESCRIPTION + ControlChars.CrLf + sMEMO ;
												else
													sMEMO = sDESCRIPTION;
											}
										}
									}
								}
								SqlProcs.spORDERS_Update
									( ref gORDER_ID
									, Guid.Empty        // ASSIGNED_USER_ID
									, sORDER            // NAME
									, Guid.Empty        // QUOTE_ID
									, Guid.Empty        // OPPORTUNITY_ID
									, "Due on Receipt"  // PAYMENT_TERMS
									, sORDER_STAGE
									, sRECEIPT_ID       // PURCHASE_ORDER_NUM
									, dtPAYMENT_DATE    // ORIGINAL_PO_DATE
									, dtPAYMENT_DATE    // DATE_ORDER_DUE
									, DateTime.MinValue // DATE_ORDER_SHIPPED
									, false             // SHOW_LINE_NUMS
									, false             // CALC_GRAND_TOTAL
									, 1.0f              // EXCHANGE_RATE
									, gUSD_CURRENCY     // CURRENCY_ID
									, Guid.Empty        // TAXRATE_ID
									, gSHIPPER_ID       // SHIPPER_ID
									, dSUBTOTAL         // SUBTOTAL
									, Decimal.Zero      // DISCOUNT
									, Decimal.Zero      // SHIPPING
									, dTAX              // TAX
									, dPAYMENT_GROSS    // TOTAL
									, gACCOUNT_ID       // BILLING_ACCOUNT_ID
									, gCONTACT_ID       // BILLING_CONTACT_ID
									, sBILLING_ADDRESS_STREET
									, sBILLING_ADDRESS_CITY
									, sBILLING_ADDRESS_STATE
									, sBILLING_ADDRESS_ZIP
									, sBILLING_ADDRESS_COUNTRY
									, Guid.Empty        // SHIPPING_ACCOUNT_ID
									, Guid.Empty        // SHIPPING_CONTACT_ID
									, sSHIPPING_ADDRESS_STREET
									, sSHIPPING_ADDRESS_CITY
									, sSHIPPING_ADDRESS_STATE
									, sSHIPPING_ADDRESS_ZIP
									, sSHIPPING_ADDRESS_COUNTRY
									, sMEMO             // DESCRIPTION
									, String.Empty      // ORDER_NUM
									, Guid.Empty        // TEAM_ID
									, String.Empty      // TEAM_SET_LIST
									// 05/12/2016 Paul.  Add Tags module. 
									, String.Empty      // TAG_SET_NAME
									// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
									, String.Empty      // ASSIGNED_SET_LIST
									, trn
									);
							}
							
							string sINVOICE_STAGE = sPAYMENT_STATUS;
							switch ( sPAYMENT_STATUS )
							{
								case "Pending Settlement":  sINVOICE_STAGE = "Due"       ;  break;
								case "Authorization Only":  sINVOICE_STAGE = "Pending"   ;  break;
								case "Not Approved"      :  sINVOICE_STAGE = "Due"       ;  break;
								case "VOIDED"            :  sINVOICE_STAGE = "Cancelled" ;  break;
							}
							if ( sPAYMENT_STATUS.StartsWith("GB") )
								sINVOICE_STAGE = "Paid";
							if ( sTXN_TYPE == "Refund" )
								sINVOICE_STAGE = "Refunded";
							
							if ( Sql.IsEmptyGuid(gINVOICE_ID) )
							{
								// 02/27/2015 Paul.  Add SHIP_DATE to sync with QuickBooks. 
								SqlProcs.spINVOICES_Update
									( ref gINVOICE_ID
									, Guid.Empty        // ASSIGNED_USER_ID
									, sINVOICE          // NAME
									, Guid.Empty        // QUOTE_ID
									, gORDER_ID         // ORDER_ID
									, Guid.Empty        // OPPORTUNITY_ID
									, "Due on Receipt"  // PAYMENT_TERMS
									, sINVOICE_STAGE
									, sRECEIPT_ID       // PURCHASE_ORDER_NUM
									, dtPAYMENT_DATE    // DUE_DATE
									, 1.0f              // EXCHANGE_RATE
									, gUSD_CURRENCY     // CURRENCY_ID
									, Guid.Empty        // TAXRATE_ID
									, gSHIPPER_ID       // SHIPPER_ID
									, dSUBTOTAL         // SUBTOTAL
									, Decimal.Zero      // DISCOUNT
									, Decimal.Zero      // SHIPPING
									, dTAX              // TAX
									, dPAYMENT_GROSS    // TOTAL
									, Decimal.Zero      // AMOUNT_DUE
									, gACCOUNT_ID       // BILLING_ACCOUNT_ID
									, gCONTACT_ID       // BILLING_CONTACT_ID
									, sBILLING_ADDRESS_STREET
									, sBILLING_ADDRESS_CITY
									, sBILLING_ADDRESS_STATE
									, sBILLING_ADDRESS_ZIP
									, sBILLING_ADDRESS_COUNTRY
									, Guid.Empty        // SHIPPING_ACCOUNT_ID
									, Guid.Empty        // SHIPPING_CONTACT_ID
									, sSHIPPING_ADDRESS_STREET
									, sSHIPPING_ADDRESS_CITY
									, sSHIPPING_ADDRESS_STATE
									, sSHIPPING_ADDRESS_ZIP
									, sSHIPPING_ADDRESS_COUNTRY
									, sMEMO             // DESCRIPTION
									, String.Empty      // INVOICE_NUM
									, Guid.Empty        // TEAM_ID
									, String.Empty      // TEAM_SET_LIST
									, DateTime.MinValue // SHIP_DATE
									// 05/12/2016 Paul.  Add Tags module. 
									, String.Empty      // TAG_SET_NAME
									// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
									, String.Empty      // ASSIGNED_SET_LIST
									, trn
									);
								
								if ( nNUM_CART_ITEMS > 0 )
								{
									sSQL = "select *                          " + ControlChars.CrLf
									    + "  from vwPRODUCT_CATALOG           " + ControlChars.CrLf
									    + " where MFT_PART_NUM = @MFT_PART_NUM" + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.Transaction = trn;
										cmd.CommandText = sSQL;
										IDbDataParameter parMFT_PART_NUM = Sql.AddParameter(cmd, "@MFT_PART_NUM", String.Empty);
										int nPOSITION = 1;
										foreach ( DataRow rowItem in dtLINE_ITEMS.Rows )
										{
											Guid    gPRODUCT_TEMPLATE_ID = Guid.Empty;
											string  sPRODUCT_NAME        = Sql.ToString (rowItem["NAME"     ]);
											string  sMFT_PART_NUM        = Sql.ToString (rowItem["NUMBER"   ]);
											Decimal dITEM_TAX            = Sql.ToDecimal(rowItem["SALES_TAX"]);
											int     nITEM_QUANTITY       = Sql.ToInteger(rowItem["QUANTITY" ]);
											string  sVENDOR_PART_NUM     = String.Empty;
											string  sTAX_CLASS           = String.Empty;
											Decimal dCOST_PRICE          = Decimal.Zero;
											Decimal dCOST_USDOLLAR       = Decimal.Zero;
											Decimal dLIST_PRICE          = Decimal.Zero;
											Decimal dLIST_USDOLLAR       = Decimal.Zero;
											Decimal dUNIT_PRICE          = Sql.ToDecimal(rowItem["AMOUNT"   ]);
											Decimal dUNIT_USDOLLAR       = Sql.ToDecimal(rowItem["AMOUNT"   ]);
											if ( nITEM_QUANTITY > 0 )
											{
												dUNIT_PRICE    /= nITEM_QUANTITY;
												dUNIT_USDOLLAR /= nITEM_QUANTITY;
											}
											parMFT_PART_NUM.Value = sMFT_PART_NUM;
											using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
											{
												if ( rdr.Read() )
												{
													gPRODUCT_TEMPLATE_ID = Sql.ToGuid   (rdr["ID"             ]);
													sPRODUCT_NAME        = Sql.ToString (rdr["NAME"           ]);
													sMFT_PART_NUM        = Sql.ToString (rdr["MFT_PART_NUM"   ]);
													sVENDOR_PART_NUM     = Sql.ToString (rdr["VENDOR_PART_NUM"]);
													sTAX_CLASS           = Sql.ToString (rdr["TAX_CLASS"      ]);
													dCOST_PRICE          = Sql.ToDecimal(rdr["COST_PRICE"     ]);
													dCOST_USDOLLAR       = Sql.ToDecimal(rdr["COST_USDOLLAR"  ]);
													dLIST_PRICE          = Sql.ToDecimal(rdr["LIST_PRICE"     ]);
													dLIST_USDOLLAR       = Sql.ToDecimal(rdr["LIST_USDOLLAR"  ]);
												}
											}
											Guid gLINE_ITEM_ID = Guid.Empty;
											sTAX_CLASS = (dITEM_TAX > Decimal.Zero) ? "Taxable" : "Non-Taxable";
											// 12/13/2013 Paul.  Allow each line item to have a separate tax rate. 
											SqlProcs.spINVOICES_LINE_ITEMS_Update
												( ref gLINE_ITEM_ID   
												, gINVOICE_ID         
												, Guid.Empty          // LINE_GROUP_ID
												, String.Empty        // LINE_ITEM_TYPE
												, nPOSITION           
												, sPRODUCT_NAME       // NAME
												, sMFT_PART_NUM
												, sVENDOR_PART_NUM    
												, gPRODUCT_TEMPLATE_ID
												, sTAX_CLASS          
												, nITEM_QUANTITY      // QUANTITY
												, dCOST_PRICE         
												, dLIST_PRICE         
												, dUNIT_PRICE         
												, String.Empty        // DESCRIPTION
												, Guid.Empty          // PARENT_TEMPLATE_ID
												, Guid.Empty          // DISCOUNT_ID
												, Decimal.Zero        // DISCOUNT_PRICE
												, String.Empty        // PRICING_FORMULA
												, 0                   // PRICING_FACTOR
												, Guid.Empty          // TAXRATE_ID
												, trn
												);
											nPOSITION++;
										}
									}
								}
							}
							else
							{
								string sDESCRIPTION = String.Empty;
								sSQL = "select TAX            " + ControlChars.CrLf
								     + "     , SUBTOTAL       " + ControlChars.CrLf
								     + "     , SHIPPER_ID     " + ControlChars.CrLf
								     + "     , DESCRIPTION    " + ControlChars.CrLf
								     + "  from vwINVOICES_Edit" + ControlChars.CrLf
								     + " where ID = @ID       " + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.Transaction = trn;
									cmd.CommandText = sSQL;
									Sql.AddParameter(cmd, "@ID", gINVOICE_ID);
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											dTAX         = Sql.ToDecimal(rdr["TAX"        ]);
											dSUBTOTAL    = Sql.ToDecimal(rdr["SUBTOTAL"   ]);
											gSHIPPER_ID  = Sql.ToGuid   (rdr["SHIPPER_ID" ]);
											sDESCRIPTION = Sql.ToString (rdr["DESCRIPTION"]);
											if ( !Sql.IsEmptyString(sDESCRIPTION) )
											{
												// 09/20/2013 Paul.  Prevent repeated appending of memo. 
												if ( !Sql.IsEmptyString(sMEMO) && sDESCRIPTION != sMEMO )
													sMEMO = sDESCRIPTION + ControlChars.CrLf + sMEMO ;
												else
													sMEMO = sDESCRIPTION;
											}
										}
									}
								}
								// 02/27/2015 Paul.  Add SHIP_DATE to sync with QuickBooks. 
								SqlProcs.spINVOICES_Update
									( ref gINVOICE_ID
									, Guid.Empty        // ASSIGNED_USER_ID
									, sINVOICE          // NAME
									, Guid.Empty        // QUOTE_ID
									, gORDER_ID         // ORDER_ID
									, Guid.Empty        // OPPORTUNITY_ID
									, "Due on Receipt"  // PAYMENT_TERMS
									, sINVOICE_STAGE
									, sRECEIPT_ID       // PURCHASE_ORDER_NUM
									, dtPAYMENT_DATE    // DUE_DATE
									, 1.0f              // EXCHANGE_RATE
									, gUSD_CURRENCY     // CURRENCY_ID
									, Guid.Empty        // TAXRATE_ID
									, gSHIPPER_ID       // SHIPPER_ID
									, dSUBTOTAL         // SUBTOTAL
									, Decimal.Zero      // DISCOUNT
									, Decimal.Zero      // SHIPPING
									, dTAX              // TAX
									, dPAYMENT_GROSS    // TOTAL
									, Decimal.Zero      // AMOUNT_DUE
									, gACCOUNT_ID       // BILLING_ACCOUNT_ID
									, gCONTACT_ID       // BILLING_CONTACT_ID
									, sBILLING_ADDRESS_STREET
									, sBILLING_ADDRESS_CITY
									, sBILLING_ADDRESS_STATE
									, sBILLING_ADDRESS_ZIP
									, sBILLING_ADDRESS_COUNTRY
									, Guid.Empty        // SHIPPING_ACCOUNT_ID
									, Guid.Empty        // SHIPPING_CONTACT_ID
									, sSHIPPING_ADDRESS_STREET
									, sSHIPPING_ADDRESS_CITY
									, sSHIPPING_ADDRESS_STATE
									, sSHIPPING_ADDRESS_ZIP
									, sSHIPPING_ADDRESS_COUNTRY
									, sMEMO             // DESCRIPTION
									, String.Empty      // INVOICE_NUM
									, Guid.Empty        // TEAM_ID
									, String.Empty      // TEAM_SET_LIST
									, DateTime.MinValue // SHIP_DATE
									// 05/12/2016 Paul.  Add Tags module. 
									, String.Empty      // TAG_SET_NAME
									// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
									, String.Empty      // ASSIGNED_SET_LIST
									, trn
									);
							}
							
							if ( Sql.IsEmptyGuid(gPAYMENT_ID) )
							{
								Guid gB2C_CONTACT_ID = Guid.Empty;
								SqlProcs.spPAYMENTS_Update
									( ref gPAYMENT_ID
									, Guid.Empty      // ASSIGNED_USER_ID
									, gACCOUNT_ID
									, dtPAYMENT_DATE
									, "Credit card"   // PAYMENT_TYPE
									, sRECEIPT_ID     // CUSTOMER_REFERENCE
									, 1.0f            // EXCHANGE_RATE
									, gUSD_CURRENCY   // CURRENCY_ID
									, dPAYMENT_GROSS  // AMOUNT
									, String.Empty    // DESCRIPTION
									, gCREDIT_CARD_ID
									, String.Empty    // PAYMENT_NUM
									, Guid.Empty      // TEAM_ID
									, String.Empty    // TEAM_SET_LIST
									, Decimal.Zero    // BANK_FEE
									, gB2C_CONTACT_ID
									// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
									, String.Empty    // ASSIGNED_SET_LIST
									, trn
									);
								Guid gINVOICES_PAYMENT_ID = Guid.Empty;
								SqlProcs.spINVOICES_PAYMENTS_Update(ref gINVOICES_PAYMENT_ID, gINVOICE_ID, gPAYMENT_ID, dPAYMENT_GROSS, trn);
							}
							if ( Sql.IsEmptyGuid(gPAYMENTS_TRANSACTION_ID) )
							{
								string sTRANSACTION_TYPE = sPAYMENT_STATUS;
								switch ( sPAYMENT_STATUS )
								{
									case "Pending Settlement":  sINVOICE_STAGE = "Pending"   ;  break;
									case "Authorization Only":  sINVOICE_STAGE = "Pending"   ;  break;
									case "Not Approved"      :  sINVOICE_STAGE = "Due"       ;  break;
									case "VOIDED"            :  sINVOICE_STAGE = "Cancelled" ;  break;
								}
								if ( sPAYMENT_STATUS.StartsWith("GB") )
									sINVOICE_STAGE = "Sale";
								if ( sTXN_TYPE == "Refund" )
									sPAYMENT_STATUS = "Refund";
								
								string sINVOICE_NUMBER = String.Empty;
								sSQL = "select INVOICE_NUM" + ControlChars.CrLf
								     + "  from vwINVOICES " + ControlChars.CrLf
								     + " where ID = @ID   " + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.Transaction = trn;
									cmd.CommandText = sSQL;
									Sql.AddParameter(cmd, "@ID", gINVOICE_ID);
									sINVOICE_NUMBER = Sql.ToString(cmd.ExecuteScalar());
								}
								
								SqlProcs.spPAYMENTS_TRANSACTIONS_InsertOnly
									( ref gPAYMENTS_TRANSACTION_ID
									, gPAYMENT_ID
									, "PayTrace"         // PAYMENT_GATEWAY
									, sTRANSACTION_TYPE  // Sale or Refund. 
									, dPAYMENT_GROSS
									, gUSD_CURRENCY      // CURRENCY_ID
									, sINVOICE_NUMBER    // INVOICE_NUMBER
									, sMEMO              // DESCRIPTION
									, gCREDIT_CARD_ID
									, gACCOUNT_ID
									, sPAYMENT_STATUS    // STATUS
									, trn
									);
								SqlProcs.spPAYMENTS_TRANSACTIONS_Update
									( gPAYMENTS_TRANSACTION_ID
									, sPAYMENT_STATUS     // STATUS
									, sTXN_ID             // TRANSACTION_NUMBER
									, sREFERENCE_NUMBER   // REFERENCE_NUMBER
									, sAUTHORIZATION_CODE // AUTHORIZATION_CODE
									, sAVS_CODE           // AVS_CODE
									, sPENDING_REASON     // ERROR_CODE
									, sREASON_CODE        // ERROR_MESSAGE
									, trn
									);
							}
							trn.Commit();
						}
						catch
						{
							trn.Rollback();
							throw;
						}
					}
				}
			}
		}

	}
}
