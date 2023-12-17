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

namespace Spring.Social.SalesFusion
{
	public class User : SFObject
	{
		#region Properties
		public String     user_name                     { get; set; }  // 50
		public String     portal_password               { get; set; }  // 20
		public String     salutation                    { get; set; }  // 50
		public String     first_name                    { get; set; }  // 50
		public String     last_name                     { get; set; }  // 50
		public String     job_title                     { get; set; }  // 100
		public String     email                         { get; set; }  // 100
		public String     phone                         { get; set; }  // 50
		public String     phone_extension               { get; set; }  // 10
		public String     mobile                        { get; set; }  // 20
		public String     address1                      { get; set; }  // 50
		public String     address2                      { get; set; }  // 50
		public String     city                          { get; set; }  // 50
		public String     state                         { get; set; }  // 100
		public String     zip                           { get; set; }  // 16
		public String     country                       { get; set; }  // 50
		public String     face_book                     { get; set; }  // 100
		public String     linked_in                     { get; set; }  // 200
		public String     company_website               { get; set; }  // 150
		public String     twitter                       { get; set; }  // 200
		public String     profile_picture               { get; set; }  // 200
		#endregion

		public User(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, SalesFusionSync SalesFusionSync, Spring.Social.SalesFusion.Api.ISalesFusion salesFusion, DataTable dtUSERS)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, SalesFusionSync, salesFusion, "Accounts", "Name", "Accounts", "ACCOUNTS", "NAME", true, dtUSERS)
		{
		}

