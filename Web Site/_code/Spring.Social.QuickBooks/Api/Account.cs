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
	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/account
	[Serializable]
	public class Account : QBase
	{
		#region Properties
		public String                     Name                          { get; set; }  // 100 chars. 
		public Boolean?                   SubAccount                    { get; set; }
		public ReferenceType              ParentRef                     { get; set; }
		public String                     Description                   { get; set; }  // 100 chars. 
		public String                     FullyQualifiedName            { get; set; }
		public Boolean?                   Active                        { get; set; }
		public AccountClassificationEnum? Classification                { get; set; }
		public AccountTypeEnum?           AccountType                   { get; set; }
		public String                     AccountSubType                { get; set; }  // 7 chars. 
		public String                     AcctNum                       { get; set; }  // 7 chars. 
		public String                     BankNum                       { get; set; }
		public Decimal?                   OpeningBalance                { get; set; }
		public DateTime?                  OpeningBalanceDate            { get; set; }
		public Decimal?                   CurrentBalance                { get; set; }
		public Decimal?                   CurrentBalanceWithSubAccounts { get; set; }
		public ReferenceType              CurrencyRef                   { get; set; }
		public Boolean?                   TaxAccount                    { get; set; }
		public ReferenceType              TaxCodeRef                    { get; set; }
		public Boolean?                   OnlineBankingEnabled          { get; set; }
		public String                     FIName                        { get; set; }

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

		public string CurrencyRefValue
		{
			get
			{
				return this.CurrencyRef == null ? String.Empty : this.CurrencyRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.CurrencyRef = new ReferenceType(value);
				else
					this.CurrencyRef = null;
			}
		}

		public string TaxCodeRefValue
		{
			get
			{
				return this.TaxCodeRef == null ? String.Empty : this.TaxCodeRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.TaxCodeRef = new ReferenceType(value);
				else
					this.TaxCodeRef = null;
			}
		}

		public string AccountClassificationValue
		{
			get
			{
				return (this.Classification == null || !this.Classification.HasValue) ? String.Empty : this.Classification.Value.ToString();
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.Classification = Spring.Social.QuickBooks.Api.Impl.Json._EnumDeserializer.DeserializeClassification(new Spring.Json.JsonValue(value));
				else
					this.Classification = null;
			}
		}

		public string AccountTypeValue
		{
			get
			{
				return (this.AccountType == null || !this.AccountType.HasValue) ? String.Empty : this.AccountType.Value.ToString();
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.AccountType = Spring.Social.QuickBooks.Api.Impl.Json._EnumDeserializer.DeserializeAccountType(new Spring.Json.JsonValue(value));
				else
					this.AccountType = null;
			}
		}
		#endregion


		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("Id"                           , Type.GetType("System.String"  ));
			dt.Columns.Add("SyncToken"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("CreateTime"                   , Type.GetType("System.DateTime"));
			dt.Columns.Add("LastUpdatedTime"              , Type.GetType("System.DateTime"));
			dt.Columns.Add("Name"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("SubAccount"                   , Type.GetType("System.Boolean" ));
			dt.Columns.Add("ParentRef"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("Description"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("FullyQualifiedName"           , Type.GetType("System.String"  ));
			dt.Columns.Add("Active"                       , Type.GetType("System.Boolean" ));
			dt.Columns.Add("Classification"               , Type.GetType("System.String"  ));
			dt.Columns.Add("AccountType"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("AccountSubType"               , Type.GetType("System.String"  ));
			dt.Columns.Add("AcctNum"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("BankNum"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("OpeningBalance"               , Type.GetType("System.Decimal" ));
			dt.Columns.Add("OpeningBalanceDate"           , Type.GetType("System.DateTime"));
			dt.Columns.Add("CurrentBalance"               , Type.GetType("System.Decimal" ));
			dt.Columns.Add("CurrentBalanceWithSubAccounts", Type.GetType("System.Decimal" ));
			dt.Columns.Add("CurrencyRef"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("TaxAccount"                   , Type.GetType("System.Boolean" ));
			dt.Columns.Add("TaxCodeRef"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("OnlineBankingEnabled"         , Type.GetType("System.Boolean" ));
			dt.Columns.Add("FIName"                       , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.Id                            != null   ) row["Id"                           ] = Sql.ToDBString  (this.Id                                 );
			if ( this.SyncToken                     != null   ) row["SyncToken"                    ] = Sql.ToDBString  (this.SyncToken                          );
			if ( this.MetaData                      != null   ) row["TimeCreated"                  ] = Sql.ToDBDateTime(this.MetaData.CreateTime                );
			if ( this.MetaData                      != null   ) row["TimeModified"                 ] = Sql.ToDBDateTime(this.MetaData.LastUpdatedTime           );
			if ( this.Name                          != null   ) row["Name"                         ] = Sql.ToDBString  (this.Name                               );
			if ( this.SubAccount                    .HasValue ) row["SubAccount"                   ] = Sql.ToDBBoolean (this.SubAccount                   .Value);
			if ( this.ParentRef                     != null   ) row["ParentRef"                    ] = Sql.ToDBString  (this.ParentRef                    .Value);
			if ( this.Description                   != null   ) row["Description"                  ] = Sql.ToDBString  (this.Description                        );
			if ( this.FullyQualifiedName            != null   ) row["FullyQualifiedName"           ] = Sql.ToDBString  (this.FullyQualifiedName                 );
			if ( this.Active                        .HasValue ) row["Active"                       ] = Sql.ToDBBoolean (this.Active                       .Value);
			if ( this.Classification                != null   ) row["Classification"               ] = Sql.ToDBString  (this.Classification                     );
			if ( this.AccountType                   != null   ) row["AccountType"                  ] = Sql.ToDBString  (this.AccountType                        );
			if ( this.AccountSubType                != null   ) row["AccountSubType"               ] = Sql.ToDBString  (this.AccountSubType                     );
			if ( this.AcctNum                       != null   ) row["AcctNum"                      ] = Sql.ToDBString  (this.AcctNum                            );
			if ( this.BankNum                       != null   ) row["BankNum"                      ] = Sql.ToDBString  (this.BankNum                            );
			if ( this.OpeningBalance                .HasValue ) row["OpeningBalance"               ] = Sql.ToDBDecimal (this.OpeningBalance               .Value);
			if ( this.OpeningBalanceDate            .HasValue ) row["OpeningBalanceDate"           ] = Sql.ToDBDateTime(this.OpeningBalanceDate           .Value);
			if ( this.CurrentBalance                .HasValue ) row["CurrentBalance"               ] = Sql.ToDBDecimal (this.CurrentBalance               .Value);
			if ( this.CurrentBalanceWithSubAccounts .HasValue ) row["CurrentBalanceWithSubAccounts"] = Sql.ToDBDecimal (this.CurrentBalanceWithSubAccounts.Value);
			if ( this.CurrencyRef                   != null   ) row["CurrencyRef"                  ] = Sql.ToDBString  (this.CurrencyRef                  .Value);
			if ( this.TaxAccount                    .HasValue ) row["TaxAccount"                   ] = Sql.ToDBBoolean (this.TaxAccount                   .Value);
			if ( this.TaxCodeRef                    != null   ) row["TaxCodeRef"                   ] = Sql.ToDBString  (this.TaxCodeRef                   .Value);
			if ( this.OnlineBankingEnabled          .HasValue ) row["OnlineBankingEnabled"         ] = Sql.ToDBBoolean (this.OnlineBankingEnabled         .Value);
			if ( this.FIName                        != null   ) row["FIName"                       ] = Sql.ToDBString  (this.FIName                             );
		}

		public static DataRow ConvertToRow(Account obj)
		{
			DataTable dt = Account.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Account> accounts)
		{
			DataTable dt = Account.CreateTable();
			if ( accounts != null )
			{
				foreach ( Account account in accounts )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					account.SetRow(row);
				}
			}
			return dt;
		}
	}
}
