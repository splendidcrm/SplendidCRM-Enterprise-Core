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
	public class Opportunity : SFObject
	{
		#region Properties
		public int        contact_id                    { get; set; }
		public int        account_id                    { get; set; }
		public DateTime   closing_date                  { get; set; }
		public String     lead_source                   { get; set; }  // 50
		public String     stage                         { get; set; }  // 50
		public String     next_step                     { get; set; }  // 50
		public Decimal    amount                        { get; set; }
		public String     probability                   { get; set; }  // 50
		public String     won                           { get; set; }
		public DateTime   est_closing_date              { get; set; }
		public String     sub_lead_source_originator    { get; set; }  // 100
		public String     lead_source_originator        { get; set; }  // 100
		public String     sub_lead_source               { get; set; }  // 100
		public String     description                   { get; set; }  // 500
		public String     opp_type                      { get; set; }  // 50
		public String     shared_opp                    { get; set; }  // 5
		public String     product_name                  { get; set; }  // 100
		public String     action_steps_complete         { get; set; }  // 500
		public String     custom_mapping                { get; set; }
		#endregion

		protected DataView vwAccounts;
		
		public Opportunity(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, SalesFusionSync SalesFusionSync, Spring.Social.SalesFusion.Api.ISalesFusion salesFusion, DataTable dtUSERS, DataTable dtACCOUNTS)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, SalesFusionSync, salesFusion, "Accounts", "Name", "Accounts", "ACCOUNTS", "NAME", true, dtUSERS)
		{
			this.vwAccounts = new DataView(dtACCOUNTS);
		}

		public void SetAccount(Guid gACCOUNT_ID)
		{
			if ( this.account_id >0 )
			{
				vwAccounts.RowFilter = "SYNC_LOCAL_ID = '" + gACCOUNT_ID.ToString() + "'";
				if ( vwAccounts.Count > 0 )
					this.account_id = Sql.ToInteger(vwAccounts[0]["SYNC_REMOTE_KEY"]);
			}
		}

		public override void Reset()
		{
			base.Reset();
			this.contact_id                    = 0;
			this.account_id                    = 0;
			this.closing_date                  = DateTime.MinValue;
			this.lead_source                   = String.Empty;
			this.stage                         = String.Empty;
			this.next_step                     = String.Empty;
			this.amount                        = 0m;
			this.probability                   = String.Empty;
			this.won                           = String.Empty;
			this.est_closing_date              = DateTime.MinValue;
			this.sub_lead_source_originator    = String.Empty;
			this.lead_source_originator        = String.Empty;
			this.sub_lead_source               = String.Empty;
			this.description                   = String.Empty;
			this.opp_type                      = String.Empty;
			this.shared_opp                    = String.Empty;
			this.product_name                  = String.Empty;
			this.action_steps_complete         = String.Empty;
			this.custom_mapping                = String.Empty;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			int nAccountID = 0;
			if ( !Sql.IsEmptyGuid(row["ACCOUNT_ID"]) )
			{
				vwAccounts.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["ACCOUNT_ID"]) + "'";
				if ( vwAccounts.Count > 0 )
					nAccountID = Sql.ToInteger(vwAccounts[0]["SYNC_REMOTE_KEY"]);
			}
			
			int nOwnerID = this.GetUserID();
			if ( !Sql.IsEmptyGuid(row["ASSIGNED_USER_ID"]) )
			{
				vwUSERS.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["ASSIGNED_USER_ID"]) + "'";
				if ( vwUSERS.Count > 0 )
					nOwnerID = Sql.ToInteger(vwUSERS[0]["SYNC_REMOTE_KEY"]);
			}
			
			this.id = Sql.ToInteger(sID);
			this.LOCAL_ID = Sql.ToGuid(row["ID"]);
			if ( Sql.IsEmptyString(sID) )
			{
				this.name                          = Sql.ToString  (row["NAME"            ]);
				this.owner_id                      = nOwnerID;
				this.account_id                    = nAccountID;
				this.closing_date                  = Sql.ToDateTime(row["DATE_CLOSED"     ]);
				this.lead_source                   = Sql.ToString  (row["LEAD_SOURCE"     ]);
				this.stage                         = Sql.ToString  (row["SALES_STAGE"     ]);
				this.next_step                     = Sql.ToString  (row["NEXT_STEP"       ]);
				this.amount                        = Sql.ToDecimal (row["AMOUNT_USDOLLAR" ]);
				this.probability                   = Sql.ToString  (row["PROBABILITY"     ]);
				this.opp_type                      = Sql.ToString  (row["OPPORTUNITY_TYPE"]);
				this.description                   = Sql.ToString  (row["DESCRIPTION"     ]);
				//this.contact_id                    = 0;
				//this.won                           = String.Empty;
				//this.est_closing_date              = DateTime.MinValue;
				//this.sub_lead_source_originator    = String.Empty;
				//this.lead_source_originator        = String.Empty;
				//this.sub_lead_source               = String.Empty;
				//this.shared_opp                    = String.Empty;
				//this.product_name                  = String.Empty;
				//this.action_steps_complete         = String.Empty;
				//this.custom_mapping                = String.Empty;
				bChanged = true;
			}
			else
			{
				if ( nAccountID == 0 && this.account_id == 1 )
					nAccountID = 1;
				
				if ( Compare(this.owner_id                  , nOwnerID                               , ""                , sbChanges) ) { this.owner_id                   = nOwnerID                               ;  bChanged = true; }
				if ( Compare(this.account_id                , nAccountID                             , "ACCOUNT_ID"      , sbChanges) ) { this.account_id                 = nAccountID                             ;  bChanged = true; }
				if ( Compare(this.closing_date              , Sql.ToDateTime(row["DATE_CLOSED"     ]), "DATE_CLOSED"     , sbChanges) ) { this.closing_date               = Sql.ToDateTime(row["DATE_CLOSED"     ]);  bChanged = true; }
				if ( Compare(this.amount                    , Sql.ToDecimal (row["AMOUNT_USDOLLAR" ]), "AMOUNT_USDOLLAR" , sbChanges) ) { this.amount                     = Sql.ToDecimal (row["AMOUNT_USDOLLAR" ]);  bChanged = true; }
				// 11/21/2016 Paul.  The max length should be the min between two systems. 
				if ( Compare(MaxLength(this.name        , 150), MaxLength(Sql.ToString  (row["NAME"            ]), 150), "NAME"            , sbChanges) ) { this.name                       = Sql.ToString  (row["NAME"            ]);  bChanged = true; }
				if ( Compare(MaxLength(this.lead_source ,  50), MaxLength(Sql.ToString  (row["LEAD_SOURCE"     ]),  50), "LEAD_SOURCE"     , sbChanges) ) { this.lead_source                = Sql.ToString  (row["LEAD_SOURCE"     ]);  bChanged = true; }
				if ( Compare(MaxLength(this.stage       ,  25), MaxLength(Sql.ToString  (row["SALES_STAGE"     ]),  25), "SALES_STAGE"     , sbChanges) ) { this.stage                      = Sql.ToString  (row["SALES_STAGE"     ]);  bChanged = true; }
				if ( Compare(MaxLength(this.next_step   , 100), MaxLength(Sql.ToString  (row["NEXT_STEP"       ]), 100), "NEXT_STEP"       , sbChanges) ) { this.next_step                  = Sql.ToString  (row["NEXT_STEP"       ]);  bChanged = true; }
				if ( Compare(MaxLength(this.probability ,  50), MaxLength(Sql.ToString  (row["PROBABILITY"     ]),  50), "PROBABILITY"     , sbChanges) ) { this.probability                = Sql.ToString  (row["PROBABILITY"     ]);  bChanged = true; }
				if ( Compare(MaxLength(this.opp_type    ,  50), MaxLength(Sql.ToString  (row["OPPORTUNITY_TYPE"]),  50), "OPPORTUNITY_TYPE", sbChanges) ) { this.opp_type                   = Sql.ToString  (row["OPPORTUNITY_TYPE"]);  bChanged = true; }
				if ( Compare(MaxLength(this.description , 500), MaxLength(Sql.ToString  (row["DESCRIPTION"     ]), 500), "DESCRIPTION"     , sbChanges) ) { this.description                = Sql.ToString  (row["DESCRIPTION"     ]);  bChanged = true; }
				//if ( Compare(this.contact_id                , 0                                      , ""                , sbChanges) ) { this.contact_id                 = 0                                      ;  bChanged = true; }
				//if ( Compare(this.est_closing_date          , DateTime.MinValue                      , ""                , sbChanges) ) { this.est_closing_date           = DateTime.MinValue                      ;  bChanged = true; }
				//if ( Compare(this.sub_lead_source_originator, String.Empty                           , ""                , sbChanges) ) { this.sub_lead_source_originator = String.Empty                           ;  bChanged = true; }
				//if ( Compare(this.lead_source_originator    , String.Empty                           , ""                , sbChanges) ) { this.lead_source_originator     = String.Empty                           ;  bChanged = true; }
				//if ( Compare(this.sub_lead_source           , String.Empty                           , ""                , sbChanges) ) { this.sub_lead_source            = String.Empty                           ;  bChanged = true; }
				//if ( Compare(this.shared_opp                , String.Empty                           , ""                , sbChanges) ) { this.shared_opp                 = String.Empty                           ;  bChanged = true; }
				//if ( Compare(this.product_name              , String.Empty                           , ""                , sbChanges) ) { this.product_name               = String.Empty                           ;  bChanged = true; }
				//if ( Compare(this.action_steps_complete     , String.Empty                           , ""                , sbChanges) ) { this.action_steps_complete      = String.Empty                           ;  bChanged = true; }
				//if ( Compare(this.custom_mapping            , String.Empty                           , ""                , sbChanges) ) { this.custom_mapping             = String.Empty                           ;  bChanged = true; }
				if ( Compare(this.updated_date              , Sql.ToDateTime(row["DATE_MODIFIED"   ]), "DATE_MODIFIED"   , sbChanges) ) { this.updated_date               = Sql.ToDateTime (row["DATE_MODIFIED"  ]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromSalesFusion(int nId)
		{
			Spring.Social.SalesFusion.Api.Opportunity obj = this.SalesFusion.OpportunityOperations.GetById(nId);
			SetFromSalesFusion(obj);
		}

		public void SetFromSalesFusion(Spring.Social.SalesFusion.Api.Opportunity obj)
		{
			this.Reset();
			this.RawContent        = obj.RawContent            ;
			this.id                = obj.id.Value              ;
			this.owner_id          = obj.owner_id.Value        ;
			this.created_date      = obj.created_date.Value    ;
			this.updated_date      = obj.updated_date.Value    ;

			this.account_id        = (obj.account_id  .HasValue ? obj.account_id  .Value : 0);
			this.closing_date      = (obj.closing_date.HasValue ? obj.closing_date.Value : DateTime.MinValue);
			this.amount            = (obj.amount      .HasValue ? obj.amount.Value : Decimal.Zero);
			this.name              = obj.name                  ;
			this.lead_source       = obj.lead_source           ;
			this.stage             = obj.stage                 ;
			this.next_step         = obj.next_step             ;
			this.probability       = obj.probability           ;
			this.opp_type          = obj.opp_type              ;
			this.description       = obj.description           ;
		}

		public override void Update()
		{
			Spring.Social.SalesFusion.Api.Opportunity obj = this.SalesFusion.OpportunityOperations.GetById(this.id);
			obj.id                    = this.id                ;
			obj.owner_id              = this.owner_id          ;
			obj.crm_id                = this.LOCAL_ID.ToString();
			obj.account_id            = this.account_id        ;
			obj.closing_date          = this.closing_date      ;
			obj.amount                = this.amount            ;

			obj.name                  = MaxLength(this.name         , 255);
			obj.lead_source           = MaxLength(this.lead_source  ,  50);
			obj.stage                 = MaxLength(this.stage        ,  50);
			obj.next_step             = MaxLength(this.next_step    ,  50);
			obj.probability           = MaxLength(this.probability  ,  50);
			obj.opp_type              = MaxLength(this.opp_type     ,  50);
			obj.description           = MaxLength(this.description  , 500);
			
			this.SalesFusion.OpportunityOperations.Update(obj);
			obj = this.SalesFusion.OpportunityOperations.GetById(this.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id.Value              ;
			this.updated_date     = obj.updated_date.Value    ;
		}

		public override string Insert()
		{
			this.id = 0;
			
			Spring.Social.SalesFusion.Api.Opportunity obj = new Spring.Social.SalesFusion.Api.Opportunity();
			obj.owner_id              = this.owner_id          ;
			obj.crm_id                = this.LOCAL_ID.ToString();
			obj.account_id            = this.account_id        ;
			obj.closing_date          = this.closing_date      ;
			obj.amount                = this.amount            ;

			obj.name                  = MaxLength(this.name         , 255);
			obj.lead_source           = MaxLength(this.lead_source  ,  50);
			obj.stage                 = MaxLength(this.stage        ,  50);
			obj.next_step             = MaxLength(this.next_step    ,  50);
			obj.probability           = MaxLength(this.probability  ,  50);
			obj.opp_type              = MaxLength(this.opp_type     ,  50);
			obj.description           = MaxLength(this.description  , 500);

			obj = this.SalesFusion.OpportunityOperations.Insert(obj);
			obj = this.SalesFusion.OpportunityOperations.GetById(obj.id.Value);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id.Value              ;
			this.updated_date     = obj.updated_date.Value    ;
			return this.id.ToString();
		}

		public override void Delete()
		{
			this.SalesFusion.OpportunityOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.SalesFusion.Api.Opportunity obj = this.SalesFusion.OpportunityOperations.GetById(Sql.ToInteger(sID));
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
			Sql.AppendParameter(cmd, Sql.ToString(this.name), "NAME");
			Sql.AppendParameter(cmd, this.closing_date, "DATE_CLOSED");
			Guid gACCOUNT_ID = Guid.Empty;
			if ( this.account_id >0 )
			{
				vwAccounts.RowFilter = "SYNC_REMOTE_KEY = '" + this.account_id.ToString() + "'";
				if ( vwAccounts.Count > 0 )
					gACCOUNT_ID = Sql.ToGuid(vwAccounts[0]["SYNC_LOCAL_ID"]);
			}
			if ( Sql.IsEmptyGuid(gACCOUNT_ID) )
				cmd.CommandText += "   and ACCOUNT_ID is null" + ControlChars.CrLf;
			else
				Sql.AppendParameter(cmd, gACCOUNT_ID, "ACCOUNT_ID");
		}

		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = this.InitUpdateProcedure(spUpdate, row, gUSER_ID, gTEAM_ID);
			
			Guid gACCOUNT_ID = Guid.Empty;
			if ( this.account_id > 0 )
			{
				vwAccounts.RowFilter = "SYNC_REMOTE_KEY = '" + this.account_id.ToString() + "'";
				if ( vwAccounts.Count > 0 )
					gACCOUNT_ID = Sql.ToGuid(vwAccounts[0]["SYNC_LOCAL_ID"]);
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
							case "AMOUNT_USDOLLAR" :  oValue = Sql.ToDBDecimal (this.amount         );  break;
							case "DATE_CLOSED"     :  oValue = Sql.ToDBDateTime(this.closing_date   );  break;
							case "NAME"            :  oValue = Sql.ToDBString  (this.name           );  break;
							case "LEAD_SOURCE"     :  oValue = Sql.ToDBString  (this.lead_source    );  break;
							case "NEXT_STEP"       :  oValue = Sql.ToDBString  (this.next_step      );  break;
							case "OPPORTUNITY_TYPE":  oValue = Sql.ToDBString  (this.opp_type       );  break;
							case "PROBABILITY"     :  oValue = Sql.ToDBFloat   (this.probability    );  break;
							case "SALES_STAGE"     :  oValue = Sql.ToDBString  (this.stage          );  break;
							case "DESCRIPTION"     :  oValue = Sql.ToDBString  (this.description    );  break;
							case "ACCOUNT_ID"      :  oValue = Sql.ToDBGuid    (     gACCOUNT_ID    );  break;
							case "MODIFIED_USER_ID":  oValue = Sql.ToDBGuid    (     gUSER_ID       );  break;
							case "ASSIGNED_USER_ID":  oValue = Sql.ToDBGuid    (     gOWNER_USER_ID );  break;
						}
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "NAME"            :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "LEAD_SOURCE"     :  bChanged = ParameterChanged(par, oValue,   50, sbChanges);  break;
									case "NEXT_STEP"       :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "OPPORTUNITY_TYPE":  bChanged = ParameterChanged(par, oValue,  255, sbChanges);  break;
									case "SALES_STAGE"     :  bChanged = ParameterChanged(par, oValue,   10, sbChanges);  break;
									case "DESCRIPTION"     :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
									default                :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
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
