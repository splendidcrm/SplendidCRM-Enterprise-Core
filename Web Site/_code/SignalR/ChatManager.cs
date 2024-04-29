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
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Diagnostics;

using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.Authorization;
using DocumentFormat.OpenXml.InkML;
using Microsoft.AspNetCore.Http;

namespace SplendidCRM
{
	/// <summary>
	/// Summary description for ChatManager.
	/// </summary>
	public class ChatManager
	{
		private IHubContext<ChatManagerHub> hubContext;
		private IHubClients                   Clients;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private L10N                 L10n               ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCRM.Crm.Config           Config           = new SplendidCRM.Crm.Config();

		public ChatManager(IHubContext<ChatManagerHub> hubContext, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError)
		{
			this.hubContext          = hubContext         ;
			this.Clients             = hubContext.Clients ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
		}

		private object NullID(Guid gID)
		{
			return Sql.IsEmptyGuid(gID) ? null : gID.ToString();
		}
		
		public async Task NewMessage(Guid gID)
		{
			try
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					if ( !Sql.IsEmptyGuid(gID) )
					{
						string sSQL ;
						sSQL = "select *              " + ControlChars.CrLf
						     + "  from vwCHAT_MESSAGES" + ControlChars.CrLf
						     + " where ID = @ID       " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@ID", gID);
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dt = new DataTable() )
								{
									da.Fill(dt);
									if ( dt.Rows.Count > 0 )
									{
										DataRow row = dt.Rows[0];
										Guid     gCHAT_CHANNEL_ID    = Sql.ToGuid    (row["CHAT_CHANNEL_ID"   ]);
										string   sNAME               = Sql.ToString  (row["NAME"              ]);
										string   sDESCRIPTION        = Sql.ToString  (row["DESCRIPTION"       ]);
										DateTime dtDATE_ENTERED      = Sql.ToDateTime(row["DATE_ENTERED"      ]);
										Guid     gCREATED_BY_ID      = Sql.ToGuid    (row["CREATED_BY_ID"     ]);
										string   sCREATED_BY         = Sql.ToString  (row["CREATED_BY"        ]);
										string   sCREATED_BY_PICTURE = Sql.ToString  (row["CREATED_BY_PICTURE"]);
										Guid     gPARENT_ID          = Sql.ToGuid    (row["PARENT_ID"         ]);
										string   sPARENT_TYPE        = Sql.ToString  (row["PARENT_TYPE"       ]);
										string   sPARENT_NAME        = Sql.ToString  (row["PARENT_NAME"       ]);
										Guid     gNOTE_ATTACHMENT_ID = Sql.ToGuid    (row["NOTE_ATTACHMENT_ID"]);
										string   sFILENAME           = Sql.ToString  (row["FILENAME"          ]);
										string   sFILE_EXT           = Sql.ToString  (row["FILE_EXT"          ]);
										string   sFILE_MIME_TYPE     = Sql.ToString  (row["FILE_MIME_TYPE"    ]);
										long     lFILE_SIZE          = Sql.ToLong    (row["FILE_SIZE"         ]);
										bool     bATTACHMENT_READY   = Sql.ToBoolean (row["ATTACHMENT_READY"  ]);
										
										Guid     gTIMEZONE        = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
										TimeZone T10n             = TimeZone.CreateTimeZone(gTIMEZONE);
										string   sDATE_ENTERED    = RestUtil.ToJsonDate(T10n.FromServerTime(dtDATE_ENTERED));
										//await Clients.Group(gCHAT_CHANNEL_ID.ToString()).SendAsync("newMessage", gCHAT_CHANNEL_ID, gID, sNAME, sDESCRIPTION, sDATE_ENTERED, NullID(gPARENT_ID), sPARENT_TYPE, sPARENT_NAME, NullID(gCREATED_BY_ID), sCREATED_BY/*, sCREATED_BY_PICTURE, NullID(gNOTE_ATTACHMENT_ID), sFILENAME, sFILE_EXT, sFILE_MIME_TYPE, lFILE_SIZE, bATTACHMENT_READY*/);
										//Clients.All.allMessage(gCHAT_CHANNEL_ID, gID, sDESCRIPTION, dtDATE_ENTERED, gUSER_ID, sCREATED_BY, NullID(gPARENT_ID), sPARENT_TYPE);
										// 04/27/2024 Paul.  SignalR core does not support more than 10 parameters, so convert to dictionary. 
										Dictionary<string, object> dict = RestUtil.ToJson("", "ChatMessages", dt.Rows[0], T10n);
										await Clients.Group(gCHAT_CHANNEL_ID.ToString()).SendAsync("newMessage", (dict["d"] as Dictionary<string, object>)["results"]);
									}
								}
							}
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
			}
		}
	}
}

