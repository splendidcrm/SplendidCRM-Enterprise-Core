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
	class AccountDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Spring.Social.MailChimp.Api.Account obj = new Spring.Social.MailChimp.Api.Account();
			obj.RawContent = json.ToString();
			
			// 04/08/2016 Paul.  When less data than paginated request, then final entries have ID of 0. 
			string sID = json.GetValueOrDefault<string>("account_id");
			if ( sID == String.Empty || sID == "0" )
				return null;
			obj.id                = json.GetValueOrDefault<String   >("account_id"       );
			obj.name              = json.GetValueOrDefault<String   >("account_name"     );
			obj.email             = json.GetValueOrDefault<String   >("email"            );
			obj.role              = json.GetValueOrDefault<String   >("role"             );
			obj.pro_enabled       = json.GetValueOrDefault<bool?    >("pro_enabled"      );
			obj.total_subscribers = json.GetValueOrDefault<int?     >("total_subscribers");
			if ( !String.IsNullOrEmpty(json.GetValueOrDefault<String>("last_login")) ) 
				obj.last_login        = json.GetValueOrDefault<DateTime?>("last_login"       );
			// Contact
			JsonValue jsonContact = json.GetValue("contact");
			if ( jsonContact != null )
			{
				obj.company = jsonContact.GetValueOrDefault<String  >("company");
				obj.addr1   = jsonContact.GetValueOrDefault<String  >("addr1"  );
				obj.addr2   = jsonContact.GetValueOrDefault<String  >("addr2"  );
				obj.city    = jsonContact.GetValueOrDefault<String  >("city"   );
				obj.state   = jsonContact.GetValueOrDefault<String  >("state"  );
				obj.zip     = jsonContact.GetValueOrDefault<String  >("zip"    );
				obj.country = jsonContact.GetValueOrDefault<String  >("country");
			}
			// Stats
			JsonValue jsonStats = json.GetValue("industry_stats");
			if ( jsonStats != null )
			{
				obj.open_rate   = jsonStats.GetValueOrDefault<Decimal? >("open_rate"  );
				obj.bounce_rate = jsonStats.GetValueOrDefault<Decimal? >("bounce_rate");
				obj.click_rate  = jsonStats.GetValueOrDefault<Decimal? >("click_rate ");
			}
			return obj;
		}
	}
}
