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
	class ContactDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Contact obj = new Contact();
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

			obj.contact_id                     = json.GetValueOrDefault<int?       >("contact_id"                   );
			obj.contact                        = json.GetValueOrDefault<String     >("contact"                      );
			obj.crm_type                       = json.GetValueOrDefault<String     >("crm_type"                     );
			obj.salutation                     = json.GetValueOrDefault<String     >("salutation"                   );
			obj.first_name                     = json.GetValueOrDefault<String     >("first_name"                   );
			obj.last_name                      = json.GetValueOrDefault<String     >("last_name"                    );
			obj.phone                          = json.GetValueOrDefault<String     >("phone"                        );
			obj.mobile                         = json.GetValueOrDefault<String     >("mobile"                       );
			obj.fax                            = json.GetValueOrDefault<String     >("fax"                          );
			obj.home_phone                     = json.GetValueOrDefault<String     >("home_phone"                   );
			obj.other_phone                    = json.GetValueOrDefault<String     >("other_phone"                  );
			obj.email                          = json.GetValueOrDefault<String     >("email"                        );
			obj.account_id                     = json.GetValueOrDefault<int?       >("account_id"                   );
			obj.account_name                   = json.GetValueOrDefault<String     >("account_name"                 );
			obj.account                        = json.GetValueOrDefault<String     >("account"                      );
			obj.billing_street                 = json.GetValueOrDefault<String     >("billing_street"               );
			obj.billing_city                   = json.GetValueOrDefault<String     >("billing_city"                 );
			obj.billing_state                  = json.GetValueOrDefault<String     >("billing_state"                );
			obj.billing_zip                    = json.GetValueOrDefault<String     >("billing_zip"                  );
			obj.billing_country                = json.GetValueOrDefault<String     >("billing_country"              );
			obj.mailing_street                 = json.GetValueOrDefault<String     >("mailing_street"               );
			obj.mailing_city                   = json.GetValueOrDefault<String     >("mailing_city"                 );
			obj.mailing_state                  = json.GetValueOrDefault<String     >("mailing_state"                );
			obj.mailing_zip                    = json.GetValueOrDefault<String     >("mailing_zip"                  );
			obj.mailing_country                = json.GetValueOrDefault<String     >("mailing_country"              );
			obj.street                         = json.GetValueOrDefault<String     >("street"                       );
			obj.city                           = json.GetValueOrDefault<String     >("city"                         );
			obj.state                          = json.GetValueOrDefault<String     >("state"                        );
			obj.postal_code                    = json.GetValueOrDefault<String     >("postal_code"                  );
			obj.country                        = json.GetValueOrDefault<String     >("country"                      );
			obj.area                           = json.GetValueOrDefault<String     >("area"                         );
			obj.region                         = json.GetValueOrDefault<String     >("region"                       );
			obj.district                       = json.GetValueOrDefault<String     >("district"                     );
			obj.status                         = json.GetValueOrDefault<String     >("status"                       );
			obj.industry                       = json.GetValueOrDefault<String     >("industry"                     );
			obj.source                         = json.GetValueOrDefault<String     >("source"                       );
			obj.lead_source_id                 = json.GetValueOrDefault<String     >("lead_source_id"               );
			obj.gender                         = json.GetValueOrDefault<String     >("gender"                       );
			obj.birth_date                     = json.GetValueOrDefault<DateTime?  >("birth_date"                   );
			obj.salary                         = json.GetValueOrDefault<String     >("salary"                       );
			obj.company                        = json.GetValueOrDefault<String     >("company"                      );
			obj.title                          = json.GetValueOrDefault<String     >("title"                        );
			obj.department                     = json.GetValueOrDefault<String     >("department"                   );
			obj.website                        = json.GetValueOrDefault<String     >("website"                      );
			obj.currency_iso_code              = json.GetValueOrDefault<String     >("currency_iso_code"            );
			obj.purlid                         = json.GetValueOrDefault<String     >("purlid"                       );
			obj.rating                         = json.GetValueOrDefault<String     >("rating"                       );
			obj.assistant_name                 = json.GetValueOrDefault<String     >("assistant_name"               );
			obj.assistant_phone                = json.GetValueOrDefault<String     >("assistant_phone"              );
			obj.owner_email                    = json.GetValueOrDefault<String     >("owner_email"                  );
			obj.description                    = json.GetValueOrDefault<String     >("description"                  );
			obj.short_description              = json.GetValueOrDefault<String     >("short_description"            );
			obj.do_not_call                    = json.GetValueOrDefault<String     >("do_not_call"                  );
			obj.opt_out                        = json.GetValueOrDefault<String     >("opt_out"                      );
			obj.opt_out_date                   = json.GetValueOrDefault<DateTime?  >("opt_out_date"                 );
			obj.last_modified_by_id            = json.GetValueOrDefault<String     >("last_modified_by_id"          );
			obj.last_modified_date             = json.GetValueOrDefault<String     >("last_modified_date"           );
			obj.last_activity_date             = json.GetValueOrDefault<String     >("last_activity_date"           );

			obj.custom_score_field             = json.GetValueOrDefault<String     >("custom_score_field"           );
			obj.deliverability_status          = json.GetValueOrDefault<int?       >("deliverability_status"        );
			obj.deliverability_message         = json.GetValueOrDefault<String     >("deliverability_message"       );
			obj.delivered_date                 = json.GetValueOrDefault<DateTime?  >("delivered_date"               );
			//obj.custom_fields                  = json.GetValueOrDefault<String   >("custom_fields");
			return obj;
		}
	}

	class ContactListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Contact> results = new List<Contact>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("results");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					results.Add( mapper.Deserialize<Contact>(itemValue) );
				}
			}
			return results;
		}
	}

	class ContactPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ContactPagination pag = new ContactPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				pag.page_size   = json.GetValueOrDefault<int   >("page_size"  );
				pag.page_number = json.GetValueOrDefault<int   >("page_number");
				pag.total_count = json.GetValueOrDefault<int   >("total_count");
				pag.next        = json.GetValueOrDefault<String>("next"       );
				pag.results     = mapper.Deserialize<IList<Contact>>(json);
			}
			return pag;
		}
	}
}
