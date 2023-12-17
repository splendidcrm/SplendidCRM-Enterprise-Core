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

namespace Spring.Social.Etsy
{
	public class Item : QObject
	{
		#region Properties
		public string   Type                       ;
		public string   IncomeAccount              ;
		public string   Description                ;
		public Decimal  UnitPrice                  ;
		public bool     Active                     ;
		public Decimal  PurchaseCost               ;
		public Decimal  QtyOnHand                  ;
		public bool     Taxable                    ;
		#endregion
		protected DataView vwProductTypes;

		public Item(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.Etsy.Api.IEtsy shopify, DataTable dtProductTypes)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, shopify, "Items", "Name", "ProductTemplates", "PRODUCT_TEMPLATES", "NAME", false, false, false)
		{
			this.vwProductTypes = new DataView(dtProductTypes);
		}

		public override void Reset()
		{
			base.Reset();
			this.Type                 = String.Empty;
			this.IncomeAccount        = String.Empty;
			this.Description          = String.Empty;
			this.UnitPrice            = 0           ;
			this.Active               = false       ;
			this.PurchaseCost         = 0           ;
			this.QtyOnHand            = 0           ;
			this.Taxable              = false       ;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			this.ID       = sID;
			this.LOCAL_ID = Sql.ToGuid(row["ID"]);
			bool   bTaxable  = (Sql.ToString(row["TAX_CLASS"]) == "Taxable"  );
			bool   bActive   = (Sql.ToString(row["STATUS"   ]) == "Available");
			if ( Sql.IsEmptyString(this.ID) )
			{
				// 03/23/2015 Paul.  Change from MFT_PART_NUM begin the primary field to NAME being the primary field. 
				this.Name                 = Sql.MaxLength(Sql.ToString (row["NAME"              ]),  100);
				this.Type                 =               Sql.ToString (row["TYPE_NAME"         ]);
				this.IncomeAccount        =               Sql.ToString (row["ETSY_ACCOUNT"]);
				this.Description          = Sql.MaxLength(Sql.ToString (row["DESCRIPTION"       ]), 4000);
				this.UnitPrice            =               Sql.ToDecimal(row["DISCOUNT_PRICE"    ]);
				this.Active               =               Sql.ToBoolean(bActive                  );
				this.PurchaseCost         =               Sql.ToDecimal(row["COST_PRICE"        ]);
				this.QtyOnHand            =               Sql.ToDecimal(row["QUANTITY"          ]);
				this.Taxable              =               bTaxable;
				bChanged = true;
			}
			else
			{
				// 03/23/2015 Paul.  Change from MFT_PART_NUM begin the primary field to NAME being the primary field. 
				if ( Compare(this.Name          , Sql.MaxLength(Sql.ToString (row["NAME"              ]),  100), "NAME"              , sbChanges) ) { this.Name           = Sql.MaxLength(Sql.ToString (row["NAME"              ]),  100);  bChanged = true; }
				if ( Compare(this.Type          ,               Sql.ToString (row["TYPE_NAME"         ])       , "TYPE_NAME"         , sbChanges) ) { this.Type           =               Sql.ToString (row["TYPE_NAME"         ])       ;  bChanged = true; }
				if ( Compare(this.IncomeAccount ,               Sql.ToString (row["ETSY_ACCOUNT"])       , "ETSY_ACCOUNT", sbChanges) ) { this.IncomeAccount  =               Sql.ToString (row["ETSY_ACCOUNT"])       ;  bChanged = true; }
				if ( Compare(this.Description   , Sql.MaxLength(Sql.ToString (row["DESCRIPTION"       ]), 4000), "DESCRIPTION"       , sbChanges) ) { this.Description    = Sql.MaxLength(Sql.ToString (row["DESCRIPTION"       ]), 4000);  bChanged = true; }
				if ( Compare(this.UnitPrice     ,               Sql.ToDecimal(row["DISCOUNT_PRICE"    ])       , "DISCOUNT_PRICE"    , sbChanges) ) { this.UnitPrice      =               Sql.ToDecimal(row["DISCOUNT_PRICE"    ])       ;  bChanged = true; }
				if ( Compare(this.Active        ,               Sql.ToBoolean(    bActive              )       , "STATUS"            , sbChanges) ) { this.Active         =               Sql.ToBoolean(     bActive             )       ;  bChanged = true; }
				if ( Compare(this.PurchaseCost  ,               Sql.ToDecimal(row["COST_PRICE"        ])       , "COST_PRICE"        , sbChanges) ) { this.PurchaseCost   =               Sql.ToDecimal(row["COST_PRICE"        ])       ;  bChanged = true; }
				if ( Compare(this.QtyOnHand     ,               Sql.ToDecimal(row["QUANTITY"          ])       , "QUANTITY"          , sbChanges) ) { this.QtyOnHand      =               Sql.ToDecimal(row["QUANTITY"          ])       ;  bChanged = true; }
				if ( Compare(this.Taxable       ,               bTaxable                                       , "TAX_CLASS"         , sbChanges) ) { this.Taxable        =               bTaxable                                       ;  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromEtsy(string sId)
		{
			this.Reset();
			Spring.Social.Etsy.Api.Product obj = this.shopify.ProductOperations.GetById(sId);
			this.RawContent    = obj.RawContent           ;
			this.ID            = obj.Id                   ;
			this.TimeCreated   = obj.TimeCreated          ;
			this.TimeModified  = obj.TimeModified         ;
			this.Name          = obj.Name                 ;
			this.Description   = obj.Description          ;
			//this.Type          = obj.TypeValue            ;
			//this.IncomeAccount = obj.IncomeAccountRefValue;
			//this.UnitPrice     = obj.UnitPriceValue       ;
			//this.Active        = obj.ActiveValue          ;
			//this.PurchaseCost  = obj.PurchaseCostValue    ;
			//this.QtyOnHand     = obj.QtyOnHandValue       ;
			//this.Taxable       = obj.TaxableValue         ;
			//this.ManPartNum    = obj.ManPartNum   ;
		}

		public override void Update()
		{
			Spring.Social.Etsy.Api.Product obj = this.shopify.ProductOperations.GetById(this.ID);
			obj.Id                    = this.ID           ;
			obj.Name                  = Sql.Truncate(this.Name       ,  100);
			obj.Description           = Sql.Truncate(this.Description, 4000);
			//obj.TypeValue             = this.Type         ;
			// 03/21/2015 Paul.  With the initial sync, the CRM IncomeAccount may be blank and the update would get rejected, so keep the IncomeAccount. 
			//if ( Sql.IsEmptyString(this.IncomeAccount) )
			//	obj.IncomeAccountRefValue = this.IncomeAccount;
			//obj.UnitPriceValue        = this.UnitPrice    ;
			//obj.ActiveValue           = this.Active       ;
			//obj.PurchaseCostValue     = this.PurchaseCost ;
			//obj.QtyOnHandValue        = this.QtyOnHand    ;
			//obj.TaxableValue          = this.Taxable      ;
			//obj.ManPartNum            = this.ManPartNum   ;
			
			obj = this.shopify.ProductOperations.Update(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.TimeModified;
		}

		public override string Insert()
		{
			this.ID = String.Empty;
			
			Spring.Social.Etsy.Api.Product obj = new Spring.Social.Etsy.Api.Product();
			obj.Id                    = this.ID           ;
			obj.Name                  = Sql.Truncate(this.Name       ,  100);
			obj.Description           = Sql.Truncate(this.Description, 4000);
			//obj.TypeValue             = this.Type         ;
			//obj.IncomeAccountRefValue = this.IncomeAccount;
			//obj.UnitPriceValue        = this.UnitPrice    ;
			//obj.ActiveValue           = this.Active       ;
			//obj.PurchaseCostValue     = this.PurchaseCost ;
			//obj.QtyOnHandValue        = this.QtyOnHand    ;
			//obj.TaxableValue          = this.Taxable      ;
			//obj.ManPartNum            = this.ManPartNum   ;
			
			obj = this.shopify.ProductOperations.Insert(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.TimeModified;
			return this.ID;
		}

		public override void Delete()
		{
			this.shopify.ProductOperations.Delete(this.ID);
		}

		public override void Get(string sID)
		{
			IList<Spring.Social.Etsy.Api.Product> lst = this.shopify.ProductOperations.GetAll("Id = '" + sID + "'");
			if ( lst.Count > 0 )
			{
				this.SetFromEtsy(lst[0].Id);
			}
			else
			{
				this.Deleted = true;
			}
		}

		public override IList<Spring.Social.Etsy.Api.QBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.Etsy.Api.Product> products = this.shopify.ProductOperations.GetModified(dtStartModifiedDate);
			List<Spring.Social.Etsy.Api.QBase> lst = new List<Spring.Social.Etsy.Api.QBase>();
			foreach ( Spring.Social.Etsy.Api.Product product in products )
			{
				lst.Add(product);
			}
			return lst;
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			Sql.AppendParameter(cmd, Sql.ToString(this.Name), "NAME");
		}

		// 02/03/2015 Paul.  It would be helpful to track changes. 
		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = this.InitUpdateProcedure(spUpdate, row, gUSER_ID, gTEAM_ID);
			
			Guid gTYPE_ID = Guid.Empty;
			vwProductTypes.RowFilter = "NAME = '" + Sql.EscapeSQL(this.Type) + "'";
			if ( vwProductTypes.Count > 0 )
			{
				gTYPE_ID = Sql.ToGuid(vwProductTypes[0]["ID"]);
			}
			else
			{
				// 05/22/2012 Paul.  If the product type does not existing the CRM, then add it. 
				gTYPE_ID = Guid.NewGuid();
				IDbCommand cmdPRODUCT_TYPES_Update = SqlProcs.cmdPRODUCT_TYPES_Update(trn.Connection);
				cmdPRODUCT_TYPES_Update.Transaction = trn;
				Sql.SetParameter(cmdPRODUCT_TYPES_Update, "@ID"              , gTYPE_ID            );
				Sql.SetParameter(cmdPRODUCT_TYPES_Update, "@MODIFIED_USER_ID", gUSER_ID            );
				Sql.SetParameter(cmdPRODUCT_TYPES_Update, "@NAME"            , this.Type           );
				Sql.SetParameter(cmdPRODUCT_TYPES_Update, "@DESCRIPTION"     , this.Type           );
				Sql.SetParameter(cmdPRODUCT_TYPES_Update, "@LIST_ORDER"      , vwProductTypes.Count);
				cmdPRODUCT_TYPES_Update.ExecuteNonQuery();
				
				DataRow rowPRODUCT_TYPE = vwProductTypes.Table.NewRow();
				rowPRODUCT_TYPE["ID"  ] = gTYPE_ID ;
				rowPRODUCT_TYPE["NAME"] = this.Type;
				vwProductTypes.Table.Rows.Add(rowPRODUCT_TYPE);
			}
			
			foreach(IDbDataParameter par in spUpdate.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
				string sColumnName = Sql.ExtractDbName(spUpdate, par.ParameterName).ToUpper();
				if ( acl.IsWriteable() )
				{
					try
					{
						// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
						object oValue = null;
						switch ( sColumnName )
						{
							case "TYPE_ID"           :  oValue = Sql.ToDBGuid   (     gTYPE_ID            );  break;
							case "ETSY_ACCOUNT":  oValue = Sql.ToDBString (this.IncomeAccount       );  break;
							// 03/23/2015 Paul.  Change from MFT_PART_NUM begin the primary field to NAME being the primary field. 
							case "NAME"              :  oValue = Sql.ToDBString (this.Name                );  break;
							case "DESCRIPTION"       :  oValue = Sql.ToDBString (this.Description         );  break;
							case "LIST_PRICE"        :  oValue = Sql.ToDBDecimal(this.UnitPrice           );  break;
							case "DISCOUNT_PRICE"    :  oValue = Sql.ToDBDecimal(this.UnitPrice           );  break;
							case "STATUS"            :  oValue = Sql.ToDBString (this.Active   ? "Available" : "Unavailable");  break;
							case "COST_PRICE"        :  oValue = Sql.ToDBDecimal(this.PurchaseCost        );  break;
							case "QUANTITY"          :  oValue = Sql.ToDBDecimal(this.QtyOnHand           );  break;
							case "TAX_CLASS"         :  oValue = Sql.ToDBString (this.Taxable ? "Taxable" : "Non-Taxable");  break;
							case "MODIFIED_USER_ID"  :  oValue = gUSER_ID                                  ;  break;
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						// 02/17/2015 Paul.  Modified User ID does not count as a changed field. 
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "NAME"              :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "DESCRIPTION"       :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "ETSY_ACCOUNT":  bChanged = ParameterChanged(par, oValue,   50, sbChanges);  break;
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
