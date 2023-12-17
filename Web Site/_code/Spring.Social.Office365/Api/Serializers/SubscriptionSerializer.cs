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
	class SubscriptionSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Subscription o = obj as Subscription;
			
			JsonObject json = new JsonObject();
			json.AddValue("changeType"              , (Sql.IsEmptyString  (o.ChangeType               ) ? new JsonValue() : new JsonValue(o.ChangeType               )));
			json.AddValue("notificationUrl"         , (Sql.IsEmptyString  (o.NotificationUrl          ) ? new JsonValue() : new JsonValue(o.NotificationUrl          )));
			json.AddValue("resource"                , (Sql.IsEmptyString  (o.Resource                 ) ? new JsonValue() : new JsonValue(o.Resource                 )));
			json.AddValue("clientState"             , (Sql.IsEmptyString  (o.ClientState              ) ? new JsonValue() : new JsonValue(o.ClientState              )));
			json.AddValue("lifecycleNotificationUrl", (Sql.IsEmptyString  (o.LifecycleNotificationUrl ) ? new JsonValue() : new JsonValue(o.LifecycleNotificationUrl )));
			json.AddValue("includeResourceData"     , (Sql.IsEmptyString  (o.IncludeResourceData.Value) ? new JsonValue() : new JsonValue(o.IncludeResourceData.Value)));
			if ( Sql.IsEmptyString(o.Id) )
			{
				json.AddValue("applicationId"       , (Sql.IsEmptyString  (o.ApplicationId            ) ? new JsonValue() : new JsonValue(o.ApplicationId            )));
				json.AddValue("creatorId"           , (Sql.IsEmptyString  (o.CreatorId                ) ? new JsonValue() : new JsonValue(o.CreatorId                )));
			}

			if ( !Sql.IsEmptyString(o.EncryptionCertificate    ) ) json.AddValue("encryptionCertificate"    , new JsonValue(o.EncryptionCertificate    ));
			if ( !Sql.IsEmptyString(o.EncryptionCertificateId  ) ) json.AddValue("encryptionCertificateId"  , new JsonValue(o.EncryptionCertificateId  ));
			if ( !Sql.IsEmptyString(o.LatestSupportedTlsVersion) ) json.AddValue("latestSupportedTlsVersion", new JsonValue(o.LatestSupportedTlsVersion));

			json.AddValue("expirationDateTime", (Sql.IsEmptyDateTime(o.ExpirationDateTime) ? new JsonValue() : new JsonValue(o.ExpirationDateTime.Value.UtcDateTime.ToString(Spring.Social.Office365.Api.DateTimeTimeZone.DateTimeFormat))));
			return json;
		}
	}

	class SubscriptionUpdateSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Subscription o = obj as Subscription;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.ChangeType                 ) ) json.AddValue("changeType"              , new JsonValue(o.ChangeType               ));
			if ( !Sql.IsEmptyString(o.NotificationUrl            ) ) json.AddValue("notificationUrl"         , new JsonValue(o.NotificationUrl          ));
			if ( !Sql.IsEmptyString(o.Resource                   ) ) json.AddValue("resource"                , new JsonValue(o.Resource                 ));
			if ( !Sql.IsEmptyString(o.ClientState                ) ) json.AddValue("clientState"             , new JsonValue(o.ClientState              ));
			if (                    o.IncludeResourceData.HasValue ) json.AddValue("includeResourceData"     , new JsonValue(o.IncludeResourceData.Value));

			if (                    o.ExpirationDateTime .HasValue ) json.AddValue("expirationDateTime"      , new JsonValue(o.ExpirationDateTime.Value.UtcDateTime.ToString(Spring.Social.Office365.Api.DateTimeTimeZone.DateTimeFormat)));
			return json;
		}
	}
}
