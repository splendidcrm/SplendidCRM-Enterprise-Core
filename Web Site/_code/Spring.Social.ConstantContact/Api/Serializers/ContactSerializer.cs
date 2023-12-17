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

namespace Spring.Social.ConstantContact.Api.Impl.Json
{
	class ContactSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Contact o = obj as Contact;
			
			JsonObject json = new JsonObject();
			// 11/11/2019 Paul.  Updated to v3. 
			// https://v3.developer.constantcontact.com/api_reference/index.html#!/Contacts/getContacts
			if ( !Sql.IsEmptyString(o.id             ) ) json.AddValue("contact_id"     , new JsonValue(o.id            ));
			if ( !Sql.IsEmptyString(o.prefix_name    ) ) json.AddValue("prefix_name"    , new JsonValue(o.prefix_name   ));
			if ( !Sql.IsEmptyString(o.first_name     ) ) json.AddValue("first_name"     , new JsonValue(o.first_name    ));
			if ( !Sql.IsEmptyString(o.last_name      ) ) json.AddValue("last_name"      , new JsonValue(o.last_name     ));
			if ( !Sql.IsEmptyString(o.job_title      ) ) json.AddValue("job_title"      , new JsonValue(o.job_title     ));
			if ( !Sql.IsEmptyString(o.company_name   ) ) json.AddValue("company_name"   , new JsonValue(o.company_name  ));
			if ( !Sql.IsEmptyString(o.work_phone     ) ) json.AddValue("work_phone"     , new JsonValue(o.work_phone    ));
			if ( !Sql.IsEmptyString(o.fax            ) ) json.AddValue("fax"            , new JsonValue(o.fax           ));
			if ( !Sql.IsEmptyString(o.cell_phone     ) ) json.AddValue("cell_phone"     , new JsonValue(o.cell_phone    ));
			if ( !Sql.IsEmptyString(o.home_phone     ) ) json.AddValue("home_phone"     , new JsonValue(o.home_phone    ));
			// 05/04/2015 Paul.  false is being returned, but it is not allowed when being sent. 
			// #/confirmed: Value is of a disallowed type. Allowed types are: Boolean, Null.
			//if ( !Sql.IsEmptyString(o.confirmed      ) ) json.AddValue("confirmed"      , new JsonValue(o.confirmed     ));
			if ( !Sql.IsEmptyString(o.status         ) ) json.AddValue("status"         , new JsonValue(o.status        ));
			if ( !Sql.IsEmptyString(o.source         ) ) json.AddValue("source"         , new JsonValue(o.source        ));
			if ( !Sql.IsEmptyString(o.source_details ) ) json.AddValue("source_details" , new JsonValue(o.source_details));
			
			if ( o.email_address             != null   ) json.AddValue("email_address"  , mapper.Serialize(o.email_address  ));
			if ( o.addresses                 != null   ) json.AddValue("street_address" , mapper.Serialize(o.addresses      ));
			if ( o.lists                     != null   ) json.AddValue("lists"          , mapper.Serialize(o.lists          ));
			if ( o.notes                     != null   ) json.AddValue("notes"          , mapper.Serialize(o.notes          ));
			o.RawContent = json.ToString();
			return json;
		}
	}
}
