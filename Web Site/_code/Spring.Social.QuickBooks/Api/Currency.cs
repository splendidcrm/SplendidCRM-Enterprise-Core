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

namespace Spring.Social.QuickBooks.Api
{
	[Serializable]
	public class Currency : QBase
	{
		#region Properties
		public String                    Name                          { get; set; }
		public Boolean?                  Active                        { get; set; }
		public CurrencyCode?             Code                          { get; set; }
		public String                    Separator                     { get; set; }
		public String                    Format                        { get; set; }
		public String                    DecimalPlaces                 { get; set; }
		public String                    DecimalSeparator              { get; set; }
		public String                    Symbol                        { get; set; }
		public SymbolPositionEnum?       SymbolPosition                { get; set; }
		public Boolean?                  UserDefined                   { get; set; }
		public Decimal?                  ExchangeRate                  { get; set; }
		public DateTime?                 AsOfDate                      { get; set; }

		public string SymbolPositionValue
		{
			get
			{
				return (this.SymbolPosition == null || !this.SymbolPosition.HasValue) ? String.Empty : this.SymbolPosition.Value.ToString();
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.SymbolPosition = Spring.Social.QuickBooks.Api.Impl.Json._EnumDeserializer.DeserializeSymbolPosition(new Spring.Json.JsonValue(value));
				else
					this.SymbolPosition = null;
			}
		}
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			/*
			dt.Columns.Add("Id"                           , Type.GetType("System.Int64"   ));
			dt.Columns.Add("SyncToken"                    , Type.GetType("System.Int64"   ));
			dt.Columns.Add("CreateTime"                   , Type.GetType("System.DateTime"));
			dt.Columns.Add("LastUpdatedTime"              , Type.GetType("System.DateTime"));
			dt.Columns.Add("AccountSubType"               , Type.GetType("System.String"  ));
			dt.Columns.Add("AccountType"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("AcctNum"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("Active"                       , Type.GetType("System.Boolean" ));
			dt.Columns.Add("BankNum"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("Classification"               , Type.GetType("System.String"  ));
			dt.Columns.Add("CurrencyRef"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("CurrentBalance"               , Type.GetType("System.Decimal" ));
			dt.Columns.Add("CurrentBalanceWithSubAccounts", Type.GetType("System.Decimal" ));
			dt.Columns.Add("Description"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("FIName"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("FullyQualifiedName"           , Type.GetType("System.String"  ));
			dt.Columns.Add("Name"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("OnlineBankingEnabled"         , Type.GetType("System.Boolean" ));
			dt.Columns.Add("OpeningBalance"               , Type.GetType("System.Decimal" ));
			dt.Columns.Add("OpeningBalanceDate"           , Type.GetType("System.DateTime"));
			dt.Columns.Add("ParentRef"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("SubAccount"                   , Type.GetType("System.Boolean" ));
			dt.Columns.Add("TaxAccount"                   , Type.GetType("System.Boolean" ));
			dt.Columns.Add("TaxCodeRef"                   , Type.GetType("System.String"  ));
			*/
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			/*
			row["Id"                           ] = this.Id                           ;
			row["SyncToken"                    ] = this.SyncToken                    ;
			row["CreateTime"                   ] = this.MetaData.CreateTime          ;
			row["LastUpdatedTime"              ] = this.MetaData.LastUpdatedTime     ;
			row["Name"                         ] = this.Name                         ;
			row["Description"                  ] = this.Description                  ;
			row["FullyQualifiedName"           ] = this.FullyQualifiedName           ;
			row["Classification"               ] = this.Classification.ToString();
			row["AccountType"                  ] = this.AccountType.ToString();
			row["AccountSubType"               ] = this.AccountSubType               ;
			row["AcctNum"                      ] = this.AcctNum                      ;
			row["BankNum"                      ] = this.BankNum                      ;
			row["FIName"                       ] = this.FIName                       ;
			if ( this.SubAccount.HasValue                    ) row["SubAccount"                   ] = this.SubAccount                   .Value;
			if ( this.ParentRef != null                      ) row["ParentRef"                    ] = this.ParentRef                    .Value;
			if ( this.Active.HasValue                        ) row["Active"                       ] = this.Active                       .Value;
			if ( this.OpeningBalance.HasValue                ) row["OpeningBalance"               ] = this.OpeningBalance               .Value;
			if ( this.OpeningBalanceDate.HasValue            ) row["OpeningBalanceDate"           ] = this.OpeningBalanceDate           .Value;
			if ( this.CurrentBalance.HasValue                ) row["CurrentBalance"               ] = this.CurrentBalance               .Value;
			if ( this.CurrentBalanceWithSubAccounts.HasValue ) row["CurrentBalanceWithSubAccounts"] = this.CurrentBalanceWithSubAccounts.Value;
			if ( this.CurrencyRef != null                    ) row["CurrencyRef"                  ] = this.CurrencyRef                  .Value;
			if ( this.TaxAccount.HasValue                    ) row["TaxAccount"                   ] = this.TaxAccount                   .Value;
			if ( this.TaxCodeRef != null                     ) row["TaxCodeRef"                   ] = this.TaxCodeRef                   .Value;
			if ( this.OnlineBankingEnabled.HasValue          ) row["OnlineBankingEnabled"         ] = this.OnlineBankingEnabled         .Value;
			*/
		}
	}
}
