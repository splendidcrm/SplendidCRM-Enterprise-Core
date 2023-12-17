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

namespace Spring.Social.Watson
{
	public class Prospect : HObject
	{
		#region Properties
		public string    email_address        ;
		public string    first_name           ;
		public string    last_name            ;
		public string    status               ;
		public string    list_id              ;
		public string    CRMContactTableName  ;
		#endregion
		protected Dictionary<string, string> dictMergeValues;
		protected List<string>               lstWatsonFields;

		public Prospect(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.Watson.Api.IWatson watson, string database_id, string list_id, Guid gPROSPECT_LIST_ID, DataTable dtMergeFields, List<string> lstWatsonFields)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, watson, database_id, "Contacts", "email_address", "Prospects", "PROSPECT_LISTS_RELATED", "EMAIL1", true, dtMergeFields)
		{
			this.list_id              = list_id          ;
			this.PARENT_ID            = gPROSPECT_LIST_ID;
			this.IsContact            = true             ;
			this.CRMContactTableName  = "PROSPECTS"      ;
			this.dictMergeValues      = new Dictionary<string,string>();
			this.lstWatsonFields      = lstWatsonFields  ;
		}

		public Prospect(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.Watson.Api.IWatson watson, string database_id, string list_id, string sCRMModuleName, Guid gPROSPECT_LIST_ID, string sCRMContactTableName, DataTable dtMergeFields, List<string> lstWatsonFields)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError,watson, database_id, "Contacts", "email_address", sCRMModuleName, "PROSPECT_LISTS_RELATED", "EMAIL1", true, dtMergeFields)
		{
			this.list_id              = list_id          ;
			this.PARENT_ID            = gPROSPECT_LIST_ID;
			this.IsContact            = true             ;
			this.CRMContactTableName  = sCRMContactTableName;
			this.dictMergeValues      = new Dictionary<string,string>();
			this.lstWatsonFields      = lstWatsonFields  ;
		}

		public override void Reset()
		{
			base.Reset();
			this.email_address   = String.Empty;
			this.first_name      = String.Empty;
			this.last_name       = String.Empty;
			this.status          = String.Empty;
			this.dictMergeValues = new Dictionary<string,string>();
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			
			this.id         = sID;
			this.LOCAL_ID   = Sql.ToGuid  (row["ID"  ]);
			this.name       = Sql.ToString(row["NAME"]);
			
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
			if ( this.dtMergeFields != null )
			{
				foreach ( DataRow rowMergeField in this.dtMergeFields.Rows )
				{
					string sColumnName  = Sql.ToString(rowMergeField["ColumnName" ]);
					string sCsType      = Sql.ToString(rowMergeField["CsType"     ]);
					string sWatsonField = Sql.ToString(rowMergeField["WatsonField"]);
					if ( row.Table.Columns.Contains(sColumnName) )
					{
						if ( !this.dictMergeValues.ContainsKey(sWatsonField) )
						{
							// 01/01/2020 Paul.  Watson seems to only like simple dates. 
							string sValue = Sql.ToString(row[sColumnName]);
							if ( sCsType == "DateTime" )
							{
								DateTime dtValue = Sql.ToDateTime(row[sColumnName]);
								if ( dtValue != DateTime.MinValue )
									sValue = dtValue.ToString("MM/dd/yyyy");
							}
							this.dictMergeValues.Add(sWatsonField, sValue);
						}
					}
				}
			}
			return bChanged;
		}

		public override void SetFromWatson(string sId)
		{
			Spring.Social.Watson.Api.Contact obj = this.Watson.ContactOperations.GetById(this.list_id, sId);
			SetFromWatson(obj);
		}

		public void SetFromWatson(Spring.Social.Watson.Api.Contact obj)
		{
			this.Reset();
			this.RawContent          = obj.RawContent            ;
			this.id                  = obj.ID                    ;
			this.lastmodifieddate    = (obj.LAST_MODIFIED.HasValue ? obj.LAST_MODIFIED.Value : DateTime.MinValue);
		}

		public override void Update()
		{
			Spring.Social.Watson.Api.Contact obj = new Spring.Social.Watson.Api.Contact();
			obj.ID      = this.id     ;
			obj.LIST_ID = this.list_id;
			foreach ( string sWatsonField in dictMergeValues.Keys )
			{
				if ( this.lstWatsonFields != null && this.lstWatsonFields.Contains(sWatsonField) )
					obj.SetMergeField(sWatsonField, dictMergeValues[sWatsonField]);
			}

			this.Watson.ContactOperations.Update(this.database_id, this.list_id, obj);
			// 02/01/2018 Paul.  Watson does not return the modified date, so we have to fake it. 
			this.lastmodifieddate = DateTime.Now;
		}

		public override string Insert()
		{
			this.id = String.Empty;
			
			Spring.Social.Watson.Api.Contact obj = new Spring.Social.Watson.Api.Contact();
			obj.LIST_ID = this.list_id;
			foreach ( string sWatsonField in dictMergeValues.Keys )
			{
				if ( this.lstWatsonFields != null && this.lstWatsonFields.Contains(sWatsonField) )
					obj.SetMergeField(sWatsonField, dictMergeValues[sWatsonField]);
			}
			
			Spring.Social.Watson.Api.ContactInsert objNew = this.Watson.ContactOperations.Insert(this.database_id, this.list_id, obj);
			this.RawContent       = objNew.RawContent;
			this.id               = objNew.ID        ;
			// 02/01/2018 Paul.  Watson does not return the modified date, so we have to fake it. 
			this.lastmodifieddate = DateTime.Now;
			return this.id;
		}

		public override void AddToProspectList(string sId)
		{
			this.id = sId;
			this.Watson.ContactOperations.AddToContactList(this.list_id, this.id);
		}

		public override void Delete()
		{
			this.Watson.ContactOperations.Delete(this.list_id, this.email_address);
		}

		public override void Get(string sID)
		{
			Spring.Social.Watson.Api.Contact obj = this.Watson.ContactOperations.GetById(this.list_id, sID);
			if ( !String.IsNullOrEmpty(obj.ID) )
			{
				this.SetFromWatson(obj);
			}
			else
			{
				this.Deleted = true;
			}
		}

		public override IList<Spring.Social.Watson.Api.HBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.Watson.Api.HBase> lst = this.Watson.ContactOperations.GetModified(this.list_id, dtStartModifiedDate);
			return lst;
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			// 05/19/2015 Paul.  The email is treated as a primary key. 
			Sql.AppendParameter(cmd, Sql.ToString(this.email_address), "EMAIL1");
		}

		public override Guid CreateContact(ExchangeSession Session, IDbCommand spUpdate, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			Guid gMEMBER_ID = Guid.Empty;
			IDbCommand spInsert = SqlProcs.Factory(trn.Connection, "sp" + this.CRMContactTableName + "_Update");
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
