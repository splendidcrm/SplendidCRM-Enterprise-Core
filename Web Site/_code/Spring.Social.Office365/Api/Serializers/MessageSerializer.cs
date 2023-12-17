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
	class MessageSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Message o = obj as Message;
			
			JsonObject json = new JsonObject();
			// 01/04/2020 Paul.  SendTestMessage does not specify a category. 
			if ( o.Categories != null )
				json.AddValue("categories", mapper.Serialize(o.Categories));

			o.HasAttachments = (o.Attachments != null && o.Attachments.Count > 0);
			//json.AddValue("bodyPreview"                  , (Sql.IsEmptyString(o.BodyPreview                         ) ? new JsonValue()  :    new JsonValue(o.BodyPreview                  )));
			//json.AddValue("conversationId"               , (Sql.IsEmptyString(o.ConversationId                      ) ? new JsonValue()  :    new JsonValue(o.ConversationId               )));
			//json.AddValue("conversationIndex"            , (Sql.IsEmptyString(o.ConversationIndex                   ) ? new JsonValue()  :    new JsonValue(o.ConversationIndex            )));
			json.AddValue("hasAttachments"               , (                 !o.HasAttachments             .HasValue  ? new JsonValue()  :    new JsonValue(o.HasAttachments               .Value)));
			json.AddValue("importance"                   , (Sql.IsEmptyString(o.Importance                          ) ? new JsonValue()  :    new JsonValue(o.Importance                   )));
			json.AddValue("inferenceClassification"      , (Sql.IsEmptyString(o.InferenceClassification             ) ? new JsonValue()  :    new JsonValue(o.InferenceClassification      )));
			//json.AddValue("internetMessageId"            , (Sql.IsEmptyString(o.InternetMessageId                   ) ? new JsonValue()  :    new JsonValue(o.InternetMessageId            )));
			json.AddValue("isDeliveryReceiptRequested"   , (                 !o.IsDeliveryReceiptRequested .HasValue  ? new JsonValue()  :    new JsonValue(o.IsDeliveryReceiptRequested   .Value)));
			//json.AddValue("isDraft"                      , (                 !o.IsDraft                    .HasValue  ? new JsonValue()  :    new JsonValue(o.IsDraft                      .Value)));
			//json.AddValue("isRead"                       , (                 !o.IsRead                     .HasValue  ? new JsonValue()  :    new JsonValue(o.IsRead                       .Value)));
			json.AddValue("isReadReceiptRequested"       , (                 !o.IsReadReceiptRequested     .HasValue  ? new JsonValue()  :    new JsonValue(o.IsReadReceiptRequested       .Value)));
			json.AddValue("parentFolderId"               , (Sql.IsEmptyString(o.ParentFolderId                      ) ? new JsonValue()  :    new JsonValue(o.ParentFolderId               )));
			//json.AddValue("receivedDateTime"             , (                  o.ReceivedDateTime              == null ? new JsonValue()  :    new JsonValue(o.ReceivedDateTime             .Value.ToString(Spring.Social.Office365.Api.DateTimeTimeZone.DateTimeFormat))));
			//json.AddValue("sentDateTime"                 , (                  o.SentDateTime                  == null ? new JsonValue()  :    new JsonValue(o.SentDateTime                 .Value.ToString(Spring.Social.Office365.Api.DateTimeTimeZone.DateTimeFormat))));
			json.AddValue("subject"                      , (Sql.IsEmptyString(o.Subject                             ) ? new JsonValue()  :    new JsonValue(o.Subject                      )));
			//json.AddValue("webLink"                      , (Sql.IsEmptyString(o.WebLink                             ) ? new JsonValue()  :    new JsonValue(o.WebLink                      )));

			json.AddValue("body"                         , (                  o.Body                          == null ? new JsonObject() : mapper.Serialize(o.Body                         )));
			json.AddValue("flag"                         , (                  o.Flag                          == null ? new JsonObject() : mapper.Serialize(o.Flag                         )));
			json.AddValue("from"                         , (                  o.From                          == null ? new JsonObject() : mapper.Serialize(o.From                         )));
			json.AddValue("sender"                       , (                  o.Sender                        == null ? new JsonObject() : mapper.Serialize(o.Sender                       )));
			//json.AddValue("uniqueBody"                   , (                  o.UniqueBody                    == null ? new JsonObject() : mapper.Serialize(o.UniqueBody                   )));

			json.AddValue("bccRecipients"                , (                  o.BccRecipients                 == null ? new JsonArray()  : mapper.Serialize(o.BccRecipients                )));
			json.AddValue("ccRecipients"                 , (                  o.CcRecipients                  == null ? new JsonArray()  : mapper.Serialize(o.CcRecipients                 )));
			json.AddValue("replyTo"                      , (                  o.ReplyTo                       == null ? new JsonArray()  : mapper.Serialize(o.ReplyTo                      )));
			json.AddValue("toRecipients"                 , (                  o.ToRecipients                  == null ? new JsonArray()  : mapper.Serialize(o.ToRecipients                 )));
			json.AddValue("attachments"                  , (                  o.Attachments                   == null ? new JsonArray()  : mapper.Serialize(o.Attachments                  )));
			json.AddValue("singleValueExtendedProperties", (                  o.SingleValueExtendedProperties == null ? new JsonArray()  : mapper.Serialize(o.SingleValueExtendedProperties)));
			return json;
		}
	}

	class MessageUpdateSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Message o = obj as Message;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.Importance                          ) ) json.AddValue("importance"                   ,    new JsonValue(o.Importance                   ));
			if ( !Sql.IsEmptyString(o.InferenceClassification             ) ) json.AddValue("inferenceClassification"      ,    new JsonValue(o.InferenceClassification      ));
			if (                    o.IsDeliveryReceiptRequested .HasValue  ) json.AddValue("isDeliveryReceiptRequested"   ,    new JsonValue(o.IsDeliveryReceiptRequested   .Value));
			if (                    o.IsRead                     .HasValue  ) json.AddValue("isRead"                       ,    new JsonValue(o.IsRead                       .Value));
			if (                    o.IsReadReceiptRequested     .HasValue  ) json.AddValue("isReadReceiptRequested"       ,    new JsonValue(o.IsReadReceiptRequested       .Value));
			if ( !Sql.IsEmptyString(o.Subject                             ) ) json.AddValue("subject"                      ,    new JsonValue(o.Subject                      ));

			if (                    o.Body                          != null ) json.AddValue("body"                         , mapper.Serialize(o.Body                         ));
			if (                    o.Flag                          != null ) json.AddValue("flag"                         , mapper.Serialize(o.Flag                         ));
			if (                    o.From                          != null ) json.AddValue("from"                         , mapper.Serialize(o.From                         ));
			if (                    o.Sender                        != null ) json.AddValue("sender"                       , mapper.Serialize(o.Sender                       ));

			if (                    o.Categories                    != null ) json.AddValue("categories"                   , mapper.Serialize(o.Categories                   ));
			if (                    o.BccRecipients                 != null ) json.AddValue("bccRecipients"                , mapper.Serialize(o.BccRecipients                ));
			if (                    o.CcRecipients                  != null ) json.AddValue("ccRecipients"                 , mapper.Serialize(o.CcRecipients                 ));
			if (                    o.ReplyTo                       != null ) json.AddValue("replyTo"                      , mapper.Serialize(o.ReplyTo                      ));
			if (                    o.ToRecipients                  != null ) json.AddValue("toRecipients"                 , mapper.Serialize(o.ToRecipients                 ));
			if (                    o.SingleValueExtendedProperties != null ) json.AddValue("singleValueExtendedProperties", mapper.Serialize(o.SingleValueExtendedProperties));
			return json;
		}
	}
}
