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

namespace Spring.Social.Etsy.Api
{
	[Serializable]
	public class Product : QBase
	{
		#region Properties
		// https://shopify.dev/api/admin-graphql/2022-01/objects/Product#fields
		public DateTime?             publishedAt      { get; set; }
		public String                title            { get; set; }
		public String                handle           { get; set; }
		public String                description      { get; set; }
		public String                descriptionHtml  { get; set; }
		public List<Image>           images           { get; set; }
		public String                productType      { get; set; }
		public String                status           { get; set; }
		public String                vendor           { get; set; }
		public int?                  totalInventory   { get; set; }
		public MoneyV2               maxVariantPrice  { get; set; }
		public MoneyV2               minVariantPrice  { get; set; }
		public Image                 featuredImage    { get; set; }
		public IList<String>         tags             { get; set; }
		#endregion

		public override string ToString()
		{
			StringBuilder sb = new StringBuilder();
			sb.AppendLine("Product");
			sb.AppendLine("   id               : " +  this.id               );
			sb.AppendLine("   cursor           : " +  this.cursor           );
			sb.AppendLine("   createdAt        : " + (this.createdAt        .HasValue ? this.createdAt  .Value.ToString() : String.Empty));
			sb.AppendLine("   updatedAt        : " + (this.updatedAt        .HasValue ? this.updatedAt  .Value.ToString() : String.Empty));
			sb.AppendLine("   publishedAt      : " + (this.publishedAt      .HasValue ? this.publishedAt.Value.ToString() : String.Empty));
			sb.AppendLine("   title            : " +  this.title            );
			sb.AppendLine("   handle           : " +  this.handle           );
			sb.AppendLine("   description      : " +  this.description      );
			sb.AppendLine("   descriptionHtml  : " +  this.descriptionHtml  );
			sb.AppendLine("   productType      : " +  this.productType      );
			sb.AppendLine("   status           : " +  this.status           );
			sb.AppendLine("   vendor           : " +  this.vendor           );
			sb.AppendLine("   totalInventory   : " + (this.totalInventory   .HasValue ? this.totalInventory.Value.ToString() : String.Empty));
			sb.AppendLine("   maxVariantPrice  : " + (this.maxVariantPrice  != null ? this.maxVariantPrice       .ToString() : String.Empty));
			sb.AppendLine("   minVariantPrice  : " + (this.minVariantPrice  != null ? this.minVariantPrice       .ToString() : String.Empty));
			sb.AppendLine("   featuredImage    : " + (this.featuredImage    != null ? this.featuredImage         .ToString() : "null"      ));
			sb.AppendLine("   tags             : " + (this.tags             != null ? this.tags                  .ToString() : "null"      ));
			return sb.ToString();
		}

		public string Name
		{
			get { return title; }
			set { title = value; }
		}

		public string Description
		{
			get { return description; }
			set { description = value; }
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("createdAt"               , Type.GetType("System.DateTime"));
			dt.Columns.Add("updatedAt"               , Type.GetType("System.DateTime"));
			dt.Columns.Add("publishedAt"             , Type.GetType("System.DateTime"));
			dt.Columns.Add("title"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("handle"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("description"             , Type.GetType("System.String"  ));
			dt.Columns.Add("descriptionHtml"         , Type.GetType("System.String"  ));
			dt.Columns.Add("productType"             , Type.GetType("System.String"  ));
			dt.Columns.Add("status"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("tags"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("vendor"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("totalInventory"          , Type.GetType("System.Int32"   ));
			dt.Columns.Add("maxVariantPrice"         , Type.GetType("System.Decimal" ));
			dt.Columns.Add("minVariantPrice"         , Type.GetType("System.Decimal" ));
			dt.Columns.Add("currencyCode"            , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id               != null   ) row["id"             ] = Sql.ToDBInteger (this.id                    );
			if ( this.createdAt        .HasValue ) row["createdAt"      ] = Sql.ToDBDateTime(this.createdAt       .Value);
			if ( this.updatedAt        .HasValue ) row["updatedAt"      ] = Sql.ToDBDateTime(this.updatedAt       .Value);
			if ( this.publishedAt      .HasValue ) row["publishedAt"    ] = Sql.ToDBDateTime(this.publishedAt     .Value);
			if ( this.title            != null   ) row["title"          ] = Sql.ToDBString  (this.title                 );
			if ( this.handle           != null   ) row["handle"         ] = Sql.ToDBString  (this.handle                );
			if ( this.description      != null   ) row["description"    ] = Sql.ToDBString  (this.description           );
			if ( this.descriptionHtml  != null   ) row["descriptionHtml"] = Sql.ToDBString  (this.descriptionHtml       );
			if ( this.productType      != null   ) row["productType"    ] = Sql.ToDBString  (this.productType           );
			if ( this.status           != null   ) row["status"         ] = Sql.ToDBString  (this.status                );
			if ( this.tags             != null   ) row["tags"           ] = Sql.ToDBString  (String.Join(",", this.tags));
			if ( this.vendor           != null   ) row["vendor"         ] = Sql.ToDBString  (this.vendor                );
			if ( this.totalInventory   .HasValue ) row["totalInventory" ] = Sql.ToDBString  (this.totalInventory        );
			if ( this.maxVariantPrice  != null   )
			{
				row["maxVariantPrice"    ] = Sql.ToDBString  (this.maxVariantPrice.amount      );
				row["currencyCode"       ] = Sql.ToDBString  (this.maxVariantPrice.currencyCode);
			}
			if ( this.minVariantPrice  != null   )
			{
				row["minVariantPrice"    ] = Sql.ToDBString  (this.minVariantPrice.amount      );
				row["currencyCode"       ] = Sql.ToDBString  (this.minVariantPrice.currencyCode);
			}
		}

		public static DataRow ConvertToRow(Product obj)
		{
			DataTable dt = Product.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Product> contacts)
		{
			DataTable dt = Product.CreateTable();
			if ( contacts != null )
			{
				foreach ( Product contact in contacts )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					contact.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class ProductPagination
	{
		public IList<Product> items       { get; set; }
		public PageInfo       pageInfo    { get; set; }
	}
}
