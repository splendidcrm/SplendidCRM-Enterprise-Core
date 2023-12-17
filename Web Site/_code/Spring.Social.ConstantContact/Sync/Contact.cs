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
	public class Contact : HObject
	{
		#region Properties
		public string   prefix_name          ;
		public string   first_name           ;
		public string   last_name            ;
		public string   job_title            ;
		public string   company_name         ;
		public string   work_phone           ;
		public string   fax                  ;
		public string   cell_phone           ;
		public string   home_phone           ;
		public string   email1               ;
		public string   email2               ;
		public string   business_address     ;
		public string   business_city        ;
		public string   business_state       ;
		public string   business_postal_code ;
		public string   business_country_code;
		public string   personal_address     ;
		public string   personal_city        ;
		public string   personal_state       ;
		public string   personal_postal_code ;
		public string   personal_country_code;
		public string   notes                ;
		public string   status               ;
		public string   source               ;
		public string   source_details       ;
		// 08/17/2016 Paul.  Manage the lists as comma-separated string. 
		public string   list_ids             ;
		#endregion

		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.ConstantContact.Api.IConstantContact constantContact)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, constantContact, "Contacts", "Name", "Contacts", "CONTACTS", "NAME", true)
		{
		}

		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.ConstantContact.Api.IConstantContact constantContact, string siContactTableName, string siContactTableSort, string sCRMModuleName, string sCRMTableName, string sCRMTableSort, bool bCRMAssignedUser)
			 : base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, constantContact, siContactTableName, siContactTableSort, sCRMModuleName, sCRMTableName, sCRMTableSort, bCRMAssignedUser)
		{
		}

		public override void Reset()
		{
			base.Reset();
			this.prefix_name           = String.Empty;
			this.first_name            = String.Empty;
			this.last_name             = String.Empty;
			this.job_title             = String.Empty;
			this.company_name          = String.Empty;
			this.work_phone            = String.Empty;
			this.fax                   = String.Empty;
			this.cell_phone            = String.Empty;
			this.home_phone            = String.Empty;
			this.email1                = String.Empty;
			this.email2                = String.Empty;
			this.business_address      = String.Empty;
			this.business_city         = String.Empty;
			this.business_state        = String.Empty;
			this.business_postal_code  = String.Empty;
			this.business_country_code = String.Empty;
			this.personal_address      = String.Empty;
			this.personal_city         = String.Empty;
			this.personal_state        = String.Empty;
			this.personal_postal_code  = String.Empty;
			this.personal_country_code = String.Empty;
			this.notes                 = String.Empty;
			this.status                = String.Empty;
			this.source                = String.Empty;
			this.source_details        = String.Empty;
			// 08/17/2016 Paul.  Manage the lists as comma-separated string. 
			this.list_ids              = String.Empty;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			this.id       = sID;
			this.LOCAL_ID = Sql.ToGuid  (row["ID"  ]);
			this.name     = Sql.ToString(row["NAME"]);
			if ( Sql.IsEmptyString(sID) )
			{
				this.prefix_name           = Sql.ToString(row["SALUTATION"                ]);
				this.first_name            = Sql.ToString(row["FIRST_NAME"                ]);
				this.last_name             = Sql.ToString(row["LAST_NAME"                 ]);
				this.job_title             = Sql.ToString(row["TITLE"                     ]);
				this.company_name          = Sql.ToString(row["ACCOUNT_NAME"              ]);
				this.work_phone            = Sql.ToString(row["PHONE_WORK"                ]);
				this.fax                   = Sql.ToString(row["PHONE_FAX"                 ]);
				this.cell_phone            = Sql.ToString(row["PHONE_MOBILE"              ]);
				this.home_phone            = Sql.ToString(row["PHONE_HOME"                ]);
				this.email1                = Sql.ToString(row["EMAIL1"                    ]);
				this.email2                = Sql.ToString(row["EMAIL2"                    ]);
				this.business_address      = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);
				this.business_city         = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);
				this.business_state        = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);
				this.business_postal_code  = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);
				this.business_country_code = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]);
				this.personal_address      = Sql.ToString(row["ALT_ADDRESS_STREET"        ]);
				this.personal_city         = Sql.ToString(row["ALT_ADDRESS_CITY"          ]);
				this.personal_state        = Sql.ToString(row["ALT_ADDRESS_STATE"         ]);
				this.personal_postal_code  = Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]);
				this.personal_country_code = Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]);
				this.notes                 = Sql.ToString(row["DESCRIPTION"               ]);
				// 08/17/2016 Paul.  Manage the lists as comma-separated string. 
				this.list_ids              = Sql.ToString(row["SYNC_LIST_IDS"             ]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.prefix_name          , row["SALUTATION"                ], "SALUTATION"                , sbChanges) ) { this.prefix_name           = Sql.ToString(row["SALUTATION"                ]);  bChanged = true; }
				if ( Compare(this.first_name           , row["FIRST_NAME"                ], "FIRST_NAME"                , sbChanges) ) { this.first_name            = Sql.ToString(row["FIRST_NAME"                ]);  bChanged = true; }
				if ( Compare(this.last_name            , row["LAST_NAME"                 ], "LAST_NAME"                 , sbChanges) ) { this.last_name             = Sql.ToString(row["LAST_NAME"                 ]);  bChanged = true; }
				if ( Compare(this.job_title            , row["TITLE"                     ], "TITLE"                     , sbChanges) ) { this.job_title             = Sql.ToString(row["TITLE"                     ]);  bChanged = true; }
				if ( Compare(this.company_name         , row["ACCOUNT_NAME"              ], "ACCOUNT_NAME"              , sbChanges) ) { this.company_name          = Sql.ToString(row["ACCOUNT_NAME"              ]);  bChanged = true; }
				if ( Compare(this.work_phone           , row["PHONE_WORK"                ], "PHONE_WORK"                , sbChanges) ) { this.work_phone            = Sql.ToString(row["PHONE_WORK"                ]);  bChanged = true; }
				if ( Compare(this.fax                  , row["PHONE_FAX"                 ], "PHONE_FAX"                 , sbChanges) ) { this.fax                   = Sql.ToString(row["PHONE_FAX"                 ]);  bChanged = true; }
				if ( Compare(this.cell_phone           , row["PHONE_MOBILE"              ], "PHONE_MOBILE"              , sbChanges) ) { this.cell_phone            = Sql.ToString(row["PHONE_MOBILE"              ]);  bChanged = true; }
				if ( Compare(this.home_phone           , row["PHONE_HOME"                ], "PHONE_HOME"                , sbChanges) ) { this.home_phone            = Sql.ToString(row["PHONE_HOME"                ]);  bChanged = true; }
				if ( Compare(this.email1               , row["EMAIL1"                    ], "EMAIL1"                    , sbChanges) ) { this.email1                = Sql.ToString(row["EMAIL1"                    ]);  bChanged = true; }
				if ( Compare(this.email2               , row["EMAIL2"                    ], "EMAIL2"                    , sbChanges) ) { this.email2                = Sql.ToString(row["EMAIL2"                    ]);  bChanged = true; }
				if ( Compare(this.business_address     , row["PRIMARY_ADDRESS_STREET"    ], "PRIMARY_ADDRESS_STREET"    , sbChanges) ) { this.business_address      = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);  bChanged = true; }
				if ( Compare(this.business_city        , row["PRIMARY_ADDRESS_CITY"      ], "PRIMARY_ADDRESS_CITY"      , sbChanges) ) { this.business_city         = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);  bChanged = true; }
				if ( Compare(this.business_state       , row["PRIMARY_ADDRESS_STATE"     ], "PRIMARY_ADDRESS_STATE"     , sbChanges) ) { this.business_state        = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);  bChanged = true; }
				if ( Compare(this.business_postal_code , row["PRIMARY_ADDRESS_POSTALCODE"], "PRIMARY_ADDRESS_POSTALCODE", sbChanges) ) { this.business_postal_code  = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);  bChanged = true; }
				if ( Compare(this.business_country_code, row["PRIMARY_ADDRESS_COUNTRY"   ], "PRIMARY_ADDRESS_COUNTRY"   , sbChanges) ) { this.business_country_code = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]);  bChanged = true; }
				if ( Compare(this.personal_address     , row["ALT_ADDRESS_STREET"        ], "ALT_ADDRESS_STREET"        , sbChanges) ) { this.personal_address      = Sql.ToString(row["ALT_ADDRESS_STREET"        ]);  bChanged = true; }
				if ( Compare(this.personal_city        , row["ALT_ADDRESS_CITY"          ], "ALT_ADDRESS_CITY"          , sbChanges) ) { this.personal_city         = Sql.ToString(row["ALT_ADDRESS_CITY"          ]);  bChanged = true; }
				if ( Compare(this.personal_state       , row["ALT_ADDRESS_STATE"         ], "ALT_ADDRESS_STATE"         , sbChanges) ) { this.personal_state        = Sql.ToString(row["ALT_ADDRESS_STATE"         ]);  bChanged = true; }
				if ( Compare(this.personal_postal_code , row["ALT_ADDRESS_POSTALCODE"    ], "ALT_ADDRESS_POSTALCODE"    , sbChanges) ) { this.personal_postal_code  = Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]);  bChanged = true; }
				if ( Compare(this.personal_country_code, row["ALT_ADDRESS_COUNTRY"       ], "ALT_ADDRESS_COUNTRY"       , sbChanges) ) { this.personal_country_code = Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]);  bChanged = true; }
				if ( Compare(this.notes                , row["DESCRIPTION"               ], "DESCRIPTION"               , sbChanges) ) { this.notes                 = Sql.ToString(row["DESCRIPTION"               ]);  bChanged = true; }
				// 08/17/2016 Paul.  Manage the lists as comma-separated string. 
				if ( Compare(this.list_ids             , row["SYNC_LIST_IDS"             ], "SYNC_LIST_IDS"             , sbChanges) ) { this.list_ids              = Sql.ToString(row["SYNC_LIST_IDS"             ]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromConstantContact(string sID)
		{
			Spring.Social.ConstantContact.Api.Contact obj = this.ConstantContact.ContactOperations.GetById(sID);
			SetFromConstantContact(obj);
		}

		public override void SetFromConstantContact(Spring.Social.ConstantContact.Api.HBase objBase)
		{
			this.Reset();
			Spring.Social.ConstantContact.Api.Contact obj = objBase as Spring.Social.ConstantContact.Api.Contact;
			this.RawContent            = obj.RawContent           ;
			this.id                    = obj.id                   ;
			this.Deleted               = (obj.status == "REMOVED") ;
			this.name                  = (obj.first_name + " " + obj.last_name).Trim();
			this.created_date          = obj.created_date.Value   ;
			this.modified_date         = obj.modified_date.Value  ;
			this.prefix_name           = obj.prefix_name          ;
			this.first_name            = obj.first_name           ;
			this.last_name             = obj.last_name            ;
			this.job_title             = obj.job_title            ;
			this.company_name          = obj.company_name         ;
			this.work_phone            = obj.work_phone           ;
			this.fax                   = obj.fax                  ;
			this.cell_phone            = obj.cell_phone           ;
			this.home_phone            = obj.home_phone           ;
			this.email1                = obj.Email1               ;
			//this.email2                = obj.Email2               ;
			obj.GetAddress("BUSINESS", ref this.business_address, ref this.business_city, ref this.business_state, ref this.business_postal_code, ref this.business_country_code);
			obj.GetAddress("PERSONAL", ref this.personal_address, ref this.personal_city, ref this.personal_state, ref this.personal_postal_code, ref this.personal_country_code);
			this.notes                 = obj.Notes                ;
			this.status                = obj.status               ;
			this.source                = obj.source               ; 
			this.source_details        = obj.source_details       ;
			// 08/17/2016 Paul.  Manage the lists as comma-separated string. 
			this.list_ids              = obj.Lists                ;
		}

		public override void Update()
		{
			Spring.Social.ConstantContact.Api.Contact obj = this.ConstantContact.ContactOperations.GetById(this.id);
			obj.prefix_name           = this.prefix_name          ;
			obj.first_name            = this.first_name           ;
			obj.last_name             = this.last_name            ;
			obj.job_title             = this.job_title            ;
			obj.company_name          = this.company_name         ;
			obj.work_phone            = this.work_phone           ;
			obj.fax                   = this.fax                  ;
			obj.cell_phone            = this.cell_phone           ;
			obj.home_phone            = this.home_phone           ;
			obj.Email1                = this.email1               ;
			// 05/04/2015 Paul.  The API will only allow for 1 email. 
			//obj.Email2                = this.email2               ;
			obj.SetAddress("BUSINESS", this.business_address, this.business_city, this.business_state, this.business_postal_code, this.business_country_code);
			obj.SetAddress("PERSONAL", this.personal_address, this.personal_city, this.personal_state, this.personal_postal_code, this.personal_country_code);
			obj.Notes                 = this.notes                ;
			//obj.status                = this.status               ;
			obj.source                = this.source               ; 
			obj.source_details        = this.source_details       ;
			// 08/17/2016 Paul.  Manage the lists as comma-separated string. 
			obj.Lists                 = this.list_ids             ;
			
			obj = this.ConstantContact.ContactOperations.Update(obj);
			this.RawContent           = obj.RawContent          ;
			this.id                   = obj.id                  ;
			this.modified_date        = obj.modified_date.Value ;
		}

		// 05/04/2015 Paul.  A contact can only be inserted with a list ID. 
		public override string Insert(string sDefaultListID)
		{
			this.id = String.Empty;
			
			Spring.Social.ConstantContact.Api.Contact obj = new Spring.Social.ConstantContact.Api.Contact();
			obj.prefix_name           = this.prefix_name          ;
			obj.first_name            = this.first_name           ;
			obj.last_name             = this.last_name            ;
			obj.job_title             = this.job_title            ;
			obj.company_name          = this.company_name         ;
			obj.work_phone            = this.work_phone           ;
			obj.fax                   = this.fax                  ;
			obj.cell_phone            = this.cell_phone           ;
			obj.home_phone            = this.home_phone           ;
			obj.Email1                = this.email1               ;
			// 05/04/2015 Paul.  The API will only allow for 1 email. 
			//obj.Email2                = this.email2               ;
			obj.SetAddress("BUSINESS", this.business_address, this.business_city, this.business_state, this.business_postal_code, this.business_country_code);
			obj.SetAddress("PERSONAL", this.personal_address, this.personal_city, this.personal_state, this.personal_postal_code, this.personal_country_code);
			obj.Notes                 = this.notes                ;
			//obj.status                = this.status               ;
			obj.source                = this.source               ; 
			obj.source_details        = this.source_details       ;
			// 08/17/2016 Paul.  Manage the lists as comma-separated string. 
			if ( Sql.IsEmptyString(this.list_ids) )
				this.list_ids = sDefaultListID;
			obj.Lists                 = this.list_ids             ;

			obj = this.ConstantContact.ContactOperations.Insert(obj);
			this.RawContent           = obj.RawContent          ;
			this.id                   = obj.id                  ;
			this.modified_date        = obj.modified_date.Value ;
			// 05/04/2015 Paul.  Creating a contact without a list will make it unviewable in the ConstantContact UI. 
			//try
			//{
			//	// 05/04/2015 Paul.  After creating a new contact with a default list, clear the list. 
			//	obj.lists = null;
			//	obj = this.ConstantContact.ContactOperations.Update(obj);
			//	if ( obj.status == "REMOVED" )
			//	{
			//		obj.status = "ACTIVE";
			//		obj = this.ConstantContact.ContactOperations.Update(obj);
			//	}
			//}
			//catch(Exception ex)
			//{
			//	// 05/04/2015 Paul.  We are not getting an error, but lets capture any future error. 
			//	Debug.WriteLine(ex.Message);
			//}
			return Sql.ToString(this.id);
		}

		public override void Delete()
		{
			this.ConstantContact.ContactOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.ConstantContact.Api.Contact obj = this.ConstantContact.ContactOperations.GetById(sID);
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
			IList<Spring.Social.ConstantContact.Api.Contact> lstContacts = this.ConstantContact.ContactOperations.GetModified(dtStartModifiedDate);
			IList<Spring.Social.ConstantContact.Api.HBase> lst = new List<Spring.Social.ConstantContact.Api.HBase>();
			foreach ( Spring.Social.ConstantContact.Api.Contact contact in lstContacts )
			{
				lst.Add(contact);
			}
			return lst;
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			// 05/19/2015 Paul.  The email is treated as a primary key. 
			Sql.AppendParameter(cmd, Sql.ToString(this.email1), "EMAIL1");
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
							case "SALUTATION"                 :  oValue = Sql.ToDBString (this.prefix_name          );  break;
							case "FIRST_NAME"                 :  oValue = Sql.ToDBString (this.first_name           );  break;
							case "LAST_NAME"                  :  oValue = Sql.ToDBString (this.last_name            );  break;
							case "TITLE"                      :  oValue = Sql.ToDBString (this.job_title            );  break;
							case "ACCOUNT_NAME"               :  oValue = Sql.ToDBString (this.company_name         );  break;
							case "PHONE_WORK"                 :  oValue = Sql.ToDBString (this.work_phone           );  break;
							case "PHONE_FAX"                  :  oValue = Sql.ToDBString (this.fax                  );  break;
							case "PHONE_MOBILE"               :  oValue = Sql.ToDBString (this.cell_phone           );  break;
							case "PHONE_HOME"                 :  oValue = Sql.ToDBString (this.home_phone           );  break;
							case "EMAIL1"                     :  oValue = Sql.ToDBString (this.email1               );  break;
							case "EMAIL2"                     :  oValue = Sql.ToDBString (this.email2               );  break;
							case "PRIMARY_ADDRESS_STREET"     :  oValue = Sql.ToDBString (this.business_address     );  break;
							case "PRIMARY_ADDRESS_CITY"       :  oValue = Sql.ToDBString (this.business_city        );  break;
							case "PRIMARY_ADDRESS_STATE"      :  oValue = Sql.ToDBString (this.business_state       );  break;
							case "PRIMARY_ADDRESS_POSTALCODE" :  oValue = Sql.ToDBString (this.business_postal_code );  break;
							case "PRIMARY_ADDRESS_COUNTRY"    :  oValue = Sql.ToDBString (this.business_country_code);  break;
							case "ALT_ADDRESS_STREET"         :  oValue = Sql.ToDBString (this.personal_address     );  break;
							case "ALT_ADDRESS_CITY"           :  oValue = Sql.ToDBString (this.personal_city        );  break;
							case "ALT_ADDRESS_STATE"          :  oValue = Sql.ToDBString (this.personal_state       );  break;
							case "ALT_ADDRESS_POSTALCODE"     :  oValue = Sql.ToDBString (this.personal_postal_code );  break;
							case "ALT_ADDRESS_COUNTRY"        :  oValue = Sql.ToDBString (this.personal_country_code);  break;
							case "DESCRIPTION"                :  oValue = Sql.ToDBString (this.notes                );  break;
							case "MODIFIED_USER_ID"           :  oValue = gUSER_ID                                   ;  break;
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						// 02/17/2015 Paul.  Modified User ID does not count as a changed field. 
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "SALUTATION"                 :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "FIRST_NAME"                 :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "LAST_NAME"                  :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "TITLE"                      :  bChanged = ParameterChanged(par, oValue,   50, sbChanges);  break;
									case "ACCOUNT_NAME"               :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "PHONE_WORK"                 :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_FAX"                  :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_MOBILE"               :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_HOME"                 :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "EMAIL1"                     :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "EMAIL2"                     :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PRIMARY_ADDRESS_STREET"     :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "PRIMARY_ADDRESS_CITY"       :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PRIMARY_ADDRESS_STATE"      :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PRIMARY_ADDRESS_POSTALCODE" :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "PRIMARY_ADDRESS_COUNTRY"    :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "ALT_ADDRESS_STREET"         :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "ALT_ADDRESS_CITY"           :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "ALT_ADDRESS_STATE"          :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "ALT_ADDRESS_POSTALCODE"     :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "ALT_ADDRESS_COUNTRY"        :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "DESCRIPTION"                :  bChanged = ParameterChanged(par, oValue, 4000, sbChanges);  break;
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

		public override bool UpdateRelationships(Guid gID, string sREMOTE_KEY, IDbTransaction trn, Guid gUSER_ID)
		{
			bool bChanged = false;
			String sSQL = String.Empty;
			string sExistingRelationships = String.Empty;
			sSQL = "select SYNC_LIST_IDS                              " + ControlChars.CrLf
			     + "  from vw" + this.CRMTableName + "_ConstantContact" + ControlChars.CrLf
			     + " where ID = @ID                                   " + ControlChars.CrLf;
			using ( IDbCommand cmd = trn.Connection.CreateCommand() )
			{
				cmd.Transaction = trn;
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@ID", gID);
				sExistingRelationships = Sql.ToString(cmd.ExecuteScalar());
			}
			List<string> lstExistingRelationships = new List<string>();
			if ( !Sql.IsEmptyString(sExistingRelationships) )
				lstExistingRelationships = new List<string>(sExistingRelationships.Split(','));
			
			List<string> lstLists = new List<string>();
			if ( !Sql.IsEmptyString(this.list_ids) )
				lstLists = new List<string>(this.list_ids.Split(','));
			foreach ( string sLIST_REMOTE_KEY in lstLists )
			{
				Guid   gPROSPECT_LIST_ID         = Guid.Empty;
				Guid   gPROSPECT_LIST_RELATED_ID = Guid.Empty;
				sSQL = "select ID                                    " + ControlChars.CrLf
				     + "  from vwPROSPECT_LISTS_SYNC                 " + ControlChars.CrLf
				     + " where SYNC_REMOTE_KEY   = @SYNC_REMOTE_KEY  " + ControlChars.CrLf
				     + "   and SYNC_SERVICE_NAME = N'ConstantContact'" + ControlChars.CrLf
				     + "   and LIST_TYPE         = N'ConstantContact'" + ControlChars.CrLf;
				using ( IDbCommand cmd = trn.Connection.CreateCommand() )
				{
					cmd.Transaction = trn;
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY", sLIST_REMOTE_KEY);
					gPROSPECT_LIST_ID = Sql.ToGuid(cmd.ExecuteScalar());
				}
				sSQL = "select ID                                    " + ControlChars.CrLf
				     + "  from vwPROSPECT_LISTS_RELATED              " + ControlChars.CrLf
				     + " where PROSPECT_LIST_ID   = @PROSPECT_LIST_ID" + ControlChars.CrLf
				     + "   and RELATED_ID         = @RELATED_ID      " + ControlChars.CrLf
				     + "   and RELATED_TYPE       = @RELATED_TYPE    " + ControlChars.CrLf;
				using ( IDbCommand cmd = trn.Connection.CreateCommand() )
				{
					cmd.Transaction = trn;
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@PROSPECT_LIST_ID", gPROSPECT_LIST_ID );
					Sql.AddParameter(cmd, "@RELATED_ID"      , gID               );
					Sql.AddParameter(cmd, "@RELATED_TYPE"    , this.CRMModuleName);
					gPROSPECT_LIST_RELATED_ID = Sql.ToGuid(cmd.ExecuteScalar());
				}
				if ( Sql.IsEmptyGuid(gPROSPECT_LIST_RELATED_ID) )
				{
					IDbCommand spPROSPECT_LISTS_RELATED_Update = SqlProcs.Factory(trn.Connection, "spPROSPECT_LISTS_RELATED_Update");
					spPROSPECT_LISTS_RELATED_Update.Transaction = trn;
					Sql.SetParameter(spPROSPECT_LISTS_RELATED_Update, "@ID"              , Guid.Empty       );
					Sql.SetParameter(spPROSPECT_LISTS_RELATED_Update, "@MODIFIED_USER_ID", gUSER_ID         );
					Sql.SetParameter(spPROSPECT_LISTS_RELATED_Update, "@PROSPECT_LIST_ID", gPROSPECT_LIST_ID);
					Sql.SetParameter(spPROSPECT_LISTS_RELATED_Update, "@RELATED_ID"      , gID              );
					Sql.SetParameter(spPROSPECT_LISTS_RELATED_Update, "@RELATED_TYPE"    ,this.CRMModuleName);
					spPROSPECT_LISTS_RELATED_Update.ExecuteNonQuery();
					bChanged = true;
				}
			}
			foreach ( string sLIST_REMOTE_KEY in lstExistingRelationships )
			{
				if ( !lstLists.Contains(sLIST_REMOTE_KEY) )
				{
					Guid   gPROSPECT_LIST_ID         = Guid.Empty;
					Guid   gPROSPECT_LIST_RELATED_ID = Guid.Empty;
					sSQL = "select ID                                    " + ControlChars.CrLf
					     + "  from vwPROSPECT_LISTS_SYNC                 " + ControlChars.CrLf
					     + " where SYNC_REMOTE_KEY   = @SYNC_REMOTE_KEY  " + ControlChars.CrLf
					     + "   and SYNC_SERVICE_NAME = N'ConstantContact'" + ControlChars.CrLf
					     + "   and LIST_TYPE         = N'ConstantContact'" + ControlChars.CrLf;
					using ( IDbCommand cmd = trn.Connection.CreateCommand() )
					{
						cmd.Transaction = trn;
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY", sLIST_REMOTE_KEY);
						gPROSPECT_LIST_ID = Sql.ToGuid(cmd.ExecuteScalar());
					}
					if ( !Sql.IsEmptyGuid(gPROSPECT_LIST_ID) )
					{
						sSQL = "select ID                                    " + ControlChars.CrLf
						     + "  from vwPROSPECT_LISTS_RELATED              " + ControlChars.CrLf
						     + " where PROSPECT_LIST_ID   = @PROSPECT_LIST_ID" + ControlChars.CrLf
						     + "   and RELATED_ID         = @RELATED_ID      " + ControlChars.CrLf
						     + "   and RELATED_TYPE       = @RELATED_TYPE    " + ControlChars.CrLf;
						using ( IDbCommand cmd = trn.Connection.CreateCommand() )
						{
							cmd.Transaction = trn;
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@PROSPECT_LIST_ID", gPROSPECT_LIST_ID );
							Sql.AddParameter(cmd, "@RELATED_ID"      , gID               );
							Sql.AddParameter(cmd, "@RELATED_TYPE"    , this.CRMModuleName);
							gPROSPECT_LIST_RELATED_ID = Sql.ToGuid(cmd.ExecuteScalar());
						}
						if ( !Sql.IsEmptyGuid(gPROSPECT_LIST_RELATED_ID) )
						{
							IDbCommand spPROSPECT_LISTS_RELATED_Delete = SqlProcs.Factory(trn.Connection, "spPROSPECT_LISTS_RELATED_Delete");
							spPROSPECT_LISTS_RELATED_Delete.Transaction = trn;
							Sql.SetParameter(spPROSPECT_LISTS_RELATED_Delete, "@ID"              , gPROSPECT_LIST_RELATED_ID);
							Sql.SetParameter(spPROSPECT_LISTS_RELATED_Delete, "@MODIFIED_USER_ID", gUSER_ID                 );
							spPROSPECT_LISTS_RELATED_Delete.ExecuteNonQuery();
							bChanged = true;
						}
					}
				}
			}
			return bChanged;
		}

	}
}
