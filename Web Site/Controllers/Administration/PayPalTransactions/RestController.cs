/*
 * Copyright (C) 2019-2021 SplendidCRM Software, Inc. All Rights Reserved. 
 *
 * Any use of the contents of this file are subject to the SplendidCRM Professional Source Code License 
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
 */
using System;
using System.IO;
using System.Net;
using System.Web;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Controllers.Administration.PayPalTransactions
{
	[Authorize]
	[ApiController]
	[Route("Administration/PayPalTransactions/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "PayPal";
		private IMemoryCache         Cache              ;
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SplendidError        SplendidError      ;
		private PayPalCache          PayPalCache        ;
		private PayPalRest           PayPalRest         ;

		public RestController(IMemoryCache memoryCache, HttpSessionState Session, Security Security, SplendidError SplendidError, PayPalCache PayPalCache, PayPalRest PayPalRest)
		{
			this.Cache               = memoryCache        ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = new Sql(Session, Security);
			this.SplendidError       = SplendidError      ;
			this.PayPalCache         = PayPalCache        ;
			this.PayPalRest          = PayPalRest         ;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Test([FromBody] Dictionary<string, object> dict)
		{
			if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			Guid      gTIMEZONE   = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
			SplendidCRM.TimeZone  T10n        = TimeZone.CreateTimeZone(gTIMEZONE);
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				int    nSKIP     = Sql.ToInteger(Request.Query["$skip"    ]);
				int    nTOP      = Sql.ToInteger(Request.Query["$top"     ]);
				string sFILTER   = Sql.ToString (Request.Query["$filter"  ]);
				string sORDER_BY = Sql.ToString (Request.Query["$orderby" ]);
				// 06/17/2013 Paul.  Add support for GROUP BY. 
				string sGROUP_BY = Sql.ToString (Request.Query["$groupby" ]);
				// 08/03/2011 Paul.  We need a way to filter the columns so that we can be efficient. 
				string sSELECT   = Sql.ToString (Request.Query["$select"  ]);
				
				DateTime dtSTART_DATE        = DateTime.Today;
				DateTime dtEND_DATE          = DateTime.Today;
				string   sEMAIL              = String.Empty;
				string   sTRANSACTION_CLASS  = String.Empty;
				string   sTRANSACTION_STATUS = String.Empty;
				string   sUSER_NAME          = String.Empty;
				string   sPASSWORD           = String.Empty;
				string   sPRIVATE_KEY        = String.Empty;
				string   sCERTIFICATE        = String.Empty;
				bool     bSANDBOX            = Sql.ToBoolean(Application["CONFIG.PayPal.Sandbox"        ]);
				string   sREST_CLIENT_ID     = String.Empty;
				string   sREST_CLIENT_SECRET = String.Empty;
				try
				{
					foreach ( string sName in dict.Keys )
					{
						switch ( sName )
						{
							case "PayPal.APIUsername"    :  sUSER_NAME          = Sql.ToString (dict[sName]);  break;
							case "PayPal.APIPassword"    :  sPASSWORD           = Sql.ToString (dict[sName]);  break;
							case "PayPal.X509PrivateKey" :  sPRIVATE_KEY        = Sql.ToString (dict[sName]);  break;
							case "PayPal.X509Certificate":  sCERTIFICATE        = Sql.ToString (dict[sName]);  break;
							case "PayPal.Sandbox"        :  bSANDBOX            = Sql.ToBoolean(dict[sName]);  break;
							case "PayPal.ClientID"       :  sREST_CLIENT_ID     = Sql.ToString (dict[sName]);  break;
							case "PayPal.ClientSecret"   :  sREST_CLIENT_SECRET = Sql.ToString (dict[sName]);  break;
						}
					}
				}
				catch(Exception ex)
				{
					Debug.WriteLine(ex.Message);
					throw;
				}
				if ( Sql.IsEmptyString(sUSER_NAME         ) ) sUSER_NAME          = Sql.ToString (Application["CONFIG.PayPal.APIUsername"    ]);
				if ( Sql.IsEmptyString(sPASSWORD          ) ) sPASSWORD           = Sql.ToString (Application["CONFIG.PayPal.APIPassword"    ]);
				if ( Sql.IsEmptyString(sPRIVATE_KEY       ) ) sPRIVATE_KEY        = Sql.ToString (Application["CONFIG.PayPal.X509PrivateKey" ]);
				if ( Sql.IsEmptyString(sCERTIFICATE       ) ) sCERTIFICATE        = Sql.ToString (Application["CONFIG.PayPal.X509Certificate"]);
				if ( Sql.IsEmptyString(sREST_CLIENT_ID    ) ) sREST_CLIENT_ID     = Sql.ToString (Application["CONFIG.PayPal.ClientID"       ]);
				if ( Sql.IsEmptyString(sREST_CLIENT_SECRET) ) sREST_CLIENT_SECRET = Sql.ToString (Application["CONFIG.PayPal.ClientSecret"   ]);
				
				if ( !Sql.IsEmptyString(Application["CONFIG.PayPal.ClientID"]) && !Sql.IsEmptyString(Application["CONFIG.PayPal.ClientSecret"]) )
				{
					DataSet ds = PayPalRest.PaymentSearch(dtSTART_DATE, dtEND_DATE, sEMAIL);
				}
				else
				{
					throw(new Exception(MODULE_NAME + " is not enabled or configured."));
				}
			}
			catch(Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[HttpPost("[action]")]
		public Dictionary<string, object> Transactions([FromBody] Dictionary<string, object> dict)
		{
			if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			Guid      gTIMEZONE   = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
			SplendidCRM.TimeZone  T10n        = TimeZone.CreateTimeZone(gTIMEZONE);
			DataTable dtPaginated = new DataTable();
			long      lTotalCount = 0;
			try
			{
				int    nSKIP     = Sql.ToInteger(Request.Query["$skip"    ]);
				int    nTOP      = Sql.ToInteger(Request.Query["$top"     ]);
				string sFILTER   = Sql.ToString (Request.Query["$filter"  ]);
				string sORDER_BY = Sql.ToString (Request.Query["$orderby" ]);
				// 06/17/2013 Paul.  Add support for GROUP BY. 
				string sGROUP_BY = Sql.ToString (Request.Query["$groupby" ]);
				// 08/03/2011 Paul.  We need a way to filter the columns so that we can be efficient. 
				string sSELECT   = Sql.ToString (Request.Query["$select"  ]);
				
				DateTime dtSTART_DATE        = DateTime.MinValue;
				DateTime dtEND_DATE          = DateTime.MinValue;
				string   sEMAIL              = String.Empty;
				string   sTRANSACTION_CLASS  = String.Empty;
				string   sTRANSACTION_STATUS = String.Empty;
				Dictionary<string, object> dictSearchValues = null;
				try
				{
					foreach ( string sName in dict.Keys )
					{
						switch ( sName )
						{
							case "$skip"           :  nSKIP            = Sql.ToInteger(dict[sName]);  break;
							case "$top"            :  nTOP             = Sql.ToInteger(dict[sName]);  break;
							case "$filter"         :  sFILTER          = Sql.ToString (dict[sName]);  break;
							case "$orderby"        :  sORDER_BY        = Sql.ToString (dict[sName]);  break;
							case "$groupby"        :  sGROUP_BY        = Sql.ToString (dict[sName]);  break;
							case "$select"         :  sSELECT          = Sql.ToString (dict[sName]);  break;
							case "$searchvalues"   :  dictSearchValues = dict[sName] as Dictionary<string, object>;  break;
						}
					}
					if ( dictSearchValues != null )
					{
						if ( dictSearchValues.ContainsKey("START_DATE") )
						{
							Dictionary<string, object> dictValue = dictSearchValues["START_DATE"] as Dictionary<string, object>;
							if ( dictValue.ContainsKey("value") )
								dtSTART_DATE = T10n.ToServerTime(RestUtil.FromJsonDate(Sql.ToString(dictValue["value"])));
						}
						if ( dictSearchValues.ContainsKey("END_DATE") )
						{
							Dictionary<string, object> dictValue = dictSearchValues["END_DATE"] as Dictionary<string, object>;
							if ( dictValue.ContainsKey("value") )
								dtEND_DATE = T10n.ToServerTime(RestUtil.FromJsonDate(Sql.ToString(dictValue["value"])));
						}
						if ( dictSearchValues.ContainsKey("EMAIL") )
						{
							Dictionary<string, object> dictValue = dictSearchValues["EMAIL"] as Dictionary<string, object>;
							if ( dictValue.ContainsKey("value") )
								sEMAIL = Sql.ToString(dictValue["value"]);
						}
						if ( dictSearchValues.ContainsKey("TRANSACTION_CLASS") )
						{
							Dictionary<string, object> dictValue = dictSearchValues["TRANSACTION_CLASS"] as Dictionary<string, object>;
							if ( dictValue.ContainsKey("value") )
								sTRANSACTION_CLASS = Sql.ToString(dictValue["value"]);
						}
						if ( dictSearchValues.ContainsKey("TRANSACTION_STATUS") )
						{
							Dictionary<string, object> dictValue = dictSearchValues["TRANSACTION_STATUS"] as Dictionary<string, object>;
							if ( dictValue.ContainsKey("value") )
								sTRANSACTION_STATUS = Sql.ToString(dictValue["value"]);
						}
					}
				}
				catch(Exception ex)
				{
					Debug.WriteLine(ex.Message);
					throw;
				}
				
				// 02/26/2021 Paul.  Include the date in the cache key so that we can speed pagination but still have live data. 
				string sCacheKey = dtSTART_DATE.ToString("yyyy-MM-ddTHH:mm:ss.fffZ") + dtEND_DATE.ToString("yyyy-MM-ddTHH:mm:ss.fffZ");
				DataSet ds = Cache.Get(MODULE_NAME + ".Transactions_" + sCacheKey) as DataSet;
				if ( ds == null )
				{
					if ( !Sql.IsEmptyString(Application["CONFIG.PayPal.ClientID"]) && !Sql.IsEmptyString(Application["CONFIG.PayPal.ClientSecret"]) )
					{
						ds = PayPalRest.PaymentSearch(dtSTART_DATE, dtEND_DATE, sEMAIL);
						DataTable dtTransactions = ds.Tables["TRANSACTIONS"];
						dtTransactions.Columns.Add("NAME");
						// 10/14/2008 Paul.  We need to convert the time to the user's specified timezone. 
						foreach ( DataRow row in dtTransactions.Rows )
						{
							row["NAME"            ] = row["TRANSACTION_ID"];
							row["TRANSACTION_DATE"] = T10n.FromServerTime(Sql.ToDateTime(row["TRANSACTION_DATE"]));
						}
						Cache.Set(MODULE_NAME + ".Transactions_" + sCacheKey, ds, PayPalCache.DefaultCacheExpiration());
					}
					else
					{
						throw(new Exception(MODULE_NAME + " is not enabled or configured."));
					}
				}
				DataTable dt = ds.Tables["TRANSACTIONS"];
				DataView vw = new DataView(dt);
				if ( Sql.IsEmptyString(sORDER_BY) )
					sORDER_BY = "TRANSACTION_DATE desc";
				vw.Sort = sORDER_BY;

				dtPaginated = dt.Clone();
				for ( int i = nSKIP; i < vw.Count; i++ )
				{
					DataRow row = dtPaginated.NewRow();
					foreach ( DataColumn col in dtPaginated.Columns )
					{
						row[col.ColumnName] = vw[i].Row[col.ColumnName];
					}
					dtPaginated.Rows.Add(row);
					if ( dtPaginated.Rows.Count >= nTOP )
						break;
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw;
			}
			
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			// 04/01/2020 Paul.  Move json utils to RestUtil. 
			Dictionary<string, object> dictResponse = RestUtil.ToJson(sBaseURI, String.Empty, dtPaginated, T10n);
			dictResponse.Add("__total", lTotalCount);
			return dictResponse;
		}

		[HttpGet("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetTransaction(string ID)
		{
			if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			DataSet   ds        = null;
			DataTable dt        = null;
			Guid      gTIMEZONE = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
			SplendidCRM.TimeZone  T10n      = TimeZone.CreateTimeZone(gTIMEZONE);
			string    sTransactionID = Sql.ToString(ID).ToUpper();
			if ( !Sql.IsEmptyString(Application["CONFIG.PayPal.ClientID"]) && !Sql.IsEmptyString(Application["CONFIG.PayPal.ClientSecret"]) )
			{
				ds = PayPalRest.PaymentDetails(sTransactionID);
				dt = ds.Tables["TRANSACTIONS"];
				if ( dt.Rows.Count > 0 )
				{
					DataRow row = dt.Rows[0];
					if ( row["PAYMENT_DATE"] != DBNull.Value )
						row["PAYMENT_DATE"] = T10n.FromServerTime(Sql.ToDateTime(row["PAYMENT_DATE"]));
					if ( row["AUCTION_CLOSING_DATE"] != DBNull.Value )
						row["AUCTION_CLOSING_DATE"] = T10n.FromServerTime(Sql.ToDateTime(row["AUCTION_CLOSING_DATE"]));
				}
			}
			else
			{
				throw(new Exception(MODULE_NAME + " is not enabled or configured."));
			}
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			Dictionary<string, object> dict = RestUtil.ToJson(sBaseURI, MODULE_NAME, dt.Rows[0], T10n);
			return dict;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Refund([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				string sTransactionID = (dict.ContainsKey("TransactionID") ? Sql.ToString(dict["TransactionID"]) : String.Empty);
				if ( Sql.IsEmptyString(sTransactionID ) )
				{
					throw(new Exception("Missing TransactionID"));
				}
				
				if ( !Sql.IsEmptyString(Application["CONFIG.PayPal.ClientID"]) && !Sql.IsEmptyString(Application["CONFIG.PayPal.ClientSecret"]) )
				{
					// 07/14/2023 Paul.  TODO.  Add support for Not CRM refund. 
					//PayPalRest.Refund(sTransactionID, "Full");
					//PayPalCache.ClearTransaction(sTransactionID);
				}
				else
				{
					throw(new Exception(MODULE_NAME + " is not enabled or configured."));
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

	}
}
