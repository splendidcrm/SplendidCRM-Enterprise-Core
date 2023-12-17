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
	class UserDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			User obj = new User();
			obj.RawContent = json.ToString();
			obj.crm_id                         = json.GetValueOrDefault<String     >("crm_id"                       );

			obj.user_id                        = json.GetValueOrDefault<int?       >("user_id"                      );
			obj.user                           = json.GetValueOrDefault<String     >("user"                         );
			obj.status                         = json.GetValueOrDefault<int?       >("status"                       );
			obj.user_name                      = json.GetValueOrDefault<String     >("user_name"                    );
			obj.portal_password                = json.GetValueOrDefault<String     >("portal_password"              );
			obj.salutation                     = json.GetValueOrDefault<String     >("salutation"                   );
			obj.first_name                     = json.GetValueOrDefault<String     >("first_name"                   );
			obj.last_name                      = json.GetValueOrDefault<String     >("last_name"                    );
			obj.job_title                      = json.GetValueOrDefault<String     >("job_title"                    );
			obj.email                          = json.GetValueOrDefault<String     >("email"                        );
			obj.phone                          = json.GetValueOrDefault<String     >("phone"                        );
			obj.phone_extension                = json.GetValueOrDefault<String     >("phone_extension"              );
			obj.mobile                         = json.GetValueOrDefault<String     >("mobile"                       );
			obj.address1                       = json.GetValueOrDefault<String     >("address1"                     );
			obj.address2                       = json.GetValueOrDefault<String     >("address2"                     );
			obj.city                           = json.GetValueOrDefault<String     >("city"                         );
			obj.state                          = json.GetValueOrDefault<String     >("state"                        );
			obj.zip                            = json.GetValueOrDefault<String     >("zip"                          );
			obj.country                        = json.GetValueOrDefault<String     >("country"                      );
			obj.face_book                      = json.GetValueOrDefault<String     >("face_book"                    );
			obj.linked_in                      = json.GetValueOrDefault<String     >("linked_in"                    );
			obj.company_website                = json.GetValueOrDefault<String     >("company_website"              );
			obj.twitter                        = json.GetValueOrDefault<String     >("twitter"                      );
			obj.profile_picture                = json.GetValueOrDefault<String     >("profile_picture"              );
			return obj;
		}
	}

	class UserListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<User> results = new List<User>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("results");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					results.Add( mapper.Deserialize<User>(itemValue) );
				}
			}
			return results;
		}
	}

	class UserPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			UserPagination pag = new UserPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				pag.page_size   = json.GetValueOrDefault<int   >("page_size"  );
				pag.page_number = json.GetValueOrDefault<int   >("page_number");
				pag.total_count = json.GetValueOrDefault<int   >("total_count");
				pag.next        = json.GetValueOrDefault<String>("next"       );
				pag.results     = mapper.Deserialize<IList<User>>(json);
			}
			return pag;
		}
	}
}
