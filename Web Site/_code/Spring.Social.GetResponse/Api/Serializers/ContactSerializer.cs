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

namespace Spring.Social.GetResponse.Api.Impl.Json
{
	class ContactSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Contact o = obj as Contact;
			
			JsonObject json = new JsonObject();
			if ( o.id         != null ) json.AddValue("id"        , new JsonValue(o.id        ));
			if ( o.name       != null ) json.AddValue("name"      , new JsonValue(o.name      ));
			if ( o.email      != null ) json.AddValue("email"     , new JsonValue(o.email     ));
			if ( o.note       != null ) json.AddValue("note"      , new JsonValue(o.note      ));
			if ( o.origin     != null ) json.AddValue("origin"    , new JsonValue(o.origin    ));
			if ( o.ipAddress  != null ) json.AddValue("ipAddress" , new JsonValue(o.ipAddress ));
			if ( o.dayOfCycle != null ) json.AddValue("dayOfCycle", new JsonValue(o.dayOfCycle));
			if ( o.campaignId != null )
			{
				JsonObject jsonCampaign = new JsonObject();
				jsonCampaign.AddValue("campaignId", new JsonValue(o.campaignId));
				json.AddValue("campaign"  , jsonCampaign);
			}
			o.RawContent = json.ToString();
			return json;
		}
	}
}
