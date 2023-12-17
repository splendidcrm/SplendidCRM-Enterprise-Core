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

namespace Spring.Social.Pardot
{
	public class Contact : HObject
	{
		#region Properties
		public String       salutation          ;
		public String       first_name          ;
		public String       last_name           ;
		public String       email               ;
		public String       password            ;
		public String       company             ;
		public int?         prospect_account_id ;
		public String       website             ;
		public String       job_title           ;
		public String       department          ;
		public String       country             ;
		public String       address_one         ;
		public String       address_two         ;
		public String       city                ;
		public String       state               ;
		public String       territory           ;
		public String       zip                 ;
		public String       phone               ;
		public String       fax                 ;
		public String       source              ;
		public String       annual_revenue      ;
		public String       employees           ;
		public String       industry            ;
		public String       years_in_business   ;
		public String       comments            ;
		public String       notes               ;
		public int?         score               ;
		public String       grade               ;
		public DateTime?    last_activity_at    ;
		public String       recent_interaction  ;
		public String       crm_lead_fid        ;
		public String       crm_contact_fid     ;
		public String       crm_owner_fid       ;
		public String       crm_account_fid     ;
		public DateTime?    crm_last_sync       ;
		public String       crm_url             ;
		public bool?        is_do_not_email     ;
		public bool?        is_do_not_call      ;
		public bool?        opted_out           ;
		public bool?        is_reviewed         ;
		public bool?        is_starred          ;
		public int?         campaign_id         ;
		public string       campaign_name       ;
		#endregion

		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.Pardot.Api.IPardot pardot)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, pardot, "Prospects", "Name", "Contacts", "CONTACTS", "NAME", true)
		{
		}

		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.Pardot.Api.IPardot pardot, string sPardotTableName, string sPardotTableSort, string sCRMModuleName, string sCRMTableName, string sCRMTableSort, bool bCRMAssignedUser)
			 : base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, pardot, sPardotTableName, sPardotTableSort, sCRMModuleName, sCRMTableName, sCRMTableSort, bCRMAssignedUser)
		{
		}

		public override void Reset()
		{
			base.Reset();
			this.salutation          = String.Empty ;
			this.first_name          = String.Empty ;
			this.last_name           = String.Empty ;
			this.email               = String.Empty ;
			this.password            = String.Empty ;
			this.company             = String.Empty ;
			this.prospect_account_id = null         ;
			this.website             = String.Empty ;
			this.job_title           = String.Empty ;
			this.department          = String.Empty ;
			this.country             = String.Empty ;
			this.address_one         = String.Empty ;
			this.address_two         = String.Empty ;
			this.city                = String.Empty ;
			this.state               = String.Empty ;
			this.territory           = String.Empty ;
			this.zip                 = String.Empty ;
			this.phone               = String.Empty ;
			this.fax                 = String.Empty ;
			this.source              = String.Empty ;
			this.annual_revenue      = String.Empty ;
			this.employees           = String.Empty ;
			this.industry            = String.Empty ;
			this.years_in_business   = String.Empty ;
			this.comments            = String.Empty ;
			this.notes               = String.Empty ;
			this.score               = null         ;
			this.grade               = String.Empty ;
			this.last_activity_at    = DateTime.MinValue;
			this.recent_interaction  = String.Empty ;
			this.crm_lead_fid        = String.Empty ;
			this.crm_contact_fid     = String.Empty ;
			this.crm_owner_fid       = String.Empty ;
			this.crm_account_fid     = String.Empty ;
			this.crm_last_sync       = DateTime.MinValue;
			this.crm_url             = String.Empty ;
			this.is_do_not_email     = null         ;
			this.is_do_not_call      = null         ;
			this.opted_out           = null         ;
			this.is_reviewed         = null         ;
			this.is_starred          = null         ;
			this.campaign_id         = null         ;
			this.campaign_name       = String.Empty ;
		}

		private string SplitStreet(object sAddress, int nIndex)
		{
			string[] arr = Sql.ToString(sAddress).Split('\n');
			string sLine = String.Empty;
			if ( arr.Length > nIndex )
				sLine = arr[nIndex];
			return sLine;
		}

		private string CombineStreet(string sStreet1, string sStreet2)
		{
			string sAddress = sStreet1;
			if ( String.IsNullOrEmpty(sStreet2) )
				sAddress = sStreet1 + ControlChars.CrLf + sStreet2;
			return sAddress;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			
			this.id        = sID;
			this.LOCAL_ID  = Sql.ToGuid   (row["ID"  ]);
			this.name      = Sql.ToString (row["NAME"]);
			if ( Sql.IsEmptyString(sID) )
			{
				this.email           = Sql.ToString (row["EMAIL1"                    ]);
				this.salutation      = Sql.ToString (row["SALUTATION"                ]);
				this.first_name      = Sql.ToString (row["FIRST_NAME"                ]);
				this.last_name       = Sql.ToString (row["LAST_NAME"                 ]);
				this.department      = Sql.ToString (row["DEPARTMENT"                ]);
				this.job_title       = Sql.ToString (row["TITLE"                     ]);
				this.address_one     = SplitStreet  (row["PRIMARY_ADDRESS_STREET"    ], 0);
				this.address_two     = SplitStreet  (row["PRIMARY_ADDRESS_STREET"    ], 1);
				this.city            = Sql.ToString (row["PRIMARY_ADDRESS_CITY"      ]);
				this.state           = Sql.ToString (row["PRIMARY_ADDRESS_STATE"     ]);
				this.zip             = Sql.ToString (row["PRIMARY_ADDRESS_POSTALCODE"]);
				this.country         = Sql.ToString (row["PRIMARY_ADDRESS_COUNTRY"   ]);
				this.phone           = Sql.ToString (row["PHONE_WORK"                ]);
				this.fax             = Sql.ToString (row["PHONE_FAX"                 ]);
				this.company         = Sql.ToString (row["ACCOUNT_NAME"              ]);
				this.is_do_not_email = Sql.ToBoolean(row["EMAIL_OPT_OUT"             ]);
				this.is_do_not_call  = Sql.ToBoolean(row["DO_NOT_CALL"               ]);
				this.notes           = Sql.ToString (row["DESCRIPTION"               ]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.email          ,             row["EMAIL1"                    ]    , "EMAIL1"                    , sbChanges) ) { this.email           = Sql.ToString(row["EMAIL1"                    ])   ;  bChanged = true; }
				if ( Compare(this.salutation     ,             row["SALUTATION"                ]    , "SALUTATION"                , sbChanges) ) { this.salutation      = Sql.ToString(row["SALUTATION"                ])   ;  bChanged = true; }
				if ( Compare(this.first_name     ,             row["FIRST_NAME"                ]    , "FIRST_NAME"                , sbChanges) ) { this.first_name      = Sql.ToString(row["FIRST_NAME"                ])   ;  bChanged = true; }
				if ( Compare(this.last_name      ,             row["LAST_NAME"                 ]    , "LAST_NAME"                 , sbChanges) ) { this.last_name       = Sql.ToString(row["LAST_NAME"                 ])   ;  bChanged = true; }
				if ( Compare(this.department     ,             row["DEPARTMENT"                ]    , "DEPARTMENT"                , sbChanges) ) { this.department      = Sql.ToString(row["DEPARTMENT"                ])   ;  bChanged = true; }
				if ( Compare(this.job_title      ,             row["TITLE"                     ]    , "TITLE"                     , sbChanges) ) { this.job_title       = Sql.ToString(row["TITLE"                     ])   ;  bChanged = true; }
				if ( Compare(this.address_one    , SplitStreet(row["PRIMARY_ADDRESS_STREET"    ], 0), "PRIMARY_ADDRESS_STREET"    , sbChanges) ) { this.address_one     = SplitStreet (row["PRIMARY_ADDRESS_STREET"    ], 0);  bChanged = true; }
				if ( Compare(this.address_two    , SplitStreet(row["PRIMARY_ADDRESS_STREET"    ], 1), "PRIMARY_ADDRESS_STREET"    , sbChanges) ) { this.address_two     = SplitStreet (row["PRIMARY_ADDRESS_STREET"    ], 1);  bChanged = true; }
				if ( Compare(this.city           ,             row["PRIMARY_ADDRESS_CITY"      ]    , "PRIMARY_ADDRESS_CITY"      , sbChanges) ) { this.city            = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ])   ;  bChanged = true; }
				if ( Compare(this.state          ,             row["PRIMARY_ADDRESS_STATE"     ]    , "PRIMARY_ADDRESS_STATE"     , sbChanges) ) { this.state           = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ])   ;  bChanged = true; }
				if ( Compare(this.zip            ,             row["PRIMARY_ADDRESS_POSTALCODE"]    , "PRIMARY_ADDRESS_POSTALCODE", sbChanges) ) { this.zip             = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"])   ;  bChanged = true; }
				if ( Compare(this.country        ,             row["PRIMARY_ADDRESS_COUNTRY"   ]    , "PRIMARY_ADDRESS_COUNTRY"   , sbChanges) ) { this.country         = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ])   ;  bChanged = true; }
				if ( Compare(this.phone          ,             row["PHONE_WORK"                ]    , "PHONE_WORK"                , sbChanges) ) { this.phone           = Sql.ToString(row["PHONE_WORK"                ])   ;  bChanged = true; }
				if ( Compare(this.fax            ,             row["PHONE_FAX"                 ]    , "PHONE_FAX"                 , sbChanges) ) { this.fax             = Sql.ToString(row["PHONE_FAX"                 ])   ;  bChanged = true; }
				if ( Compare(this.company        ,             row["ACCOUNT_NAME"              ]    , "ACCOUNT_NAME"              , sbChanges) ) { this.company         = Sql.ToString(row["ACCOUNT_NAME"              ])   ;  bChanged = true; }
				if ( Compare(this.is_do_not_email,             row["EMAIL_OPT_OUT"             ]    , "EMAIL_OPT_OUT"             , sbChanges) ) { this.is_do_not_email = Sql.ToBoolean(row["EMAIL_OPT_OUT"            ])   ;  bChanged = true; }
				if ( Compare(this.is_do_not_call ,             row["DO_NOT_CALL"               ]    , "DO_NOT_CALL"               , sbChanges) ) { this.is_do_not_call  = Sql.ToBoolean(row["DO_NOT_CALL"              ])   ;  bChanged = true; }
				if ( Compare(this.notes          ,             row["DESCRIPTION"               ]    , "DESCRIPTION"               , sbChanges) ) { this.notes           = Sql.ToString (row["DESCRIPTION"              ])   ;  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromPardot(string sID)
		{
			Spring.Social.Pardot.Api.Prospect obj = this.Pardot.ProspectOperations.GetById(Sql.ToInteger(sID));
			SetFromPardot(obj);
		}

		public void SetFromPardot(Spring.Social.Pardot.Api.Prospect obj)
		{
			this.Reset();
			this.RawContent          = obj.RawContent         ;
			this.id                  = obj.id.ToString()      ;
			this.name                = (obj.first_name + " " + obj.last_name).Trim();
			this.createDate          = obj.created_at.HasValue ? obj.created_at.Value : DateTime.MinValue;
			this.modifiedDate        = obj.updated_at.HasValue ? obj.updated_at.Value : DateTime.MinValue;
			this.salutation          = obj.salutation         ;
			this.first_name          = obj.first_name         ;
			this.last_name           = obj.last_name          ;
			this.email               = obj.email              ;
			this.password            = obj.password           ;
			this.company             = obj.company            ;
			this.prospect_account_id = obj.prospect_account_id;
			this.website             = obj.website            ;
			this.job_title           = obj.job_title          ;
			this.department          = obj.department         ;
			this.country             = obj.country            ;
			this.address_one         = obj.address_one        ;
			this.address_two         = obj.address_two        ;
			this.city                = obj.city               ;
			this.state               = obj.state              ;
			this.territory           = obj.territory          ;
			this.zip                 = obj.zip                ;
			this.phone               = obj.phone              ;
			this.fax                 = obj.fax                ;
			this.source              = obj.source             ;
			this.annual_revenue      = obj.annual_revenue     ;
			this.employees           = obj.employees          ;
			this.industry            = obj.industry           ;
			this.years_in_business   = obj.years_in_business  ;
			this.comments            = obj.comments           ;
			this.notes               = obj.notes              ;
			this.score               = obj.score              ;
			this.grade               = obj.grade              ;
			this.last_activity_at    = obj.last_activity_at   ;
			this.recent_interaction  = obj.recent_interaction ;
			this.crm_lead_fid        = obj.crm_lead_fid       ;
			this.crm_contact_fid     = obj.crm_contact_fid    ;
			this.crm_owner_fid       = obj.crm_owner_fid      ;
			this.crm_account_fid     = obj.crm_account_fid    ;
			this.crm_last_sync       = obj.crm_last_sync      ;
			this.crm_url             = obj.crm_url            ;
			this.is_do_not_email     = obj.is_do_not_email    ;
			this.is_do_not_call      = obj.is_do_not_call     ;
			this.opted_out           = obj.opted_out          ;
			this.is_reviewed         = obj.is_reviewed        ;
			this.is_starred          = obj.is_starred         ;
			this.campaign_id         = obj.campaign_id        ;
			this.campaign_name       = obj.campaign_name      ;
		}

		public override void Update()
		{
			Spring.Social.Pardot.Api.Prospect obj = this.Pardot.ProspectOperations.GetById(Sql.ToInteger(this.id));
			obj.id          = Sql.ToInteger(this.id);
			obj.email       = this.email      ;
			obj.salutation  = this.salutation ;
			obj.first_name  = this.first_name ;
			obj.last_name   = this.last_name  ;
			obj.department  = this.department ;
			obj.job_title   = this.job_title  ;
			obj.address_one = this.address_one;
			obj.address_two = this.address_two;
			obj.city        = this.city       ;
			obj.state       = this.state      ;
			obj.zip         = this.zip        ;
			obj.phone       = this.phone      ;
			obj.fax         = this.fax        ;
			obj.company     = this.company    ;
			
			this.Pardot.ProspectOperations.Update(obj);
			this.RawContent = obj.RawContent;
			this.id         = obj.id.ToString();
		}

		public override string Insert()
		{
			Spring.Social.Pardot.Api.Prospect obj = new Spring.Social.Pardot.Api.Prospect();
			obj.email       = this.email      ;
			obj.salutation  = this.salutation ;
			obj.first_name  = this.first_name ;
			obj.last_name   = this.last_name  ;
			obj.department  = this.department ;
			obj.job_title   = this.job_title  ;
			obj.address_one = this.address_one;
			obj.address_two = this.address_two;
			obj.city        = this.city       ;
			obj.state       = this.state      ;
			obj.zip         = this.zip        ;
			obj.phone       = this.phone      ;
			obj.fax         = this.fax        ;
			obj.company     = this.company    ;

			obj = this.Pardot.ProspectOperations.Insert(obj);
			this.RawContent = obj.RawContent;
			this.id         = obj.id.ToString();
			return Sql.ToString(this.id);
		}

		public override void Delete()
		{
			this.Pardot.ProspectOperations.Delete(Sql.ToInteger(this.id));
		}

		public override void Get(string sID)
		{
			Spring.Social.Pardot.Api.Prospect obj = this.Pardot.ProspectOperations.GetById(Sql.ToInteger(sID));
			if ( Sql.IsEmptyString(obj.id) )
			{
				this.Deleted = true;
			}
			else
			{
				this.SetFromPardot(obj);
			}
		}

		public override IList<Spring.Social.Pardot.Api.Prospect> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.Pardot.Api.Prospect> lstProspects = this.Pardot.ProspectOperations.GetModified(dtStartModifiedDate);
			IList<Spring.Social.Pardot.Api.Prospect> lst = new List<Spring.Social.Pardot.Api.Prospect>();
			foreach ( Spring.Social.Pardot.Api.Prospect prospect in lstProspects )
			{
				lst.Add(prospect);
			}
			return lst;
		}

		public override IList<Spring.Social.Pardot.Api.Prospect> SelectDeleted(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.Pardot.Api.Prospect> lstProspects = this.Pardot.ProspectOperations.GetDeleted(dtStartModifiedDate);
			IList<Spring.Social.Pardot.Api.Prospect> lst = new List<Spring.Social.Pardot.Api.Prospect>();
			foreach ( Spring.Social.Pardot.Api.Prospect prospect in lstProspects )
			{
				lst.Add(prospect);
			}
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
							case "SALUTATION"                 :  oValue = Sql.ToDBString (this.salutation           );  break;
							case "FIRST_NAME"                 :  oValue = Sql.ToDBString (this.first_name           );  break;
							case "LAST_NAME"                  :  oValue = Sql.ToDBString (this.last_name            );  break;
							case "DEPARTMENT"                 :  oValue = Sql.ToDBString (this.department           );  break;
							case "TITLE"                      :  oValue = Sql.ToDBString (this.job_title            );  break;
							case "ACCOUNT_NAME"               :  oValue = Sql.ToDBString (this.company              );  break;
							case "PHONE_WORK"                 :  oValue = Sql.ToDBString (this.phone                );  break;
							case "PHONE_FAX"                  :  oValue = Sql.ToDBString (this.fax                  );  break;
							case "EMAIL1"                     :  oValue = Sql.ToDBString (this.email                );  break;
							case "PRIMARY_ADDRESS_STREET"     :  oValue = Sql.ToDBString (CombineStreet(this.address_one, this.address_two));  break;
							case "PRIMARY_ADDRESS_CITY"       :  oValue = Sql.ToDBString (this.city                 );  break;
							case "PRIMARY_ADDRESS_STATE"      :  oValue = Sql.ToDBString (this.state                );  break;
							case "PRIMARY_ADDRESS_POSTALCODE" :  oValue = Sql.ToDBString (this.zip                  );  break;
							case "PRIMARY_ADDRESS_COUNTRY"    :  oValue = Sql.ToDBString (this.country              );  break;
							case "DESCRIPTION"                :  oValue = Sql.ToDBString (this.notes                );  break;
							case "EMAIL_OPT_OUT"              :  oValue = Sql.ToDBBoolean(this.is_do_not_email      );  break;
							case "DO_NOT_CALL"                :  oValue = Sql.ToDBBoolean(this.is_do_not_call       );  break;
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
									case "DEPARTMENT"                 :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
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

/*
		public override bool UpdateRelationships(Guid gID, string sREMOTE_KEY, IDbTransaction trn, Guid gUSER_ID)
		{
			bool bChanged = false;
			String sSQL = String.Empty;
			string sExistingRelationships = String.Empty;
			sSQL = "select SYNC_LIST_IDS                     " + ControlChars.CrLf
			     + "  from vw" + this.CRMTableName + "_Pardot" + ControlChars.CrLf
			     + " where ID = @ID                          " + ControlChars.CrLf;
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
			//if ( !Sql.IsEmptyString(this.list_ids) )
			//	lstLists = new List<string>(this.list_ids.Split(','));
			foreach ( string sLIST_REMOTE_KEY in lstLists )
			{
				Guid   gPROSPECT_LIST_ID         = Guid.Empty;
				Guid   gPROSPECT_LIST_RELATED_ID = Guid.Empty;
				sSQL = "select ID                                    " + ControlChars.CrLf
				     + "  from vwPROSPECT_LISTS_SYNC                 " + ControlChars.CrLf
				     + " where SYNC_REMOTE_KEY   = @SYNC_REMOTE_KEY  " + ControlChars.CrLf
				     + "   and SYNC_SERVICE_NAME = N'Pardot'         " + ControlChars.CrLf
				     + "   and LIST_TYPE         = N'Pardot'         " + ControlChars.CrLf;
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
					     + "   and SYNC_SERVICE_NAME = N'Pardot'         " + ControlChars.CrLf
					     + "   and LIST_TYPE         = N'Pardot'         " + ControlChars.CrLf;
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
*/
	}
}