		public override void Reset()
		{
			base.Reset();
			this.user_name       = String.Empty;
			this.salutation      = String.Empty;
			this.first_name      = String.Empty;
			this.last_name       = String.Empty;
			this.job_title       = String.Empty;
			this.email           = String.Empty;
			this.phone           = String.Empty;
			this.phone_extension = String.Empty;
			this.mobile          = String.Empty;
			this.address1        = String.Empty;
			this.address2        = String.Empty;
			this.city            = String.Empty;
			this.state           = String.Empty;
			this.zip             = String.Empty;
			this.country         = String.Empty;
			this.face_book       = String.Empty;
			this.linked_in       = String.Empty;
			this.company_website = String.Empty;
			this.twitter         = String.Empty;
			this.profile_picture = String.Empty;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			this.id = Sql.ToInteger(sID);
			this.LOCAL_ID = Sql.ToGuid(row["ID"]);
			this.name = Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]);
			if ( Sql.IsEmptyString(sID) )
			{
				this.user_name       = Sql.ToString(row["USER_NAME"         ]);
				this.first_name      = Sql.ToString(row["FIRST_NAME"        ]);
				this.last_name       = Sql.ToString(row["LAST_NAME"         ]);
				this.job_title       = Sql.ToString(row["TITLE"             ]);
				this.email           = Sql.ToString(row["EMAIL1"            ]);
				this.phone           = Sql.ToString(row["PHONE_WORK"        ]);
				this.mobile          = Sql.ToString(row["PHONE_MOBILE"      ]);
				this.address1        = Sql.ToString(row["ADDRESS_STREET"    ]);
				this.city            = Sql.ToString(row["ADDRESS_CITY"      ]);
				this.state           = Sql.ToString(row["ADDRESS_STATE"     ]);
				this.zip             = Sql.ToString(row["ADDRESS_POSTALCODE"]);
				this.country         = Sql.ToString(row["ADDRESS_COUNTRY"   ]);
				this.face_book       = Sql.ToString(row["FACEBOOK_ID"       ]);
				bChanged = true;
			}
			else
			{
				// 11/21/2016 Paul.  The max length should be the min between two systems. 
				if ( Compare(MaxLength(this.user_name    ,  50), MaxLength(Sql.ToString  (row["USER_NAME"         ]),  50), "USER_NAME"         , sbChanges) ) { this.user_name     = Sql.ToString  (row["USER_NAME"         ]);  bChanged = true; }
				if ( Compare(MaxLength(this.first_name   ,  30), MaxLength(Sql.ToString  (row["FIRST_NAME"        ]),  30), "FIRST_NAME"        , sbChanges) ) { this.first_name    = Sql.ToString  (row["FIRST_NAME"        ]);  bChanged = true; }
				if ( Compare(MaxLength(this.last_name    ,  30), MaxLength(Sql.ToString  (row["LAST_NAME"         ]),  30), "LAST_NAME"         , sbChanges) ) { this.last_name     = Sql.ToString  (row["LAST_NAME"         ]);  bChanged = true; }
				if ( Compare(MaxLength(this.job_title    ,  50), MaxLength(Sql.ToString  (row["TITLE"             ]),  50), "TITLE"             , sbChanges) ) { this.job_title     = Sql.ToString  (row["TITLE"             ]);  bChanged = true; }
				if ( Compare(MaxLength(this.email        , 100), MaxLength(Sql.ToString  (row["EMAIL1"            ]), 100), "EMAIL1"            , sbChanges) ) { this.email         = Sql.ToString  (row["EMAIL1"            ]);  bChanged = true; }
				if ( Compare(MaxLength(this.phone        ,  50), MaxLength(Sql.ToString  (row["PHONE_WORK"        ]),  50), "PHONE_WORK"        , sbChanges) ) { this.phone         = Sql.ToString  (row["PHONE_WORK"        ]);  bChanged = true; }
				if ( Compare(MaxLength(this.mobile       ,  50), MaxLength(Sql.ToString  (row["PHONE_MOBILE"      ]),  50), "PHONE_MOBILE"      , sbChanges) ) { this.mobile        = Sql.ToString  (row["PHONE_MOBILE"      ]);  bChanged = true; }
				if ( Compare(MaxLength(this.address1     ,  50), MaxLength(Sql.ToString  (row["ADDRESS_STREET"    ]),  50), "ADDRESS_STREET"    , sbChanges) ) { this.address1      = Sql.ToString  (row["ADDRESS_STREET"    ]);  bChanged = true; }
				if ( Compare(MaxLength(this.city         ,  50), MaxLength(Sql.ToString  (row["ADDRESS_CITY"      ]),  50), "ADDRESS_CITY"      , sbChanges) ) { this.city          = Sql.ToString  (row["ADDRESS_CITY"      ]);  bChanged = true; }
				if ( Compare(MaxLength(this.state        , 100), MaxLength(Sql.ToString  (row["ADDRESS_STATE"     ]), 100), "ADDRESS_STATE"     , sbChanges) ) { this.state         = Sql.ToString  (row["ADDRESS_STATE"     ]);  bChanged = true; }
				if ( Compare(MaxLength(this.zip          ,   9), MaxLength(Sql.ToString  (row["ADDRESS_POSTALCODE"]),   9), "ADDRESS_POSTALCODE", sbChanges) ) { this.zip           = Sql.ToString  (row["ADDRESS_POSTALCODE"]);  bChanged = true; }
				if ( Compare(MaxLength(this.country      ,  25), MaxLength(Sql.ToString  (row["ADDRESS_COUNTRY"   ]),  25), "ADDRESS_COUNTRY"   , sbChanges) ) { this.country       = Sql.ToString  (row["ADDRESS_COUNTRY"   ]);  bChanged = true; }
				if ( Compare(MaxLength(this.face_book    , 100), MaxLength(Sql.ToString  (row["FACEBOOK_ID"       ]), 100), "FACEBOOK_ID"       , sbChanges) ) { this.face_book     = Sql.ToString  (row["FACEBOOK_ID"       ]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromSalesFusion(int nId)
		{
			Spring.Social.SalesFusion.Api.User obj = this.SalesFusion.UserOperations.GetById(nId);
			SetFromSalesFusion(obj);
		}

		public void SetFromSalesFusion(Spring.Social.SalesFusion.Api.User obj)
		{
			this.Reset();
			this.RawContent        = obj.RawContent            ;
			this.id                = obj.id.Value              ;
			this.owner_id          = obj.owner_id.Value        ;
			this.created_date      = obj.created_date.Value    ;
			this.updated_date      = obj.updated_date.Value    ;

			this.user_name         = obj.user_name ;
			this.first_name        = obj.first_name;
			this.last_name         = obj.last_name ;
			this.job_title         = obj.job_title ;
			this.email             = obj.email     ;
			this.phone             = obj.phone     ;
			this.mobile            = obj.mobile    ;
			this.address1          = obj.address1  ;
			this.city              = obj.city      ;
			this.state             = obj.state     ;
			this.zip               = obj.zip       ;
			this.country           = obj.country   ;
			this.face_book         = obj.face_book ;
		}

		public override void Update()
		{
			Spring.Social.SalesFusion.Api.User obj = this.SalesFusion.UserOperations.GetById(this.id);
			obj.id                    = this.id                ;
			obj.crm_id                = this.LOCAL_ID.ToString();
			
			obj.user_name             = MaxLength(this.user_name ,  50);
			obj.first_name            = MaxLength(this.first_name,  30);
			obj.last_name             = MaxLength(this.last_name ,  30);
			obj.job_title             = MaxLength(this.job_title ,  50);
			obj.email                 = MaxLength(this.email     , 100);
			obj.phone                 = MaxLength(this.phone     ,  50);
			obj.mobile                = MaxLength(this.mobile    ,  50);
			obj.address1              = MaxLength(this.address1  ,  50);
			obj.city                  = MaxLength(this.city      ,  50);
			obj.state                 = MaxLength(this.state     , 100);
			obj.zip                   = MaxLength(this.zip       ,   9);
			obj.country               = MaxLength(this.country   ,  25);
			obj.face_book             = MaxLength(this.face_book , 100);
			
			this.SalesFusion.UserOperations.Update(obj);
			obj = this.SalesFusion.UserOperations.GetById(this.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id.Value              ;
			this.updated_date     = obj.updated_date.Value    ;
		}

		public override string Insert()
		{
			this.id = 0;
			
			Spring.Social.SalesFusion.Api.User obj = new Spring.Social.SalesFusion.Api.User();
			obj.crm_id                = this.LOCAL_ID.ToString();
			
			obj.user_name             = MaxLength(this.user_name ,  50);
			obj.first_name            = MaxLength(this.first_name,  30);
			obj.last_name             = MaxLength(this.last_name ,  30);
			obj.job_title             = MaxLength(this.job_title ,  50);
			obj.email                 = MaxLength(this.email     , 100);
			obj.phone                 = MaxLength(this.phone     ,  50);
			obj.mobile                = MaxLength(this.mobile    ,  50);
			obj.address1              = MaxLength(this.address1  ,  50);
			obj.city                  = MaxLength(this.city      ,  50);
			obj.state                 = MaxLength(this.state     , 100);
			obj.zip                   = MaxLength(this.zip       ,   9);
			obj.country               = MaxLength(this.country   ,  25);
			obj.face_book             = MaxLength(this.face_book , 100);
			
			obj = this.SalesFusion.UserOperations.Insert(obj);
			obj = this.SalesFusion.UserOperations.GetById(obj.id.Value);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id.Value              ;
			this.updated_date     = obj.updated_date.Value    ;
			return this.id.ToString();
		}

		public override void Delete()
		{
			this.SalesFusion.UserOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.SalesFusion.Api.User obj = this.SalesFusion.UserOperations.GetById(Sql.ToInteger(sID));
			if ( obj.id.HasValue )
			{
				this.SetFromSalesFusion(obj.id.Value);
			}
			else
			{
				this.Deleted = true;
			}
		}

		public override IList<Spring.Social.SalesFusion.Api.HBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.SalesFusion.Api.HBase> lst = this.SalesFusion.AccountOperations.GetModified(dtStartModifiedDate);
			return lst;
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			Sql.AppendParameter(cmd, Sql.ToString(this.user_name), "USER_NAME");
		}

		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = this.InitUpdateProcedure(spUpdate, row, gUSER_ID, gTEAM_ID);
			
			Guid gOWNER_USER_ID = Guid.Empty;
			if ( this.owner_id > 0 )
			{
				vwUSERS.RowFilter = "SYNC_REMOTE_KEY = '" + this.owner_id.ToString() + "'";
				if ( vwUSERS.Count > 0 )
					gOWNER_USER_ID = Sql.ToGuid(vwUSERS[0]["SYNC_LOCAL_ID"]);
			}
			
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
						object oValue = null;
						switch ( sColumnName )
						{
							case "USER_NAME"         :  oValue = Sql.ToDBString  (this.user_name      );  break;
							case "FIRST_NAME"        :  oValue = Sql.ToDBString  (this.first_name     );  break;
							case "LAST_NAME"         :  oValue = Sql.ToDBString  (this.last_name      );  break;
							case "TITLE"             :  oValue = Sql.ToDBString  (this.job_title      );  break;
							case "EMAIL1"            :  oValue = Sql.ToDBString  (this.email          );  break;
							case "PHONE_WORK"        :  oValue = Sql.ToDBString  (this.phone          );  break;
							case "PHONE_MOBILE"      :  oValue = Sql.ToDBString  (this.mobile         );  break;
							case "ADDRESS_STREET"    :  oValue = Sql.ToDBString  (this.address1       );  break;
							case "ADDRESS_CITY"      :  oValue = Sql.ToDBString  (this.city           );  break;
							case "ADDRESS_STATE"     :  oValue = Sql.ToDBString  (this.state          );  break;
							case "ADDRESS_POSTALCODE":  oValue = Sql.ToDBString  (this.zip            );  break;
							case "ADDRESS_COUNTRY"   :  oValue = Sql.ToDBString  (this.country        );  break;
							case "FACEBOOK_ID"       :  oValue = Sql.ToDBString  (this.face_book      );  break;
							case "MODIFIED_USER_ID"  :  oValue = Sql.ToDBGuid    (     gUSER_ID       );  break;
						}
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "USER_NAME"         :  bChanged = ParameterChanged(par, oValue,   60, sbChanges);  break;
									case "FIRST_NAME"        :  bChanged = ParameterChanged(par, oValue,   30, sbChanges);  break;
									case "LAST_NAME"         :  bChanged = ParameterChanged(par, oValue,   30, sbChanges);  break;
									case "TITLE"             :  bChanged = ParameterChanged(par, oValue,   50, sbChanges);  break;
									case "EMAIL1"            :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PHONE_WORK"        :  bChanged = ParameterChanged(par, oValue,   50, sbChanges);  break;
									case "PHONE_MOBILE"      :  bChanged = ParameterChanged(par, oValue,   50, sbChanges);  break;
									case "ADDRESS_STREET"    :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "ADDRESS_CITY"      :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "ADDRESS_STATE"     :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "ADDRESS_POSTALCODE":  bChanged = ParameterChanged(par, oValue,    9, sbChanges);  break;
									case "ADDRESS_COUNTRY"   :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "FACEBOOK_ID"       :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									default                  :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
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
