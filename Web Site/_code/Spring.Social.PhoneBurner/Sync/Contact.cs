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

namespace Spring.Social.PhoneBurner
{
	public class Contact : HObject
	{
		#region Properties
		public int       owner_id                ;
		public String    owner_username          ;
		public String    email                   ;
		public String    first_name              ;
		public String    last_name               ;
		public String    additional_name         ;
		public String    additional_phone        ;
		public String    phone                   ;
		public int       phone_type              ;
		public String    phone_label             ;
		public String    address1                ;
		public String    address2                ;
		public String    city                    ;
		public String    state                   ;
		public String    state_other             ;
		public String    zip                     ;
		public String    country                 ;
		public String    ad_code                 ;
		public String    notes                   ;
		public int       viewed                  ;
		public String    category_id             ;
		public String    tags                    ;
		public String    q_and_a                 ;
		public String    custom_fields           ;
		public String    social_accounts         ;
		public String    token                   ;
		public String    return_lead_token       ;
		public String    lead_id                 ;
		public String    order_number            ;
		public String    lead_vendor_product_name;
		public String    allow_duplicates        ;
		public int       rating                  ;
		#endregion

		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.PhoneBurner.Api.IPhoneBurner phoneBurner)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, phoneBurner, "Contacts", "Name", "Contacts", "CONTACTS", "NAME", true)
		{
		}

		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.PhoneBurner.Api.IPhoneBurner phoneBurner, string siContactTableName, string siContactTableSort, string sCRMModuleName, string sCRMTableName, string sCRMTableSort, bool bCRMAssignedUser)
			 : base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, phoneBurner, siContactTableName, siContactTableSort, sCRMModuleName, sCRMTableName, sCRMTableSort, bCRMAssignedUser)
		{
		}

		public override void Reset()
		{
			base.Reset();
			this.owner_id                 = 0;
			this.owner_username           = String.Empty;
			this.email                    = String.Empty;
			this.first_name               = String.Empty;
			this.last_name                = String.Empty;
			this.additional_name          = String.Empty;
			this.additional_phone         = String.Empty;
			this.phone                    = String.Empty;
			this.phone_type               = 0;
			this.phone_label              = String.Empty;
			this.address1                 = String.Empty;
			this.address2                 = String.Empty;
			this.city                     = String.Empty;
			this.state                    = String.Empty;
			this.state_other              = String.Empty;
			this.zip                      = String.Empty;
			this.country                  = String.Empty;
			this.ad_code                  = String.Empty;
			this.notes                    = String.Empty;
			this.viewed                   = 0;
			this.category_id              = String.Empty;
			this.tags                     = String.Empty;
			this.q_and_a                  = String.Empty;
			this.custom_fields            = String.Empty;
			this.social_accounts          = String.Empty;
			this.token                    = String.Empty;
			this.return_lead_token        = String.Empty;
			this.lead_id                  = String.Empty;
			this.order_number             = String.Empty;
			this.lead_vendor_product_name = String.Empty;
			this.allow_duplicates         = String.Empty;
			this.rating                   = 0;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			this.id       = sID;
			this.LOCAL_ID = Sql.ToGuid  (row["ID"  ]);
			this.lead_id  = Sql.ToString(row["ID"  ]);
			this.name     = Sql.ToString(row["NAME"]);

			string sPHONE      = Sql.ToString(row["PHONE_MOBILE"]);
			int    nPHONE_TYPE = 3;
			if ( Sql.IsEmptyString(sPHONE) )
			{
				sPHONE      = Sql.ToString(row["PHONE_WORK"]);
				nPHONE_TYPE = 2;
			}
			if ( Sql.IsEmptyString(sPHONE) )
			{
				sPHONE      = Sql.ToString(row["PHONE_HOME"]);
				nPHONE_TYPE = 1;
			}
			if ( Sql.IsEmptyString(sID) )
			{
				this.email                    = Sql.ToString(row["EMAIL1"                    ]);
				this.first_name               = Sql.ToString(row["FIRST_NAME"                ]);
				this.last_name                = Sql.ToString(row["LAST_NAME"                 ]);
				this.phone                    = sPHONE;
				this.phone_type               = nPHONE_TYPE;
				this.address1                 = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);
				this.city                     = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);
				this.state                    = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);
				this.zip                      = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);
				this.country                  = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]);
				this.notes                    = Sql.ToString(row["DESCRIPTION"               ]);
				this.lead_id                  = this.LOCAL_ID.ToString();
				this.lead_vendor_product_name = "SplendidCRM";
				this.allow_duplicates         = "1";
				bChanged = true;
			}
			else
			{
				if ( Compare(this.email     , row["EMAIL1"                    ], "EMAIL1"                    , sbChanges) ) { this.email      = Sql.ToString(row["EMAIL1"                    ]);  bChanged = true; }
				if ( Compare(this.first_name, row["FIRST_NAME"                ], "FIRST_NAME"                , sbChanges) ) { this.first_name = Sql.ToString(row["FIRST_NAME"                ]);  bChanged = true; }
				if ( Compare(this.last_name , row["LAST_NAME"                 ], "LAST_NAME"                 , sbChanges) ) { this.last_name  = Sql.ToString(row["LAST_NAME"                 ]);  bChanged = true; }
				if ( Compare(this.phone     ,     sPHONE                       , "PHONE"                     , sbChanges) ) { this.phone      =                  sPHONE                        ;  bChanged = true; }
				if ( Compare(this.phone_type,     nPHONE_TYPE                  , "PHONE_TYPE"                , sbChanges) ) { this.phone_type =                  nPHONE_TYPE                   ;  bChanged = true; }
				if ( Compare(this.address1  , row["PRIMARY_ADDRESS_STREET"    ], "PRIMARY_ADDRESS_STREET"    , sbChanges) ) { this.address1   = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);  bChanged = true; }
				if ( Compare(this.city      , row["PRIMARY_ADDRESS_CITY"      ], "PRIMARY_ADDRESS_CITY"      , sbChanges) ) { this.city       = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);  bChanged = true; }
				if ( Compare(this.state     , row["PRIMARY_ADDRESS_STATE"     ], "PRIMARY_ADDRESS_STATE"     , sbChanges) ) { this.state      = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);  bChanged = true; }
				if ( Compare(this.zip       , row["PRIMARY_ADDRESS_POSTALCODE"], "PRIMARY_ADDRESS_POSTALCODE", sbChanges) ) { this.zip        = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);  bChanged = true; }
				if ( Compare(this.country   , row["PRIMARY_ADDRESS_COUNTRY"   ], "PRIMARY_ADDRESS_COUNTRY"   , sbChanges) ) { this.country    = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]);  bChanged = true; }
				if ( Compare(this.notes     , row["DESCRIPTION"               ], "DESCRIPTION"               , sbChanges) ) { this.notes      = Sql.ToString(row["DESCRIPTION"               ]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromPhoneBurner(string sId)
		{
			Spring.Social.PhoneBurner.Api.Contact obj = this.PhoneBurner.ContactOperations.GetById(sId);
			SetFromPhoneBurner(obj);
		}

		public void SetFromPhoneBurner(Spring.Social.PhoneBurner.Api.Contact obj)
		{
			this.Reset();
			this.RawContent          = obj.RawContent               ;
			this.id                  = obj.id                       ;
			this.lead_id             = obj.lead_id                  ;
			this.category_id         = obj.category_id              ;
			this.createdate          = obj.date_added.Value         ;
			this.date_modified       = obj.date_modified.Value      ;
			this.name                = (obj.first_name + " " + obj.last_name).Trim();
			this.email               = obj.email                    ;
			this.first_name          = obj.first_name               ;
			this.last_name           = obj.last_name                ;
			this.phone               = obj.phone                    ;
			this.phone_type          = obj.phone_type.Value         ;
			this.address1            = obj.address1                 ;
			this.city                = obj.city                     ;
			this.state               = obj.state                    ;
			this.zip                 = obj.zip                      ;
			this.country             = obj.country                  ;
			this.notes               = (obj.notes != null ? obj.notes.notes : String.Empty);
		}

		public override void Update()
		{
			Spring.Social.PhoneBurner.Api.Contact obj = this.PhoneBurner.ContactOperations.GetById(this.id);
			obj.id                    = this.id                 ;
			obj.category_id           = this.category_id        ;
			obj.email                 = this.email              ;
			obj.first_name            = this.first_name         ;
			obj.last_name             = this.last_name          ;
			obj.phone                 = this.phone              ;
			obj.phone_type            = this.phone_type         ;
			obj.address1              = this.address1           ;
			obj.address2              = this.address2           ;
			obj.city                  = this.city               ;
			obj.state                 = this.state              ;
			obj.zip                   = this.zip                ;
			obj.country               = this.country            ;
			
			this.PhoneBurner.ContactOperations.Update(obj);
			obj = this.PhoneBurner.ContactOperations.GetById(this.id);
			this.RawContent       = obj.RawContent              ;
			this.id               = obj.id                      ;
			this.date_modified    = obj.date_modified.Value     ;
		}

		public Spring.Social.PhoneBurner.Api.Contact CreateApiContext()
		{
			Spring.Social.PhoneBurner.Api.Contact obj = new Spring.Social.PhoneBurner.Api.Contact();
			obj.lead_id               = this.lead_id            ;
			obj.category_id           = this.category_id        ;
			obj.email                 = this.email              ;
			obj.first_name            = this.first_name         ;
			obj.last_name             = this.last_name          ;
			obj.phone                 = this.phone              ;
			obj.phone_type            = this.phone_type         ;
			obj.address1              = this.address1           ;
			obj.address2              = this.address2           ;
			obj.city                  = this.city               ;
			obj.state                 = this.state              ;
			obj.zip                   = this.zip                ;
			obj.country               = this.country            ;
			return obj;
		}

		public override string Insert()
		{
			this.id = String.Empty;
			Spring.Social.PhoneBurner.Api.Contact obj = this.CreateApiContext();
			
			obj = this.PhoneBurner.ContactOperations.Insert(obj);
			// 04/28/2015 Paul.  Insert does not return the last modified date. Get the record again. 
			obj = this.PhoneBurner.ContactOperations.GetById(obj.id);
			this.RawContent       = obj.RawContent              ;
			this.id               = obj.id                      ;
			this.date_modified = obj.date_modified.Value;
			return Sql.ToString(this.id);
		}

		public override void Delete()
		{
			this.PhoneBurner.ContactOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.PhoneBurner.Api.Contact obj = this.PhoneBurner.ContactOperations.GetById(sID);
			if ( !Sql.IsEmptyString(obj.id) )
			{
				this.SetFromPhoneBurner(obj);
			}
			else
			{
				this.Deleted = true;
			}
		}

		public override IList<Spring.Social.PhoneBurner.Api.HBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.PhoneBurner.Api.HBase> lst = this.PhoneBurner.ContactOperations.GetModified(dtStartModifiedDate);
			return lst;
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			// 05/19/2015 Paul.  The email is treated as a primary key. 
			Sql.AppendParameter(cmd, Sql.ToString(this.email), "EMAIL1");
		}

		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = this.InitUpdateProcedure(spUpdate, row, gUSER_ID, gTEAM_ID);
			
			Guid gACCOUNT_ID = Guid.Empty;
			
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
							case "ACCOUNT_ID"                 :  oValue = Sql.ToDBGuid   (     gACCOUNT_ID            );  break;
							case "EMAIL1"                     :  oValue = Sql.ToDBString (this.email                  );  break;
							case "FIRST_NAME"                 :  oValue = Sql.ToDBString (this.first_name             );  break;
							case "LAST_NAME"                  :  oValue = Sql.ToDBString (this.last_name              );  break;
							case "DESCRIPTION"                :  oValue = Sql.ToDBString (this.notes                  );  break;
							case "PHONE_MOBILE"               :  oValue = Sql.ToDBString (this.phone                  );  break;
							case "PRIMARY_ADDRESS_STREET"     :  oValue = Sql.ToDBString (this.address1               );  break;
							case "PRIMARY_ADDRESS_CITY"       :  oValue = Sql.ToDBString (this.city                   );  break;
							case "PRIMARY_ADDRESS_STATE"      :  oValue = Sql.ToDBString (this.state                  );  break;
							case "PRIMARY_ADDRESS_POSTALCODE" :  oValue = Sql.ToDBString (this.zip                    );  break;
							case "PRIMARY_ADDRESS_COUNTRY"    :  oValue = Sql.ToDBString (this.country                );  break;
							case "MODIFIED_USER_ID"           :  oValue = gUSER_ID                                    ;  break;
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						// 02/17/2015 Paul.  Modified User ID does not count as a changed field. 
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "FIRST_NAME"                 :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "LAST_NAME"                  :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "DESCRIPTION"                :  bChanged = ParameterChanged(par, oValue, 4000, sbChanges);  break;
									case "EMAIL1"                     :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "ASSISTANT"                  :  bChanged = ParameterChanged(par, oValue,   75, sbChanges);  break;
									case "PHONE_MOBILE"               :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_FAX"                  :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_WORK"                 :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PRIMARY_ADDRESS_STREET"     :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "PRIMARY_ADDRESS_CITY"       :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PRIMARY_ADDRESS_STATE"      :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PRIMARY_ADDRESS_POSTALCODE" :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "PRIMARY_ADDRESS_COUNTRY"    :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									default                           :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
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
