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

namespace Spring.Social.QuickBooks.Api
{
	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/invoice#Line_Details
	[Serializable]
	public class Line
	{
		#region Properties
		public String                    RawContent                        { get; set; }
		public String                    Id                                { get; set; }
		public String                    LineNum                           { get; set; }
		public String                    Description                       { get; set; }  // 4000 chars. 
		public Decimal?                  Amount                            { get; set; }
		public IList<LinkedTxn>          LinkedTxn                         { get; set; }
		public LineDetailTypeEnum?       DetailType                        { get; set; }
		public object                    Item                              { get; set; }
		//public IList<CustomField>        CustomField                       { get; set; }
		
		public Decimal AmountValue
		{
			get
			{
				if ( Amount.HasValue )
					return Amount.Value;
				return 0;
			}
			set
			{
				Amount = value;
			}
		}
		
		public Decimal Quantity
		{
			get
			{
				if ( this.DetailType == LineDetailTypeEnum.SalesItemLineDetail && this.Item is SalesItemLineDetail )
				{
					if ( (this.Item as SalesItemLineDetail).Qty.HasValue )
						return (this.Item as SalesItemLineDetail).Qty.Value;
				}
				return 0;
			}
			set
			{
				if ( this.Item == null || !(this.Item is SalesItemLineDetail) )
				{
					this.DetailType = LineDetailTypeEnum.SalesItemLineDetail;
					this.Item = new SalesItemLineDetail();
				}
				(this.Item as SalesItemLineDetail).Qty = value;
			}
		}
		
		public Decimal UnitPrice
		{
			get
			{
				if ( this.DetailType == LineDetailTypeEnum.SalesItemLineDetail && this.Item is SalesItemLineDetail )
				{
					if ( (this.Item as SalesItemLineDetail).UnitPrice.HasValue )
						return (this.Item as SalesItemLineDetail).UnitPrice.Value;
				}
				return 0;
			}
			set
			{
				if ( this.Item == null || !(this.Item is SalesItemLineDetail) )
				{
					this.DetailType = LineDetailTypeEnum.SalesItemLineDetail;
					this.Item = new SalesItemLineDetail();
				}
				(this.Item as SalesItemLineDetail).UnitPrice = value;
			}
		}
		
		public bool IsEmpty()
		{
			bool bIsEmpty = false;
			if ( this.DetailType == LineDetailTypeEnum.DescriptionOnly && this.Amount == null && String.IsNullOrEmpty(this.Description) && this.Item == null )
			{
				bIsEmpty = true;
			}
			return bIsEmpty;
		}

		public string TaxCode
		{
			get
			{
				if ( this.DetailType == LineDetailTypeEnum.SalesItemLineDetail && this.Item is SalesItemLineDetail )
				{
					if ( (this.Item as SalesItemLineDetail).TaxCodeRef != null )
						return (this.Item as SalesItemLineDetail).TaxCodeRef.Value;
				}
				return String.Empty;
			}
			set
			{
				if ( this.Item == null || !(this.Item is SalesItemLineDetail) )
				{
					this.DetailType = LineDetailTypeEnum.SalesItemLineDetail;
					this.Item = new SalesItemLineDetail();
				}
				(this.Item as SalesItemLineDetail).TaxCodeRef = new ReferenceType(value);
			}
		}
		
		public string ItemRefId
		{
			get
			{
				if ( this.DetailType == LineDetailTypeEnum.SalesItemLineDetail && this.Item is SalesItemLineDetail )
				{
					if ( (this.Item as SalesItemLineDetail).ItemRef != null )
						return (this.Item as SalesItemLineDetail).ItemRef.Value;
				}
				return String.Empty;
			}
			set
			{
				if ( this.Item == null || !(this.Item is SalesItemLineDetail) )
				{
					this.DetailType = LineDetailTypeEnum.SalesItemLineDetail;
					this.Item = new SalesItemLineDetail();
				}
				if ( (this.Item as SalesItemLineDetail).ItemRef == null )
					(this.Item as SalesItemLineDetail).ItemRef = new ReferenceType();
				(this.Item as SalesItemLineDetail).ItemRef.Value = value;
			}
		}
		
		public string ItemRefName
		{
			get
			{
				if ( this.DetailType == LineDetailTypeEnum.SalesItemLineDetail && this.Item is SalesItemLineDetail )
				{
					if ( (this.Item as SalesItemLineDetail).ItemRef != null )
						return (this.Item as SalesItemLineDetail).ItemRef.Name;
				}
				return String.Empty;
			}
			set
			{
				if ( this.Item == null || !(this.Item is SalesItemLineDetail) )
				{
					this.DetailType = LineDetailTypeEnum.SalesItemLineDetail;
					this.Item = new SalesItemLineDetail();
				}
				if ( (this.Item as SalesItemLineDetail).ItemRef == null )
					(this.Item as SalesItemLineDetail).ItemRef = new ReferenceType();
				(this.Item as SalesItemLineDetail).ItemRef.Name = value;
			}
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
			if ( this.Id           != null   ) row["Id"         ] = Sql.ToDBString  (this.Id               );
			if ( this.LineNum      != null   ) row["LineNum"    ] = Sql.ToDBString  (this.LineNum          );
			if ( this.Description  != null   ) row["Description"] = Sql.ToDBString  (this.Description      );
			if ( this.Amount       .HasValue ) row["Amount"     ] = Sql.ToDBDecimal (this.Amount     .Value);
			if ( this.DetailType   != null   ) row["DetailType" ] = Sql.ToDBString  (this.DetailType       );
			
			switch ( this.DetailType )
			{
				case LineDetailTypeEnum.PaymentLineDetail            :  break;
				case LineDetailTypeEnum.DiscountLineDetail           :  break;
				case LineDetailTypeEnum.TaxLineDetail                :  break;
				case LineDetailTypeEnum.ItemBasedExpenseLineDetail   :  break;
				case LineDetailTypeEnum.AccountBasedExpenseLineDetail:  break;
				case LineDetailTypeEnum.DepositLineDetail            :  break;
				case LineDetailTypeEnum.PurchaseOrderItemLineDetail  :  break;
				case LineDetailTypeEnum.ItemReceiptLineDetail        :  break;
				case LineDetailTypeEnum.JournalEntryLineDetail       :  break;
				case LineDetailTypeEnum.GroupLineDetail              :  break;
				case LineDetailTypeEnum.DescriptionOnly              :  break;
				case LineDetailTypeEnum.SubTotalLineDetail           :  break;
				case LineDetailTypeEnum.SalesOrderItemLineDetail     :  break;
				case LineDetailTypeEnum.SalesItemLineDetail          :
				{
					if ( this.Item is SalesItemLineDetail )
					{
						SalesItemLineDetail detail = this.Item as SalesItemLineDetail ;
						if ( detail.ItemRef    != null   ) row["ItemRefId"  ] = Sql.ToDBString (detail.ItemRef   .Value);
						if ( detail.Qty        .HasValue ) row["Quantity"   ] = Sql.ToDBDecimal(detail.Qty       .Value);
						if ( detail.UnitPrice  .HasValue ) row["UnitPrice"  ] = Sql.ToDBDecimal(detail.UnitPrice .Value);
						if ( detail.TaxCodeRef != null   ) row["TaxCode"    ] = Sql.ToDBString (detail.TaxCodeRef.Value);
					}
					break;
				}
			}
		}

		public static DataTable ConvertToTable(IList<Line> lines)
		{
			DataTable dt = Line.CreateTable();
			if ( lines != null )
			{
				foreach ( Line line in lines )
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
