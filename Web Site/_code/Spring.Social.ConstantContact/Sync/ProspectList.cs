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

namespace Spring.Social.ConstantContact
{
	public class ProspectList : HObject
	{
		public string   status               ;

		public ProspectList(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.ConstantContact.Api.IConstantContact constantContact) : base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, constantContact, "Lists", "Name", "ProspectList", "PROSPECT_LISTS", "NAME", false)
		{
		}

		public override void Reset()
		{
			base.Reset();
			this.status = String.Empty;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			this.id       = sID;
			this.LOCAL_ID = Sql.ToGuid  (row["ID"  ]);
			if ( Sql.IsEmptyString(sID) )
			{
				this.name   = Sql.ToString(row["NAME"  ]);
				this.status = Sql.ToString(row["STATUS"]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.name  , row["NAME"  ], "NAME"  , sbChanges) ) { this.name   = Sql.ToString(row["NAME"  ]);  bChanged = true; }
				if ( Compare(this.status, row["STATUS"], "STATUS", sbChanges) ) { this.status = Sql.ToString(row["STATUS"]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromConstantContact(string sID)
		{
			Spring.Social.ConstantContact.Api.List obj = this.ConstantContact.ListOperations.GetById(sID);
			SetFromConstantContact(obj);
		}

		public override void SetFromConstantContact(Spring.Social.ConstantContact.Api.HBase objBase)
		{
			this.Reset();
			Spring.Social.ConstantContact.Api.List obj = objBase as Spring.Social.ConstantContact.Api.List;
			this.RawContent            = obj.RawContent           ;
			this.id                    = obj.id                   ;
			this.Deleted               = (obj.status == "REMOVED");
			this.name                  = obj.name                 ;
			this.created_date          = obj.created_date.Value   ;
			this.modified_date         = obj.modified_date.Value  ;
			this.status                = obj.status               ;
		}

		public override void Update()
		{
			Spring.Social.ConstantContact.Api.List obj = this.ConstantContact.ListOperations.GetById(this.id);
			obj.name                  = this.name                 ;
			obj.status                = this.status               ;
			obj = this.ConstantContact.ListOperations.Update(obj);
			this.RawContent           = obj.RawContent          ;
			this.id                   = obj.id                  ;
			this.modified_date        = obj.modified_date.Value ;
		}

		// 08/17/2016 Paul.  sDefaultListID is ignored for a list. 
		public override string Insert(string sDefaultListID)
		{
			this.id = String.Empty;
			
			Spring.Social.ConstantContact.Api.List obj = new Spring.Social.ConstantContact.Api.List();
			obj.name                  = this.name                 ;
			obj.status                = this.status               ;

			obj = this.ConstantContact.ListOperations.Insert(obj);
			this.RawContent           = obj.RawContent          ;
			this.id                   = obj.id                  ;
			this.modified_date        = obj.modified_date.Value ;
			return Sql.ToString(this.id);
		}

		public override void Delete()
		{
			this.ConstantContact.ListOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.ConstantContact.Api.List obj = this.ConstantContact.ListOperations.GetById(sID);
			if ( !Sql.IsEmptyString(obj.id) )
			{
				this.SetFromConstantContact(obj.id);
			}
			else
			{
				this.Deleted = true;
			}
		}

		public override IList<Spring.Social.ConstantContact.Api.HBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.ConstantContact.Api.List> lstLists = this.ConstantContact.ListOperations.GetModified(dtStartModifiedDate);
			IList<Spring.Social.ConstantContact.Api.HBase> lst = new List<Spring.Social.ConstantContact.Api.HBase>();
			foreach ( Spring.Social.ConstantContact.Api.List contact in lstLists )
			{
				lst.Add(contact);
			}
			return lst;
		}

		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = this.InitUpdateProcedure(spUpdate, row, gUSER_ID, gTEAM_ID);
			
			foreach(IDbDataParameter par in spUpdate.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
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
							case "NAME"            :  oValue = Sql.ToDBString(this.name);  break;
							case "LIST_TYPE"       :  oValue = "ConstantContact"        ;  break;
							case "MODIFIED_USER_ID":  oValue = gUSER_ID                 ;  break;
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
