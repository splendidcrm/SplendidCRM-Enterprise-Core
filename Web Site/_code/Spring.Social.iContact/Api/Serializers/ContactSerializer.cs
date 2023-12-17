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

namespace Spring.Social.iContact.Api.Impl.Json
{
	class ContactSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Contact o = obj as Contact;
			
			JsonObject  contact = new JsonObject();
			JsonObject json = new JsonObject();
			if ( o.contactId   != null   ) json.AddValue("contactId"  , new JsonValue(o.contactId  ));
			if ( o.email       != null   ) json.AddValue("email"      , new JsonValue(o.email      ));
			if ( o.prefix      != null   ) json.AddValue("prefix"     , new JsonValue(o.prefix     ));
			if ( o.firstName   != null   ) json.AddValue("firstName"  , new JsonValue(o.firstName  ));
			if ( o.lastName    != null   ) json.AddValue("lastName"   , new JsonValue(o.lastName   ));
			if ( o.suffix      != null   ) json.AddValue("suffix"     , new JsonValue(o.suffix     ));
			if ( o.street      != null   ) json.AddValue("street"     , new JsonValue(o.street     ));
			if ( o.street2     != null   ) json.AddValue("street2"    , new JsonValue(o.street2    ));
			if ( o.city        != null   ) json.AddValue("city"       , new JsonValue(o.city       ));
			if ( o.state       != null   ) json.AddValue("state"      , new JsonValue(o.state      ));
			if ( o.postalCode  != null   ) json.AddValue("postalCode" , new JsonValue(o.postalCode ));
			if ( o.phone       != null   ) json.AddValue("phone"      , new JsonValue(o.phone      ));
			if ( o.fax         != null   ) json.AddValue("fax"        , new JsonValue(o.fax        ));
			if ( o.business    != null   ) json.AddValue("business"   , new JsonValue(o.business   ));
			contact.AddValue("contact", json);
			o.RawContent = contact.ToString();
			return contact;
		}
	}
}
