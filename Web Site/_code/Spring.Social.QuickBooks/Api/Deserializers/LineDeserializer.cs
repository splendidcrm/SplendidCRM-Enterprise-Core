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
using System.Globalization;
using System.Collections.Generic;
using Spring.Json;

namespace Spring.Social.QuickBooks.Api.Impl.Json
{
	class LineDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Line obj = new Line();
			obj.RawContent   = json.ToString();
			obj.Id           = json.GetValueOrDefault<String  >("Id"         );
			obj.LineNum      = json.GetValueOrDefault<String  >("LineNum"    );
			obj.Description  = json.GetValueOrDefault<String  >("Description");
			obj.Amount       = json.GetValueOrDefault<Decimal?>("Amount"     );

			if ( json.ContainsName("DetailType") ) obj.DetailType = _EnumDeserializer.DeserializeLineDetailType(json.GetValue("DetailType"));

			JsonValue linkedTxn   = json.GetValue("LinkedTxn"   );
			//JsonValue customField = json.GetValue("CustomField" );
			if ( linkedTxn         != null && linkedTxn  .IsArray  ) obj.LinkedTxn   = mapper.Deserialize<IList<LinkedTxn>>( linkedTxn   );
			//if ( customField       != null && customField.IsObject ) line.CustomField = mapper.Deserialize<CustomField[]>( customField );
			
			// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/invoice#Line_Details
			// 02/13/2015 Paul.  The Item property is serialized as the detail type. 
			JsonValue item = json.GetValue(obj.DetailType.ToString());
			if ( item != null && item.IsObject )
			{
				switch ( obj.DetailType )
				{
					case LineDetailTypeEnum.PaymentLineDetail            :  obj.Item = mapper.Deserialize<PaymentLineDetail            >( item );  break;
					case LineDetailTypeEnum.DiscountLineDetail           :  obj.Item = mapper.Deserialize<DiscountLineDetail           >( item );  break;
					case LineDetailTypeEnum.TaxLineDetail                :  obj.Item = mapper.Deserialize<TaxLineDetail                >( item );  break;
					case LineDetailTypeEnum.SalesItemLineDetail          :  obj.Item = mapper.Deserialize<SalesItemLineDetail          >( item );  break;
					case LineDetailTypeEnum.ItemBasedExpenseLineDetail   :  obj.Item = mapper.Deserialize<ItemBasedExpenseLineDetail   >( item );  break;
					case LineDetailTypeEnum.AccountBasedExpenseLineDetail:  obj.Item = mapper.Deserialize<AccountBasedExpenseLineDetail>( item );  break;
					case LineDetailTypeEnum.DepositLineDetail            :  obj.Item = mapper.Deserialize<DepositLineDetail            >( item );  break;
					case LineDetailTypeEnum.PurchaseOrderItemLineDetail  :  obj.Item = mapper.Deserialize<PurchaseOrderItemLineDetail  >( item );  break;
					case LineDetailTypeEnum.ItemReceiptLineDetail        :  obj.Item = mapper.Deserialize<ItemReceiptLineDetail        >( item );  break;
					case LineDetailTypeEnum.JournalEntryLineDetail       :  obj.Item = mapper.Deserialize<JournalEntryLineDetail       >( item );  break;
					case LineDetailTypeEnum.GroupLineDetail              :  obj.Item = mapper.Deserialize<GroupLineDetail              >( item );  break;
					case LineDetailTypeEnum.DescriptionOnly              :  obj.Item = mapper.Deserialize<DescriptionLineDetail        >( item );  break;
					case LineDetailTypeEnum.SubTotalLineDetail           :  obj.Item = mapper.Deserialize<SubTotalLineDetail           >( item );  break;
					case LineDetailTypeEnum.SalesOrderItemLineDetail     :  obj.Item = mapper.Deserialize<SalesOrderItemLineDetail     >( item );  break;
				}
			}
			return obj;
		}
	}

	class LineListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue value, JsonMapper mapper)
		{
			IList<Line> lines = new List<Line>();
			if ( value != null && value.IsArray )
			{
				foreach ( JsonValue itemValue in value.GetValues() )
				{
					lines.Add( mapper.Deserialize<Line>(itemValue) );
				}
			}
			return lines;
		}
	}
}
