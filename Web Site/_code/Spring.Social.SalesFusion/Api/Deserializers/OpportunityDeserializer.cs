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

namespace Spring.Social.SalesFusion.Api.Impl.Json
{
	class OpportunityDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Opportunity obj = new Opportunity();
			obj.RawContent = json.ToString();
			obj.created_date                   = json.GetValueOrDefault<DateTime?  >("created_date"                 );
			obj.created_by_id                  = json.GetValueOrDefault<int?       >("created_by_id"                );
			obj.created_by                     = json.GetValueOrDefault<String     >("created_by"                   );
			obj.updated_date                   = json.GetValueOrDefault<DateTime?  >("updated_date"                 );
			obj.updated_by_id                  = json.GetValueOrDefault<int?       >("updated_by_id"                );
			obj.updated_by                     = json.GetValueOrDefault<String     >("updated_by"                   );
			obj.owner_id                       = json.GetValueOrDefault<int?       >("owner_id"                     );
			obj.owner_name                     = json.GetValueOrDefault<String     >("owner_name"                   );
			obj.owner                          = json.GetValueOrDefault<String     >("owner"                        );
			obj.crm_id                         = json.GetValueOrDefault<String     >("crm_id"                       );
			if ( Sql.IsEmptyString(obj.owner_id) && !Sql.IsEmptyString(obj.owner) )
			{
				obj.owner_id = Sql.ToInteger(obj.owner.Replace("https://pub.salesfusion360.com/api/users/", "").Replace("/", ""));
			}

			obj.opportunity_id                 = json.GetValueOrDefault<int?       >("opportunity_id"               );
			obj.opportunity                    = json.GetValueOrDefault<String     >("opportunity"                  );
			obj.name                           = json.GetValueOrDefault<String     >("name"                         );
			obj.contact_id                     = json.GetValueOrDefault<int?       >("contact_id"                   );
			obj.contact                        = json.GetValueOrDefault<String     >("contact"                      );
			obj.account_id                     = json.GetValueOrDefault<int?       >("account_id"                   );
			obj.account                        = json.GetValueOrDefault<String     >("account"                      );
			obj.closing_date                   = json.GetValueOrDefault<DateTime?  >("closing_date"                 );
			obj.lead_source                    = json.GetValueOrDefault<String     >("lead_source"                  );
			obj.stage                          = json.GetValueOrDefault<String     >("stage"                        );
			obj.next_step                      = json.GetValueOrDefault<String     >("next_step"                    );
			obj.amount                         = json.GetValueOrDefault<Decimal?   >("amount"                       );
			obj.probability                    = json.GetValueOrDefault<String     >("probability"                  );
			obj.won                            = json.GetValueOrDefault<String     >("won"                          );
			obj.est_closing_date               = json.GetValueOrDefault<DateTime?  >("est_closing_date"             );
			obj.sub_lead_source_originator     = json.GetValueOrDefault<String     >("sub_lead_source_originator"   );
			obj.lead_source_originator         = json.GetValueOrDefault<String     >("lead_source_originator"       );
			obj.sub_lead_source                = json.GetValueOrDefault<String     >("sub_lead_source"              );
			obj.description                    = json.GetValueOrDefault<String     >("description"                  );
			obj.opp_type                       = json.GetValueOrDefault<String     >("opp_type"                     );
			obj.shared_opp                     = json.GetValueOrDefault<String     >("shared_opp"                   );
			obj.product_name                   = json.GetValueOrDefault<String     >("product_name"                 );
			obj.action_steps_complete          = json.GetValueOrDefault<String     >("action_steps_complete"        );
			//obj.custom_mapping                 = json.GetValueOrDefault<String     >("custom_mapping"               );
			//obj.custom_fields                  = json.GetValueOrDefault<String   >("custom_fields");
			return obj;
		}
	}

	class OpportunityListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Opportunity> results = new List<Opportunity>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("results");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					results.Add( mapper.Deserialize<Opportunity>(itemValue) );
				}
			}
			return results;
		}
	}

	class OpportunityPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			OpportunityPagination pag = new OpportunityPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				pag.page_size   = json.GetValueOrDefault<int   >("page_size"  );
				pag.page_number = json.GetValueOrDefault<int   >("page_number");
				pag.total_count = json.GetValueOrDefault<int   >("total_count");
				pag.next        = json.GetValueOrDefault<String>("next"       );
				pag.results     = mapper.Deserialize<IList<Opportunity>>(json);
			}
			return pag;
		}
	}
}
