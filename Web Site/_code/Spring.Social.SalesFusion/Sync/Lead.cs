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
	public class Lead : SFObject
	{
		#region Properties
		public string    salutation         ;  // 10
		public string    first_name         ;  // 40
		public string    last_name          ;  // 40
		public string    phone              ;  // 40
		public string    mobile             ;  // 40
		public string    fax                ;  // 40
		public string    home_phone         ;  // 40
		public string    other_phone        ;  // 40
		public string    email              ;  // 250
		public string    billing_street     ;  // 80
		public string    billing_city       ;  // 40
		public string    billing_state      ;  // 20
		public string    billing_zip        ;  // 20
		public string    billing_country    ;  // 40
		public string    mailing_street     ;  // 80
		public string    mailing_city       ;  // 40
		public string    mailing_state      ;  // 20
		public string    mailing_zip        ;  // 20
		public string    mailing_country    ;  // 40
		public string    title              ;  // 80
		public string    department         ;  // 80
		public string    assistant_name     ;  // 40
		public string    assistant_phone    ;  // 40
		public string    description        ;  // 450
		public string    account_name       ;  // 250
		public int       account_id         ;
		public bool      opt_out            ;  // EMAIL_OPT_OUT
		public bool      do_not_call        ;
		public string    source             ;  // 250
		public string    status             ;  // 40
		public string    website            ;  // 255
		public DateTime  birth_date         ;
		#endregion

		protected DataView vwACCOUNTS;

		public Lead(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, SalesFusionSync SalesFusionSync, Spring.Social.SalesFusion.Api.ISalesFusion salesFusion, DataTable dtUSERS, DataTable dtACCOUNTS) 
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, SalesFusionSync, salesFusion, "Contacts", "Name", "Leads", "LEADS", "NAME", true, dtUSERS)
		{
			if ( dtACCOUNTS != null )
				this.vwACCOUNTS = new DataView(dtACCOUNTS);
		}

		public override void Reset()
		{
			base.Reset();
			this.salutation          = String.Empty;
			this.first_name          = String.Empty;
			this.last_name           = String.Empty;
			this.phone               = String.Empty;
			this.mobile              = String.Empty;
			this.fax                 = String.Empty;
			this.home_phone          = String.Empty;
			this.other_phone         = String.Empty;
			this.email               = String.Empty;
			this.billing_street      = String.Empty;
			this.billing_city        = String.Empty;
			this.billing_state       = String.Empty;
			this.billing_zip         = String.Empty;
			this.billing_country     = String.Empty;
			this.mailing_street      = String.Empty;
			this.mailing_city        = String.Empty;
			this.mailing_state       = String.Empty;
			this.mailing_zip         = String.Empty;
			this.mailing_country     = String.Empty;
			this.title               = String.Empty;
			this.department          = String.Empty;
			this.assistant_name      = String.Empty;
			this.assistant_phone     = String.Empty;
			this.description         = String.Empty;
			this.account_name        = String.Empty;
			this.account_id          = 0;
			this.opt_out             = false;
			this.do_not_call         = false;
			this.source              = String.Empty;
			//this.status              = String.Empty;
			//this.website             = String.Empty;
			this.birth_date          = DateTime.MinValue;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			if ( this.vwACCOUNTS != null )
			{
				this.vwACCOUNTS.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["ACCOUNT_ID"]) + "'";
				if ( this.vwACCOUNTS.Count > 0 )
					this.account_id = Sql.ToInteger(this.vwACCOUNTS[0]["SYNC_REMOTE_KEY"]);
			}
			
			int nOwnerID = this.GetUserID();
			if ( !Sql.IsEmptyGuid(row["ASSIGNED_USER_ID"]) )
			{
				vwUSERS.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["ASSIGNED_USER_ID"]) + "'";
				if ( vwUSERS.Count > 0 )
					nOwnerID = Sql.ToInteger(vwUSERS[0]["SYNC_REMOTE_KEY"]);
			}
			
			this.id       = Sql.ToInteger(sID);
			this.LOCAL_ID = Sql.ToGuid  (row["ID"  ]);
			this.name     = Sql.ToString(row["NAME"]);
			if ( Sql.IsEmptyString(sID) )
			{
				this.owner_id           = nOwnerID;
				this.salutation         = Sql.ToString  (row["SALUTATION"                 ]);
				this.first_name         = Sql.ToString  (row["FIRST_NAME"                 ]);
				this.last_name          = Sql.ToString  (row["LAST_NAME"                  ]);
				this.phone              = Sql.ToString  (row["PHONE_WORK"                 ]);
				this.mobile             = Sql.ToString  (row["PHONE_MOBILE"               ]);
				this.fax                = Sql.ToString  (row["PHONE_FAX"                  ]);
				this.home_phone         = Sql.ToString  (row["PHONE_HOME"                 ]);
				this.other_phone        = Sql.ToString  (row["PHONE_OTHER"                ]);
				this.email              = Sql.ToString  (row["EMAIL1"                     ]);
				this.billing_street     = Sql.ToString  (row["PRIMARY_ADDRESS_STREET"     ]);
				this.billing_city       = Sql.ToString  (row["PRIMARY_ADDRESS_CITY"       ]);
				this.billing_state      = Sql.ToString  (row["PRIMARY_ADDRESS_STATE"      ]);
				this.billing_zip        = Sql.ToString  (row["PRIMARY_ADDRESS_POSTALCODE" ]);
				this.billing_country    = Sql.ToString  (row["PRIMARY_ADDRESS_COUNTRY"    ]);
				this.mailing_street     = Sql.ToString  (row["ALT_ADDRESS_STREET"         ]);
				this.mailing_city       = Sql.ToString  (row["ALT_ADDRESS_CITY"           ]);
				this.mailing_state      = Sql.ToString  (row["ALT_ADDRESS_STATE"          ]);
				this.mailing_zip        = Sql.ToString  (row["ALT_ADDRESS_POSTALCODE"     ]);
				this.mailing_country    = Sql.ToString  (row["ALT_ADDRESS_COUNTRY"        ]);
				this.title              = Sql.ToString  (row["TITLE"                      ]);
				this.department         = Sql.ToString  (row["DEPARTMENT"                 ]);
				this.description        = Sql.ToString  (row["DESCRIPTION"                ]);
				this.assistant_name     = Sql.ToString  (row["ASSISTANT"                  ]);
				this.assistant_phone    = Sql.ToString  (row["ASSISTANT_PHONE"            ]);
				this.account_name       = Sql.ToString  (row["ACCOUNT_NAME"               ]);
				this.opt_out            = Sql.ToBoolean (row["EMAIL_OPT_OUT"              ]);
				this.do_not_call        = Sql.ToBoolean (row["DO_NOT_CALL"                ]);
				this.source             = Sql.ToString  (row["LEAD_SOURCE"                ]);
				this.status             = Sql.ToString  (row["STATUS"                     ]);
				this.website            = Sql.ToString  (row["WEBSITE"                    ]);
				this.birth_date         = Sql.ToDateTime(row["BIRTHDATE"                  ]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.owner_id          , nOwnerID                          , "ASSIGNED_USER_ID"           , sbChanges) ) { this.owner_id           = nOwnerID                                         ;  bChanged = true; }
				// 11/21/2016 Paul.  The max length should be the min between two systems. 
				if ( Compare(MaxLength(this.salutation        ,  10), MaxLength(Sql.ToString(row["SALUTATION"                 ]),  10), "SALUTATION"                 , sbChanges) ) { this.salutation         = Sql.ToString  (row["SALUTATION"                 ]);  bChanged = true; }
				if ( Compare(MaxLength(this.first_name        ,  40), MaxLength(Sql.ToString(row["FIRST_NAME"                 ]),  40), "FIRST_NAME"                 , sbChanges) ) { this.first_name         = Sql.ToString  (row["FIRST_NAME"                 ]);  bChanged = true; }
				if ( Compare(MaxLength(this.last_name         ,  40), MaxLength(Sql.ToString(row["LAST_NAME"                  ]),  40), "LAST_NAME"                  , sbChanges) ) { this.last_name          = Sql.ToString  (row["LAST_NAME"                  ]);  bChanged = true; }
				if ( Compare(MaxLength(this.phone             ,  25), MaxLength(Sql.ToString(row["PHONE_WORK"                 ]),  25), "PHONE_WORK"                 , sbChanges) ) { this.phone              = Sql.ToString  (row["PHONE_WORK"                 ]);  bChanged = true; }
				if ( Compare(MaxLength(this.mobile            ,  25), MaxLength(Sql.ToString(row["PHONE_MOBILE"               ]),  25), "PHONE_MOBILE"               , sbChanges) ) { this.mobile             = Sql.ToString  (row["PHONE_MOBILE"               ]);  bChanged = true; }
				if ( Compare(MaxLength(this.fax               ,  25), MaxLength(Sql.ToString(row["PHONE_FAX"                  ]),  25), "PHONE_FAX"                  , sbChanges) ) { this.fax                = Sql.ToString  (row["PHONE_FAX"                  ]);  bChanged = true; }
				if ( Compare(MaxLength(this.home_phone        ,  25), MaxLength(Sql.ToString(row["PHONE_HOME"                 ]),  25), "PHONE_HOME"                 , sbChanges) ) { this.home_phone         = Sql.ToString  (row["PHONE_HOME"                 ]);  bChanged = true; }
				if ( Compare(MaxLength(this.other_phone       ,  25), MaxLength(Sql.ToString(row["PHONE_OTHER"                ]),  25), "PHONE_OTHER"                , sbChanges) ) { this.other_phone        = Sql.ToString  (row["PHONE_OTHER"                ]);  bChanged = true; }
				if ( Compare(MaxLength(this.email             , 100), MaxLength(Sql.ToString(row["EMAIL1"                     ]), 100), "EMAIL1"                     , sbChanges) ) { this.email              = Sql.ToString  (row["EMAIL1"                     ]);  bChanged = true; }
				if ( Compare(MaxLength(this.billing_street    ,  80), MaxLength(Sql.ToString(row["PRIMARY_ADDRESS_STREET"     ]),  80), "PRIMARY_ADDRESS_STREET"     , sbChanges) ) { this.billing_street     = Sql.ToString  (row["PRIMARY_ADDRESS_STREET"     ]);  bChanged = true; }
				if ( Compare(MaxLength(this.billing_city      ,  40), MaxLength(Sql.ToString(row["PRIMARY_ADDRESS_CITY"       ]),  40), "PRIMARY_ADDRESS_CITY"       , sbChanges) ) { this.billing_city       = Sql.ToString  (row["PRIMARY_ADDRESS_CITY"       ]);  bChanged = true; }
				if ( Compare(MaxLength(this.billing_state     ,  20), MaxLength(Sql.ToString(row["PRIMARY_ADDRESS_STATE"      ]),  20), "PRIMARY_ADDRESS_STATE"      , sbChanges) ) { this.billing_state      = Sql.ToString  (row["PRIMARY_ADDRESS_STATE"      ]);  bChanged = true; }
				if ( Compare(MaxLength(this.billing_zip       ,  20), MaxLength(Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE" ]),  20), "PRIMARY_ADDRESS_POSTALCODE" , sbChanges) ) { this.billing_zip        = Sql.ToString  (row["PRIMARY_ADDRESS_POSTALCODE" ]);  bChanged = true; }
				if ( Compare(MaxLength(this.billing_country   ,  40), MaxLength(Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"    ]),  40), "PRIMARY_ADDRESS_COUNTRY"    , sbChanges) ) { this.billing_country    = Sql.ToString  (row["PRIMARY_ADDRESS_COUNTRY"    ]);  bChanged = true; }
				if ( Compare(MaxLength(this.mailing_street    ,  80), MaxLength(Sql.ToString(row["ALT_ADDRESS_STREET"         ]),  80), "ALT_ADDRESS_STREET"         , sbChanges) ) { this.mailing_street     = Sql.ToString  (row["ALT_ADDRESS_STREET"         ]);  bChanged = true; }
				if ( Compare(MaxLength(this.mailing_city      ,  40), MaxLength(Sql.ToString(row["ALT_ADDRESS_CITY"           ]),  40), "ALT_ADDRESS_CITY"           , sbChanges) ) { this.mailing_city       = Sql.ToString  (row["ALT_ADDRESS_CITY"           ]);  bChanged = true; }
				if ( Compare(MaxLength(this.mailing_state     ,  20), MaxLength(Sql.ToString(row["ALT_ADDRESS_STATE"          ]),  20), "ALT_ADDRESS_STATE"          , sbChanges) ) { this.mailing_state      = Sql.ToString  (row["ALT_ADDRESS_STATE"          ]);  bChanged = true; }
				if ( Compare(MaxLength(this.mailing_zip       ,  20), MaxLength(Sql.ToString(row["ALT_ADDRESS_POSTALCODE"     ]),  20), "ALT_ADDRESS_POSTALCODE"     , sbChanges) ) { this.mailing_zip        = Sql.ToString  (row["ALT_ADDRESS_POSTALCODE"     ]);  bChanged = true; }
				if ( Compare(MaxLength(this.mailing_country   ,  40), MaxLength(Sql.ToString(row["ALT_ADDRESS_COUNTRY"        ]),  40), "ALT_ADDRESS_COUNTRY"        , sbChanges) ) { this.mailing_country    = Sql.ToString  (row["ALT_ADDRESS_COUNTRY"        ]);  bChanged = true; }
				if ( Compare(MaxLength(this.title             ,  50), MaxLength(Sql.ToString(row["TITLE"                      ]),  50), "TITLE"                      , sbChanges) ) { this.title              = Sql.ToString  (row["TITLE"                      ]);  bChanged = true; }
				if ( Compare(MaxLength(this.department        ,  80), MaxLength(Sql.ToString(row["DEPARTMENT"                 ]),  80), "DEPARTMENT"                 , sbChanges) ) { this.department         = Sql.ToString  (row["DEPARTMENT"                 ]);  bChanged = true; }
				if ( Compare(MaxLength(this.assistant_name    ,  40), MaxLength(Sql.ToString(row["ASSISTANT"                  ]),  40), "ASSISTANT"                  , sbChanges) ) { this.assistant_name     = Sql.ToString  (row["ASSISTANT"                  ]);  bChanged = true; }
				if ( Compare(MaxLength(this.assistant_phone   ,  25), MaxLength(Sql.ToString(row["ASSISTANT_PHONE"            ]),  25), "ASSISTANT_PHONE"            , sbChanges) ) { this.assistant_phone    = Sql.ToString  (row["ASSISTANT_PHONE"            ]);  bChanged = true; }
				if ( Compare(MaxLength(this.description       , 450), MaxLength(Sql.ToString(row["DESCRIPTION"                ]), 450), "DESCRIPTION"                , sbChanges) ) { this.description        = Sql.ToString  (row["DESCRIPTION"                ]);  bChanged = true; }
				if ( Compare(MaxLength(this.source            , 100), MaxLength(Sql.ToString(row["LEAD_SOURCE"                ]), 100), "LEAD_SOURCE"                , sbChanges) ) { this.source             = Sql.ToString  (row["LEAD_SOURCE"                ]);  bChanged = true; }
				if ( Compare(MaxLength(this.status            ,  40), MaxLength(Sql.ToString(row["STATUS"                     ]),  40), "STATUS"                     , sbChanges) ) { this.status             = Sql.ToString  (row["STATUS"                     ]);  bChanged = true; }
				if ( Compare(MaxLength(this.website           , 255), MaxLength(Sql.ToString(row["WEBSITE"                    ]), 255), "WEBSITE"                    , sbChanges) ) { this.website            = Sql.ToString  (row["WEBSITE"                    ]);  bChanged = true; }

				if ( Compare(this.account_name      , row["ACCOUNT_NAME"               ], "ACCOUNT_NAME"               , sbChanges) ) { this.account_name       = Sql.ToString  (row["ACCOUNT_NAME"               ]);  bChanged = true; }
				if ( Compare(this.opt_out           , row["EMAIL_OPT_OUT"              ], "EMAIL_OPT_OUT"              , sbChanges) ) { this.opt_out            = Sql.ToBoolean (row["EMAIL_OPT_OUT"              ]);  bChanged = true; }
				if ( Compare(this.do_not_call       , row["DO_NOT_CALL"                ], "DO_NOT_CALL"                , sbChanges) ) { this.do_not_call        = Sql.ToBoolean (row["DO_NOT_CALL"                ]);  bChanged = true; }
				if ( Compare(this.birth_date        , row["BIRTHDATE"                  ], "BIRTHDATE"                  , sbChanges) ) { this.birth_date         = Sql.ToDateTime(row["BIRTHDATE"                  ]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromSalesFusion(int nId)
		{
			Spring.Social.SalesFusion.Api.Lead obj = this.SalesFusion.LeadOperations.GetById(nId);
			SetFromSalesFusion(obj);
		}

		public void SetFromSalesFusion(Spring.Social.SalesFusion.Api.Lead obj)
		{
			this.Reset();
			this.RawContent          = obj.RawContent               ;
			this.id                  = obj.id.Value                 ;
			this.owner_id            = obj.owner_id.Value           ;
			this.name                = (obj.first_name + " " + obj.last_name).Trim();
			this.created_date        = obj.created_date.Value       ;
			this.updated_date        = obj.updated_date.Value       ;
			this.salutation          = obj.salutation               ;
			this.first_name          = obj.first_name               ;
			this.last_name           = obj.last_name                ;
			this.account_id          = (obj.account_id.HasValue ? obj.account_id.Value : 0);
			this.phone               = obj.phone                    ;
			this.mobile              = obj.mobile                   ;
			this.fax                 = obj.fax                      ;
			this.home_phone          = obj.home_phone               ;
			this.other_phone         = obj.other_phone              ;
			this.email               = obj.email                    ;
			this.billing_street      = obj.billing_street           ;
			this.billing_city        = obj.billing_city             ;
			this.billing_state       = obj.billing_state            ;
			this.billing_zip         = obj.billing_zip              ;
			this.billing_country     = obj.billing_country          ;
			this.mailing_street      = obj.mailing_street           ;
			this.mailing_city        = obj.mailing_city             ;
			this.mailing_state       = obj.mailing_state            ;
			this.mailing_zip         = obj.mailing_zip              ;
			this.mailing_country     = obj.mailing_country          ;
			this.title               = obj.title                    ;
			this.department          = obj.department               ;
			this.assistant_name      = obj.assistant_name           ;
			this.assistant_phone     = obj.assistant_phone          ;
			this.description         = obj.description              ;
			this.account_name        = obj.account_name             ;
			this.opt_out             = Sql.ToBoolean(obj.opt_out    );
			this.do_not_call         = Sql.ToBoolean(obj.do_not_call);
			this.source              = obj.source        ;
			this.status              = obj.status        ;
			this.website             = obj.website       ;
			this.birth_date          = (obj.birth_date.HasValue ? obj.birth_date.Value : DateTime.MinValue);
		}

		public override void Update()
		{
			Spring.Social.SalesFusion.Api.Lead obj = this.SalesFusion.LeadOperations.GetById(this.id);
			obj.id                    = this.id                 ;
			obj.crm_id                = this.LOCAL_ID.ToString();
			obj.owner_id              = this.owner_id           ;
			obj.account_id            = this.account_id         ;

			obj.salutation            = MaxLength(this.salutation         ,  10);
			obj.first_name            = MaxLength(this.first_name         ,  40);
			obj.last_name             = MaxLength(this.last_name          ,  40);
			obj.phone                 = MaxLength(this.phone              ,  40);
			obj.mobile                = MaxLength(this.mobile             ,  40);
			obj.fax                   = MaxLength(this.fax                ,  40);
			obj.home_phone            = MaxLength(this.home_phone         ,  40);
			obj.other_phone           = MaxLength(this.other_phone        ,  40);
			obj.email                 = MaxLength(this.email              , 250);
			obj.billing_street        = MaxLength(this.billing_street     ,  80);
			obj.billing_city          = MaxLength(this.billing_city       ,  40);
			obj.billing_state         = MaxLength(this.billing_state      ,  20);
			obj.billing_zip           = MaxLength(this.billing_zip        ,  20);
			obj.billing_country       = MaxLength(this.billing_country    ,  40);
			obj.mailing_street        = MaxLength(this.mailing_street     ,  80);
			obj.mailing_city          = MaxLength(this.mailing_city       ,  40);
			obj.mailing_state         = MaxLength(this.mailing_state      ,  20);
			obj.mailing_zip           = MaxLength(this.mailing_zip        ,  20);
			obj.mailing_country       = MaxLength(this.mailing_country    ,  40);
			obj.title                 = MaxLength(this.title              ,  80);
			obj.department            = MaxLength(this.department         ,  80);
			obj.assistant_name        = MaxLength(this.assistant_name     ,  40);
			obj.assistant_phone       = MaxLength(this.assistant_phone    ,  40);
			obj.description           = MaxLength(this.description        , 450);
			obj.source                = MaxLength(this.source             , 250);
			obj.status                = MaxLength(this.status             ,  40);
			obj.website               = MaxLength(this.website            , 255);

			obj.opt_out               = (this.opt_out      ? "Y" : "N");
			obj.do_not_call           = (this.do_not_call  ? "Y" : "N");
			obj.birth_date            = this.birth_date         ;
			
			this.SalesFusion.LeadOperations.Update(obj);
			obj = this.SalesFusion.LeadOperations.GetById(this.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id.Value              ;
			this.updated_date     = obj.updated_date.Value    ;
		}

		public override string Insert()
		{
			this.id = 0;
			
			Spring.Social.SalesFusion.Api.Lead obj = new Spring.Social.SalesFusion.Api.Lead();
			obj.owner_id              = this.owner_id           ;
			obj.crm_id                = this.LOCAL_ID.ToString();
			obj.account_id            = this.account_id         ;

			obj.salutation            = MaxLength(this.salutation         ,  10);
			obj.first_name            = MaxLength(this.first_name         ,  40);
			obj.last_name             = MaxLength(this.last_name          ,  40);
			obj.phone                 = MaxLength(this.phone              ,  40);
			obj.mobile                = MaxLength(this.mobile             ,  40);
			obj.fax                   = MaxLength(this.fax                ,  40);
			obj.home_phone            = MaxLength(this.home_phone         ,  40);
			obj.other_phone           = MaxLength(this.other_phone        ,  40);
			obj.email                 = MaxLength(this.email              , 250);
			obj.billing_street        = MaxLength(this.billing_street     ,  80);
			obj.billing_city          = MaxLength(this.billing_city       ,  40);
			obj.billing_state         = MaxLength(this.billing_state      ,  20);
			obj.billing_zip           = MaxLength(this.billing_zip        ,  20);
			obj.billing_country       = MaxLength(this.billing_country    ,  40);
			obj.mailing_street        = MaxLength(this.mailing_street     ,  80);
			obj.mailing_city          = MaxLength(this.mailing_city       ,  40);
			obj.mailing_state         = MaxLength(this.mailing_state      ,  20);
			obj.mailing_zip           = MaxLength(this.mailing_zip        ,  20);
			obj.mailing_country       = MaxLength(this.mailing_country    ,  40);
			obj.title                 = MaxLength(this.title              ,  80);
			obj.department            = MaxLength(this.department         ,  80);
			obj.assistant_name        = MaxLength(this.assistant_name     ,  40);
			obj.assistant_phone       = MaxLength(this.assistant_phone    ,  40);
			obj.description           = MaxLength(this.description        , 450);
			obj.source                = MaxLength(this.source             , 250);
			obj.status                = MaxLength(this.status             ,  40);
			obj.website               = MaxLength(this.website            , 255);

			obj.opt_out               = (this.opt_out      ? "Y" : "N");
			obj.do_not_call           = (this.do_not_call  ? "Y" : "N");
			obj.birth_date            = this.birth_date         ;

			obj = this.SalesFusion.LeadOperations.Insert(obj);
			// 04/28/2015 Paul.  Insert does not return the last modified date. Get the record again. 
			obj = this.SalesFusion.LeadOperations.GetById(obj.id.Value);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id.Value              ;
			this.updated_date     = obj.updated_date.Value    ;
			return Sql.ToString(this.id);
		}

		public override void Delete()
		{
			this.SalesFusion.LeadOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.SalesFusion.Api.Lead obj = this.SalesFusion.LeadOperations.GetById(Sql.ToInteger(sID));
			if ( obj.id.HasValue )
			{
				this.SetFromSalesFusion(obj);
			}
			else
			{
				this.Deleted = true;
			}
		}

		public override IList<Spring.Social.SalesFusion.Api.HBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.SalesFusion.Api.HBase> lst = this.SalesFusion.LeadOperations.GetModified(dtStartModifiedDate);
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
			if ( this.account_id > 0 && this.vwACCOUNTS != null )
			{
				this.vwACCOUNTS.RowFilter = "SYNC_REMOTE_KEY = '" + this.account_id.ToString() + "'";
				if ( this.vwACCOUNTS.Count > 0 )
					gACCOUNT_ID = Sql.ToGuid(this.vwACCOUNTS[0]["SYNC_LOCAL_ID"]);
			}
			
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
							case "ACCOUNT_ID"                 :  oValue = Sql.ToDBGuid    (     gACCOUNT_ID            );  break;
							case "SALUTATION"                 :  oValue = Sql.ToDBString  (this.salutation             );  break;
							case "FIRST_NAME"                 :  oValue = Sql.ToDBString  (this.first_name             );  break;
							case "LAST_NAME"                  :  oValue = Sql.ToDBString  (this.last_name              );  break;
							case "PHONE_WORK"                 :  oValue = Sql.ToDBString  (this.phone                  );  break;
							case "PHONE_MOBILE"               :  oValue = Sql.ToDBString  (this.mobile                 );  break;
							case "PHONE_FAX"                  :  oValue = Sql.ToDBString  (this.fax                    );  break;
							case "PHONE_HOME"                 :  oValue = Sql.ToDBString  (this.home_phone             );  break;
							case "PHONE_OTHER"                :  oValue = Sql.ToDBString  (this.other_phone            );  break;
							case "EMAIL1"                     :  oValue = Sql.ToDBString  (this.email                  );  break;
							case "PRIMARY_ADDRESS_STREET"     :  oValue = Sql.ToDBString  (this.billing_street         );  break;
							case "PRIMARY_ADDRESS_CITY"       :  oValue = Sql.ToDBString  (this.billing_city           );  break;
							case "PRIMARY_ADDRESS_STATE"      :  oValue = Sql.ToDBString  (this.billing_state          );  break;
							case "PRIMARY_ADDRESS_POSTALCODE" :  oValue = Sql.ToDBString  (this.billing_zip            );  break;
							case "PRIMARY_ADDRESS_COUNTRY"    :  oValue = Sql.ToDBString  (this.billing_country        );  break;
							case "ALT_ADDRESS_STREET"         :  oValue = Sql.ToDBString  (this.mailing_street         );  break;
							case "ALT_ADDRESS_CITY"           :  oValue = Sql.ToDBString  (this.mailing_city           );  break;
							case "ALT_ADDRESS_STATE"          :  oValue = Sql.ToDBString  (this.mailing_state          );  break;
							case "ALT_ADDRESS_POSTALCODE"     :  oValue = Sql.ToDBString  (this.mailing_zip            );  break;
							case "ALT_ADDRESS_COUNTRY"        :  oValue = Sql.ToDBString  (this.mailing_country        );  break;
							case "TITLE"                      :  oValue = Sql.ToDBString  (this.title                  );  break;
							case "DEPARTMENT"                 :  oValue = Sql.ToDBString  (this.department             );  break;
							case "ASSISTANT"                  :  oValue = Sql.ToDBString  (this.assistant_name         );  break;
							case "ASSISTANT_PHONE"            :  oValue = Sql.ToDBString  (this.assistant_phone        );  break;
							case "DESCRIPTION"                :  oValue = Sql.ToDBString  (this.description            );  break;
							case "DO_NOT_CALL"                :  oValue = Sql.ToDBBoolean (this.do_not_call            );  break;
							case "EMAIL_OPT_OUT"              :  oValue = Sql.ToDBBoolean (this.opt_out                );  break;
							case "LEAD_SOURCE"                :  oValue = Sql.ToDBString  (this.source                 );  break;
							case "STATUS"                     :  oValue = Sql.ToDBString  (this.status                 );  break;
							case "WEBSITE"                    :  oValue = Sql.ToDBString  (this.website                );  break;
							case "BIRTHDATE"                  :  oValue = Sql.ToDBDateTime(this.birth_date             );  break;
							case "ASSIGNED_USER_ID"           :  oValue = Sql.ToDBGuid   (     gOWNER_USER_ID         );  break;
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
									case "SALUTATION"                 :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "FIRST_NAME"                 :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "LAST_NAME"                  :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PHONE_WORK"                 :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_MOBILE"               :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_FAX"                  :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_HOME"                 :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_OTHER"                :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "EMAIL1"                     :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
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
									case "TITLE"                      :  bChanged = ParameterChanged(par, oValue,   50, sbChanges);  break;
									case "DEPARTMENT"                 :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "ASSISTANT"                  :  bChanged = ParameterChanged(par, oValue,   75, sbChanges);  break;
									case "ASSISTANT_PHONE"            :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "DESCRIPTION"                :  bChanged = ParameterChanged(par, oValue, 4000, sbChanges);  break;
									case "LEAD_SOURCE"                :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "STATUS"                     :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "WEBSITE"                    :  bChanged = ParameterChanged(par, oValue,  255, sbChanges);  break;
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
