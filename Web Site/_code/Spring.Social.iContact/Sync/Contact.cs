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

namespace Spring.Social.iContact
{
	public class Contact : HObject
	{
		#region Properties
		public string    email       ;
		public string    prefix      ;
		public string    firstName   ;
		public string    lastName    ;
		public string    suffix      ;
		public string    street      ;
		public string    street2     ;
		public string    city        ;
		public string    state       ;
		public string    postalCode  ;
		public string    phone       ;
		public string    fax         ;
		public string    business    ;
		public string    status      ;
		public int?      bounceCount ;
		#endregion

		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.iContact.Api.IiContact icontact)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, icontact, "Contacts", "Name", "Contacts", "CONTACTS", "NAME", true)
		{
		}

		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.iContact.Api.IiContact icontact, string siContactTableName, string siContactTableSort, string sCRMModuleName, string sCRMTableName, string sCRMTableSort, bool bCRMAssignedUser)
			 : base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, icontact, siContactTableName, siContactTableSort, sCRMModuleName, sCRMTableName, sCRMTableSort, bCRMAssignedUser)
		{
		}

		public override void Reset()
		{
			base.Reset();
			this.email       = String.Empty;
			this.prefix      = String.Empty;
			this.firstName   = String.Empty;
			this.lastName    = String.Empty;
			this.suffix      = String.Empty;
			this.street      = String.Empty;
			this.street2     = String.Empty;
			this.city        = String.Empty;
			this.state       = String.Empty;
			this.postalCode  = String.Empty;
			this.phone       = String.Empty;
			this.fax         = String.Empty;
			this.business    = String.Empty;
			this.status      = String.Empty;
			this.bounceCount = null;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			
			this.contactId = sID;
			this.LOCAL_ID  = Sql.ToGuid   (row["ID"  ]);
			this.name      = Sql.ToString (row["NAME"]);
			if ( Sql.IsEmptyString(sID) )
			{
				this.email       = Sql.ToString(row["EMAIL1"                    ]);
				this.prefix      = Sql.ToString(row["SALUTATION"                ]);
				this.firstName   = Sql.ToString(row["FIRST_NAME"                ]);
				this.lastName    = Sql.ToString(row["LAST_NAME"                 ]);
				this.street      = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);
				//this.street2     = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);
				this.city        = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);
				this.state       = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);
				this.postalCode  = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);
				this.phone       = Sql.ToString(row["PHONE_WORK"                ]);
				this.fax         = Sql.ToString(row["PHONE_FAX"                 ]);
				this.business    = Sql.ToString(row["ACCOUNT_NAME"              ]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.email       , row["EMAIL1"                    ], "EMAIL1"                    , sbChanges) ) { this.email       = Sql.ToString(row["EMAIL1"                    ]);  bChanged = true; }
				if ( Compare(this.prefix      , row["SALUTATION"                ], "SALUTATION"                , sbChanges) ) { this.prefix      = Sql.ToString(row["SALUTATION"                ]);  bChanged = true; }
				if ( Compare(this.firstName   , row["FIRST_NAME"                ], "FIRST_NAME"                , sbChanges) ) { this.firstName   = Sql.ToString(row["FIRST_NAME"                ]);  bChanged = true; }
				if ( Compare(this.lastName    , row["LAST_NAME"                 ], "LAST_NAME"                 , sbChanges) ) { this.lastName    = Sql.ToString(row["LAST_NAME"                 ]);  bChanged = true; }
				if ( Compare(this.street      , row["PRIMARY_ADDRESS_STREET"    ], "PRIMARY_ADDRESS_STREET"    , sbChanges) ) { this.street      = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);  bChanged = true; }
				//if ( Compare(this.street2     , row["PRIMARY_ADDRESS_STREET"    ], "PRIMARY_ADDRESS_STREET"    , sbChanges) ) { this.street2     = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);  bChanged = true; }
				if ( Compare(this.city        , row["PRIMARY_ADDRESS_CITY"      ], "PRIMARY_ADDRESS_CITY"      , sbChanges) ) { this.city        = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);  bChanged = true; }
				if ( Compare(this.state       , row["PRIMARY_ADDRESS_STATE"     ], "PRIMARY_ADDRESS_STATE"     , sbChanges) ) { this.state       = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);  bChanged = true; }
				if ( Compare(this.postalCode  , row["PRIMARY_ADDRESS_POSTALCODE"], "PRIMARY_ADDRESS_POSTALCODE", sbChanges) ) { this.postalCode  = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);  bChanged = true; }
				if ( Compare(this.phone       , row["PHONE_WORK"                ], "PHONE_WORK"                , sbChanges) ) { this.phone       = Sql.ToString(row["PHONE_WORK"                ]);  bChanged = true; }
				if ( Compare(this.fax         , row["PHONE_FAX"                 ], "PHONE_FAX"                 , sbChanges) ) { this.fax         = Sql.ToString(row["PHONE_FAX"                 ]);  bChanged = true; }
				if ( Compare(this.business    , row["ACCOUNT_NAME"              ], "ACCOUNT_NAME"              , sbChanges) ) { this.business    = Sql.ToString(row["ACCOUNT_NAME"              ]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromiContact(string sID)
		{
			Spring.Social.iContact.Api.Contact obj = this.iContact.ContactOperations.GetById(sID);
			SetFromiContact(obj);
		}

		public void SetFromiContact(Spring.Social.iContact.Api.Contact obj)
		{
			this.Reset();
			this.RawContent  = obj.RawContent ;
			this.contactId   = obj.contactId  ;
			this.name        = (obj.firstName + " " + obj.lastName).Trim();
			this.createDate  = obj.createDate ;
			this.email       = obj.email      ;
			this.prefix      = obj.prefix     ;
			this.firstName   = obj.firstName  ;
			this.lastName    = obj.lastName   ;
			this.street      = obj.street     ;
			this.street2     = obj.street2    ;
			this.city        = obj.city       ;
			this.state       = obj.state      ;
			this.postalCode  = obj.postalCode ;
			this.phone       = obj.phone      ;
			this.fax         = obj.fax        ;
			this.business    = obj.business   ;
			this.status      = obj.status     ;
			this.bounceCount = obj.bounceCount;
		}

		public override void Update()
		{
			Spring.Social.iContact.Api.Contact obj = this.iContact.ContactOperations.GetById(this.contactId);
			obj.contactId  = this.contactId ;
			obj.email      = this.email     ;
			obj.prefix     = this.prefix    ;
			obj.firstName  = this.firstName ;
			obj.lastName   = this.lastName  ;
			obj.street     = this.street    ;
			obj.street2    = this.street2   ;
			obj.city       = this.city      ;
			obj.state      = this.state     ;
			obj.postalCode = this.postalCode;
			obj.phone      = this.phone     ;
			obj.fax        = this.fax       ;
			obj.business   = this.business  ;
			
			this.iContact.ContactOperations.Update(obj);
			this.RawContent = obj.RawContent;
			this.contactId  = obj.contactId ;
		}

		public override string Insert()
		{
			Spring.Social.iContact.Api.Contact obj = new Spring.Social.iContact.Api.Contact();
			obj.email      = this.email     ;
			obj.prefix     = this.prefix    ;
			obj.firstName  = this.firstName ;
			obj.lastName   = this.lastName  ;
			obj.street     = this.street    ;
			obj.street2    = this.street2   ;
			obj.city       = this.city      ;
			obj.state      = this.state     ;
			obj.postalCode = this.postalCode;
			obj.phone      = this.phone     ;
			obj.fax        = this.fax       ;
			obj.business   = this.business  ;

			obj = this.iContact.ContactOperations.Insert(obj);
			this.RawContent = obj.RawContent;
			this.contactId  = obj.contactId ;
			return Sql.ToString(this.contactId);
		}

		public override void Delete()
		{
			this.iContact.ContactOperations.Delete(this.contactId);
		}

		public override void Get(string sID)
		{
			Spring.Social.iContact.Api.Contact obj = this.iContact.ContactOperations.GetById(sID);
			if ( Sql.IsEmptyString(obj.contactId) && obj.status == "deleted" )
			{
				this.Deleted = true;
			}
			else
			{
				this.SetFromiContact(obj);
			}
		}

		// 05/02/2015 Paul.  iContact does not provide a modification date, so we cannot do by-directional sync. 
	}
}
