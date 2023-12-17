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
	public class Campaign : HObject
	{
		#region Properties
		// Contact properties 
		public String    company                      { get; set; }
		public String    address1                     { get; set; }
		public String    address2                     { get; set; }
		public String    city                         { get; set; }
		public String    state                        { get; set; }
		public String    zip                          { get; set; }
		public String    country                      { get; set; }
		public String    phone                        { get; set; }
		// Campaign properties 
		public String    from_name                    { get; set; }
		public String    from_email                   { get; set; }
		public String    subject                      { get; set; }
		public String    language                     { get; set; }
		#endregion

		// 05/29/2016 Paul.  Add merge fields. 
		public Campaign(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.MailChimp.Api.IMailChimp mailChimp, string from_name, string from_email)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, mailChimp, "Campaigns", "name", "Campaigns", "CAMPAIGNS", "NAME", true, null)
		{
			Spring.Social.MailChimp.Api.Account obj = this.MailChimp.AccountOperations.Get();
			this.company    = obj.company ;
			this.address1   = obj.addr1   ;
			this.address2   = obj.addr2   ;
			this.city       = obj.city    ;
			this.state      = obj.state   ;
			this.zip        = obj.zip     ;
			this.country    = obj.country ;
			this.phone      = String.Empty;
			this.from_name  = from_name   ;
			this.from_email = from_email  ;
			this.language   = "en"        ;
		}

		public override void Reset()
		{
			base.Reset();
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			
			this.id       = sID;
			this.LOCAL_ID = Sql.ToGuid  (row["ID"  ]);
			this.name     = Sql.ToString(row["NAME"]);
			if ( Sql.IsEmptyString(sID) )
			{
				this.subject  = Sql.ToString(row["NAME"]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.name, row["NAME"], "NAME", sbChanges) ) { this.name = Sql.ToString(row["NAME"]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromMailChimp(string sId)
		{
			Spring.Social.MailChimp.Api.Campaign obj = this.MailChimp.CampaignOperations.GetById(sId);
			SetFromMailChimp(obj);
		}

		public void SetFromMailChimp(Spring.Social.MailChimp.Api.Campaign obj)
		{
			this.Reset();
			this.RawContent          = obj.RawContent               ;
			this.id                  = obj.id                       ;
			this.name                = obj.settings.subject_line    ;
			this.date_created        = obj.date_created.Value       ;
			this.lastmodifieddate    = obj.lastmodifieddate.Value   ;
		}

		public override void Update()
		{
			Spring.Social.MailChimp.Api.Campaign obj = this.MailChimp.CampaignOperations.GetById(this.id);
			obj.id                    = this.id                 ;
			obj.settings.subject_line = this.name               ;
			
			this.MailChimp.CampaignOperations.Update(obj);
			obj = this.MailChimp.CampaignOperations.GetById(this.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id                    ;
			// 04/16/2016 Paul.  MailChimp does not return the modified date, so we have to fake it. 
			this.lastmodifieddate = DateTime.Now;
		}

		public override string Insert()
		{
			this.id = String.Empty;
			
			Spring.Social.MailChimp.Api.Campaign obj = new Spring.Social.MailChimp.Api.Campaign();
			obj.settings = new Spring.Social.MailChimp.Api.Campaign.Settings();
			obj.settings.subject_line = this.name               ;

			obj = this.MailChimp.CampaignOperations.Insert(obj);
			obj = this.MailChimp.CampaignOperations.GetById(obj.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id                    ;
			// 04/16/2016 Paul.  MailChimp does not return the modified date, so we have to fake it. 
			this.lastmodifieddate = DateTime.Now;
			return this.id;
		}

		public override void Delete()
		{
			this.MailChimp.CampaignOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.MailChimp.Api.Campaign obj = this.MailChimp.CampaignOperations.GetById(sID);
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
			IList<Spring.Social.MailChimp.Api.HBase> lst = this.MailChimp.CampaignOperations.GetModified(dtStartModifiedDate);
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
