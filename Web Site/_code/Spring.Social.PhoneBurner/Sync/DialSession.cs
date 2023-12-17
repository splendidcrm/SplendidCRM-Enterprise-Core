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
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Web;
using System.Diagnostics;
using SplendidCRM;

using Microsoft.Extensions.Caching.Memory;

namespace Spring.Social.PhoneBurner
{
	public class DialSession
	{
		private IMemoryCache         Cache              ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private SyncError            SyncError          ;
		private SplendidCRM.Crm.Config                    Config           = new SplendidCRM.Crm.Config();
		private SplendidCRM.Crm.Modules                   Modules          ;
		private Spring.Social.PhoneBurner.PhoneBurnerSync PhoneBurnerSync;

		public DialSession(IMemoryCache memoryCache, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, SplendidCRM.Crm.Modules Modules, Spring.Social.PhoneBurner.PhoneBurnerSync PhoneBurnerSync)
		{
			this.Cache               = memoryCache        ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;
			this.Modules             = Modules            ;
			this.PhoneBurnerSync     = PhoneBurnerSync    ;
		}

		public string CreateSession(Guid gUSER_ID, string sMODULE_NAME, List<string> arrID)
		{
			// 09/07/2020 Paul.  Use the User-specific PhoneBurner OAuth token. 
			Spring.Social.PhoneBurner.Api.IPhoneBurner phoneBurner = PhoneBurnerSync.CreateApi(gUSER_ID);
			Spring.Social.PhoneBurner.Api.DialSession obj = new Spring.Social.PhoneBurner.Api.DialSession();

			// 08/26/2020 Paul.  The PhoneBurnerUserSessionID custom data will be used to determine if the session is valid. 
			string sPhoneBurnerUserSessionID = Guid.NewGuid().ToString();
			Cache.Set("PhoneBurnerSession." + sPhoneBurnerUserSessionID, gUSER_ID, DateTime.Now.AddHours(24));
			
			string sSiteURL = Config.SiteURL();
			obj.api_callbegin = sSiteURL + "Administration/PhoneBurner/CallBegin.aspx";
			obj.api_calldone  = sSiteURL + "Administration/PhoneBurner/CallDone.aspx" ;
			obj.custom_data.PhoneBurnerUserSessionID = sPhoneBurnerUserSessionID;
			obj.custom_data.ModuleName               = sMODULE_NAME;
			
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					string sTABLE_NAME = Modules.TableName(sMODULE_NAME);
					string sSQL = String.Empty;
					sSQL = "select *"                + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf
					     + " where 1 = 0"            + ControlChars.CrLf;
					cmd.CommandText = sSQL;
					Sql.AppendParameter(cmd, arrID.ToArray(), "ID", true);
					cmd.CommandText += " order by NAME asc" + ControlChars.CrLf;
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dt = new DataTable() )
						{
							da.Fill(dt);
							foreach ( DataRow row in dt.Rows )
							{
								StringBuilder sbChanges = new StringBuilder();
								Spring.Social.PhoneBurner.Contact contact = new Spring.Social.PhoneBurner.Contact(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, phoneBurner);
								contact.SetFromCRM(String.Empty, row, sbChanges);
								obj.contacts.Add(contact.CreateApiContext());
							}
						}
					}
				}
			}
			
			Spring.Social.PhoneBurner.Api.DialSessionResult result = phoneBurner.DialOperations.CreateSession(obj);
			if ( result.status != "success" )
			{
				throw(new Exception(result.errors));
			}
			return result.redirect_url;
		}
	}
}
