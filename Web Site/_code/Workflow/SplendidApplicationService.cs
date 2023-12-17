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
using System.Workflow.Runtime.Hosting;

using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Caching.Memory;

using Spring.Social.Office365;

namespace SplendidCRM
{
	public class SplendidApplicationService : WorkflowRuntimeService
	{
		public  IWebHostEnvironment   hostingEnvironment   ;
		public  IMemoryCache         memoryCache        ;
		public  SplendidDefaults      SplendidDefaults     = new SplendidDefaults();
		public  HttpApplicationState  Application          = new HttpApplicationState();
		public  HttpSessionState      Session              ;
		public  Security              Security             ;
		public  Sql                   Sql                  ;
		public  L10N                  L10n                 ;
		public  SqlProcs              SqlProcs             ;
		public  SplendidError         SplendidError        ;
		public  SplendidCache         SplendidCache        ;
		public  SplendidDynamic       SplendidDynamic      ;
		public  EmailUtils            EmailUtils           ;
		public  XmlUtil               XmlUtil              ;
		public  Crm.Modules           Modules              ;
		public  Crm.NoteAttachments   NoteAttachments      ;
		public  ReportsAttachmentView ReportsAttachmentView;
		public  SyncError             SyncError            ;
		public  ExchangeSecurity      ExchangeSecurity     ;
		public  ExchangeUtils         ExchangeUtils        ;
		public  GoogleApps            GoogleApps           ;
		public  Office365Sync         Office365Sync        ;
		public  ExchangeSync          ExchangeSync         ;
		public  GoogleSync            GoogleSync           ;
		public  iCloudSync            iCloudSync           ;
		
		public SplendidApplicationService(IWebHostEnvironment hostingEnvironment, IMemoryCache memoryCache, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, SplendidDynamic SplendidDynamic, EmailUtils EmailUtils, XmlUtil XmlUtil, SplendidCRM.Crm.Modules Modules, SplendidCRM.Crm.NoteAttachments NoteAttachments, ReportsAttachmentView ReportsAttachmentView, SyncError SyncError, ExchangeSecurity ExchangeSecurity, ExchangeUtils ExchangeUtils, GoogleApps GoogleApps, Office365Sync Office365Sync, ExchangeSync ExchangeSync, GoogleSync GoogleSync, iCloudSync iCloudSync)
		{
			this.memoryCache           = memoryCache          ;
			this.sCultureName          = SplendidDefaults.Culture();
			this.hostingEnvironment    = hostingEnvironment   ;
			this.Session               = Session              ;
			this.Security              = Security             ;
			this.L10n                  = new L10N(sCultureName);
			this.Sql                   = Sql                  ;
			this.SqlProcs              = SqlProcs             ;
			this.SplendidError         = SplendidError        ;
			this.SplendidCache         = SplendidCache        ;
			this.SplendidDynamic       = SplendidDynamic      ;
			this.EmailUtils            = EmailUtils           ;
			this.XmlUtil               = XmlUtil              ;
			this.Modules               = Modules              ;
			this.NoteAttachments       = NoteAttachments      ;
			this.ReportsAttachmentView = ReportsAttachmentView;
			this.SyncError             = SyncError            ;
			this.ExchangeSecurity      = ExchangeSecurity     ;
			this.ExchangeUtils         = ExchangeUtils        ;
			this.GoogleApps            = GoogleApps           ;
			this.Office365Sync         = Office365Sync        ;
			this.ExchangeSync          = ExchangeSync         ;
			this.GoogleSync            = GoogleSync           ;
			this.iCloudSync            = iCloudSync           ;
		}

		protected string      sCultureName;

		public string SplendidProvider
		{
			get { return Sql.ToString(Application["SplendidProvider"]); }
		}

		public string ConnectionString
		{
			get { return Sql.ToString(Application["ConnectionString"]); }
		}

		public string Term(string sEntryName)
		{
			return L10n.Term(sEntryName);
		}

		public object Term(string sListName, object oField)
		{
			return L10n.Term(sListName, oField);
		}
	}
}
