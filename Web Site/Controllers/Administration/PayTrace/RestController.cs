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

using SplendidCRM;

namespace SplendidCRM.Controllers.Administration.PayTrace
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/PayTrace/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "PayTrace";
		private IMemoryCache         memoryCache        ;
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SplendidError        SplendidError      ;
		private PayPalCache          PayPalCache        ;
		private PayTraceUtils        PayTraceUtils      ;

		public RestController(IMemoryCache memoryCache, HttpSessionState Session, Security Security, SplendidError SplendidError, PayPalCache PayPalCache, PayTraceUtils PayTraceUtils)
		{
			this.memoryCache         = memoryCache        ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = new Sql(Session, Security);
			this.SplendidError       = SplendidError      ;
			this.PayPalCache         = PayPalCache        ;
			this.PayTraceUtils       = PayTraceUtils      ;
		}


		[HttpPost("[action]")]
		public string Test([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				bool   bENABLED    = false;
				string sUSER_NAME  = String.Empty;
				string sPASSWORD   = String.Empty;
				foreach ( string sKey in dict.Keys )
				{
					switch ( sKey )
					{
						case "PayTrace.Enabled" :  bENABLED   = Sql.ToBoolean(dict[sKey]);  break;
						case "PayTrace.UserName":  sUSER_NAME = Sql.ToString (dict[sKey]);  break;
						case "PayTrace.Password":  sPASSWORD  = Sql.ToString (dict[sKey]);  break;
					}
				}
				// 02/23/2021 Paul.  The React client will not get the user name or the transaction key, so if blank, then not changed. 
				if ( Sql.IsEmptyString(sUSER_NAME) || sUSER_NAME == Sql.sEMPTY_PASSWORD )
				{
					sUSER_NAME = Sql.ToString (Application["CONFIG.PayTrace.UserName"]);
					sPASSWORD  = Sql.ToString (Application["CONFIG.PayTrace.Password"]);
				}
				// 11/08/2019 Paul.  Move sEMPTY_PASSWORD to Sql. 
				// 03/10/2021 Paul.  Sensitive fields will not be sent to React client, so check for empty string. 
				if ( Sql.IsEmptyString(sPASSWORD) || sPASSWORD == Sql.sEMPTY_PASSWORD )
				{
					sPASSWORD = Sql.ToString (Application["CONFIG.PayTrace.TransactionKey"]);
				}
				else
				{
					Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
					Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
					string sENCRYPTED_PASSWORD = Security.EncryptPassword(sPASSWORD, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
					if ( Security.DecryptPassword(sENCRYPTED_PASSWORD, gCREDIT_CARD_KEY, gCREDIT_CARD_IV) != sPASSWORD )
						throw(new Exception("Decryption failed"));
					sPASSWORD = sENCRYPTED_PASSWORD;
				}
				string sResult = PayTraceUtils.ValidateLogin(sUSER_NAME, sPASSWORD);
				if ( Sql.IsEmptyString(sResult) )
				{
					sbErrors.Append(L10n.Term("PayTrace.LBL_CONNECTION_SUCCESSFUL"));
				}
				else
				{
					sbErrors.Append(sResult);
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
				
				DateTime dtSTART_DATE      = DateTime.MinValue;
				DateTime dtEND_DATE        = DateTime.MinValue;
				string   sTRANSACTION_TYPE = String.Empty;
				string   sSEARCH_TEXT      = String.Empty;
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
						if ( dictSearchValues.ContainsKey("TRANSACTION_TYPE") )
						{
							Dictionary<string, object> dictValue = dictSearchValues["TRANSACTION_TYPE"] as Dictionary<string, object>;
							if ( dictValue.ContainsKey("value") )
								sTRANSACTION_TYPE = Sql.ToString(dictValue["value"]);
						}
						if ( dictSearchValues.ContainsKey("SEARCH_TEXT") )
						{
							Dictionary<string, object> dictValue = dictSearchValues["SEARCH_TEXT"] as Dictionary<string, object>;
							if ( dictValue.ContainsKey("value") )
								sSEARCH_TEXT = Sql.ToString(dictValue["value"]);
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
				DataSet ds = memoryCache.Get(MODULE_NAME + ".Transactions_" + sCacheKey) as DataSet;
				if ( ds == null )
				{
					if ( Sql.ToBoolean(Application["CONFIG.PayTrace.Enabled"]) && !Sql.IsEmptyString(Application["CONFIG.PayTrace.UserName"]) )
					{
						ds = PayTraceUtils.Transactions(dtSTART_DATE, dtEND_DATE, sTRANSACTION_TYPE, sSEARCH_TEXT, String.Empty);
						DataTable dtTransactions = ds.Tables["TRANSACTIONS"];
						dtTransactions.Columns.Add("NAME");
						foreach ( DataRow row in dtTransactions.Rows )
						{
							row["NAME"] = row["TRANXID"];
						}
						memoryCache.Set(MODULE_NAME + ".Transactions_" + sCacheKey, ds, PayPalCache.DefaultCacheExpiration());
					}
					else
					{
						throw(new Exception(MODULE_NAME + " is not enabled or configured."));
					}
				}
				DataTable dt = ds.Tables["TRANSACTIONS"];
				DataView vw = new DataView(dt);
				if ( Sql.IsEmptyString(sORDER_BY) )
					sORDER_BY = "TRANXID desc";
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
			string    sTransactionID = ID;
			if ( Sql.ToBoolean(Application["CONFIG.PayTrace.Enabled"]) && !Sql.IsEmptyString(Application["CONFIG.PayTrace.UserName"]) )
			{
				ds = PayTraceUtils.Transaction(sTransactionID);
				dt = ds.Tables["TRANSACTIONS"];
			}
			else
			{
				throw(new Exception(MODULE_NAME + " is not enabled or configured."));
			}
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			
			Dictionary<string, object> dict = RestUtil.ToJson(sBaseURI, MODULE_NAME, dt.Rows[0], T10n);
			return dict;
		}

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
				
				if ( Sql.ToBoolean(Application["CONFIG.PayTrace.Enabled"]) && !Sql.IsEmptyString(Application["CONFIG.PayTrace.UserName"]) )
				{
					PayTraceUtils.Refund(sTransactionID);
					memoryCache.Remove("PayTrace.Transaction." + sTransactionID);
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
