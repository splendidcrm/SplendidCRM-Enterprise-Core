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
	public class ProspectList : HObject
	{
		public ProspectList(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.Watson.Api.IWatson watson, string database_id, DataTable dtMergeFields) : base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, watson, database_id, "Lists", "name", "ProspectLists", "PROSPECT_LISTS", "NAME", true, dtMergeFields)
		{
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
				bChanged = true;
			}
			else
			{
				if ( Compare(this.name   , row["NAME"], "NAME", sbChanges) ) { this.name    = Sql.ToString(row["NAME"]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromWatson(string sId)
		{
			Spring.Social.Watson.Api.ProspectList obj = this.watson.ProspectListOperations.GetById(sId);
			SetFromWatson(obj);
		}

		public void SetFromWatson(Spring.Social.Watson.Api.ProspectList obj)
		{
			this.Reset();
			this.RawContent          = obj.RawContent               ;
			this.id                  = obj.ID                       ;
			this.name                = obj.NAME                     ;
			this.lastmodifieddate    = obj.LAST_MODIFIED.Value      ;
		}

		public override void Update()
		{
			Spring.Social.Watson.Api.ProspectList obj = this.watson.ProspectListOperations.GetById(this.id);
			obj.ID                    = this.id                 ;
			obj.NAME                  = this.name               ;
			
			this.watson.ProspectListOperations.Update(this.database_id, obj);
			obj = this.watson.ProspectListOperations.GetById(this.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.ID                    ;
			this.lastmodifieddate = obj.LAST_MODIFIED.Value   ;
		}

		public override string Insert()
		{
			this.id = String.Empty;
			
			Spring.Social.Watson.Api.ProspectList obj = new Spring.Social.Watson.Api.ProspectList();
			obj.NAME               = this.name       ;
			obj.PARENT_DATABASE_ID = this.database_id;
			obj.VISIBILITY         = 1               ;  // Lists created will always be marked as Shared. 

			// 01/26/2018 Paul.  If list already exists, then don't create. 
			IList<Spring.Social.Watson.Api.ProspectList> lst = this.watson.ProspectListOperations.GetAll();
			foreach ( Spring.Social.Watson.Api.ProspectList item in lst )
			{
				if ( String.Compare(item.NAME, this.name, true) == 0 )
				{
					obj = this.watson.ProspectListOperations.GetById(item.ID);
					this.RawContent       = obj.RawContent            ;
					this.id               = obj.ID                    ;
					this.lastmodifieddate = obj.LAST_MODIFIED.Value   ;
					return this.id;
				}
			}

			Spring.Social.Watson.Api.ProspectListInsert objNew = this.watson.ProspectListOperations.Insert(database_id, obj);
			obj = this.watson.ProspectListOperations.GetById(objNew.CONTACT_LIST_ID);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.ID                    ;
			this.lastmodifieddate = obj.LAST_MODIFIED.Value   ;
			return this.id;
		}

		public override void Delete()
		{
			this.watson.ProspectListOperations.Delete(this.database_id, this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.Watson.Api.ProspectList obj = this.watson.ProspectListOperations.GetById(sID);
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
			IList<Spring.Social.Watson.Api.HBase> lst = this.watson.ProspectListOperations.GetModified(dtStartModifiedDate);
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
							case "LIST_TYPE"       :  oValue = "Watson"               ;  break;
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
