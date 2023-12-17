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
	class CallDoneDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			CallDone obj = new CallDone();
			try
			{
				obj.ds_id                 = json.GetValueOrDefault<String  >("ds_id"                );
				obj.call_id               = json.GetValueOrDefault<String  >("call_id"              );
				obj.lead_id               = json.GetValueOrDefault<String  >("lead_id"              );
				obj.status                = json.GetValueOrDefault<String  >("status"               );
				obj.connected             = json.GetValueOrDefault<String  >("connected"            );
				obj.duration              = json.GetValueOrDefault<int     >("duration"             );
				obj.start_time            = json.GetValueOrDefault<DateTime>("start_time"           );
				obj.end_time              = json.GetValueOrDefault<DateTime>("end_time"             );
				obj.recording_link        = json.GetValueOrDefault<String  >("recording_link"       );
				obj.recording_link_public = json.GetValueOrDefault<String  >("recording_link_public");

				JsonValue contact     = json.GetValue("contact"    );
				JsonValue custom_data = json.GetValue("custom_data");
				if ( contact     != null && !contact     .IsNull && contact    .IsObject ) obj.contact     = mapper.Deserialize<Contact   >(contact    );
				if ( custom_data != null && !custom_data .IsNull && custom_data.IsObject ) obj.custom_data = mapper.Deserialize<CustomData>(custom_data);
				if ( contact != null )
					obj.lead_id = obj.contact.lead_id;
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
