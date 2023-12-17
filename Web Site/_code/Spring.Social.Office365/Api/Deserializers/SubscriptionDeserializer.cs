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
	class SubscriptionDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Subscription obj = new Subscription();
			obj.RawContent = json.ToString();
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.FolderDeserializer.Deserialize " + obj.RawContent);
			
			try
			{
				// Entity
				obj.Id                           = json.GetValueOrDefault<String>   ("id"                        );
				
				// Subscription
				obj.ApplicationId                = json.GetValueOrDefault<String>   ("applicationId"             );
				obj.ChangeType                   = json.GetValueOrDefault<String>   ("changeType"                );
				obj.ClientState                  = json.GetValueOrDefault<String>   ("clientState"               );
				obj.CreatorId                    = json.GetValueOrDefault<String>   ("creatorId"                 );
				obj.EncryptionCertificate        = json.GetValueOrDefault<String>   ("encryptionCertificate"     );
				obj.EncryptionCertificateId      = json.GetValueOrDefault<String>   ("encryptionCertificateId"   );
				obj.ExpirationDateTime           = json.GetValueOrDefault<DateTime?>("expirationDateTime"        );
				obj.IncludeResourceData          = json.GetValueOrDefault<bool?>    ("includeResourceData"       );
				obj.LatestSupportedTlsVersion    = json.GetValueOrDefault<String>   ("latestSupportedTlsVersion" );
				obj.LifecycleNotificationUrl     = json.GetValueOrDefault<String>   ("lifecycleNotificationUrl"  );
				obj.NotificationUrl              = json.GetValueOrDefault<String>   ("notificationUrl"           );
				obj.Resource                     = json.GetValueOrDefault<String>   ("resource"                  );
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

	class SubscriptionListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Subscription> subscriptions = new List<Subscription>();
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					subscriptions.Add( mapper.Deserialize<Subscription>(itemValue) );
				}
			}
			return subscriptions;
		}
	}

	class SubscriptionPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			SubscriptionPagination pag = new SubscriptionPagination();
			//JsonUtils.FaultCheck(json);
			if ( json != null && !json.IsNull )
			{
				pag.count = json.GetValueOrDefault<int>("@odata.count");
				//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.SubscriptionPaginationDeserializer.Deserialize " + json.ToString());
				JsonValue subscriptions  = json.GetValue("value");
				if ( subscriptions != null && !subscriptions.IsNull )
				{
					pag.subscriptions = mapper.Deserialize<IList<Subscription>>(subscriptions);
				}
			}
			return pag;
		}
	}
}
