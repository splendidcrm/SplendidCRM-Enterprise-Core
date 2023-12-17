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
	public class ProspectList : HObject
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
		public ProspectList(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.MailChimp.Api.IMailChimp mailChimp, string from_name, string from_email, DataTable dtMergeFields)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, mailChimp, "Lists", "name", "ProspectLists", "PROSPECT_LISTS", "NAME", true, dtMergeFields)
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
			if ( Sql.IsEmptyString(sID) )
			{
				this.name     = Sql.ToString(row["NAME"]);
				this.subject  = Sql.ToString(row["NAME"]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.name   , row["NAME"], "NAME", sbChanges) ) { this.name    = Sql.ToString(row["NAME"]);  bChanged = true; }
				if ( Compare(this.subject, row["NAME"], "NAME", sbChanges) ) { this.subject = Sql.ToString(row["NAME"]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromMailChimp(string sId)
		{
			Spring.Social.MailChimp.Api.List obj = this.MailChimp.ListOperations.GetById(sId);
			SetFromMailChimp(obj);
		}

		public void SetFromMailChimp(Spring.Social.MailChimp.Api.List obj)
		{
			this.Reset();
			this.RawContent          = obj.RawContent               ;
			this.id                  = obj.id                       ;
			this.name                = obj.name                     ;
			this.date_created        = obj.date_created.Value       ;
			this.lastmodifieddate    = obj.lastmodifieddate.Value   ;
			this.subject             = obj.campaign_defaults.subject;
		}

		public override void Update()
		{
			Spring.Social.MailChimp.Api.List obj = this.MailChimp.ListOperations.GetById(this.id);
			obj.id                    = this.id                 ;
			obj.name                  = this.name               ;
			
			this.MailChimp.ListOperations.Update(obj);
			obj = this.MailChimp.ListOperations.GetById(this.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id                    ;
			// 04/16/2016 Paul.  MailChimp does not return the modified date, so we have to fake it. 
			this.lastmodifieddate = DateTime.Now;
		}

		// 05/29/2016 Paul.  Add merge fields. 
		public void UpdateMergeFields()
		{
			if ( this.dtMergeFields != null && !Sql.IsEmptyString(this.id) )
			{
				IList<Spring.Social.MailChimp.Api.MergeField> lstExistingFields = this.MailChimp.ListOperations.GetMergeFields(this.id);
				foreach ( DataRow rowMergeField in this.dtMergeFields.Rows )
				{
					string sColumnName  = Sql.ToString(rowMergeField["ColumnName" ]);
					string sTag         = Sql.ToString(rowMergeField["Tag"        ]);
					string sCsType      = Sql.ToString(rowMergeField["CsType"     ]);
					string sDisplayName = Sql.ToString(rowMergeField["DisplayName"]);
					string sMergeType   = "text";
					// text, number, radio, dropdown, date, birthday, address, zip, phone, url, image
					switch ( sCsType )
					{
						case "Int32"   :  sMergeType = "number";  break;
						case "Int16"   :  sMergeType = "number";  break;
						case "Int64"   :  sMergeType = "number";  break;
						case "float"   :  sMergeType = "number";  break;
						case "decimal" :  sMergeType = "number";  break;
						case "DateTime":  sMergeType = "date"  ;  break;
					}
					if ( sColumnName.Contains("PHONE") )
						sMergeType = "phone";
					else if ( sColumnName.Contains("POSTALCODE") )
						sMergeType = "zip";
					else if ( sColumnName.Contains("ADDRESS_") )
						sMergeType = "address";
					else if ( sColumnName.Contains("WEBSITE") )
						sMergeType = "url";
					else if ( sColumnName.Contains("DATE") )
						sMergeType = "date";
					
					// 05/30/2016 Paul.  MailChimp will truncate tag to 10 chars. 
					if ( sTag.Length > 10 )
						sTag = sTag.Substring(0, 10);
					bool bFound = false;
					foreach ( Spring.Social.MailChimp.Api.MergeField fld in lstExistingFields )
					{
						if ( fld.tag == sTag )
						{
							bFound = true;
							break;
						}
					}
					if ( !bFound )
					{
						Spring.Social.MailChimp.Api.MergeField obj = new Spring.Social.MailChimp.Api.MergeField();
						obj.tag           = sTag        ;
						obj.name          = sDisplayName;
						obj.type          = sMergeType  ;
						this.MailChimp.ListOperations.AddMergeField(this.id, obj);
					}
				}
			}
		}

		public override string Insert()
		{
			this.id = String.Empty;
			
			Spring.Social.MailChimp.Api.List obj = new Spring.Social.MailChimp.Api.List();
			obj.name                         = this.name      ;
			obj.permission_reminder          = "This list is opt-in.";
			// Subscribers will receive HTML emails, with a plain-text alternative backup
			obj.email_type_option            = false          ;
			obj.contact.company              = this.company   ;
			obj.contact.address1             = this.address1  ;
			obj.contact.address2             = this.address2  ;
			obj.contact.city                 = this.city      ;
			obj.contact.state                = this.state     ;
			obj.contact.zip                  = this.zip       ;
			obj.contact.country              = this.country   ;
			obj.contact.phone                = this.phone     ;
			obj.campaign_defaults.from_name  = this.from_name ;
			obj.campaign_defaults.from_email = this.from_email;
			obj.campaign_defaults.subject    = this.subject   ;
			obj.campaign_defaults.language   = this.language  ;

			obj = this.MailChimp.ListOperations.Insert(obj);
			obj = this.MailChimp.ListOperations.GetById(obj.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id                    ;
			// 04/16/2016 Paul.  MailChimp does not return the modified date, so we have to fake it. 
			this.lastmodifieddate = DateTime.Now;
			return this.id;
		}

		public override void Delete()
		{
			this.MailChimp.ListOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.MailChimp.Api.List obj = this.MailChimp.ListOperations.GetById(sID);
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
			IList<Spring.Social.MailChimp.Api.HBase> lst = this.MailChimp.ListOperations.GetModified(dtStartModifiedDate);
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
							case "LIST_TYPE"       :  oValue = "MailChimp"               ;  break;
							case "MODIFIED_USER_ID":  oValue = gUSER_ID                  ;  break;
						}
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "NAME"     :  bChanged = ParameterChanged(par, oValue,  255, sbChanges);  break;
									case "LIST_TYPE":  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
									default         :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
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
