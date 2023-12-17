/*
 * Copyright (C) 2019-2023 SplendidCRM Software, Inc. All Rights Reserved. 
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

namespace SplendidCRM.Controllers.Administration.AuthorizeNet
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/AuthorizeNet/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "AuthorizeNet";
		private IMemoryCache         memoryCache        ;
		//private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SplendidError        SplendidError      ;
		private AuthorizeNetUtils    AuthorizeNetUtils  ;

		public RestController(IMemoryCache memoryCache, HttpSessionState Session, Security Security, SplendidError SplendidError, AuthorizeNetUtils AuthorizeNetUtils)
		{
			this.memoryCache         = memoryCache        ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = new Sql(Session, Security);
			this.SplendidError       = SplendidError      ;
			this.AuthorizeNetUtils   = AuthorizeNetUtils  ;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Test([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
				if ( Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				string sUSER_NAME       = String.Empty;
				string sTRANSACTION_KEY = String.Empty;
				bool   bTEST_MODE       = false;
				foreach ( string sKey in dict.Keys )
				{
					switch ( sKey )
					{
						case "AuthorizeNet.UserName"      :  sUSER_NAME       = Sql.ToString (dict[sKey]);  break;
						case "AuthorizeNet.TransactionKey":  sTRANSACTION_KEY = Sql.ToString (dict[sKey]);  break;
						case "AuthorizeNet.TestMode"      :  bTEST_MODE       = Sql.ToBoolean(dict[sKey]);  break;
					}
				}
				// 02/23/2021 Paul.  The React client will not get the user name or the transaction key, so if blank, then not changed. 
				if ( Sql.IsEmptyString(sUSER_NAME) || sUSER_NAME == Sql.sEMPTY_PASSWORD )
				{
					sUSER_NAME       = Sql.ToString (Application["CONFIG.AuthorizeNet.UserName"      ]);
					sTRANSACTION_KEY = Sql.ToString (Application["CONFIG.AuthorizeNet.TransactionKey"]);
				}
				// 11/08/2019 Paul.  Move sEMPTY_PASSWORD to Sql. 
				// 03/10/2021 Paul.  Sensitive fields will not be sent to React client, so check for empty string. 
				if ( Sql.IsEmptyString(sTRANSACTION_KEY) || sTRANSACTION_KEY == Sql.sEMPTY_PASSWORD )
				{
					sTRANSACTION_KEY = Sql.ToString (Application["CONFIG.AuthorizeNet.TransactionKey"]);
				}
				else
				{
					Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
					Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
					string sENCRYPTED_TRANSACTION_KEY = Security.EncryptPassword(sTRANSACTION_KEY, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
					if ( Security.DecryptPassword(sENCRYPTED_TRANSACTION_KEY, gCREDIT_CARD_KEY, gCREDIT_CARD_IV) != sTRANSACTION_KEY )
						throw(new Exception("Decryption failed"));
					sTRANSACTION_KEY = sENCRYPTED_TRANSACTION_KEY;
				}
				string sResult = AuthorizeNetUtils.ValidateLogin(sUSER_NAME, sTRANSACTION_KEY, bTEST_MODE);
				if ( Sql.IsEmptyString(sResult) )
				{
					sbErrors.Append(L10n.Term("AuthorizeNet.LBL_CONNECTION_SUCCESSFUL"));
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
			if ( Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			if ( !Sql.ToBoolean(Application["CONFIG.AuthorizeNet.Enabled"]) ||  Sql.IsEmptyString(Application["CONFIG.AuthorizeNet.UserName"]) )
			{
				throw(new Exception(MODULE_NAME + " is not enabled or configured."));
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
				
				DateTime dtSTART_DATE = DateTime.MinValue;
				DateTime dtEND_DATE   = DateTime.MinValue;
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
							Dictionary<string, object> dictSTART_DATE = dictSearchValues["START_DATE"] as Dictionary<string, object>;
							if ( dictSTART_DATE.ContainsKey("value") )
								dtSTART_DATE = T10n.ToServerTime(RestUtil.FromJsonDate(Sql.ToString(dictSTART_DATE["value"])));
						}
						if ( dictSearchValues.ContainsKey("END_DATE") )
						{
							Dictionary<string, object> dictEND_DATE = dictSearchValues["END_DATE"] as Dictionary<string, object>;
							if ( dictEND_DATE.ContainsKey("value") )
								dtEND_DATE = T10n.ToServerTime(RestUtil.FromJsonDate(Sql.ToString(dictEND_DATE["value"])));
						}
					}
				}
				catch(Exception ex)
				{
					Debug.WriteLine(ex.Message);
					throw;
				}
				
				// 02/26/2021 Paul.  Include the date in the cache key so that we can speed pagination but still have live data. 
				string sCacheKey = dtSTART_DATE.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ") + dtEND_DATE.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ");
				DataTable dt = memoryCache.Get(MODULE_NAME + ".Transactions_" + sCacheKey) as DataTable;
				if ( dt == null )
				{
					dt = AuthorizeNetUtils.Transactions(dtSTART_DATE, dtEND_DATE);
					memoryCache.Set(MODULE_NAME + ".Transactions_" + sCacheKey, dt, DateTime.Now.AddMinutes(5));
				}
				DataView vw = new DataView(dt);
				if ( Sql.IsEmptyString(sORDER_BY) )
					sORDER_BY = "submitTimeUTC desc";
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

		[HttpPost("[action]")]
		public Dictionary<string, object> CustomerProfiles([FromBody] Dictionary<string, object> dict)
		{
			if ( Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			
			if ( !Sql.ToBoolean(Application["CONFIG.AuthorizeNet.Enabled"]) ||  Sql.IsEmptyString(Application["CONFIG.AuthorizeNet.UserName"]) )
			{
				throw(new Exception(MODULE_NAME + " is not enabled or configured."));
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
					}
				}
				catch(Exception ex)
				{
					Debug.WriteLine(ex.Message);
					throw;
				}
				
				DataSet ds = memoryCache.Get(MODULE_NAME + ".CustomerProfiles") as DataSet;
				if ( ds == null )
				{
					ds = AuthorizeNetUtils.CustomerProfiles();
					memoryCache.Set(MODULE_NAME + ".CustomerProfiles", ds, DateTime.Now.AddMinutes(1));
				}
				DataTable dt = ds.Tables["CUSTOMER_PROFILES"];
				DataView vw = new DataView(dt);
				if ( Sql.IsEmptyString(sORDER_BY) )
					sORDER_BY = "email desc";
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
		public Dictionary<string, object> GetCustomerProfile(string ID)
		{
			if ( Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			
			if ( !Sql.ToBoolean(Application["CONFIG.AuthorizeNet.Enabled"]) ||  Sql.IsEmptyString(Application["CONFIG.AuthorizeNet.UserName"]) )
			{
				throw(new Exception(MODULE_NAME + " is not enabled or configured."));
			}
			
			DataSet ds = memoryCache.Get(MODULE_NAME + ".CustomerProfiles") as DataSet;
			if ( ds == null )
			{
				ds = AuthorizeNetUtils.CustomerProfiles();
				memoryCache.Set(MODULE_NAME + ".CustomerProfiles", ds, DateTime.Now.AddMinutes(1));
			}
			DataTable dt = ds.Tables["CUSTOMER_PROFILES"];
			DataView vw = new DataView(dt);
			vw.RowFilter = "customerProfileId = '" + ID + "'";
			if ( vw.Count == 0 )
				throw(new Exception("Item not found: " + MODULE_NAME + " " + ID.ToString()));
			
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			
			Guid     gTIMEZONE         = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
			SplendidCRM.TimeZone T10n              = TimeZone.CreateTimeZone(gTIMEZONE);
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
				if ( Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				string sTransactionID = (dict.ContainsKey("TransactionID") ? Sql.ToString(dict["TransactionID"]) : String.Empty);
				if ( Sql.IsEmptyString(sTransactionID ) )
				{
					throw(new Exception("Missing TransactionID"));
				}
				
				if ( Sql.ToBoolean(Application["CONFIG.AuthorizeNet.Enabled"]) && !Sql.IsEmptyString(Application["CONFIG.AuthorizeNet.UserName"]) )
				{
					string sRefundTransactionId = AuthorizeNetUtils.Refund(sTransactionID);
					memoryCache.Remove("AuthorizeNet.Transaction." + sTransactionID);
					return sRefundTransactionId;
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
