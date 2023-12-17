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
	class CalendarDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Calendar obj = new Calendar();
			obj.RawContent = json.ToString();
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.CalendarDeserializer.Deserialize " + obj.RawContent);
			
			try
			{
				// Entity
				obj.Id                                  = json.GetValueOrDefault<String>   ("id"                           );
				JsonValue AdditionalData                = json.GetValue                    ("additionalData"               );
				if ( AdditionalData != null && !AdditionalData.IsNull && AdditionalData.IsObject )
					obj.AdditionalData = mapper.Deserialize<AdditionalData>(AdditionalData);
				
				// Calendar
				obj.CanEdit                             = json.GetValueOrDefault<bool? >   ("canEdit"                      );
				obj.CanShare                            = json.GetValueOrDefault<bool? >   ("canShare"                     );
				obj.CanViewPrivateItems                 = json.GetValueOrDefault<bool? >   ("canViewPrivateItems"          );
				obj.ChangeKey                           = json.GetValueOrDefault<String>   ("changeKey"                    );
				obj.Color                               = json.GetValueOrDefault<String>   ("color"                        );
				obj.DefaultOnlineMeetingProvider        = json.GetValueOrDefault<String>   ("defaultOnlineMeetingProvider" );
				obj.HexColor                            = json.GetValueOrDefault<String>   ("hexColor"                     );
				obj.IsDefaultCalendar                   = json.GetValueOrDefault<bool? >   ("isDefaultCalendar"            );
				obj.IsRemovable                         = json.GetValueOrDefault<bool? >   ("isRemovable"                  );
				obj.IsTallyingResponses                 = json.GetValueOrDefault<bool? >   ("isTallyingResponses"          );
				obj.Name                                = json.GetValueOrDefault<string>   ("name"                         );
				
				JsonValue AllowedOnlineMeetingProviders = json.GetValue                    ("AllowedOnlineMeetingProviders");
				JsonValue Events                        = json.GetValue                    ("Events"                       );
				JsonValue Owner                         = json.GetValue                    ("Owner"                        );
				if ( AllowedOnlineMeetingProviders != null && !AllowedOnlineMeetingProviders.IsNull && AllowedOnlineMeetingProviders.IsArray  ) obj.AllowedOnlineMeetingProviders = mapper.Deserialize<IList<String>>(AllowedOnlineMeetingProviders);
				if ( Events                        != null && !Events                       .IsNull && Events                       .IsArray  ) obj.Events                        = mapper.Deserialize<IList<Event> >(Events                       );
				if ( Owner                         != null && !Owner                        .IsNull && Owner                        .IsObject ) obj.Owner                         = mapper.Deserialize<EmailAddress >(Owner                        );
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
