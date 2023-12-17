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
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Collections.Specialized;
using Spring.Json;

namespace Spring.Social.QuickBooks.Api
{
	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/item
	[Serializable]
	public class Item : QBase
	{
		#region Properties
		public String                    Name                          { get; set; }  //  100 chars.
		public String                    Description                   { get; set; }  // 4000 chars. 
		public Boolean?                  Active                        { get; set; }
		public Boolean?                  SubItem                       { get; set; }
		public ReferenceType             ParentRef                     { get; set; }
		public int?                      Level                         { get; set; }
		public String                    FullyQualifiedName            { get; set; }
		public Boolean?                  Taxable                       { get; set; }
		public Boolean?                  SalesTaxIncluded              { get; set; }
		public Decimal?                  UnitPrice                     { get; set; }
		public Decimal?                  RatePercent                   { get; set; }
		public ItemTypeEnum?             Type                          { get; set; }
		public ReferenceType             IncomeAccountRef              { get; set; }
		public String                    PurchaseDesc                  { get; set; }  // 1000 chars. 
		public Boolean?                  PurchaseTaxIncluded           { get; set; }
		public Decimal?                  PurchaseCost                  { get; set; }
		public ReferenceType             ExpenseAccountRef             { get; set; }
		public ReferenceType             AssetAccountRef               { get; set; }
		public Boolean?                  TrackQtyOnHand                { get; set; }
		public Decimal?                  QtyOnHand                     { get; set; }
		public ReferenceType             SalesTaxCodeRef               { get; set; }
		public ReferenceType             PurchaseTaxCodeRef            { get; set; }
		public DateTime?                 InvStartDate                  { get; set; }

		public bool ActiveValue
		{
			get
			{
				return this.Active.HasValue ? this.Active.Value : false;
			}
			set
			{
				this.Active = value;
			}
		}

		public bool TaxableValue
		{
			get
			{
				return this.Taxable.HasValue ? this.Taxable.Value : false;
			}
			set
			{
				this.Taxable = value;
			}
		}

		public Decimal UnitPriceValue
		{
			get
			{
				return this.UnitPrice.HasValue ? this.UnitPrice.Value : 0;
			}
			set
			{
				this.UnitPrice = value;
			}
		}

		public Decimal PurchaseCostValue
		{
			get
			{
				return this.PurchaseCost.HasValue ? this.PurchaseCost.Value : 0;
			}
			set
			{
				this.PurchaseCost = value;
			}
		}

		public Decimal QtyOnHandValue
		{
			get
			{
				return this.QtyOnHand.HasValue ? this.QtyOnHand.Value : 0;
			}
			set
			{
				this.QtyOnHand = value;
			}
		}

		public string ParentRefValue
		{
			get
			{
				return this.ParentRef == null ? String.Empty : this.ParentRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.ParentRef = new ReferenceType(value);
				else
					this.ParentRef = null;
			}
		}

		public string IncomeAccountRefValue
		{
			get
			{
				return this.IncomeAccountRef == null ? String.Empty : this.IncomeAccountRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.IncomeAccountRef = new ReferenceType(value);
				else
					this.IncomeAccountRef = null;
			}
		}

		public string ExpenseAccountRefValue
		{
			get
			{
				return this.ExpenseAccountRef == null ? String.Empty : this.ExpenseAccountRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.ExpenseAccountRef = new ReferenceType(value);
				else
					this.ExpenseAccountRef = null;
			}
		}

		public string AssetAccountRefValue
		{
			get
			{
				return this.AssetAccountRef == null ? String.Empty : this.AssetAccountRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.AssetAccountRef = new ReferenceType(value);
				else
					this.AssetAccountRef = null;
			}
		}

		public string SalesTaxCodeRefValue
		{
			get
			{
				return this.SalesTaxCodeRef == null ? String.Empty : this.SalesTaxCodeRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.SalesTaxCodeRef = new ReferenceType(value);
				else
					this.SalesTaxCodeRef = null;
			}
		}

