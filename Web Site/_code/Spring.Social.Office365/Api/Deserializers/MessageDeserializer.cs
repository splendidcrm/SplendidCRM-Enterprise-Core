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
	class MessageDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Message obj = new Message();
			obj.RawContent = json.ToString();
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.ContactDeserializer.Deserialize " + obj.RawContent);
			
			try
			{
				// Entity
				obj.Id                           = json.GetValueOrDefault<String>   ("id"                        );
				// 01/12/2021 Paul.  Record is deleted if @removed is provided. 
				obj.Deleted                      = json.ContainsName("@removed");
				JsonValue AdditionalData         = json.GetValue                    ("additionalData"            );
				if ( AdditionalData != null && !AdditionalData.IsNull && AdditionalData.IsObject )
					obj.AdditionalData = mapper.Deserialize<AdditionalData>(AdditionalData);

				// OutlookItem
				obj.CreatedDateTime              = json.GetValueOrDefault<DateTime?>("createdDateTime"           );
				obj.LastModifiedDateTime         = json.GetValueOrDefault<DateTime?>("lastModifiedDateTime"      );
				obj.ChangeKey                    = json.GetValueOrDefault<String>   ("changeKey"                 );
				JsonValue Categories             = json.GetValue                    ("categories"                );
				if ( Categories != null && !Categories.IsNull && Categories.IsArray )
					obj.Categories  = mapper.Deserialize<IList<String>>(Categories );
				
				// Message
				obj.BodyPreview                  = json.GetValueOrDefault<String>   ("bodyPreview"               );
				obj.ConversationId               = json.GetValueOrDefault<String>   ("conversationId"            );
				obj.ConversationIndex            = json.GetValueOrDefault<String>   ("conversationIndex"         );
				obj.HasAttachments               = json.GetValueOrDefault<bool?>    ("hasAttachments"            );
				obj.Importance                   = json.GetValueOrDefault<String>   ("importance"                );
				obj.InferenceClassification      = json.GetValueOrDefault<String>   ("inferenceClassification"   );
				obj.InternetMessageId            = json.GetValueOrDefault<String>   ("internetMessageId"         );
				obj.IsDeliveryReceiptRequested   = json.GetValueOrDefault<bool?>    ("isDeliveryReceiptRequested");
				obj.IsDraft                      = json.GetValueOrDefault<bool?>    ("isDraft"                   );
				obj.IsRead                       = json.GetValueOrDefault<bool?>    ("isRead"                    );
				obj.IsReadReceiptRequested       = json.GetValueOrDefault<bool?>    ("isReadReceiptRequested"    );
				obj.ParentFolderId               = json.GetValueOrDefault<String>   ("parentFolderId"            );
				obj.ReceivedDateTime             = json.GetValueOrDefault<DateTime?>("receivedDateTime"          );
				obj.SentDateTime                 = json.GetValueOrDefault<DateTime?>("sentDateTime"              );
				obj.Subject                      = json.GetValueOrDefault<String>   ("subject"                   );
				obj.WebLink                      = json.GetValueOrDefault<String>   ("webLink"                   );

				JsonValue Body                   = json.GetValue                    ("body"                      );
				JsonValue UniqueBody             = json.GetValue                    ("uniqueBody"                );
				JsonValue Flag                   = json.GetValue                    ("flag"                      );
				JsonValue From                   = json.GetValue                    ("from"                      );
				JsonValue Sender                 = json.GetValue                    ("sender"                    );
				if ( Body       != null && !Body      .IsNull && Body      .IsObject ) obj.Body       = mapper.Deserialize<ItemBody    >(Body      );
				if ( UniqueBody != null && !UniqueBody.IsNull && UniqueBody.IsObject ) obj.UniqueBody = mapper.Deserialize<ItemBody    >(UniqueBody);
				if ( Flag       != null && !Flag      .IsNull && Flag      .IsObject ) obj.Flag       = mapper.Deserialize<FollowupFlag>(Flag      );
				if ( From       != null && !From      .IsNull && From      .IsObject ) obj.From       = mapper.Deserialize<Recipient   >(From      );
				if ( Sender     != null && !Sender    .IsNull && Sender    .IsObject ) obj.Sender     = mapper.Deserialize<Recipient   >(Sender    );

				JsonValue BccRecipients                 = json.GetValue             ("bccRecipients"                );
				JsonValue CcRecipients                  = json.GetValue             ("ccRecipients"                 );
				JsonValue InternetMessageHeaders        = json.GetValue             ("internetMessageHeaders"       );
				JsonValue ReplyTo                       = json.GetValue             ("replyTo"                      );
				JsonValue ToRecipients                  = json.GetValue             ("toRecipients"                 );
				JsonValue Attachments                   = json.GetValue             ("attachments"                  );
				JsonValue SingleValueExtendedProperties = json.GetValue             ("singleValueExtendedProperties");
				if ( BccRecipients                 != null && !BccRecipients                .IsNull && BccRecipients                .IsArray  ) obj.BccRecipients                 = mapper.Deserialize<IList<Recipient>                        >(BccRecipients                );
				if ( CcRecipients                  != null && !CcRecipients                 .IsNull && CcRecipients                 .IsArray  ) obj.CcRecipients                  = mapper.Deserialize<IList<Recipient>                        >(CcRecipients                 );
				if ( InternetMessageHeaders        != null && !InternetMessageHeaders       .IsNull && InternetMessageHeaders       .IsArray  ) obj.InternetMessageHeaders        = mapper.Deserialize<IList<InternetMessageHeader>            >(InternetMessageHeaders       );
				if ( ReplyTo                       != null && !ReplyTo                      .IsNull && ReplyTo                      .IsArray  ) obj.ReplyTo                       = mapper.Deserialize<IList<Recipient>                        >(ReplyTo                      );
				if ( ToRecipients                  != null && !ToRecipients                 .IsNull && ToRecipients                 .IsArray  ) obj.ToRecipients                  = mapper.Deserialize<IList<Recipient>                        >(ToRecipients                 );
				if ( Attachments                   != null && !Attachments                  .IsNull && Attachments                  .IsArray  ) obj.Attachments                   = mapper.Deserialize<IList<Attachment>                       >(Attachments                  );
				if ( SingleValueExtendedProperties != null && !SingleValueExtendedProperties.IsNull && SingleValueExtendedProperties.IsArray  ) obj.SingleValueExtendedProperties = mapper.Deserialize<IList<SingleValueLegacyExtendedProperty>>(SingleValueExtendedProperties);
				
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

	class MessageListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Message> messages = new List<Message>();
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					messages.Add( mapper.Deserialize<Message>(itemValue) );
				}
			}
			return messages;
		}
	}

	class MessagePaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			MessagePagination pag = new MessagePagination();
			//JsonUtils.FaultCheck(json);
			if ( json != null && !json.IsNull )
			{
				pag.count     = json.GetValueOrDefault<int   >("@odata.count"    );
				pag.nextLink  = json.GetValueOrDefault<String>("@odata.nextLink" );
				pag.deltaLink = json.GetValueOrDefault<String>("@odata.deltaLink");

				//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.MessagePaginationDeserializer.Deserialize " + json.ToString());
				JsonValue messages  = json.GetValue("value");
				if ( messages != null && !messages.IsNull )
				{
					pag.messages = mapper.Deserialize<IList<Message>>(messages);
				}
			}
			return pag;
		}
	}
}
