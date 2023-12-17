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

namespace Spring.Social.Pardot.Api.Impl.Json
{
	class ProspectAccountDeserializer : IJsonDeserializer
	{
		private int GetInt(JsonValue json, string sName)
		{
			int nValue = 0;
			JsonValue value = json.GetValue(sName);
			if ( !value.IsNull )
				nValue = value.GetValueOrDefault<int>("value");
			return nValue;
		}

		private string GetString(JsonValue json, string sName)
		{
			String sValue = String.Empty;
			JsonValue value = json.GetValue(sName);
			if ( !value.IsNull )
				sValue = value.GetValueOrDefault<String>("value");
			return sValue;
		}

		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			JsonUtils.FaultCheck(json);
			ProspectAccount obj = new ProspectAccount();
			obj.RawContent = json.ToString();
			System.Diagnostics.Debug.WriteLine(obj.RawContent);
			if ( json.ContainsName("prospectAccount") )
			{
				json = json.GetValue("prospectAccount");
			}
			
			obj.id         = json.GetValueOrDefault<int     >("id"        );
			obj.created_at = json.GetValueOrDefault<DateTime>("created_at");
			obj.updated_at = json.GetValueOrDefault<DateTime>("updated_at");
			if ( json.ContainsName("name"                ) ) obj.name                    = GetString(json, "name"                );
			if ( json.ContainsName("number"              ) ) obj.number                  = GetInt   (json, "number"              );
			if ( json.ContainsName("description"         ) ) obj.description             = GetString(json, "description"         );
			if ( json.ContainsName("phone"               ) ) obj.phone                   = GetString(json, "phone"               );
			if ( json.ContainsName("fax"                 ) ) obj.fax                     = GetString(json, "fax"                 );
			if ( json.ContainsName("website"             ) ) obj.website                 = GetString(json, "website"             );
			if ( json.ContainsName("rating"              ) ) obj.rating                  = GetString(json, "rating"              );
			if ( json.ContainsName("site"                ) ) obj.site                    = GetString(json, "site"                );
			if ( json.ContainsName("type"                ) ) obj.type                    = GetString(json, "type"                );
			if ( json.ContainsName("annual_revenue"      ) ) obj.annual_revenue          = GetInt   (json, "annual_revenue"      );
			if ( json.ContainsName("industry"            ) ) obj.industry                = GetString(json, "industry"            );
			if ( json.ContainsName("sic"                 ) ) obj.sic                     = GetString(json, "sic"                 );
			if ( json.ContainsName("employees"           ) ) obj.employees               = GetInt   (json, "employees"           );
			if ( json.ContainsName("ownership"           ) ) obj.ownership               = GetString(json, "ownership"           );
			if ( json.ContainsName("ticker_symbol"       ) ) obj.ticker_symbol           = GetString(json, "ticker_symbol"       );
			if ( json.ContainsName("billing_address_one" ) ) obj.billing_address_one     = GetString(json, "billing_address_one" );
			if ( json.ContainsName("billing_address_two" ) ) obj.billing_address_two     = GetString(json, "billing_address_two" );
			if ( json.ContainsName("billing_city"        ) ) obj.billing_city            = GetString(json, "billing_city"        );
			if ( json.ContainsName("billing_state"       ) ) obj.billing_state           = GetString(json, "billing_state"       );
			if ( json.ContainsName("billing_zip"         ) ) obj.billing_zip             = GetString(json, "billing_zip"         );
			if ( json.ContainsName("billing_country"     ) ) obj.billing_country         = GetString(json, "billing_country"     );
			if ( json.ContainsName("shipping_address_one") ) obj.shipping_address_one    = GetString(json, "shipping_address_one");
			if ( json.ContainsName("shipping_address_two") ) obj.shipping_address_two    = GetString(json, "shipping_address_two");
			if ( json.ContainsName("shipping_city"       ) ) obj.shipping_city           = GetString(json, "shipping_city"       );
			if ( json.ContainsName("shipping_state"      ) ) obj.shipping_state          = GetString(json, "shipping_state"      );
			if ( json.ContainsName("shipping_zip"        ) ) obj.shipping_zip            = GetString(json, "shipping_zip"        );
			if ( json.ContainsName("shipping_country"    ) ) obj.shipping_country        = GetString(json, "shipping_country"    );
			return obj;
		}
	}

	class ProspectAccountListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<ProspectAccount> items = new List<ProspectAccount>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("prospectAccount");
			if ( jsonResponse != null )
			{
				if ( jsonResponse.IsArray )
				{
					foreach ( JsonValue itemValue in jsonResponse.GetValues() )
					{
						items.Add( mapper.Deserialize<ProspectAccount>(itemValue) );
					}
				}
				else
				{
					items.Add( mapper.Deserialize<ProspectAccount>(jsonResponse) );
				}
			}
			return items;
		}
	}

	class ProspectAccountPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ProspectAccountPagination pag = new ProspectAccountPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null && json.ContainsName("result") )
			{
				json = json.GetValue("result");
				pag.total = json.GetValueOrDefault<int>("total_results");
				pag.items = mapper.Deserialize<IList<ProspectAccount>>(json);
			}
			return pag;
		}
	}
}
