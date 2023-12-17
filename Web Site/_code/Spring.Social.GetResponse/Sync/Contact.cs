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

namespace Spring.Social.GetResponse
{
	public class Contact : HObject
	{
		#region Properties
		public string   email       ;
		public string   note        ;
		public string   origin      ;
		public string   campaignId  ;
		public string   campaignName;
		public string   ipAddress   ;
		public string   timeZone    ;
		public string   dayOfCycle  ;
		#endregion

		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.GetResponse.Api.IGetResponse getResponse)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, getResponse, "Contacts", "Name", "Contacts", "CONTACTS", "NAME", true)
		{
		}

		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.GetResponse.Api.IGetResponse getResponse, string siContactTableName, string siContactTableSort, string sCRMModuleName, string sCRMTableName, string sCRMTableSort, bool bCRMAssignedUser)
			 : base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, getResponse, siContactTableName, siContactTableSort, sCRMModuleName, sCRMTableName, sCRMTableSort, bCRMAssignedUser)
		{
		}

		public override void Reset()
		{
			base.Reset();
			this.email        = String.Empty;
			this.note         = String.Empty;
			this.origin       = String.Empty;
			this.campaignId   = String.Empty;
			this.campaignName = String.Empty;
			this.ipAddress    = String.Empty;
			this.timeZone     = String.Empty;
			this.dayOfCycle   = String.Empty;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			this.id       = sID;
			this.LOCAL_ID = Sql.ToGuid  (row["ID"]);
			if ( Sql.IsEmptyString(sID) )
			{
				this.name       = Sql.ToString(row["NAME"       ]);
				this.email      = Sql.ToString(row["EMAIL1"     ]);
				this.note       = Sql.ToString(row["DESCRIPTION"]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.name , row["NAME"       ], "NAME"       , sbChanges) ) { this.name  = Sql.ToString(row["NAME"       ]);  bChanged = true; }
				if ( Compare(this.email, row["EMAIL1"     ], "EMAIL1"     , sbChanges) ) { this.email = Sql.ToString(row["EMAIL1"     ]);  bChanged = true; }
				if ( Compare(this.note , row["DESCRIPTION"], "DESCRIPTION", sbChanges) ) { this.note  = Sql.ToString(row["DESCRIPTION"]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromGetResponse(string sID)
		{
			Spring.Social.GetResponse.Api.Contact obj = this.GetResponse.ContactOperations.GetById(sID);
			SetFromGetResponse(obj);
		}

		public override void SetFromGetResponse(Spring.Social.GetResponse.Api.Contact obj)
		{
			this.Reset();
			this.RawContent       = obj.RawContent      ;
			this.id               = obj.id              ;
			this.createdOn        = obj.createdOn.Value ;
			this.changedOn        = obj.changedOn.Value ;
			this.name             = obj.name            ;
			this.email            = obj.email           ;
			this.note             = obj.note            ;
			this.origin           = obj.origin          ;
			this.campaignId       = obj.campaignId      ;
			this.campaignName     = obj.campaignName    ;
			this.ipAddress        = obj.ipAddress       ;
			this.timeZone         = obj.timeZone        ;
		}

		public override void Update()
		{
			Spring.Social.GetResponse.Api.Contact obj = this.GetResponse.ContactOperations.GetById(this.id);
			obj.name       = this.name      ;
			obj.email      = this.email     ;
			obj.note       = this.note      ;
			obj.campaignId = this.campaignId;
			
			obj = this.GetResponse.ContactOperations.Update(obj);
			this.RawContent = obj.RawContent      ;
			this.id         = obj.id              ;
			this.changedOn = obj.changedOn.Value;
		}

		// 05/04/2015 Paul.  A contact can only be inserted with a list ID. 
		public override string Insert(string sDefaultCampaignID)
		{
			this.id = String.Empty;
			
			Spring.Social.GetResponse.Api.Contact obj = new Spring.Social.GetResponse.Api.Contact();
			obj.name       = this.name         ;
			obj.email      = this.email        ;
			obj.note       = this.note         ;
			obj.campaignId = sDefaultCampaignID;

			obj = this.GetResponse.ContactOperations.Insert(obj);
			this.RawContent = obj.RawContent      ;
			this.id         = obj.id              ;
			this.changedOn = obj.changedOn.Value;
			return this.id;
		}

		public override void Delete()
		{
			this.GetResponse.ContactOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.GetResponse.Api.Contact obj = this.GetResponse.ContactOperations.GetById(sID);
			if ( !Sql.IsEmptyString(obj.id) )
			{
				this.SetFromGetResponse(obj.id);
			}
			else
			{
				this.Deleted = true;
			}
		}
	}
}
