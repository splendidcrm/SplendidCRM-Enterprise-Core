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
	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/taxcode
	[Serializable]
	public class TaxCode : QBase
	{
		#region Properties
		public String                    Name                          { get; set; }  // 100 chars. 
		public String                    Description                   { get; set; }  // 100 chars. 
		public Boolean?                  Active                        { get; set; }
		public Boolean?                  Taxable                       { get; set; }
		public Boolean?                  TaxGroup                      { get; set; }
		public TaxRateRefList            SalesTaxRateList              { get; set; }
		public TaxRateRefList            PurchaseTaxRateList           { get; set; }

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

		public bool TaxGroupValue
		{
			get
			{
				return this.TaxGroup.HasValue ? this.TaxGroup.Value : false;
			}
			set
			{
				this.TaxGroup = value;
			}
		}

		public string TaxRateRefValue
		{
			get
			{
				string sValue = String.Empty;
				if ( this.SalesTaxRateList != null && this.SalesTaxRateList.TaxRateDetail != null && this.SalesTaxRateList.TaxRateDetail.Count > 0 )
				{
					sValue = this.SalesTaxRateList.TaxRateDetail[0].TaxRateRefValue;
				}
				return sValue;
			}
			set
			{
				if ( this.SalesTaxRateList                     == null ) this.SalesTaxRateList = new TaxRateRefList();
				if ( this.SalesTaxRateList.TaxRateDetail       == null ) this.SalesTaxRateList.TaxRateDetail = new List<TaxRateDetail>();
				if ( this.SalesTaxRateList.TaxRateDetail.Count == 0    ) this.SalesTaxRateList.TaxRateDetail.Add(new TaxRateDetail());
				this.SalesTaxRateList.TaxRateDetail[0].TaxRateRefValue = value;
			}
		}
		#endregion

		public TaxCode()
		{
			this.Active   = true;
			this.Taxable  = true;
			this.TaxGroup = true;
		}

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
			dt.Columns.Add("Taxable"       , Type.GetType("System.Boolean" ));
			dt.Columns.Add("TaxGroup"      , Type.GetType("System.Boolean" ));
			dt.Columns.Add("TaxRateRef"    , Type.GetType("System.String"  ));
			dt.Columns.Add("TaxCodeTaxRate", Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.Id               != null            ) row["Id"            ] = Sql.ToDBString  (this.Id                            );
			if ( this.SyncToken        != null            ) row["SyncToken"     ] = Sql.ToDBString  (this.SyncToken                     );
			if ( this.MetaData         != null            ) row["TimeCreated"   ] = Sql.ToDBDateTime(this.MetaData.CreateTime           );
			if ( this.MetaData         != null            ) row["TimeModified"  ] = Sql.ToDBDateTime(this.MetaData.LastUpdatedTime      );
			if ( this.Name             != null            ) row["Name"          ] = Sql.ToDBString  (this.Name                          );
			if ( this.Description      != null            ) row["Description"   ] = Sql.ToDBString  (this.Description                   );
			if ( this.Active           .HasValue          ) row["Active"        ] = Sql.ToDBBoolean (this.Active                  .Value);
			if ( this.Taxable          .HasValue          ) row["Taxable"       ] = Sql.ToDBBoolean (this.Taxable                 .Value);
			if ( this.TaxGroup         .HasValue          ) row["TaxGroup"      ] = Sql.ToDBBoolean (this.TaxGroup                .Value);
			string sTaxRateId = this.TaxRateRefValue;
			row["TaxRateRef"    ] = Sql.ToDBString(sTaxRateId);
			row["TaxCodeTaxRate"] = Sql.ToString(this.Id) + (Sql.IsEmptyString(sTaxRateId) ? String.Empty : "," + sTaxRateId);
		}

		public static DataRow ConvertToRow(TaxCode obj)
		{
			DataTable dt = TaxCode.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<TaxCode> taxCodes)
		{
			DataTable dt = TaxCode.CreateTable();
			if ( taxCodes != null )
			{
				foreach ( TaxCode taxCode in taxCodes )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					taxCode.SetRow(row);
				}
			}
			return dt;
		}
	}
}
