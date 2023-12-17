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

namespace Spring.Social.Office365.Api.Impl.Json
{
	class SubscriptionNotificationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			SubscriptionNotification obj = new SubscriptionNotification();
			obj.RawContent = json.ToString();
			
			try
			{
				obj.SubscriptionId                 = json.GetValueOrDefault<String>   ("subscriptionId"                );
				obj.SubscriptionExpirationDateTime = json.GetValueOrDefault<DateTime> ("subscriptionExpirationDateTime");
				obj.ChangeType                     = json.GetValueOrDefault<String>   ("changeType"                    );
				obj.LifecycleEvent                 = json.GetValueOrDefault<String>   ("lifecycleEvent"                );
				obj.Resource                       = json.GetValueOrDefault<String>   ("resource"                      );
				obj.ClientState                    = json.GetValueOrDefault<String>   ("clientState"                   );
				obj.TenantId                       = json.GetValueOrDefault<String>   ("tenantId"                      );

				JsonValue ResourceData = json.GetValue("resourceData");
				if ( ResourceData != null && !ResourceData.IsNull && ResourceData.IsObject )
					obj.ResourceData = mapper.Deserialize<ResourceData>(ResourceData);
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

	class SubscriptionNotificationListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<SubscriptionNotification> notifications = new List<SubscriptionNotification>();
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					notifications.Add( mapper.Deserialize<SubscriptionNotification>(itemValue) );
				}
			}
			return notifications;
		}
	}

	class SubscriptionNotificationBodyDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			SubscriptionNotificationBody body = new SubscriptionNotificationBody();
			//JsonUtils.FaultCheck(json);
			if ( json != null && !json.IsNull )
			{
				JsonValue values = json.GetValue("value");
				if ( values != null && !values.IsNull )
				{
					body.values = mapper.Deserialize<IList<SubscriptionNotification>>(values);
				}
			}
			return body;
		}
	}
}
