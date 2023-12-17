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
using System.Web;
using System.Data;
using System.Data.Common;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Diagnostics;

// Install-Package PayPal
// https://github.com/paypal/PayPal-NET-SDK
using PayPal;
using PayPal.Api;

using Microsoft.Extensions.Caching.Memory;

namespace SplendidCRM
{
	/// <summary>
	/// Summary description for PayPalRest.
	/// </summary>
	public class PayPalRest
	{
		private DbProviderFactories  DbProviderFactories = new DbProviderFactories();
		private HttpApplicationState Application         = new HttpApplicationState();
		private SplendidDefaults     SplendidDefaults    = new SplendidDefaults();
		private IMemoryCache         Cache              ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private Currency             Currency           = new Currency();
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private PayPalCache          PayPalCache        ;
		
		public PayPalRest(IMemoryCache memoryCache, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, PayPalCache PayPalCache)
		{
			this.Cache               = memoryCache        ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.PayPalCache         = PayPalCache        ;
		}

		// 12/15/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
		public void StoreCreditCard(ref string sCARD_TOKEN, string sNAME, string sCARD_TYPE, string sCARD_NUMBER, string sSECURITY_CODE, int nEXPIRATION_MONTH, int nEXPIRATION_YEAR, string sADDRESS_STREET, string sADDRESS_CITY, string sADDRESS_STATE, string sADDRESS_POSTALCODE, string sADDRESS_COUNTRY, string sEMAIL, string sPHONE)
		{
			StringDictionary dictCountries = PayPalCache.Countries();
			string sPayPalClientID     = Sql.ToString (Application["CONFIG.PayPal.ClientID"    ]);
			string sPayPalClientSecret = Sql.ToString (Application["CONFIG.PayPal.ClientSecret"]);
			bool   bPayPalSandbox      = Sql.ToBoolean(Application["CONFIG.PayPal.Sandbox"     ]);
			Dictionary<string,string> config = new Dictionary<string,string>();
			config.Add("connectionTimeout", "60000");
			if ( bPayPalSandbox )
				config.Add("mode", "sandbox");
			else
				config.Add("mode", "live");
			OAuthTokenCredential oauth = new OAuthTokenCredential(sPayPalClientID, sPayPalClientSecret, config);
			
			string sAccessToken = oauth.GetAccessToken();
			APIContext apiContext = new APIContext(sAccessToken);
			apiContext.Config = config;
			
			CreditCard credit_card = null;
			// 08/16/2015 Paul.  A credit card cannot be updated, it must be deleted and recreated. 
			if ( !Sql.IsEmptyString(sCARD_TOKEN) )
			{
				try
				{
					credit_card = CreditCard.Get(apiContext, sCARD_TOKEN);
					credit_card.Delete(apiContext);
				}
				catch(Exception ex)
				{
					// 08/21/2015 Paul.  If we cannot delete the card, just ignore the error. 
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "Delete Stored Card " + sCARD_TOKEN + ": " + ex.Message);
				}
				sCARD_TOKEN = String.Empty;
			}
			
			credit_card = new CreditCard();
			credit_card.billing_address = new Address();
			string sFIRST_NAME      = String.Empty;
			string sMIDDLE_NAME     = String.Empty;
			string sLAST_NAME       = String.Empty;
			string sADDRESS_STREET1 = String.Empty;
			string sADDRESS_STREET2 = String.Empty;
			string[] arrCREDIT_CARD_NAME = sNAME.Split(' ');
			string[] arrADDRESS_STREET   = sADDRESS_STREET.Split(ControlChars.CrLf.ToCharArray());
			if ( arrCREDIT_CARD_NAME.Length == 2 )
			{
				sFIRST_NAME  = arrCREDIT_CARD_NAME[0];
				sLAST_NAME   = arrCREDIT_CARD_NAME[1];
			}
			else if ( arrCREDIT_CARD_NAME.Length == 3 )
			{
				sFIRST_NAME  = arrCREDIT_CARD_NAME[0];
				sMIDDLE_NAME = arrCREDIT_CARD_NAME[1];
				sLAST_NAME   = arrCREDIT_CARD_NAME[2];
			}
			sADDRESS_STREET1 = arrADDRESS_STREET[0];
			if ( arrADDRESS_STREET.Length > 1 )
			{
				sADDRESS_STREET2 = arrADDRESS_STREET[1];
			}
			if ( sCARD_TYPE.StartsWith("Bank Draft") )
			{
				throw(new Exception("Bank Drafts are not supported at this time. "));
			}
			else if ( sCARD_TYPE == "American Express" )
			{
				sCARD_TYPE = "amex";
			}
			else if ( sCARD_TYPE == "Discover Card" )
			{
				sCARD_TYPE = "discover";
			}
			credit_card.number       = sCARD_NUMBER           ;
			credit_card.type         = sCARD_TYPE.ToLower()   ;
			credit_card.expire_month = nEXPIRATION_MONTH      ;
			credit_card.expire_year  = nEXPIRATION_YEAR       ;
			if ( !Sql.IsEmptyString(sSECURITY_CODE     ) ) credit_card.cvv2                         = sSECURITY_CODE     ;
			if ( !Sql.IsEmptyString(sFIRST_NAME        ) ) credit_card.first_name                   = sFIRST_NAME        ;
			if ( !Sql.IsEmptyString(sLAST_NAME         ) ) credit_card.last_name                    = sLAST_NAME         ;
			if ( !Sql.IsEmptyString(sADDRESS_STREET1   ) ) credit_card.billing_address.line1        = sADDRESS_STREET1   ;
			if ( !Sql.IsEmptyString(sADDRESS_STREET2   ) ) credit_card.billing_address.line2        = sADDRESS_STREET2   ;
			if ( !Sql.IsEmptyString(sADDRESS_CITY      ) ) credit_card.billing_address.city         = sADDRESS_CITY      ;
			if ( !Sql.IsEmptyString(sADDRESS_STATE     ) ) credit_card.billing_address.state        = sADDRESS_STATE     ;
			if ( !Sql.IsEmptyString(sADDRESS_POSTALCODE) ) credit_card.billing_address.postal_code  = sADDRESS_POSTALCODE;
			if ( !Sql.IsEmptyString(sADDRESS_COUNTRY   ) ) credit_card.billing_address.country_code = sADDRESS_COUNTRY   ;
			if ( !Sql.IsEmptyString(sPHONE             ) ) credit_card.billing_address.phone        = sPHONE             ;
			// https://developer.paypal.com/webapps/developer/docs/api/#common-payments-objects
			// https://developer.paypal.com/webapps/developer/docs/classic/api/country_codes/
			if ( !Sql.IsEmptyString(credit_card.billing_address.country_code) )
			{
				try
				{
					// 12/16/2008 Paul.  Use the countries dictionary to convert to the correct country code. 
					if ( dictCountries.ContainsKey(credit_card.billing_address.country_code.ToUpper()) )
						credit_card.billing_address.country_code = dictCountries[credit_card.billing_address.country_code.ToUpper()];
				}
				catch
				{
				}
			}
			if ( Sql.IsEmptyString(credit_card.billing_address.country_code) )
			{
				// 12/16/2008 Paul.  Always set the country, otherwise PayPal will fail. 
				credit_card.billing_address.country_code = "US";
			}
			
