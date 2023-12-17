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

namespace Spring.Social.MailChimp.Api.Impl.Json
{
	class MemberSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Member o = obj as Member;
			
			JsonObject json = new JsonObject();
			// http://developer.mailchimp.com/documentation/mailchimp/reference/lists/members/
			json.AddValue("email_address", new JsonValue(o.email_address));
			// 04/25/2016 Paul.  Fields may be null. 
			if ( !String.IsNullOrEmpty(o.email_type) ) json.AddValue("email_type", new JsonValue(o.email_type));
			if ( !String.IsNullOrEmpty(o.status    ) ) json.AddValue("status"    , new JsonValue(o.status    ));
			if ( !String.IsNullOrEmpty(o.language  ) ) json.AddValue("language"  , new JsonValue(o.language  ));
			if ( o.vip.HasValue                      ) json.AddValue("vip"       , new JsonValue(o.vip.ToString()));

			if ( o.merge_fields != null )
			{
				// 04/11/2016 Paul.  Merge fields are not an array, they are name/value pairs. 
				JsonObject jsonMergeFields = new JsonObject();
				foreach ( Member.MergeField field in o.merge_fields )
				{
					jsonMergeFields.AddValue(field.field_name, new JsonValue(field.value));
				}
				json.AddValue("merge_fields", jsonMergeFields);
			}
			if ( o.interests != null )
			{
				// 04/11/2016 Paul.  Interests are not an array, they are name/value pairs. 
				JsonObject jsonInterests = new JsonObject();
				foreach ( Member.Interest interest in o.interests )
				{
					jsonInterests.AddValue(interest.interest_id, new JsonValue(interest.value.ToString()));
				}
				json.AddValue("interests", jsonInterests);
			}
			if ( o.location != null && o.location.latitude .HasValue && o.location.longitude.HasValue )
			{
				JsonObject jsonLocation = new JsonObject();
				jsonLocation.AddValue("latitude" , new JsonValue(o.location.latitude .Value));
				jsonLocation.AddValue("longitude", new JsonValue(o.location.longitude.Value));
				json.AddValue("location", jsonLocation);
			}
			o.RawContent = json.ToString();
			return json;
		}
	}
}
