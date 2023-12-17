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
	class MemberDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			if ( json.ContainsName("members") )
			{
				json = json.GetValue("members");
			}
			Member obj = new Member();
			obj.RawContent = json.ToString();
			
			// 04/08/2016 Paul.  When less data than paginated request, then final entries have ID of 0. 
			string sID = json.GetValueOrDefault<string>("id");
			if ( sID == String.Empty || sID == "0" )
				return null;
			// http://developer.mailchimp.com/documentation/mailchimp/reference/members/#
			obj.id               = json.GetValueOrDefault<String   >("id"             );
			// 04/16/2016 Paul.  Use last_changed as date_created. 
			if ( !String.IsNullOrEmpty(json.GetValueOrDefault<String>("last_changed")) ) obj.date_created     = json.GetValueOrDefault<DateTime?>("last_changed");
			// 04/16/2016 Paul.  MailChimp does not have a modified date field, so just use last_changed. 
			if ( !String.IsNullOrEmpty(json.GetValueOrDefault<String>("last_changed")) ) obj.lastmodifieddate = json.GetValueOrDefault<DateTime?>("last_changed");
			obj.created_by       = json.GetValueOrDefault<String   >("created_by"     );
			obj.email_address    = json.GetValueOrDefault<String   >("email_address"  );
			obj.unique_email_id  = json.GetValueOrDefault<String   >("unique_email_id");
			obj.email_type       = json.GetValueOrDefault<String   >("email_type"     );
			obj.status           = json.GetValueOrDefault<String   >("status"         );
			obj.status_if_new    = json.GetValueOrDefault<String   >("status_if_new"  );
			obj.ip_signup        = json.GetValueOrDefault<String   >("ip_signup"      );
			obj.ip_opt           = json.GetValueOrDefault<String   >("ip_opt"         );
			obj.member_rating    = json.GetValueOrDefault<String   >("member_rating"  );
			obj.language         = json.GetValueOrDefault<String   >("language"       );
			obj.vip              = json.GetValueOrDefault<bool?    >("vip"            );
			obj.email_client     = json.GetValueOrDefault<String   >("email_client"   );
			obj.list_id          = json.GetValueOrDefault<String   >("list_id"        );
			if ( !String.IsNullOrEmpty(json.GetValueOrDefault<String>("timestamp_signup")) ) obj.timestamp_signup = json.GetValueOrDefault<DateTime?>("timestamp_signup");
			if ( !String.IsNullOrEmpty(json.GetValueOrDefault<String>("timestamp_opt"   )) ) obj.timestamp_opt    = json.GetValueOrDefault<DateTime?>("timestamp_opt"   );
			JsonValue jsonMergeFields = json.GetValue("merge_fields");
			if ( jsonMergeFields != null )
			{
				// 04/11/2016 Paul.  Merge fields are not an array, they are name/value pairs. 
				foreach ( string sFieldName in jsonMergeFields.GetNames() )
				{
					obj.SetMergeField(sFieldName, jsonMergeFields.GetValueOrDefault<String>(sFieldName));
				}
			}
			JsonValue jsonInterests = json.GetValue("interests");
			if ( jsonInterests != null )
			{
				obj.interests = new List<Member.Interest>();
				// 04/11/2016 Paul.  Interests are not an array, they are name/value pairs. 
				foreach ( string sInterestId in jsonInterests.GetNames() )
				{
					Member.Interest interest = new Member.Interest();
					obj.interests.Add(interest);
					interest.interest_id = sInterestId;
					interest.value       = jsonInterests.GetValueOrDefault<bool?>(sInterestId);
				}
			}
			JsonValue jsonStats = json.GetValue("stats");
			if ( jsonStats != null )
			{
				obj.stats = new Member.Stats();
				obj.stats.avg_open_rate  = jsonStats.GetValueOrDefault<Decimal?>("avg_open_rate" );
				obj.stats.avg_click_rate = jsonStats.GetValueOrDefault<Decimal?>("avg_click_rate");
			}
			JsonValue jsonLocation = json.GetValue("location");
			if ( jsonLocation != null )
			{
				obj.location = new Member.Location();
				obj.location.latitude     = jsonStats.GetValueOrDefault<Decimal?>("latitude"    );
				obj.location.longitude    = jsonStats.GetValueOrDefault<Decimal?>("longitude"   );
				obj.location.gmtoff       = jsonStats.GetValueOrDefault<int?    >("gmtoff"      );
				obj.location.dstoff       = jsonStats.GetValueOrDefault<int?    >("dstoff"      );
				obj.location.country_code = jsonStats.GetValueOrDefault<String  >("country_code");
				obj.location.timezone     = jsonStats.GetValueOrDefault<String  >("timezone"    );
			}
			JsonValue jsonNote = json.GetValue("last_note");
			if ( jsonNote != null )
			{
				obj.last_note = new Member.Note();
				obj.last_note.note_id    = jsonStats.GetValueOrDefault<String   >("note_id"   );
				obj.last_note.created_at = jsonStats.GetValueOrDefault<DateTime?>("created_at");
				obj.last_note.created_by = jsonStats.GetValueOrDefault<String   >("created_by");
				obj.last_note.note       = jsonStats.GetValueOrDefault<String   >("note"      );
			}
			return obj;
		}
	}

	class MemberListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Member> items = new List<Member>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("members");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					Member item = mapper.Deserialize<Member>(itemValue);
					// 04/08/2016 Paul.  When less data than paginated request, then final entries have ID of 0. 
					if ( item != null && !String.IsNullOrEmpty(item.id) )
						items.Add(item);
				}
			}
			return items;
		}
	}

	class MemberPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			MemberPagination pag = new MemberPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				pag.total  = json.GetValueOrDefault<int>("total_items");
				pag.items  = mapper.Deserialize<IList<Member>>(json);
			}
			return pag;
		}
	}

	// 02/16/2017 Paul.  Make sure that member does not exist. 
	class MemberSearchDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			MemberSearch pag = new MemberSearch();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				JsonValue jsonResponse = json.GetValue("exact_matches");
				if ( jsonResponse != null )
				{
					pag.total  = jsonResponse.GetValueOrDefault<int>("total_items");
					pag.items  = mapper.Deserialize<IList<Member>>(jsonResponse);
				}
			}
			return pag;
		}
	}
}
