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
	public class Prospect : HObject
	{
		#region Properties
		public string    email_address        ;
		public string    first_name           ;
		public string    last_name            ;
		public string    status               ;
		public string    list_id              ;
		public string    CRMMemberTableName   ;
		#endregion
		Dictionary<string, string> dictMergeValues;

		// 05/29/2016 Paul.  Add merge fields. 
		public Prospect(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.MailChimp.Api.IMailChimp mailChimp, string list_id, Guid gPROSPECT_LIST_ID, DataTable dtMergeFields)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, mailChimp, "Members", "email_address", "Prospects", "PROSPECT_LISTS_RELATED", "EMAIL1", true, dtMergeFields)
		{
			this.list_id   = list_id          ;
			this.PARENT_ID = gPROSPECT_LIST_ID;
			this.IsMember  = true;
			this.CRMMemberTableName  = "PROSPECTS"  ;
			this.dictMergeValues = new Dictionary<string,string>();
		}

		// 05/29/2016 Paul.  Add merge fields. 
		public Prospect(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.MailChimp.Api.IMailChimp mailChimp, string sCRMModuleName, string list_id, Guid gPROSPECT_LIST_ID, string sCRMMemberTableName, DataTable dtMergeFields)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, mailChimp, "Members", "email_address", sCRMModuleName, "PROSPECT_LISTS_RELATED", "EMAIL1", true, dtMergeFields)
		{
			this.list_id   = list_id          ;
			this.PARENT_ID = gPROSPECT_LIST_ID;
			this.IsMember  = true;
			this.CRMMemberTableName  = sCRMMemberTableName ;
			// 01/31/2018 Paul.  Should initialize. 
			this.dictMergeValues = new Dictionary<string,string>();
		}

		public override void Reset()
		{
			base.Reset();
			this.email_address = String.Empty;
			this.first_name    = String.Empty;
			this.last_name     = String.Empty;
			this.status        = String.Empty;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			
			this.id         = sID;
			this.LOCAL_ID   = Sql.ToGuid  (row["ID"  ]);
			this.name       = Sql.ToString(row["NAME"]);
			this.dictMergeValues = new Dictionary<string,string>();
			
			string sSTATUS = Sql.ToBoolean(row["EMAIL_OPT_OUT"]) ? "unsubscribed" : "subscribed";
			if ( Sql.IsEmptyString(sID) )
			{
				this.email_address = Sql.ToString(row["EMAIL1"    ]);
				this.first_name    = Sql.ToString(row["FIRST_NAME"]);
				this.last_name     = Sql.ToString(row["LAST_NAME" ]);
				this.status        = sSTATUS;
				bChanged = true;
			}
			else
			{
				if ( Compare(this.email_address, row["EMAIL1"    ], "EMAIL1"       , sbChanges) ) { this.email_address = Sql.ToString(row["EMAIL1"    ]);  bChanged = true; }
				// 02/16/2017 Paul.  Correct field mapping. 
				if ( Compare(this.first_name   , row["FIRST_NAME"], "FIRST_NAME"   , sbChanges) ) { this.first_name    = Sql.ToString(row["FIRST_NAME"]);  bChanged = true; }
				if ( Compare(this.last_name    , row["LAST_NAME" ], "LAST_NAME"    , sbChanges) ) { this.last_name     = Sql.ToString(row["LAST_NAME" ]);  bChanged = true; }
				if ( Compare(this.status       , sSTATUS          , "EMAIL_OPT_OUT", sbChanges) ) { this.status        = sSTATUS                    ;  bChanged = true; }
			}
			// 05/29/2016 Paul.  Add merge fields. 
			if ( this.dtMergeFields != null )
			{
				foreach ( DataRow rowMergeField in this.dtMergeFields.Rows )
				{
					string sColumnName  = Sql.ToString(rowMergeField["ColumnName" ]);
					string sTag         = Sql.ToString(rowMergeField["Tag"        ]);
					if ( row.Table.Columns.Contains(sColumnName) )
					{
						if ( !this.dictMergeValues.ContainsKey(sTag) )
						{
							dictMergeValues.Add(sTag, Sql.ToString(row[sColumnName]));
						}
					}
				}
			}
			return bChanged;
		}

		public override void SetFromMailChimp(string sId)
		{
			Spring.Social.MailChimp.Api.Member obj = this.MailChimp.MemberOperations.GetById(this.list_id, sId);
			SetFromMailChimp(obj);
		}

		public void SetFromMailChimp(Spring.Social.MailChimp.Api.Member obj)
		{
			this.Reset();
			this.RawContent          = obj.RawContent            ;
			this.id                  = obj.id                    ;
			this.date_created        = (obj.date_created.HasValue     ? obj.date_created.Value     : DateTime.MinValue);
			this.lastmodifieddate    = (obj.lastmodifieddate.HasValue ? obj.lastmodifieddate.Value : DateTime.MinValue);
			this.status              = obj.status                ;
			this.name                = obj.email_address         ;
			this.email_address       = obj.email_address         ;
			this.dictMergeValues = new Dictionary<string,string>();
			foreach ( Spring.Social.MailChimp.Api.Member.MergeField fld in obj.merge_fields )
			{
				if ( !this.dictMergeValues.ContainsKey(fld.field_name) )
				{
					dictMergeValues.Add(fld.field_name, fld.value);
				}
				if ( fld.field_name == "FNAME" || fld.field_name == "FIRST_NAME" )
					this.first_name = fld.value;
				else if ( fld.field_name == "LNAME" || fld.field_name == "LAST_NAME" )
					this.last_name = fld.value;
			}
		}

		public override void Update()
		{
			Spring.Social.MailChimp.Api.Member obj = this.MailChimp.MemberOperations.GetById(this.list_id, this.id);
			obj.id                    = this.id                 ;
			obj.status                = this.status             ;
			obj.email_address         = this.email_address      ;
			obj.SetMergeField("EMAIL", this.email_address);
			// 05/29/2016 Paul.  Add merge fields. 
			foreach ( string sWatsonField in dictMergeValues.Keys )
			{
				obj.SetMergeField(sWatsonField, dictMergeValues[sWatsonField]);
			}
			
			this.MailChimp.MemberOperations.Update(this.list_id, obj);
			obj = this.MailChimp.MemberOperations.GetById(this.list_id, this.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id                    ;
			// 04/16/2016 Paul.  MailChimp does not return the modified date, so we have to fake it. 
			this.lastmodifieddate = DateTime.Now;
		}

		public override string Insert()
		{
			this.id = String.Empty;
			
			Spring.Social.MailChimp.Api.Member obj = new Spring.Social.MailChimp.Api.Member();
			obj.status                = this.status             ;
			obj.email_address         = this.email_address      ;
			obj.list_id               = this.list_id            ;
			obj.SetMergeField("EMAIL", this.email_address);
			// 05/29/2016 Paul.  Add merge fields. 
			foreach ( string sWatsonField in dictMergeValues.Keys )
			{
				obj.SetMergeField(sWatsonField, dictMergeValues[sWatsonField]);
			}
			
			obj = this.MailChimp.MemberOperations.Insert(this.list_id, obj);
			obj = this.MailChimp.MemberOperations.GetById(this.list_id, obj.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id                    ;
			// 04/16/2016 Paul.  MailChimp does not return the modified date, so we have to fake it. 
			this.lastmodifieddate = DateTime.Now;
			return this.id;
		}

		public override void Delete()
		{
			this.MailChimp.MemberOperations.Delete(this.list_id, this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.MailChimp.Api.Member obj = this.MailChimp.MemberOperations.GetById(this.list_id, sID);
			if ( !String.IsNullOrEmpty(obj.id) )
			{
				this.SetFromMailChimp(obj);
			}
			else
			{
				this.Deleted = true;
			}
		}

		// 02/16/2017 Paul.  Make sure that member does not exist. 
		public override bool Search()
		{
			bool bFound = false;
			IList<Spring.Social.MailChimp.Api.Member> lst = this.MailChimp.MemberOperations.Search(this.list_id, this.email_address);
			if ( lst != null && lst.Count > 0 )
			{
				this.SetFromMailChimp(lst[0]);
				bFound = true;
			}
			return bFound;
		}

		public override IList<Spring.Social.MailChimp.Api.HBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.MailChimp.Api.HBase> lst = this.MailChimp.MemberOperations.GetModified(this.list_id, dtStartModifiedDate);
			return lst;
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			// 05/19/2015 Paul.  The email is treated as a primary key. 
			Sql.AppendParameter(cmd, Sql.ToString(this.email_address), "EMAIL1");
		}

		public override Guid CreateMember(ExchangeSession Session, IDbCommand spUpdate, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			Guid gMEMBER_ID = Guid.Empty;
			IDbCommand spInsert = SqlProcs.Factory(trn.Connection, "sp" + this.CRMMemberTableName + "_Update");
			bool bChanged = this.InitUpdateProcedure(spInsert, null, gUSER_ID, gTEAM_ID);
			foreach(IDbDataParameter par in spInsert.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
				string sColumnName = Sql.ExtractDbName(spInsert, par.ParameterName).ToUpper();
				if ( SplendidInit.bEnableACLFieldSecurity )
				{
					acl = ExchangeSecurity.GetUserFieldSecurity(Session, this.CRMModuleName, sColumnName, gASSIGNED_USER_ID);
				}
				if ( acl.IsWriteable() )
				{
					try
					{
						object oValue = null;
						switch ( sColumnName )
						{
							case "EMAIL1"          :  oValue = Sql.ToDBString (this.email_address);  break;
							case "FIRST_NAME"      :  oValue = Sql.ToDBString (this.first_name   );  break;
							case "LAST_NAME"       :
								if ( !Sql.IsEmptyString(this.last_name) )
									oValue = Sql.ToDBString (this.last_name);
								else if ( this.email_address.Contains("@") )
									oValue = Sql.ToDBString (this.email_address.Split('@')[0]);
								break;
							case "EMAIL_OPT_OUT"   :  oValue = Sql.ToDBBoolean(this.status == "subscribed" || this.status == "pending");  break;
							case "MODIFIED_USER_ID":  oValue = gUSER_ID;  break;
						}
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "EMAIL1"    :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "FIRST_NAME":  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "LAST_NAME" :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									default          :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
								}
							}
							par.Value = oValue;
						}
					}
					catch
					{
					}
				}
			}
			spInsert.Transaction = trn;
			spInsert.ExecuteNonQuery();
			IDbDataParameter parID = Sql.FindParameter(spInsert, "@ID");
			gMEMBER_ID = Sql.ToGuid(parID.Value);
			
			this.InitUpdateProcedure(spUpdate, null, gUSER_ID, gTEAM_ID);
			foreach(IDbDataParameter par in spUpdate.Parameters)
			{
				string sColumnName = Sql.ExtractDbName(spUpdate, par.ParameterName).ToUpper();
				if      ( sColumnName == "MODIFIED_USER_ID" ) par.Value = gUSER_ID          ;
				else if ( sColumnName == "PROSPECT_LIST_ID" ) par.Value = this.PARENT_ID    ;
				else if ( sColumnName == "RELATED_ID"       ) par.Value = gMEMBER_ID        ;
				else if ( sColumnName == "RELATED_TYPE"     ) par.Value = this.CRMModuleName;
			}
			spUpdate.Transaction = trn;
			spUpdate.ExecuteNonQuery();
			// 09/09/2016 Paul.  Return the new member ID. 
			return gMEMBER_ID;
		}
	}
}
