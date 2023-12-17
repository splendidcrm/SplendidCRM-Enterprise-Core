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

namespace Spring.Social.MailChimp
{
	public class EmailTemplate : HObject
	{
		#region Properties
		public string    html               ;
		#endregion

		// 05/29/2016 Paul.  Add merge fields. 
		public EmailTemplate(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.MailChimp.Api.IMailChimp mailChimp)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, mailChimp, "Templates", "name", "EmailTemplates", "EMAIL_TEMPLATES", "NAME", true, null)
		{
		}

		public override void Reset()
		{
			base.Reset();
			this.html = String.Empty;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			
			this.id       = sID;
			this.LOCAL_ID = Sql.ToGuid  (row["ID"  ]);
			this.name     = Sql.ToString(row["NAME"]);
			if ( Sql.IsEmptyString(sID) )
			{
				this.html = Sql.ToString(row["BODY_HTML"]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.name, row["NAME"     ], "NAME"     , sbChanges) ) { this.name = Sql.ToString(row["NAME"     ]);  bChanged = true; }
				if ( Compare(this.html, row["BODY_HTML"], "BODY_HTML", sbChanges) ) { this.html = Sql.ToString(row["BODY_HTML"]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromMailChimp(string sId)
		{
			Spring.Social.MailChimp.Api.Template obj = this.MailChimp.TemplateOperations.GetById(sId);
			SetFromMailChimp(obj);
		}

		public void SetFromMailChimp(Spring.Social.MailChimp.Api.Template obj)
		{
			this.Reset();
			this.RawContent          = obj.RawContent               ;
			this.id                  = obj.id                       ;
			this.name                = obj.name                     ;
			this.date_created        = obj.date_created.Value       ;
			this.lastmodifieddate    = obj.lastmodifieddate.Value   ;
			this.html                = obj.html                     ;
		}

		public override void Update()
		{
			Spring.Social.MailChimp.Api.Template obj = this.MailChimp.TemplateOperations.GetById(this.id);
			obj.id                    = this.id                 ;
			obj.name                  = this.name               ;
			obj.html                  = this.html               ;
			
			this.MailChimp.TemplateOperations.Update(obj);
			obj = this.MailChimp.TemplateOperations.GetById(this.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id                    ;
			// 04/16/2016 Paul.  MailChimp does not return the modified date, so we have to fake it. 
			this.lastmodifieddate = DateTime.Now;
		}

		public override string Insert()
		{
			this.id = String.Empty;
			
			Spring.Social.MailChimp.Api.Template obj = new Spring.Social.MailChimp.Api.Template();
			obj.name                  = this.name               ;
			obj.html                  = this.html               ;

			obj = this.MailChimp.TemplateOperations.Insert(obj);
			obj = this.MailChimp.TemplateOperations.GetById(obj.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id                    ;
			// 04/16/2016 Paul.  MailChimp does not return the modified date, so we have to fake it. 
			this.lastmodifieddate = DateTime.Now;
			return this.id;
		}

		public override void Delete()
		{
			this.MailChimp.TemplateOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.MailChimp.Api.Template obj = this.MailChimp.TemplateOperations.GetById(sID);
			if ( !String.IsNullOrEmpty(obj.id) )
			{
				this.SetFromMailChimp(obj);
			}
			else
			{
				this.Deleted = true;
			}
		}

		public override IList<Spring.Social.MailChimp.Api.HBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.MailChimp.Api.HBase> lst = this.MailChimp.TemplateOperations.GetModified(dtStartModifiedDate);
			return lst;
		}

		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = this.InitUpdateProcedure(spUpdate, row, gUSER_ID, gTEAM_ID);
			
			foreach(IDbDataParameter par in spUpdate.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
				string sColumnName = Sql.ExtractDbName(spUpdate, par.ParameterName).ToUpper();
				if ( SplendidInit.bEnableACLFieldSecurity )
				{
					acl = ExchangeSecurity.GetUserFieldSecurity(Session, this.CRMModuleName, sColumnName, gASSIGNED_USER_ID);
				}
				if ( acl.IsWriteable() )
				{
					try
					{
						// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
						object oValue = null;
						switch ( sColumnName )
						{
							case "NAME"            :  oValue = Sql.ToDBString (this.name);  break;
							case "BODY_HTML"       :  oValue = Sql.ToDBString (this.html);  break;
							case "MODIFIED_USER_ID":  oValue = gUSER_ID                  ;  break;
						}
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "NAME":  bChanged = ParameterChanged(par, oValue,  255, sbChanges);  break;
									default    :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
								}
							}
							par.Value = oValue;
						}
					}
					catch
					{
						// 03/27/2010 Paul.  Some fields are not available.  Lets just ignore them. 
					}
				}
			}
			return bChanged;
		}
	}
}
