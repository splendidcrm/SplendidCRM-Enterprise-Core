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
	public class Account : SFObject
	{
		#region Properties
		public string    account_name       { get { return name; } set { name = value; } }  // 255
		public string    account_number     ;  // 255
		public string    phone              ;  // 255
		public string    fax                ;  // 255
		public string    billing_address    ;  // 255
		public string    billing_city       ;  // 255
		public string    billing_state      ;  // 255
		public string    billing_zip        ;  // 10
		public string    billing_country    ;  // 255
		public string    shipping_address   ;  // 255
		public string    shipping_city      ;  // 255
		public string    shipping_state     ;  // 255
		public string    shipping_zip       ;  // 10
		public string    shipping_country   ;  // 255
		public string    website            ;  // 255
		public string    industry           ;  // 80
		public string    type               ;  // 40
		public string    rating             ;  // 40
		public string    sic                ;  // 255
		public string    description        ;  // 255
		#endregion

		public Account(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, SalesFusionSync SalesFusionSync, Spring.Social.SalesFusion.Api.ISalesFusion salesFusion, DataTable dtUSERS)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, SalesFusionSync, salesFusion, "Accounts", "Name", "Accounts", "ACCOUNTS", "NAME", true, dtUSERS)
		{
		}

		public override void Reset()
		{
			base.Reset();
			this.account_name      = String.Empty;
			this.account_number    = String.Empty;
			this.phone             = String.Empty;
			this.fax               = String.Empty;
			this.billing_address   = String.Empty;
			this.billing_city      = String.Empty;
			this.billing_state     = String.Empty;
			this.billing_zip       = String.Empty;
			this.billing_country   = String.Empty;
			this.shipping_address  = String.Empty;
			this.shipping_city     = String.Empty;
			this.shipping_state    = String.Empty;
			this.shipping_zip      = String.Empty;
			this.shipping_country  = String.Empty;
			this.website           = String.Empty;
			this.industry          = String.Empty;
			this.type              = String.Empty;
			this.rating            = String.Empty;
			this.sic               = String.Empty;
			this.description       = String.Empty;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			
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
				this.owner_id           = nOwnerID;
				this.name               = Sql.ToString (row["NAME"                       ]);
				this.account_number     = Sql.ToString (row["ACCOUNT_NUMBER"             ]);
				this.phone              = Sql.ToString (row["PHONE_OFFICE"               ]);
				this.fax                = Sql.ToString (row["PHONE_FAX"                  ]);
				this.billing_address    = Sql.ToString (row["BILLING_ADDRESS_STREET"     ]);
				this.billing_city       = Sql.ToString (row["BILLING_ADDRESS_CITY"       ]);
				this.billing_state      = Sql.ToString (row["BILLING_ADDRESS_STATE"      ]);
				this.billing_zip        = Sql.ToString (row["BILLING_ADDRESS_POSTALCODE" ]);
				this.billing_country    = Sql.ToString (row["BILLING_ADDRESS_COUNTRY"    ]);
				this.shipping_address   = Sql.ToString (row["SHIPPING_ADDRESS_STREET"    ]);
				this.shipping_city      = Sql.ToString (row["SHIPPING_ADDRESS_CITY"      ]);
				this.shipping_state     = Sql.ToString (row["SHIPPING_ADDRESS_STATE"     ]);
				this.shipping_zip       = Sql.ToString (row["SHIPPING_ADDRESS_POSTALCODE"]);
				this.shipping_country   = Sql.ToString (row["SHIPPING_ADDRESS_COUNTRY"   ]);
				this.website            = Sql.ToString (row["WEBSITE"                    ]);
				this.industry           = Sql.ToString (row["INDUSTRY"                   ]);
				this.type               = Sql.ToString (row["ACCOUNT_TYPE"               ]);
				this.rating             = Sql.ToString (row["RATING"                     ]);
				this.sic                = Sql.ToString (row["SIC_CODE"                   ]);
				this.description        = Sql.ToString (row["DESCRIPTION"                ]);
				bChanged = true;
			}
			else
			{
				if ( Compare(          this.owner_id          ,                              nOwnerID                                 , "ASSIGNED_USER_ID"           , sbChanges) ) { this.owner_id           = nOwnerID                                         ;  bChanged = true; }
				// 11/21/2016 Paul.  The max length should be the min between two systems. 
				if ( Compare(MaxLength(this.name              , 150), MaxLength(Sql.ToString(row["NAME"                       ]), 150), "NAME"                       , sbChanges) ) { this.name               = Sql.ToString (row["NAME"                       ]);  bChanged = true; }
				if ( Compare(MaxLength(this.account_number    ,  30), MaxLength(Sql.ToString(row["ACCOUNT_NUMBER"             ]),  30), "ACCOUNT_NUMBER"             , sbChanges) ) { this.account_number     = Sql.ToString (row["ACCOUNT_NUMBER"             ]);  bChanged = true; }
				if ( Compare(MaxLength(this.phone             ,  25), MaxLength(Sql.ToString(row["PHONE_OFFICE"               ]),  25), "PHONE_OFFICE"               , sbChanges) ) { this.phone              = Sql.ToString (row["PHONE_OFFICE"               ]);  bChanged = true; }
				if ( Compare(MaxLength(this.fax               ,  25), MaxLength(Sql.ToString(row["PHONE_FAX"                  ]),  25), "PHONE_FAX"                  , sbChanges) ) { this.fax                = Sql.ToString (row["PHONE_FAX"                  ]);  bChanged = true; }
				if ( Compare(MaxLength(this.billing_address   , 150), MaxLength(Sql.ToString(row["BILLING_ADDRESS_STREET"     ]), 150), "BILLING_ADDRESS_STREET"     , sbChanges) ) { this.billing_address    = Sql.ToString (row["BILLING_ADDRESS_STREET"     ]);  bChanged = true; }
				if ( Compare(MaxLength(this.billing_city      , 100), MaxLength(Sql.ToString(row["BILLING_ADDRESS_CITY"       ]), 100), "BILLING_ADDRESS_CITY"       , sbChanges) ) { this.billing_city       = Sql.ToString (row["BILLING_ADDRESS_CITY"       ]);  bChanged = true; }
				if ( Compare(MaxLength(this.billing_state     , 100), MaxLength(Sql.ToString(row["BILLING_ADDRESS_STATE"      ]), 100), "BILLING_ADDRESS_STATE"      , sbChanges) ) { this.billing_state      = Sql.ToString (row["BILLING_ADDRESS_STATE"      ]);  bChanged = true; }
				if ( Compare(MaxLength(this.billing_zip       ,  10), MaxLength(Sql.ToString(row["BILLING_ADDRESS_POSTALCODE" ]),  10), "BILLING_ADDRESS_POSTALCODE" , sbChanges) ) { this.billing_zip        = Sql.ToString (row["BILLING_ADDRESS_POSTALCODE" ]);  bChanged = true; }
				if ( Compare(MaxLength(this.billing_country   , 100), MaxLength(Sql.ToString(row["BILLING_ADDRESS_COUNTRY"    ]), 100), "BILLING_ADDRESS_COUNTRY"    , sbChanges) ) { this.billing_country    = Sql.ToString (row["BILLING_ADDRESS_COUNTRY"    ]);  bChanged = true; }
				if ( Compare(MaxLength(this.shipping_address  , 150), MaxLength(Sql.ToString(row["SHIPPING_ADDRESS_STREET"    ]), 150), "SHIPPING_ADDRESS_STREET"    , sbChanges) ) { this.shipping_address   = Sql.ToString (row["SHIPPING_ADDRESS_STREET"    ]);  bChanged = true; }
				if ( Compare(MaxLength(this.shipping_city     , 100), MaxLength(Sql.ToString(row["SHIPPING_ADDRESS_CITY"      ]), 100), "SHIPPING_ADDRESS_CITY"      , sbChanges) ) { this.shipping_city      = Sql.ToString (row["SHIPPING_ADDRESS_CITY"      ]);  bChanged = true; }
				if ( Compare(MaxLength(this.shipping_state    , 100), MaxLength(Sql.ToString(row["SHIPPING_ADDRESS_STATE"     ]), 100), "SHIPPING_ADDRESS_STATE"     , sbChanges) ) { this.shipping_state     = Sql.ToString (row["SHIPPING_ADDRESS_STATE"     ]);  bChanged = true; }
				if ( Compare(MaxLength(this.shipping_zip      ,  10), MaxLength(Sql.ToString(row["SHIPPING_ADDRESS_POSTALCODE"]),  10), "SHIPPING_ADDRESS_POSTALCODE", sbChanges) ) { this.shipping_zip       = Sql.ToString (row["SHIPPING_ADDRESS_POSTALCODE"]);  bChanged = true; }
				if ( Compare(MaxLength(this.shipping_country  , 100), MaxLength(Sql.ToString(row["SHIPPING_ADDRESS_COUNTRY"   ]), 100), "SHIPPING_ADDRESS_COUNTRY"   , sbChanges) ) { this.shipping_country   = Sql.ToString (row["SHIPPING_ADDRESS_COUNTRY"   ]);  bChanged = true; }
				if ( Compare(MaxLength(this.website           , 255), MaxLength(Sql.ToString(row["WEBSITE"                    ]), 255), "WEBSITE"                    , sbChanges) ) { this.website            = Sql.ToString (row["WEBSITE"                    ]);  bChanged = true; }
				if ( Compare(MaxLength(this.industry          ,  25), MaxLength(Sql.ToString(row["INDUSTRY"                   ]),  25), "INDUSTRY"                   , sbChanges) ) { this.industry           = Sql.ToString (row["INDUSTRY"                   ]);  bChanged = true; }
				if ( Compare(MaxLength(this.type              ,  25), MaxLength(Sql.ToString(row["ACCOUNT_TYPE"               ]),  25), "ACCOUNT_TYPE"               , sbChanges) ) { this.type               = Sql.ToString (row["ACCOUNT_TYPE"               ]);  bChanged = true; }
				if ( Compare(MaxLength(this.rating            ,  25), MaxLength(Sql.ToString(row["RATING"                     ]),  25), "RATING"                     , sbChanges) ) { this.rating             = Sql.ToString (row["RATING"                     ]);  bChanged = true; }
				if ( Compare(MaxLength(this.sic               ,  10), MaxLength(Sql.ToString(row["SIC_CODE"                   ]),  10), "SIC_CODE"                   , sbChanges) ) { this.sic                = Sql.ToString (row["SIC_CODE"                   ]);  bChanged = true; }
				if ( Compare(MaxLength(this.description       , 255), MaxLength(Sql.ToString(row["DESCRIPTION"                ]), 255), "DESCRIPTION"                , sbChanges) ) { this.description        = Sql.ToString (row["DESCRIPTION"                ]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromSalesFusion(int nId)
		{
			Spring.Social.SalesFusion.Api.Account obj = this.SalesFusion.AccountOperations.GetById(nId);
			SetFromSalesFusion(obj);
		}

		public void SetFromSalesFusion(Spring.Social.SalesFusion.Api.Account obj)
		{
			this.Reset();
			this.RawContent        = obj.RawContent            ;
			this.id                = obj.id.Value              ;
			this.owner_id          = obj.owner_id.Value        ;
			this.created_date      = obj.created_date.Value    ;
			this.updated_date      = obj.updated_date.Value    ;
			this.name              = obj.account_name          ;
			this.account_number    = obj.account_number        ;
			this.description       = obj.description           ;
			this.phone             = obj.phone                 ;
			this.fax               = obj.fax                   ;
			this.billing_address   = obj.billing_street        ;
			this.billing_city      = obj.billing_city          ;
			this.billing_state     = obj.billing_state         ;
			this.billing_zip       = obj.billing_zip           ;
			this.billing_country   = obj.billing_country       ;
			this.shipping_address  = obj.shipping_street       ;
			this.shipping_city     = obj.shipping_city         ;
			this.shipping_state    = obj.shipping_state        ;
			this.shipping_zip      = obj.shipping_zip          ;
			this.shipping_country  = obj.shipping_country      ;
			this.website           = obj.url                   ;
			this.industry          = obj.industry              ;
			this.type              = obj.type                  ;
			this.rating            = obj.rating                ;
			this.sic               = obj.sic                   ;
		}

		public override void Update()
		{
			Spring.Social.SalesFusion.Api.Account obj = this.SalesFusion.AccountOperations.GetById(this.id);
			obj.id                    = this.id                ;
			obj.owner_id              = this.owner_id          ;
			obj.crm_id                = this.LOCAL_ID.ToString();
			obj.account_name          = MaxLength(this.account_name      , 255);
			obj.account_number        = MaxLength(this.account_number    , 255);
			obj.phone                 = MaxLength(this.phone             , 255);
			obj.fax                   = MaxLength(this.fax               , 255);
			obj.billing_street        = MaxLength(this.billing_address   , 255);
			obj.billing_city          = MaxLength(this.billing_city      , 255);
			obj.billing_state         = MaxLength(this.billing_state     , 255);
			obj.billing_zip           = MaxLength(this.billing_zip       ,  10);
			obj.billing_country       = MaxLength(this.billing_country   , 255);
			obj.shipping_street       = MaxLength(this.shipping_address  , 255);
			obj.shipping_city         = MaxLength(this.shipping_city     , 255);
			obj.shipping_state        = MaxLength(this.shipping_state    , 255);
			obj.shipping_zip          = MaxLength(this.shipping_zip      ,  10);
			obj.shipping_country      = MaxLength(this.shipping_country  , 255);
			obj.url                   = MaxLength(this.website           , 255);
			obj.industry              = MaxLength(this.industry          ,  80);
			obj.type                  = MaxLength(this.type              ,  40);
			obj.rating                = MaxLength(this.rating            ,  40);
			obj.sic                   = MaxLength(this.sic               , 255);
			obj.description           = MaxLength(this.description       , 255);
			
			this.SalesFusion.AccountOperations.Update(obj);
			obj = this.SalesFusion.AccountOperations.GetById(this.id);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id.Value              ;
			this.updated_date     = obj.updated_date.Value    ;
		}

		public override string Insert()
		{
			this.id = 0;
			
			Spring.Social.SalesFusion.Api.Account obj = new Spring.Social.SalesFusion.Api.Account();
			obj.owner_id              = this.owner_id          ;
			obj.crm_id                = this.LOCAL_ID.ToString();
			obj.account_name          = MaxLength(this.account_name      , 255);
			obj.account_number        = MaxLength(this.account_number    , 255);
			obj.phone                 = MaxLength(this.phone             , 255);
			obj.fax                   = MaxLength(this.fax               , 255);
			obj.billing_street        = MaxLength(this.billing_address   , 255);
			obj.billing_city          = MaxLength(this.billing_city      , 255);
			obj.billing_state         = MaxLength(this.billing_state     , 255);
			obj.billing_zip           = MaxLength(this.billing_zip       ,  10);
			obj.billing_country       = MaxLength(this.billing_country   , 255);
			obj.shipping_street       = MaxLength(this.shipping_address  , 255);
			obj.shipping_city         = MaxLength(this.shipping_city     , 255);
			obj.shipping_state        = MaxLength(this.shipping_state    , 255);
			obj.shipping_zip          = MaxLength(this.shipping_zip      ,  10);
			obj.shipping_country      = MaxLength(this.shipping_country  , 255);
			obj.url                   = MaxLength(this.website           , 255);
			obj.industry              = MaxLength(this.industry          ,  80);
			obj.type                  = MaxLength(this.type              ,  40);
			obj.rating                = MaxLength(this.rating            ,  40);
			obj.sic                   = MaxLength(this.sic               , 255);
			obj.description           = MaxLength(this.description       , 255);

			obj = this.SalesFusion.AccountOperations.Insert(obj);
			// 04/28/2015 Paul.  Insert does not return the last modified date. Get the record again. 
			obj = this.SalesFusion.AccountOperations.GetById(obj.id.Value);
			this.RawContent       = obj.RawContent            ;
			this.id               = obj.id.Value              ;
			this.updated_date     = obj.updated_date.Value    ;
			return this.id.ToString();
		}

		public override void Delete()
		{
			this.SalesFusion.AccountOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.SalesFusion.Api.Account obj = this.SalesFusion.AccountOperations.GetById(Sql.ToInteger(sID));
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
			// 05/19/2015 Paul.  The email is treated as a primary key. 
			Sql.AppendParameter(cmd, Sql.ToString(this.name), "NAME");
		}

		// 02/03/2015 Paul.  It would be helpful to track changes. 
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
							case "NAME"                       :  oValue = Sql.ToDBString (this.account_name           );  break;
							case "ACCOUNT_NUMBER"             :  oValue = Sql.ToDBString (this.account_number         );  break;
							case "PHONE_OFFICE"               :  oValue = Sql.ToDBString (this.phone                  );  break;
							case "PHONE_FAX"                  :  oValue = Sql.ToDBString (this.fax                    );  break;
							case "BILLING_ADDRESS_STREET"     :  oValue = Sql.ToDBString (this.billing_address        );  break;
							case "BILLING_ADDRESS_CITY"       :  oValue = Sql.ToDBString (this.billing_city           );  break;
							case "BILLING_ADDRESS_STATE"      :  oValue = Sql.ToDBString (this.billing_state          );  break;
							case "BILLING_ADDRESS_POSTALCODE" :  oValue = Sql.ToDBString (this.billing_zip            );  break;
							case "BILLING_ADDRESS_COUNTRY"    :  oValue = Sql.ToDBString (this.billing_country        );  break;
							case "SHIPPING_ADDRESS_STREET"    :  oValue = Sql.ToDBString (this.shipping_address       );  break;
							case "SHIPPING_ADDRESS_CITY"      :  oValue = Sql.ToDBString (this.shipping_city          );  break;
							case "SHIPPING_ADDRESS_STATE"     :  oValue = Sql.ToDBString (this.shipping_state         );  break;
							case "SHIPPING_ADDRESS_POSTALCODE":  oValue = Sql.ToDBString (this.shipping_zip           );  break;
							case "SHIPPING_ADDRESS_COUNTRY"   :  oValue = Sql.ToDBString (this.shipping_country       );  break;
							case "WEBSITE"                    :  oValue = Sql.ToDBString (this.website                );  break;
							case "INDUSTRY"                   :  oValue = Sql.ToDBString (this.industry               );  break;
							case "ACCOUNT_TYPE"               :  oValue = Sql.ToDBString (this.type                   );  break;
							case "RATING"                     :  oValue = Sql.ToDBString (this.rating                 );  break;
							case "SIC_CODE"                   :  oValue = Sql.ToDBString (this.sic                    );  break;
							case "DESCRIPTION"                :  oValue = Sql.ToDBString (this.description            );  break;
							case "ASSIGNED_USER_ID"           :  oValue = Sql.ToDBGuid   (     gOWNER_USER_ID         );  break;
							case "MODIFIED_USER_ID"           :  oValue = gUSER_ID                                     ;  break;
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						// 02/17/2015 Paul.  Modified User ID does not count as a changed field. 
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "NAME"                       :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "ACCOUNT_NUMBER"             :  bChanged = ParameterChanged(par, oValue,   30, sbChanges);  break;
									case "PHONE_OFFICE"               :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_FAX"                  :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "BILLING_ADDRESS_STREET"     :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "BILLING_ADDRESS_CITY"       :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "BILLING_ADDRESS_STATE"      :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "BILLING_ADDRESS_POSTALCODE" :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "BILLING_ADDRESS_COUNTRY"    :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "SHIPPING_ADDRESS_STREET"    :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "SHIPPING_ADDRESS_CITY"      :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "SHIPPING_ADDRESS_STATE"     :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "SHIPPING_ADDRESS_POSTALCODE":  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "SHIPPING_ADDRESS_COUNTRY"   :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "WEBSITE"                    :  bChanged = ParameterChanged(par, oValue,  255, sbChanges);  break;
									case "INDUSTRY"                   :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "ACCOUNT_TYPE"               :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "RATING"                     :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "SIC_CODE"                   :  bChanged = ParameterChanged(par, oValue,   10, sbChanges);  break;
									case "DESCRIPTION"                :  bChanged = ParameterChanged(par, oValue, 4000, sbChanges);  break;
									case "ASSIGNED_USER_ID"           :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
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
