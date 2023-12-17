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

namespace Spring.Social.PhoneBurner.Api.Impl.Json
{
	class PrimaryEmailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			PrimaryEmail obj = new PrimaryEmail();

			try
			{
				obj.user_email_id     = json.GetValueOrDefault<String>("user_email_id"    );
				obj.email_address     = json.GetValueOrDefault<String>("email_address"    );
				obj.status            = json.GetValueOrDefault<String>("status"           );
				obj.soft_bounce_count = json.GetValueOrDefault<String>("soft_bounce_count");
				obj.hard_bounce_count = json.GetValueOrDefault<String>("hard_bounce_count");
				obj.double_opt_status = json.GetValueOrDefault<String>("double_opt_status");
				obj.type              = json.GetValueOrDefault<String>("type"             );
			}
			catch(Exception ex)
			{
				System.Diagnostics.Debug.WriteLine(ex.Message);
				System.Diagnostics.Debug.WriteLine(ex.StackTrace);
				throw;
			}
			return obj;
		}
	}
}
