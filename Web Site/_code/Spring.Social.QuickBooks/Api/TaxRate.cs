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
using System.Collections.Generic;
using System.Collections.Specialized;
using Spring.Json;

namespace Spring.Social.QuickBooks.Api
{
	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/taxrate
	[Serializable]
	public class TaxRate : QBase
	{
		#region Properties
		public String                    Name                          { get; set; }  // 100 chars. 
		public String                    Description                   { get; set; }  // 100 chars. 
		public Boolean?                  Active                        { get; set; }
		public Decimal?                  Rate                          { get; set; }
		public ReferenceType             AgencyRef                     { get; set; }
		public ReferenceType             TaxReturnLineRef              { get; set; }
		public SpecialTaxTypeEnum?       SpecialTaxType                { get; set; }
		public TaxRateDisplayTypeEnum?   DisplayType                   { get; set; }
		public IList<EffectiveTaxRate>   EffectiveTaxRate              { get; set; }

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

		public Decimal RateValue
		{
			get
			{
				return this.Rate.HasValue ? this.Rate.Value : 0;
			}
			set
			{
				this.Rate = value;
			}
		}

		public string AgencyRefValue
		{
			get
			{
				return this.AgencyRef == null ? String.Empty : this.AgencyRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.AgencyRef = new ReferenceType(value);
				else
					this.AgencyRef = null;
			}
		}

		public string TaxReturnLineRefValue
		{
			get
			{
				return this.TaxReturnLineRef == null ? String.Empty : this.TaxReturnLineRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.TaxReturnLineRef = new ReferenceType(value);
				else
					this.TaxReturnLineRef = null;
			}
		}

		public string SpecialTaxTypeValue
		{
			get
			{
				return (this.SpecialTaxType == null || !this.SpecialTaxType.HasValue) ? String.Empty : this.SpecialTaxType.Value.ToString();
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.SpecialTaxType = Spring.Social.QuickBooks.Api.Impl.Json._EnumDeserializer.DeserializeSpecialTaxType(new Spring.Json.JsonValue(value));
				else
					this.SpecialTaxType = null;
			}
		}

		public string DisplayTypeValue
		{
			get
			{
				return (this.DisplayType == null || !this.DisplayType.HasValue) ? String.Empty : this.DisplayType.Value.ToString();
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.DisplayType = Spring.Social.QuickBooks.Api.Impl.Json._EnumDeserializer.DeserializeTaxRateDisplayType(new Spring.Json.JsonValue(value));
				else
					this.DisplayType = null;
			}
		}

		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("Id"            , Type.GetType("System.String"  ));
			dt.Columns.Add("SyncToken"     , Type.GetType("System.Int64"   ));
			dt.Columns.Add("TimeCreated"   , Type.GetType("System.DateTime"));
			dt.Columns.Add("TimeModified"  , Type.GetType("System.DateTime"));
			dt.Columns.Add("Name"          , Type.GetType("System.String"  ));
			dt.Columns.Add("Description"   , Type.GetType("System.String"  ));
			dt.Columns.Add("Active"        , Type.GetType("System.Boolean" ));
			dt.Columns.Add("RateValue"     , Type.GetType("System.Decimal" ));
			dt.Columns.Add("Agency"        , Type.GetType("System.String"  ));
			dt.Columns.Add("TaxReturnLine" , Type.GetType("System.String"  ));
			dt.Columns.Add("SpecialTaxType", Type.GetType("System.String"  ));
			dt.Columns.Add("DisplayType"   , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.Id               != null   ) row["Id"            ] = Sql.ToDBString  (this.Id                            );
			if ( this.SyncToken        != null   ) row["SyncToken"     ] = Sql.ToDBString  (this.SyncToken                     );
			if ( this.MetaData         != null   ) row["TimeCreated"   ] = Sql.ToDBDateTime(this.MetaData.CreateTime           );
			if ( this.MetaData         != null   ) row["TimeModified"  ] = Sql.ToDBDateTime(this.MetaData.LastUpdatedTime      );
			if ( this.Name             != null   ) row["Name"          ] = Sql.ToDBString  (this.Name                          );
			if ( this.Description      != null   ) row["Description"   ] = Sql.ToDBString  (this.Description                   );
			if ( this.Active           .HasValue ) row["Active"        ] = Sql.ToDBBoolean (this.Active                  .Value);
			if ( this.Rate             .HasValue ) row["RateValue"     ] = Sql.ToDBDecimal (this.Rate                    .Value);
			if ( this.AgencyRef        != null   ) row["Agency"        ] = Sql.ToDBString  (this.AgencyRef               .Value);
			if ( this.TaxReturnLineRef != null   ) row["TaxReturnLine" ] = Sql.ToDBString  (this.TaxReturnLineRef        .Value);
			if ( this.SpecialTaxType   != null   ) row["SpecialTaxType"] = Sql.ToDBString  (this.SpecialTaxType                );
			if ( this.DisplayType      != null   ) row["DisplayType"   ] = Sql.ToDBString  (this.DisplayType                   );
		}

		public static DataRow ConvertToRow(TaxRate obj)
		{
			DataTable dt = TaxRate.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<TaxRate> taxRates)
		{
			DataTable dt = TaxRate.CreateTable();
			if ( taxRates != null )
			{
				foreach ( TaxRate taxRate in taxRates )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					taxRate.SetRow(row);
				}
			}
			return dt;
		}
	}
}
