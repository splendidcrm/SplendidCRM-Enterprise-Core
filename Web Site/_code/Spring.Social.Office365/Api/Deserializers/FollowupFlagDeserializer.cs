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

namespace Spring.Social.Office365.Api.Impl.Json
{
	class FollowupFlagDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			// 12/17/2021 Paul.  Ignore errors as this data is not used. 
			string sRawJson = json.ToString();
			FollowupFlag obj = new FollowupFlag();
			try
			{
				// 12/17/2021 Paul.  These date values are not normal. 
				// "dueDateTime"  : {"dateTime":"2021-09-28T04:00:00.0000000","timeZone":"UTC"}
				// "startDateTime": {"dateTime":"2021-09-28T04:00:00.0000000","timeZone":"UTC"}
				JsonValue completedDateTime = json.GetValue("completedDateTime");
				if ( completedDateTime != null )
				{
					if ( completedDateTime.IsObject )
					{
						obj.CompletedDateTime = completedDateTime.GetValueOrDefault<DateTime?>("dateTime");
						string sTimeZone      = completedDateTime.GetValueOrDefault<String>   ("timeZone");
						if ( sTimeZone == "UTC" && obj.CompletedDateTime.HasValue )
							obj.CompletedDateTime = DateTime.SpecifyKind(obj.CompletedDateTime.Value, DateTimeKind.Utc);
					}
					else
					{
						obj.CompletedDateTime = json.GetValueOrDefault<DateTime?>("completedDateTime");
					}
				}
				JsonValue dueDateTime = json.GetValue("dueDateTime");
				if ( dueDateTime != null )
				{
					if ( json.GetValue("dueDateTime").IsObject )
					{
						obj.DueDateTime  = dueDateTime.GetValueOrDefault<DateTime?>("dateTime");
						string sTimeZone = dueDateTime.GetValueOrDefault<String>   ("timeZone");
						if ( sTimeZone == "UTC" && obj.DueDateTime.HasValue )
							obj.DueDateTime = DateTime.SpecifyKind(obj.DueDateTime.Value, DateTimeKind.Utc);
					}
					else
					{
						obj.DueDateTime = json.GetValueOrDefault<DateTime?>("dueDateTime"      );
					}
				}
				JsonValue startDateTime = json.GetValue("startDateTime");
				if ( startDateTime != null )
				{
					if ( json.GetValue("startDateTime").IsObject )
					{
						obj.StartDateTime = startDateTime.GetValueOrDefault<DateTime?>("dateTime");
						string sTimeZone  = startDateTime.GetValueOrDefault<String>   ("timeZone");
						if ( sTimeZone == "UTC" && obj.StartDateTime.HasValue )
							obj.StartDateTime = DateTime.SpecifyKind(obj.StartDateTime.Value, DateTimeKind.Utc);
					}
					else
					{
						obj.StartDateTime = json.GetValueOrDefault<DateTime?>("startDateTime"    );
					}
				}
				obj.FlagStatus           = json.GetValueOrDefault<String>   ("flagStatus"       );
				JsonValue AdditionalData = json.GetValue                    ("additionalData"   );
				if ( AdditionalData != null && !AdditionalData.IsNull && AdditionalData.IsObject )
					obj.AdditionalData = mapper.Deserialize<AdditionalData>(AdditionalData);
			}
			catch(Exception ex)
			{
				System.Diagnostics.Debug.WriteLine(ex.Message);
				System.Diagnostics.Debug.WriteLine(ex.StackTrace);
			}
			return obj;
		}
	}
}