			try
			{
				CreditCard newCreditCard = credit_card.Create(apiContext);
				sCARD_TOKEN = newCreditCard.id;
				// 08/16/2015 Paul.  Let exceptions filter up. 
			}
			catch(PaymentsException ex)
			{
				StringBuilder sbErrors = new StringBuilder();
				if ( ex.Details != null )
				{
					if ( ex.Details.details != null )
					{
						foreach ( ErrorDetails detail in ex.Details.details )
						{
#if DEBUG
							sbErrors.AppendLine(detail.field + ": " + detail.issue);
#else
							sbErrors.AppendLine(detail.issue);
#endif
						}
					}
					else
					{
						sbErrors.AppendLine(ex.Details.message);
					}
				}
				else
				{
					sbErrors.AppendLine(ex.Message);
				}
				throw(new Exception(sbErrors.ToString(), ex));
			}
		}

		public string Charge(Guid gCURRENCY_ID, Guid gCONTACT_ID, Guid gINVOICE_ID, Guid gPAYMENT_ID, Guid gCREDIT_CARD_ID)
		{
			Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
			Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
			StringDictionary dictCountries = PayPalCache.Countries();
			
			string sSTATUS = "Prevalidation";
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				Currency C10n = Currency.CreateCurrency(gCURRENCY_ID);
				Payment payment = new Payment();
				payment.intent = "sale";
				payment.payer = new Payer();
				payment.payer.payer_info = new PayerInfo();
				payment.payer.payment_method = "credit_card";
				payment.payer.funding_instruments = new List<FundingInstrument>();
				payment.payer.funding_instruments.Add(new FundingInstrument());
				payment.transactions = new List<Transaction>();
				payment.transactions.Add(new Transaction());
				payment.transactions[0].amount = new Amount();
				payment.transactions[0].amount.details = new Details();
				payment.transactions[0].item_list = new ItemList();
				payment.transactions[0].item_list.items = new List<Item>();
				
				string sFULL_NAME   = String.Empty;
				string sFIRST_NAME  = String.Empty;
				string sMIDDLE_NAME = String.Empty;
				string sLAST_NAME   = String.Empty;
				string sEMAIL1      = String.Empty;
				string sPHONE_WORK  = String.Empty;
				string sSQL         = String.Empty;
				sSQL = "select *         " + ControlChars.CrLf
				     + "  from vwCONTACTS" + ControlChars.CrLf
				     + " where ID = @ID  " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gCONTACT_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							sFULL_NAME  = Sql.ToString(rdr["NAME"      ]);
							sFIRST_NAME = Sql.ToString(rdr["FIRST_NAME"]);
							sLAST_NAME  = Sql.ToString(rdr["LAST_NAME" ]);
							sEMAIL1     = Sql.ToString(rdr["EMAIL1"    ]);
							sPHONE_WORK = Sql.ToString(rdr["PHONE_WORK"]);
							if ( !Sql.IsEmptyString(sEMAIL1    ) ) payment.payer.payer_info.email      = sEMAIL1    ;
							// 10/20/2015 Paul.  payer.payer_info.phone: This field invalid when payment_method is 'credit_card'
							//if ( !Sql.IsEmptyString(sPHONE_WORK) ) payment.payer.payer_info.phone      = sPHONE_WORK;
							if ( !Sql.IsEmptyString(sFIRST_NAME) ) payment.payer.payer_info.first_name = sFIRST_NAME;
							if ( !Sql.IsEmptyString(sLAST_NAME ) ) payment.payer.payer_info.last_name  = sLAST_NAME ;
						}
					}
				}
				
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
							string sCARD_TOKEN  = Sql.ToString(rdr["CARD_TOKEN" ]);
							if ( Sql.IsEmptyString(sCARD_TOKEN) )
							{
								string sCARD_NUMBER = Sql.ToString(rdr["CARD_NUMBER"]);
								if ( Sql.ToBoolean(rdr["IS_ENCRYPTED"]) )
								{
									sCARD_NUMBER = Security.DecryptPassword(sCARD_NUMBER, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
								}
								sCARD_NUMBER = sCARD_NUMBER.Replace(" ", String.Empty).Replace("-", String.Empty);
								string sCARD_TYPE = Sql.ToString(rdr["CARD_TYPE"]);
								if ( sCARD_TYPE.StartsWith("Bank Draft") )
								{
									throw(new Exception("Bank Drafts are not supported at this time. "));
								}
								else if ( sCARD_TYPE == "American Express" )
								{
									sCARD_TYPE = "amex";
								}
								else if ( sCARD_TYPE == "Discover Card" )
								{
									sCARD_TYPE = "discover";
								}
								
								// 12/15/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
								if ( Sql.IsEmptyString(payment.payer.payer_info.email) && !Sql.IsEmptyString(rdr["EMAIL"]) )
									payment.payer.payer_info.email = Sql.ToString(rdr["EMAIL"]);
								
								string sADDRESS_STREET1 = String.Empty;
								string sADDRESS_STREET2 = String.Empty;
								DateTime dtEXPIRATION_DATE = Sql.ToDateTime(rdr["EXPIRATION_DATE"]);
								string sCREDIT_CARD_NAME   = Sql.ToString  (rdr["NAME"           ]);
								string sADDRESS_STREET     = Sql.ToString  (rdr["ADDRESS_STREET" ]);
								string[] arrCREDIT_CARD_NAME = sCREDIT_CARD_NAME.Split(' ');
								string[] arrADDRESS_STREET   = sADDRESS_STREET.Split(ControlChars.CrLf.ToCharArray());
								if ( arrCREDIT_CARD_NAME.Length == 2 )
								{
									sFIRST_NAME  = arrCREDIT_CARD_NAME[0];
									sLAST_NAME   = arrCREDIT_CARD_NAME[1];
								}
								else if ( arrCREDIT_CARD_NAME.Length == 3 )
								{
									sFIRST_NAME  = arrCREDIT_CARD_NAME[0];
									sMIDDLE_NAME = arrCREDIT_CARD_NAME[1];
									sLAST_NAME   = arrCREDIT_CARD_NAME[2];
								}
								sADDRESS_STREET1 = arrADDRESS_STREET[0];
								if ( arrADDRESS_STREET.Length > 1 )
								{
									sADDRESS_STREET2 = arrADDRESS_STREET[1];
								}
								payment.payer.funding_instruments[0].credit_card = new CreditCard();
								payment.payer.funding_instruments[0].credit_card.billing_address = new Address();
								payment.payer.funding_instruments[0].credit_card.number       = sCARD_NUMBER           ;
								payment.payer.funding_instruments[0].credit_card.type         = sCARD_TYPE.ToLower()   ;
								payment.payer.funding_instruments[0].credit_card.expire_month = dtEXPIRATION_DATE.Month;
								payment.payer.funding_instruments[0].credit_card.expire_year  = dtEXPIRATION_DATE.Year ;
								if ( !Sql.IsEmptyString(rdr["SECURITY_CODE"     ]) ) payment.payer.funding_instruments[0].credit_card.cvv2                          = Sql.ToString(rdr["SECURITY_CODE"     ]);
								if ( !Sql.IsEmptyString(sFIRST_NAME              ) ) payment.payer.funding_instruments[0].credit_card.first_name                    = sFIRST_NAME;
								if ( !Sql.IsEmptyString(sLAST_NAME               ) ) payment.payer.funding_instruments[0].credit_card.last_name                     = sLAST_NAME ;
								if ( !Sql.IsEmptyString(sPHONE_WORK              ) ) payment.payer.funding_instruments[0].credit_card.billing_address.phone         = sPHONE_WORK;
								if ( !Sql.IsEmptyString(sADDRESS_STREET1         ) ) payment.payer.funding_instruments[0].credit_card.billing_address.line1         = sADDRESS_STREET1;
								if ( !Sql.IsEmptyString(sADDRESS_STREET2         ) ) payment.payer.funding_instruments[0].credit_card.billing_address.line2         = sADDRESS_STREET2;
								if ( !Sql.IsEmptyString(rdr["ADDRESS_CITY"      ]) ) payment.payer.funding_instruments[0].credit_card.billing_address.city          = Sql.ToString(rdr["ADDRESS_CITY"      ]);
								if ( !Sql.IsEmptyString(rdr["ADDRESS_STATE"     ]) ) payment.payer.funding_instruments[0].credit_card.billing_address.state         = Sql.ToString(rdr["ADDRESS_STATE"     ]);
								if ( !Sql.IsEmptyString(rdr["ADDRESS_POSTALCODE"]) ) payment.payer.funding_instruments[0].credit_card.billing_address.postal_code   = Sql.ToString(rdr["ADDRESS_POSTALCODE"]);
								if ( !Sql.IsEmptyString(rdr["ADDRESS_COUNTRY"   ]) ) payment.payer.funding_instruments[0].credit_card.billing_address.country_code  = Sql.ToString(rdr["ADDRESS_COUNTRY"   ]);
								// 12/15/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
								if ( !Sql.IsEmptyString(rdr["PHONE"             ]) ) payment.payer.funding_instruments[0].credit_card.billing_address.phone         = Sql.ToString(rdr["PHONE"             ]);
								// https://developer.paypal.com/webapps/developer/docs/api/#common-payments-objects
								// https://developer.paypal.com/webapps/developer/docs/classic/api/country_codes/
								if ( !Sql.IsEmptyString(payment.payer.funding_instruments[0].credit_card.billing_address.country_code) )
								{
									try
									{
										// 12/16/2008 Paul.  Use the countries dictionary to convert to the correct country code. 
										if ( dictCountries.ContainsKey(payment.payer.funding_instruments[0].credit_card.billing_address.country_code.ToUpper()) )
											payment.payer.funding_instruments[0].credit_card.billing_address.country_code = dictCountries[payment.payer.funding_instruments[0].credit_card.billing_address.country_code.ToUpper()];
									}
									catch
									{
									}
								}
								if ( Sql.IsEmptyString(payment.payer.funding_instruments[0].credit_card.billing_address.country_code) )
								{
									// 12/16/2008 Paul.  Always set the country, otherwise PayPal will fail. 
									payment.payer.funding_instruments[0].credit_card.billing_address.country_code = "US";
								}
							}
							else
							{
								payment.payer.funding_instruments[0].credit_card_token = new CreditCardToken();
								payment.payer.funding_instruments[0].credit_card_token.credit_card_id = sCARD_TOKEN;
							}
						}
					}
				}
				
				string  sInvoiceNumber = String.Empty;
				string  sInvoiceName   = String.Empty;
				decimal dAMOUNT        = Decimal.Zero;
				Guid    gACCOUNT_ID    = Guid.Empty;
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
							string sOrderSubtotal    = String.Empty;
							string sOrderTotal       = String.Empty;
							string sShippingTotal    = String.Empty;
							string sTaxTotal         = String.Empty;
							// 04/30/2016 Paul.  Base currency has been USD, but we should make it easy to allow a different base. 
							if ( C10n.ISO4217 == SplendidDefaults.BaseCurrencyISO() )
							{
								if ( rdr["SUBTOTAL_USDOLLAR"] != DBNull.Value ) sOrderSubtotal    = Sql.ToDecimal(rdr["SUBTOTAL_USDOLLAR"]).ToString("0.00");
								if ( rdr["TOTAL_USDOLLAR"   ] != DBNull.Value ) sOrderTotal       = Sql.ToDecimal(rdr["TOTAL_USDOLLAR"   ]).ToString("0.00");
								if ( rdr["SHIPPING_USDOLLAR"] != DBNull.Value ) sShippingTotal    = Sql.ToDecimal(rdr["SHIPPING_USDOLLAR"]).ToString("0.00");
								if ( rdr["TAX_USDOLLAR"     ] != DBNull.Value ) sTaxTotal         = Sql.ToDecimal(rdr["TAX_USDOLLAR"     ]).ToString("0.00");
							}
							else
							{
								if ( rdr["SUBTOTAL"] != DBNull.Value ) sOrderSubtotal    = Sql.ToDecimal(rdr["SUBTOTAL"]).ToString("0.00");
								if ( rdr["TOTAL"   ] != DBNull.Value ) sOrderTotal       = Sql.ToDecimal(rdr["TOTAL"   ]).ToString("0.00");
								if ( rdr["SHIPPING"] != DBNull.Value ) sShippingTotal    = Sql.ToDecimal(rdr["SHIPPING"]).ToString("0.00");
								if ( rdr["TAX"     ] != DBNull.Value ) sTaxTotal         = Sql.ToDecimal(rdr["TAX"     ]).ToString("0.00");
							}

							gACCOUNT_ID    = Sql.ToGuid(rdr["BILLING_ACCOUNT_ID"]);
							if ( Sql.IsEmptyGuid(gACCOUNT_ID) )
								gACCOUNT_ID = Sql.ToGuid(rdr["BILLING_CONTACT_ID"]);
							sInvoiceNumber = Sql.ToString(rdr["ID"  ]);
							sInvoiceName   = Sql.ToString(rdr["NAME"]);
							payment.transactions[0].invoice_number            = sInvoiceNumber;
							payment.transactions[0].description               = sInvoiceName  ;
							payment.transactions[0].amount.currency           = C10n.ISO4217  ;
							payment.transactions[0].amount.details.subtotal   = sOrderSubtotal;
							payment.transactions[0].amount.total              = sOrderTotal   ;
							// 04/24/2016 Paul.  Convert from string value so that we match the validation behavior of PayPal. 
							dAMOUNT = Sql.ToDecimal(sOrderTotal);
							if ( !Sql.IsEmptyString(rdr["SHIPPER_NAME"]) )
								payment.transactions[0].item_list.shipping_method = Sql.ToString(rdr["SHIPPER_NAME"]);
							if ( !Sql.IsEmptyString(sShippingTotal) )
							{
								payment.transactions[0].amount.details.shipping = sShippingTotal;
							}
							if ( !Sql.IsEmptyString(sTaxTotal) )
							{
								payment.transactions[0].amount.details.tax      = sTaxTotal;
							}
							// 03/30/2016 Paul.  PayPal does not support a discount field, but total must match subtotal, so don't include the details if there is a discount.
							if ( Sql.ToDecimal(rdr["DISCOUNT_USDOLLAR"]) > 0 )
							{
								payment.transactions[0].amount.details = null;
							}
							if ( !Sql.IsEmptyString(rdr["SHIPPING_ADDRESS_STREET"]) )
							{
								string sADDRESS_STREET1 = String.Empty;
								string sADDRESS_STREET2 = String.Empty;
								string sADDRESS_STREET  = Sql.ToString  (rdr["ADDRESS_STREET" ]);
								string[] arrADDRESS_STREET = sADDRESS_STREET.Split(ControlChars.CrLf.ToCharArray());
								sADDRESS_STREET1 = arrADDRESS_STREET[0];
								if ( arrADDRESS_STREET.Length > 1 )
								{
									sADDRESS_STREET2 = arrADDRESS_STREET[1];
								}
								payment.transactions[0].item_list.shipping_address = new ShippingAddress();
								if ( !Sql.IsEmptyString(sADDRESS_STREET1                  ) ) payment.transactions[0].item_list.shipping_address.line1          = sADDRESS_STREET1;
								if ( !Sql.IsEmptyString(sADDRESS_STREET2                  ) ) payment.transactions[0].item_list.shipping_address.line2          = sADDRESS_STREET2;
								if ( !Sql.IsEmptyString(rdr["SHIPPING_ADDRESS_CITY"      ]) ) payment.transactions[0].item_list.shipping_address.city           = Sql.ToString(rdr["SHIPPING_ADDRESS_CITY"      ]);
								if ( !Sql.IsEmptyString(rdr["SHIPPING_ADDRESS_STATE"     ]) ) payment.transactions[0].item_list.shipping_address.state          = Sql.ToString(rdr["SHIPPING_ADDRESS_STATE"     ]);
								if ( !Sql.IsEmptyString(rdr["SHIPPING_ADDRESS_POSTALCODE"]) ) payment.transactions[0].item_list.shipping_address.postal_code    = Sql.ToString(rdr["SHIPPING_ADDRESS_POSTALCODE"]);
								if ( !Sql.IsEmptyString(rdr["SHIPPING_ADDRESS_COUNTRY"   ]) ) payment.transactions[0].item_list.shipping_address.country_code   = Sql.ToString(rdr["SHIPPING_ADDRESS_COUNTRY"   ]);
								if ( !Sql.IsEmptyString(rdr["SHIPPING_CONTACT_NAME"      ]) ) payment.transactions[0].item_list.shipping_address.recipient_name = Sql.ToString(rdr["SHIPPING_CONTACT_NAME"      ]);
								// https://developer.paypal.com/webapps/developer/docs/api/#common-payments-objects
								// https://developer.paypal.com/webapps/developer/docs/classic/api/country_codes/
								if ( !Sql.IsEmptyString(payment.transactions[0].item_list.shipping_address.country_code) )
								{
									try
									{
										// 12/16/2008 Paul.  Use the countries dictionary to convert to the correct country code. 
										if ( dictCountries.ContainsKey(payment.transactions[0].item_list.shipping_address.country_code.ToUpper()) )
											payment.transactions[0].item_list.shipping_address.country_code = dictCountries[payment.transactions[0].item_list.shipping_address.country_code.ToUpper()];
									}
									catch
									{
									}
								}
								if ( Sql.IsEmptyString(payment.transactions[0].item_list.shipping_address.country_code) )
								{
									// 12/16/2008 Paul.  Always set the country, otherwise PayPal will fail. 
									payment.transactions[0].item_list.shipping_address.country_code = "US";
								}
							}
						}
					}
				}
				// 12/17/2015 Paul.  PayPal will throw an exception if total does not match amount. 
				// 03/30/2016 Paul.  PayPal does not like negative amounts in line items. 
				bool bNegativeLineItem = false;
				Decimal dCALCULATED_TOTAL = Decimal.Zero;
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
									Item item = new Item();
									payment.transactions[0].item_list.items.Add(item);
									item.currency = C10n.ISO4217;
									// 12/17/2015 Paul.  Try using 3 decimal places to solve rounding issue. 
									// 04/30/2016 Paul.  Base currency has been USD, but we should make it easy to allow a different base. 
									if ( C10n.ISO4217 == SplendidDefaults.BaseCurrencyISO() )
										item.price  = Sql.ToDecimal(row["UNIT_USDOLLAR"]).ToString("0.00");
									else
										item.price  = Sql.ToDecimal(row["UNIT_PRICE"]).ToString("0.00");
									item.quantity    = Sql.ToString(row["QUANTITY"    ]);
									if ( !Sql.IsEmptyString(row["NAME"        ]) ) item.name        = Sql.ToString(row["NAME"        ]);
									if ( !Sql.IsEmptyString(row["DESCRIPTION" ]) ) item.description = Sql.ToString(row["DESCRIPTION" ]);
									if ( !Sql.IsEmptyString(row["MFT_PART_NUM"]) ) item.sku         = Sql.ToString(row["MFT_PART_NUM"]);
									dCALCULATED_TOTAL += Sql.ToDecimal(item.quantity) * Sql.ToDecimal(item.price);
									// 03/30/2016 Paul.  PayPal does not like negative amounts in line items. 
									if ( Sql.ToFloat(row["QUANTITY"]) < 0 || Sql.ToFloat(row["UNIT_USDOLLAR"]) < 0 )
										bNegativeLineItem = true;
								}
							}
						}
					}
				}
				// 12/17/2015 Paul.  PayPal will throw an exception if total does not match amount.  In that case, do not include line items. 
				// The primary issue is due to sales tax calculations.  We perform the calculation on the subtotal, not the line item extended price. 
				// This can lead to a 1 cent difference. 
				if ( payment.transactions[0].amount.details != null )
				{
					dCALCULATED_TOTAL += Sql.ToDecimal(payment.transactions[0].amount.details.shipping);
					dCALCULATED_TOTAL += Sql.ToDecimal(payment.transactions[0].amount.details.tax);
				}
				// 03/30/2016 Paul.  PayPal does not like negative amounts in line items. 
				// 04/24/2016 Paul.  Amount not equal OR negative. 
				if ( dCALCULATED_TOTAL != dAMOUNT || bNegativeLineItem )
				{
					payment.transactions[0].item_list.items = null;
				}
				
				Guid gPAYMENTS_TRANSACTION_ID = Guid.Empty;
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						SqlProcs.spPAYMENTS_TRANSACTIONS_InsertOnly
							( ref gPAYMENTS_TRANSACTION_ID
							, gPAYMENT_ID
							, "PayPal"
							, "Sale"
							, dAMOUNT
							, gCURRENCY_ID
							, sInvoiceNumber
							, sInvoiceName
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
				string sTransactionID = String.Empty;
				string sAvsCode       = String.Empty;
				string sErrorMessage  = String.Empty;
				try
				{
					string sPayPalClientID     = Sql.ToString (Application["CONFIG.PayPal.ClientID"    ]);
					string sPayPalClientSecret = Sql.ToString (Application["CONFIG.PayPal.ClientSecret"]);
					bool   bPayPalSandbox      = Sql.ToBoolean(Application["CONFIG.PayPal.Sandbox"     ]);
					Dictionary<string,string> config = new Dictionary<string,string>();
					config.Add("connectionTimeout", "60000");
					if ( bPayPalSandbox )
						config.Add("mode", "sandbox");
					else
						config.Add("mode", "live");
					OAuthTokenCredential oauth = new OAuthTokenCredential(sPayPalClientID, sPayPalClientSecret, config);
					
					string sAccessToken = oauth.GetAccessToken();
					APIContext apiContext = new APIContext(sAccessToken);
					apiContext.Config = config;
					
					Payment createdPayment = payment.Create(apiContext);
					sSTATUS        = createdPayment.state;
					sTransactionID = createdPayment.id;
					if ( sSTATUS == "approved" )
					{
						sSTATUS = "Success";
					}
					else if ( createdPayment.state == "failed" )
					{
						sSTATUS = "Failed";
						StringBuilder sbErrors = new StringBuilder();
						foreach ( Error error in createdPayment.failed_transactions )
						{
							sbErrors.AppendLine(error.message);
							if ( error.details != null )
							{
								foreach ( ErrorDetails detail in error.details )
								{
#if DEBUG
									sbErrors.AppendLine(detail.field + ": " + detail.issue);
#else
									sbErrors.AppendLine(detail.issue);
#endif
								}
							}
						}
						sErrorMessage = sbErrors.ToString();
						//SplendidError.SystemMessage(Application, "Warning", new StackTrace(true).GetFrame(0), sErrorMessage);
					}
				}
				catch(PaymentsException ex)
				{
					StringBuilder sbErrors = new StringBuilder();
					if ( ex.Details != null )
					{
						if ( ex.Details.details != null )
						{
							foreach ( ErrorDetails detail in ex.Details.details )
							{
#if DEBUG
								sbErrors.AppendLine(detail.field + ": " + detail.issue);
#else
								sbErrors.AppendLine(detail.issue);
#endif
							}
						}
						else
						{
							sbErrors.AppendLine(ex.Details.message);
						}
					}
					else
					{
						sbErrors.AppendLine(ex.Message);
					}
					sErrorMessage = sbErrors.ToString();
					sSTATUS = "Failed";
				}
				catch(PayPalException ex)
				{
					StringBuilder sbErrors = new StringBuilder();
					sbErrors.AppendLine(ex.Message);
					sErrorMessage = sbErrors.ToString();
					sSTATUS = "Failed";
				}
				catch(Exception ex)
				{
					StringBuilder sbErrors = new StringBuilder();
					sbErrors.AppendLine(ex.Message);
					sErrorMessage = sbErrors.ToString();
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
								, sTransactionID
								, String.Empty
								, String.Empty
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
			}
			return sSTATUS;
		}

		public string Refund(Guid gPAYMENT_ID, Guid gCURRENCY_ID, Guid gACCOUNT_ID, Guid gCREDIT_CARD_ID, string sINVOICE_NUMBER, Decimal dAMOUNT, string sTRANSACTION_NUMBER)
		{
			string sPayPalClientID     = Sql.ToString (Application["CONFIG.PayPal.ClientID"    ]);
			string sPayPalClientSecret = Sql.ToString (Application["CONFIG.PayPal.ClientSecret"]);
			bool   bPayPalSandbox      = Sql.ToBoolean(Application["CONFIG.PayPal.Sandbox"     ]);
			Dictionary<string,string> config = new Dictionary<string,string>();
			config.Add("connectionTimeout", "60000");
			if ( bPayPalSandbox )
				config.Add("mode", "sandbox");
			else
				config.Add("mode", "live");
			
			Currency C10n = Currency.CreateCurrency(gCURRENCY_ID);
			
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
				
				string sErrorMessage  = String.Empty;
				string sTransactionID = String.Empty;
				try
				{
					OAuthTokenCredential oauth = new OAuthTokenCredential(sPayPalClientID, sPayPalClientSecret, config);
					string sAccessToken = oauth.GetAccessToken();
					APIContext apiContext = new APIContext(sAccessToken);
					apiContext.Config = config;
			
					Payment payment = Payment.Get(apiContext, sTRANSACTION_NUMBER);
					foreach ( Transaction transaction in payment.transactions )
					{
						foreach ( RelatedResources resource in transaction.related_resources )
						{
							if ( resource.sale != null )
							{
								// 09/07/2015 Paul.  We are not going to allow partial refunds. 
								RefundRequest refund = new RefundRequest();
								refund.amount = resource.sale.amount;
								// 07/15/2023 Paul.  Updated method requires the transaction Id. 
								Refund result = PayPal.Api.Sale.Refund(apiContext, sTRANSACTION_NUMBER, refund);
								if ( sTransactionID.Length > 0 )
									sTransactionID += ",";
								sTransactionID = result.id;
								// https://developer.paypal.com/docs/api/#refund-a-sale
								if ( sSTATUS.Length > 0 )
									sSTATUS += ",";
								if ( result.state == "failed" )
								{
									sSTATUS = "Failed";
								}
								else if ( result.state == "completed" )
								{
									sSTATUS = "Success";
								}
								else
								{
									sSTATUS = result.state;
								}
							}
						}
					}
					if ( Sql.IsEmptyString(sTransactionID) )
					{
						sSTATUS = "Failed";
						sErrorMessage = "Could not find a sale transaction for payment " + sTRANSACTION_NUMBER;
					}
				}
				catch(Exception ex)
				{
					sErrorMessage = ex.Message + " Payment " + sTRANSACTION_NUMBER;
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

		public DataSet PaymentSearch(DateTime dtStartDate, DateTime dtEndDate, string sEmail)
		{
			DataSet ds = new DataSet();
			DataTable dtTransactions = ds.Tables.Add("TRANSACTIONS");
			dtTransactions.Columns.Add("TRANSACTION_ID"       , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("TRANSACTION_TYPE"     , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("TRANSACTION_STATUS"   , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("TRANSACTION_DATE"     , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("TIMEZONE"             , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("GROSS_AMOUNT"         , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("GROSS_AMOUNT_CURRENCY", Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("FEE_AMOUNT"           , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("FEE_AMOUNT_CURRENCY"  , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("NET_AMOUNT"           , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("NET_AMOUNT_CURRENCY"  , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER"                , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ID"             , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_DISPLAY_NAME"   , Type.GetType("System.String"  ));

			string sPayPalClientID     = Sql.ToString (Application["CONFIG.PayPal.ClientID"    ]);
			string sPayPalClientSecret = Sql.ToString (Application["CONFIG.PayPal.ClientSecret"]);
			bool   bPayPalSandbox      = Sql.ToBoolean(Application["CONFIG.PayPal.Sandbox"     ]);
			Dictionary<string,string> config = new Dictionary<string,string>();
			config.Add("connectionTimeout", "60000");
			if ( bPayPalSandbox )
				config.Add("mode", "sandbox");
			else
				config.Add("mode", "live");
			OAuthTokenCredential oauth = new OAuthTokenCredential(sPayPalClientID, sPayPalClientSecret, config);
			
			string sAccessToken = oauth.GetAccessToken();
			APIContext apiContext = new APIContext(sAccessToken);
			apiContext.Config = config;

			int    count      = 100;
			string startId    = String.Empty;
			int    startIndex = 0;
			string startTime  = String.Empty;
			string endTime    = String.Empty;
			string startDate  = (dtStartDate != DateTime.MinValue ? dtStartDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ") : String.Empty);
			string endDate    = (dtEndDate   != DateTime.MinValue ? dtEndDate  .ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ") : String.Empty);
			string payeeEmail = sEmail;
			string payeeId    = String.Empty;
			string sortBy     = String.Empty;
			string sortOrder  = String.Empty;
			PaymentHistory arr = null;
			do
			{
				Debug.WriteLine("PayPal next_id:" + startId);
				arr = Payment.List(apiContext, count, startId, startIndex, startTime, endTime, startDate, endDate, payeeEmail, payeeId, sortBy, sortOrder);
				startId = String.Empty;
				if ( arr != null )
				{
					startId = arr.next_id;
					foreach ( Payment payment in arr.payments )
					{
						DataRow row = dtTransactions.NewRow();
						dtTransactions.Rows.Add(row);
						
						DateTime dtCreateTime = DateTime.MinValue;
						DateTime.TryParse(payment.create_time, out dtCreateTime);
						row["TRANSACTION_ID"       ] = Sql.ToString(payment.id    );
						row["TRANSACTION_STATUS"   ] = Sql.ToString(payment.state );
						row["TRANSACTION_DATE"     ] = dtCreateTime;
						row["TIMEZONE"             ] = DBNull.Value;
						if ( payment.payment_instruction != null )
						{
							row["TRANSACTION_TYPE"     ] = Sql.ToString(payment.payment_instruction.instruction_type);
							row["GROSS_AMOUNT"         ] = Sql.ToString(payment.payment_instruction.amount.value   );
							row["GROSS_AMOUNT_CURRENCY"] = Sql.ToString(payment.payment_instruction.amount.currency);
							row["FEE_AMOUNT"           ] = DBNull.Value;
							row["FEE_AMOUNT_CURRENCY"  ] = DBNull.Value;
							row["NET_AMOUNT"           ] = DBNull.Value;
							row["NET_AMOUNT_CURRENCY"  ] = DBNull.Value;
						}
						if ( payment.payer != null )
						{
							if ( payment.payer.payer_info != null )
							{
								row["PAYER_ID"             ] = Sql.ToString(payment.payer.payer_info.payer_id  );
								row["PAYER"                ] = Sql.ToString(payment.payer.payer_info.email     );
								row["PAYER_DISPLAY_NAME"   ] = Sql.ToString(payment.payer.payer_info.first_name) + " " + Sql.ToString(payment.payer.payer_info.last_name);
							}
						}
					}
				}
			} while ( !Sql.IsEmptyString(startId) );
			return ds;
		}

		public DataSet PaymentDetails(string sPaymentId)
		{
			DataSet ds = new DataSet();
			DataTable dtTransactions = ds.Tables.Add("TRANSACTIONS");
			dtTransactions.Columns.Add("RECEIVER_BUSINESS"             , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("RECEIVER"                      , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("RECEIVER_ID"                   , Type.GetType("System.String"  ));

			dtTransactions.Columns.Add("PAYER"                         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ID"                      , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_STATUS"                  , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_SALUATION"               , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_FIRST_NAME"              , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_LAST_NAME"               , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_MIDDLE_NAME"             , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_SUFFIX"                  , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_PHONE"                   , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_BUSINESS"                , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_COUNTRY"                 , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_OWNER"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_STATUS"          , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_NAME"            , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_STREET1"         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_STREET2"         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_CITY"            , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_STATE"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_COUNTRY"         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_COUNTRY_NAME"    , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_PHONE"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_POSTAL_CODE"     , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_INTL_NAME"       , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_INTL_STATE"      , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_ADDRESS_INTL_STREET"     , Type.GetType("System.String"  ));

			dtTransactions.Columns.Add("TRANSACTION_ID"                , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PARENT_TRANSACTION_ID"         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("RECEIPT_ID"                    , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("TRANSACTION_TYPE"              , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYMENT_TYPE"                  , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYMENT_DATE"                  , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("GROSS_AMOUNT_CURRENCY"         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("GROSS_AMOUNT"                  , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("FEE_AMOUNT_CURRENCY"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("FEE_AMOUNT"                    , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("SETTLE_AMOUNT_CURRENCY"        , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SETTLE_AMOUNT"                 , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("TAX_AMOUNT_CURRENCY"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("TAX_AMOUNT"                    , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("EXCHANGE_RATE"                 , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYMENT_STATUS"                , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PENDING_REASON"                , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("REASON_CODE"                   , Type.GetType("System.String"  ));

			dtTransactions.Columns.Add("AUCTION_BUYER_ID"              , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("AUCTION_CLOSING_DATE"          , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("AUCTION_MULTI_ITEM"            , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("CUSTOM"                        , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("INVOICE_ID"                    , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("MEMO"                          , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SALES_TAX"                     , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("SUBSCRIPTION_USERNAME"         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SUBSCRIPTION_PASSWORD"         , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SUBSCRIPTION_SUBSCRIPTION_ID"  , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SUBSCRIPTION_SUBSCRIPTION_DATE", Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("SUBSCRIPTION_EFFECTIVE_DATE"   , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("SUBSCRIPTION_REATTEMPT"        , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SUBSCRIPTION_RECURRENCES"      , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SUBSCRIPTION_RECURRING"        , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("SUBSCRIPTION_RETRY_TIME"       , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("SUBSCRIPTION_TERMS"            , Type.GetType("System.String"  ));

			// 02/26/2021 Paul.  Missing TRANSACTION_STATUS, TRANSACTION_DATE. 
			dtTransactions.Columns.Add("TRANSACTION_STATUS"            , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("TRANSACTION_DATE"              , Type.GetType("System.DateTime"));
			dtTransactions.Columns.Add("TIMEZONE"                      , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("NET_AMOUNT"                    , Type.GetType("System.Decimal" ));
			dtTransactions.Columns.Add("NET_AMOUNT_CURRENCY"           , Type.GetType("System.String"  ));
			dtTransactions.Columns.Add("PAYER_DISPLAY_NAME"            , Type.GetType("System.String"  ));

			DataTable dtLineItems = ds.Tables.Add("LINE_ITEMS");
			dtLineItems.Columns.Add("TRANSACTION_ID"   , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("AMOUNT_CURRENCY"  , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("AMOUNT"           , Type.GetType("System.Decimal" ));
			dtLineItems.Columns.Add("NAME"             , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("NUMBER"           , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("OPTIONS"          , Type.GetType("System.String"  ));
			dtLineItems.Columns.Add("QUANTITY"         , Type.GetType("System.Decimal" ));
			dtLineItems.Columns.Add("SALES_TAX"        , Type.GetType("System.Decimal" ));

			string sPayPalClientID     = Sql.ToString (Application["CONFIG.PayPal.ClientID"    ]);
			string sPayPalClientSecret = Sql.ToString (Application["CONFIG.PayPal.ClientSecret"]);
			bool   bPayPalSandbox      = Sql.ToBoolean(Application["CONFIG.PayPal.Sandbox"     ]);
			Dictionary<string,string> config = new Dictionary<string,string>();
			config.Add("connectionTimeout", "60000");
			if ( bPayPalSandbox )
				config.Add("mode", "sandbox");
			else
				config.Add("mode", "live");
			OAuthTokenCredential oauth = new OAuthTokenCredential(sPayPalClientID, sPayPalClientSecret, config);
			
			string sAccessToken = oauth.GetAccessToken();
			APIContext apiContext = new APIContext(sAccessToken);
			apiContext.Config = config;

			Payment payment = Payment.Get(apiContext, sPaymentId);
			if ( payment != null )
			{
				DataRow row = dtTransactions.NewRow();
				dtTransactions.Rows.Add(row);
				
				DateTime dtCreateTime = DateTime.MinValue;
				DateTime.TryParse(payment.create_time, out dtCreateTime);
				row["TRANSACTION_ID"       ] = Sql.ToString(payment.id    );
				row["TRANSACTION_STATUS"   ] = Sql.ToString(payment.state );
				row["TRANSACTION_DATE"     ] = dtCreateTime;
				row["TIMEZONE"             ] = DBNull.Value;
				if ( payment.payment_instruction != null )
				{
					row["TRANSACTION_TYPE"     ] = Sql.ToString(payment.payment_instruction.instruction_type);
					row["GROSS_AMOUNT"         ] = Sql.ToString(payment.payment_instruction.amount.value   );
					row["GROSS_AMOUNT_CURRENCY"] = Sql.ToString(payment.payment_instruction.amount.currency);
					row["FEE_AMOUNT"           ] = DBNull.Value;
					row["FEE_AMOUNT_CURRENCY"  ] = DBNull.Value;
					row["NET_AMOUNT"           ] = DBNull.Value;
					row["NET_AMOUNT_CURRENCY"  ] = DBNull.Value;
				}
				if ( payment.payer != null )
				{
					row["PAYMENT_TYPE"               ] = Sql.ToString(payment.payer.payment_method);
					if ( payment.payer.payer_info != null )
					{
						row["PAYER_ID"             ] = Sql.ToString(payment.payer.payer_info.payer_id  );
						row["PAYER"                ] = Sql.ToString(payment.payer.payer_info.email     );
						row["PAYER_DISPLAY_NAME"   ] = Sql.ToString(payment.payer.payer_info.first_name) + " " + Sql.ToString(payment.payer.payer_info.last_name);
						if ( payment.payer.payer_info.billing_address != null )
						{
							row["PAYER_ADDRESS_CITY"         ] = Sql.ToString(payment.payer.payer_info.billing_address.city        );
							row["PAYER_ADDRESS_COUNTRY"      ] = Sql.ToString(payment.payer.payer_info.billing_address.country_code);
							row["PAYER_ADDRESS_STREET1"      ] = Sql.ToString(payment.payer.payer_info.billing_address.line1       );
							row["PAYER_ADDRESS_STREET2"      ] = Sql.ToString(payment.payer.payer_info.billing_address.line2       );
							row["PAYER_ADDRESS_POSTAL_CODE"  ] = Sql.ToString(payment.payer.payer_info.billing_address.postal_code );
							row["PAYER_ADDRESS_STATE"        ] = Sql.ToString(payment.payer.payer_info.billing_address.state       );
							//row["PAYER_ADDRESS_STATUS"       ] = Sql.ToString(payment.payer.payer_info.billing_address.status      );
							row["PAYER_ADDRESS_PHONE"        ] = Sql.ToString(payment.payer.payer_info.billing_address.phone       );
						}
						row["PAYER_FIRST_NAME"           ] = Sql.ToString(payment.payer.payer_info.first_name             );
						row["PAYER_LAST_NAME"            ] = Sql.ToString(payment.payer.payer_info.last_name              );
						row["PAYER_MIDDLE_NAME"          ] = Sql.ToString(payment.payer.payer_info.middle_name            );
						row["PAYER_ID"                   ] = Sql.ToString(payment.payer.payer_info.payer_id               );
						row["PAYER_PHONE"                ] = Sql.ToString(payment.payer.payer_info.phone                  );
						row["PAYER_SALUATION"            ] = Sql.ToString(payment.payer.payer_info.salutation             );
						row["PAYER_SUFFIX"               ] = Sql.ToString(payment.payer.payer_info.suffix                 );
					}
				}
			}
			return ds;
		}
	}
}
