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
using System.Diagnostics;
using Spring.Json;

namespace Spring.Social.SalesFusion.Api.Impl.Json
{
	class UserSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			User o = obj as User;
			
			JsonObject json           = new JsonObject();
			if ( o.owner_id                     .HasValue ) json.AddValue("owner_id"                     , new JsonValue(o.owner_id                     .Value));
			if ( o.crm_id                       != null   ) json.AddValue("crm_id"                       , new JsonValue(o.crm_id                             ));

			//if ( o.user_id                      .HasValue ) json.AddValue("user_id"                      , new JsonValue(o.user_id                      .Value));
			//if ( o.user                         != null   ) json.AddValue("user"                         , new JsonValue(o.user                               ));
			if ( o.status                       .HasValue ) json.AddValue("status"                       , new JsonValue(o.status                       .Value));
			if ( o.user_name                    != null   ) json.AddValue("user_name"                    , new JsonValue(o.user_name                          ));
			if ( o.portal_password              != null   ) json.AddValue("portal_password"              , new JsonValue(o.portal_password                    ));
			if ( o.salutation                   != null   ) json.AddValue("salutation"                   , new JsonValue(o.salutation                         ));
			if ( o.first_name                   != null   ) json.AddValue("first_name"                   , new JsonValue(o.first_name                         ));
			if ( o.last_name                    != null   ) json.AddValue("last_name"                    , new JsonValue(o.last_name                          ));
			if ( o.job_title                    != null   ) json.AddValue("job_title"                    , new JsonValue(o.job_title                          ));
			if ( o.email                        != null   ) json.AddValue("email"                        , new JsonValue(o.email                              ));
			if ( o.phone                        != null   ) json.AddValue("phone"                        , new JsonValue(o.phone                              ));
			if ( o.phone_extension              != null   ) json.AddValue("phone_extension"              , new JsonValue(o.phone_extension                    ));
			if ( o.mobile                       != null   ) json.AddValue("mobile"                       , new JsonValue(o.mobile                             ));
			if ( o.address1                     != null   ) json.AddValue("address1"                     , new JsonValue(o.address1                           ));
			if ( o.address2                     != null   ) json.AddValue("address2"                     , new JsonValue(o.address2                           ));
			if ( o.city                         != null   ) json.AddValue("city"                         , new JsonValue(o.city                               ));
			if ( o.state                        != null   ) json.AddValue("state"                        , new JsonValue(o.state                              ));
			if ( o.zip                          != null   ) json.AddValue("zip"                          , new JsonValue(o.zip                                ));
			if ( o.country                      != null   ) json.AddValue("country"                      , new JsonValue(o.country                            ));
			if ( o.face_book                    != null   ) json.AddValue("face_book"                    , new JsonValue(o.face_book                          ));
			if ( o.linked_in                    != null   ) json.AddValue("linked_in"                    , new JsonValue(o.linked_in                          ));
			if ( o.company_website              != null   ) json.AddValue("company_website"              , new JsonValue(o.company_website                    ));
			if ( o.twitter                      != null   ) json.AddValue("twitter"                      , new JsonValue(o.twitter                            ));
			if ( o.profile_picture              != null   ) json.AddValue("profile_picture"              , new JsonValue(o.profile_picture                    ));
			o.RawContent = json.ToString();
			return json;
		}
	}
}
