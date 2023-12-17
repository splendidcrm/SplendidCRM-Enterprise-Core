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
using Spring.Json;

namespace Spring.Social.Shopify.Api
{
	[Serializable]
	public class LineItem
	{
		#region Properties
		public String                    RawContent                        { get; set; }
		public String                    id                                { get; set; }
		public String                    sku                               { get; set; }
		public String                    name                              { get; set; }
		public String                    title                             { get; set; }
		public String                    vendor                            { get; set; }
		public int                       currentQuantity                   { get; set; }
		public int                       quantity                          { get; set; }
		public bool                      requiresShipping                  { get; set; }
		public bool                      taxable                           { get; set; }
		public Image                     image                             { get; set; }
		public MoneyV2                   originalTotalSet                  { get; set; }   // shopMoney. 
		public MoneyV2                   originalUnitPriceSet              { get; set; }   // shopMoney. 
		public Product                   product                           { get; set; }
		public IList<TaxLine>            taxLines                          { get; set; }
		
		public bool IsEmpty()
		{
			bool bIsEmpty = false;
			if ( String.IsNullOrEmpty(this.id) && this.product == null )
			{
				bIsEmpty = true;
			}
			return bIsEmpty;
		}
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("Id"         , Type.GetType("System.String" ));
			dt.Columns.Add("ItemRefId"  , Type.GetType("System.String" ));
			dt.Columns.Add("LineNum"    , Type.GetType("System.String" ));
			dt.Columns.Add("Description", Type.GetType("System.String" ));
			dt.Columns.Add("Amount"     , Type.GetType("System.Decimal"));
			dt.Columns.Add("DetailType" , Type.GetType("System.String" ));
			dt.Columns.Add("Quantity"   , Type.GetType("System.Decimal"));
			dt.Columns.Add("UnitPrice"  , Type.GetType("System.Decimal"));
			dt.Columns.Add("TaxCode"    , Type.GetType("System.String" ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			//if ( this.Id           != null   ) row["Id"         ] = Sql.ToDBString  (this.Id               );
			//if ( this.LineNum      != null   ) row["LineNum"    ] = Sql.ToDBString  (this.LineNum          );
			//if ( this.Description  != null   ) row["Description"] = Sql.ToDBString  (this.Description      );
			//if ( this.Amount       .HasValue ) row["Amount"     ] = Sql.ToDBDecimal (this.Amount     .Value);
		}

		public static DataTable ConvertToTable(IList<LineItem> lines)
		{
			DataTable dt = LineItem.CreateTable();
			if ( lines != null )
			{
				foreach ( LineItem line in lines )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					line.SetRow(row);
				}
			}
			return dt;
		}
	}
}