		public string PurchaseTaxCodeRefValue
		{
			get
			{
				return this.PurchaseTaxCodeRef == null ? String.Empty : this.PurchaseTaxCodeRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.PurchaseTaxCodeRef = new ReferenceType(value);
				else
					this.PurchaseTaxCodeRef = null;
			}
		}

		public string TypeValue
		{
			get
			{
				return (this.Type == null || !this.Type.HasValue) ? String.Empty : this.Type.Value.ToString();
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.Type = Spring.Social.QuickBooks.Api.Impl.Json._EnumDeserializer.DeserializeItemType(new Spring.Json.JsonValue(value));
				else
					this.Type = null;
			}
		}
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("Id"                           , System.Type.GetType("System.Int64"   ));
			dt.Columns.Add("SyncToken"                    , System.Type.GetType("System.Int64"   ));
			dt.Columns.Add("TimeCreated"                  , System.Type.GetType("System.DateTime"));
			dt.Columns.Add("TimeModified"                 , System.Type.GetType("System.DateTime"));
			dt.Columns.Add("Name"                         , System.Type.GetType("System.String"  ));
			dt.Columns.Add("Description"                  , System.Type.GetType("System.String"  ));
			dt.Columns.Add("Active"                       , System.Type.GetType("System.Boolean" ));
			dt.Columns.Add("SubItem"                      , System.Type.GetType("System.Boolean" ));
			dt.Columns.Add("Parent"                       , System.Type.GetType("System.String"  ));
			dt.Columns.Add("Level"                        , System.Type.GetType("System.Int32"   ));
			dt.Columns.Add("FullyQualifiedName"           , System.Type.GetType("System.String"  ));
			dt.Columns.Add("Taxable"                      , System.Type.GetType("System.Boolean" ));
			dt.Columns.Add("SalesTaxIncluded"             , System.Type.GetType("System.Boolean" ));
			dt.Columns.Add("UnitPrice"                    , System.Type.GetType("System.Decimal" ));
			dt.Columns.Add("RatePercent"                  , System.Type.GetType("System.Decimal" ));
			dt.Columns.Add("Type"                         , System.Type.GetType("System.String"  ));
			dt.Columns.Add("PaymentMethod"                , System.Type.GetType("System.String"  ));
			dt.Columns.Add("UOMSet"                       , System.Type.GetType("System.String"  ));
			dt.Columns.Add("IncomeAccount"                , System.Type.GetType("System.String"  ));
			dt.Columns.Add("PurchaseDesc"                 , System.Type.GetType("System.String"  ));
			dt.Columns.Add("PurchaseTaxIncluded"          , System.Type.GetType("System.Boolean" ));
			dt.Columns.Add("PurchaseCost"                 , System.Type.GetType("System.Decimal" ));
			dt.Columns.Add("ExpenseAccount"               , System.Type.GetType("System.String"  ));
			dt.Columns.Add("COGSAccount"                  , System.Type.GetType("System.String"  ));
			dt.Columns.Add("AssetAccount"                 , System.Type.GetType("System.String"  ));
			dt.Columns.Add("PrefVendor"                   , System.Type.GetType("System.String"  ));
			dt.Columns.Add("TrackQtyOnHand"               , System.Type.GetType("System.Boolean" ));
			dt.Columns.Add("QtyOnHand"                    , System.Type.GetType("System.Decimal" ));
			dt.Columns.Add("SalesTaxCode"                 , System.Type.GetType("System.String"  ));
			dt.Columns.Add("PurchaseTaxCode"              , System.Type.GetType("System.String"  ));
			dt.Columns.Add("InvStartDate"                 , System.Type.GetType("System.DateTime"));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.Id                      != null   ) row["Id"                     ] = Sql.ToDBString  (this.Id                        );
			if ( this.SyncToken               != null   ) row["SyncToken"              ] = Sql.ToDBString  (this.SyncToken                 );
			if ( this.MetaData                != null   ) row["TimeCreated"            ] = Sql.ToDBDateTime(this.MetaData.CreateTime       );
			if ( this.MetaData                != null   ) row["TimeModified"           ] = Sql.ToDBDateTime(this.MetaData.LastUpdatedTime  );
			if ( this.Name                    != null   ) row["Name"                   ] = Sql.ToDBString  (this.Name                      );
			if ( this.Description             != null   ) row["Description"            ] = Sql.ToDBString  (this.Description               );
			if ( this.Active                  .HasValue ) row["Active"                 ] = Sql.ToDBBoolean (this.Active              .Value);
			if ( this.SubItem                 .HasValue ) row["SubItem"                ] = Sql.ToDBBoolean (this.SubItem             .Value);
			if ( this.ParentRef               != null   ) row["Parent"                 ] = Sql.ToDBString  (this.ParentRef           .Value);
			if ( this.Level                   .HasValue ) row["Level"                  ] = Sql.ToDBInteger (this.Level               .Value);
			if ( this.FullyQualifiedName      != null   ) row["FullyQualifiedName"     ] = Sql.ToDBString  (this.FullyQualifiedName        );
			if ( this.Taxable                 .HasValue ) row["Taxable"                ] = Sql.ToDBBoolean (this.Taxable             .Value);
			if ( this.SalesTaxIncluded        .HasValue ) row["SalesTaxIncluded"       ] = Sql.ToDBBoolean (this.SalesTaxIncluded    .Value);
			if ( this.UnitPrice               .HasValue ) row["UnitPrice"              ] = Sql.ToDBDecimal (this.UnitPrice           .Value);
			if ( this.RatePercent             .HasValue ) row["RatePercent"            ] = Sql.ToDBDecimal (this.RatePercent         .Value);
			if ( this.Type                    .HasValue ) row["Type"                   ] = Sql.ToDBString  (this.Type                .Value);
			if ( this.IncomeAccountRef        != null   ) row["IncomeAccount"          ] = Sql.ToDBString  (this.IncomeAccountRef    .Value);
			if ( this.PurchaseDesc            != null   ) row["PurchaseDesc"           ] = Sql.ToDBString  (this.PurchaseDesc              );
			if ( this.PurchaseTaxIncluded     .HasValue ) row["PurchaseTaxIncluded"    ] = Sql.ToDBBoolean (this.PurchaseTaxIncluded .Value);
			if ( this.PurchaseCost            .HasValue ) row["PurchaseCost"           ] = Sql.ToDBDecimal (this.PurchaseCost        .Value);
			if ( this.ExpenseAccountRef       != null   ) row["ExpenseAccount"         ] = Sql.ToDBString  (this.ExpenseAccountRef   .Value);
			if ( this.AssetAccountRef         != null   ) row["AssetAccount"           ] = Sql.ToDBString  (this.AssetAccountRef     .Value);
			if ( this.TrackQtyOnHand          .HasValue ) row["TrackQtyOnHand"         ] = Sql.ToDBBoolean (this.TrackQtyOnHand      .Value);
			if ( this.QtyOnHand               .HasValue ) row["QtyOnHand"              ] = Sql.ToDBDecimal (this.QtyOnHand           .Value);
			if ( this.SalesTaxCodeRef         != null   ) row["SalesTaxCode"           ] = Sql.ToDBString  (this.SalesTaxCodeRef     .Value);
			if ( this.PurchaseTaxCodeRef      != null   ) row["PurchaseTaxCode"        ] = Sql.ToDBString  (this.PurchaseTaxCodeRef  .Value);
			if ( this.InvStartDate            .HasValue ) row["InvStartDate"           ] = Sql.ToDBDateTime(this.InvStartDate        .Value);
		}

		public static DataRow ConvertToRow(Item obj)
		{
			DataTable dt = Item.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Item> items)
		{
			DataTable dt = Item.CreateTable();
			if ( items != null )
			{
				foreach ( Item item in items )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					item.SetRow(row);
				}
			}
			return dt;
		}
	}
}
