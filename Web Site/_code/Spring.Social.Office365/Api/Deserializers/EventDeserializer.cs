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
	class EventDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Event obj = new Event();
			obj.RawContent = json.ToString();
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.CalendarDeserializer.Deserialize " + obj.RawContent);
			
			try
			{
				// Entity
				obj.Id                           = json.GetValueOrDefault<String>   ("id"                           );
				// 01/12/2021 Paul.  Record is deleted if @removed is provided. 
				obj.Deleted                      = json.ContainsName("@removed");
				JsonValue AdditionalData         = json.GetValue                    ("additionalData"               );
				if ( AdditionalData != null && !AdditionalData.IsNull && AdditionalData.IsObject )
					obj.AdditionalData = mapper.Deserialize<AdditionalData>(AdditionalData);
				
				// OutlookItem
				obj.CreatedDateTime              = json.GetValueOrDefault<DateTime?>("createdDateTime"           );
				obj.LastModifiedDateTime         = json.GetValueOrDefault<DateTime?>("lastModifiedDateTime"      );
				obj.ChangeKey                    = json.GetValueOrDefault<String>   ("changeKey"                 );
				JsonValue Categories             = json.GetValue                    ("categories"                );
				if ( Categories != null && !Categories.IsNull && Categories.IsArray )
					obj.Categories  = mapper.Deserialize<IList<String>>(Categories );
				
				// Event
				obj.AllowNewTimeProposals        = json.GetValueOrDefault<bool?    >("allowNewTimeProposals"     );
				obj.BodyPreview                  = json.GetValueOrDefault<String   >("bodyPreview"               );
				obj.HasAttachments               = json.GetValueOrDefault<bool?    >("hasAttachments"            );
				obj.ICalUId                      = json.GetValueOrDefault<String   >("iCalUId"                   );
				obj.Importance                   = json.GetValueOrDefault<String   >("importance"                );
				obj.IsAllDay                     = json.GetValueOrDefault<bool?    >("isAllDay"                  );
				obj.IsCancelled                  = json.GetValueOrDefault<bool?    >("isCancelled"               );
				obj.IsDraft                      = json.GetValueOrDefault<bool?    >("isDraft"                   );
				obj.IsOnlineMeeting              = json.GetValueOrDefault<bool?    >("isOnlineMeeting"           );
				obj.IsOrganizer                  = json.GetValueOrDefault<bool?    >("isOrganizer"               );
				obj.IsReminderOn                 = json.GetValueOrDefault<bool?    >("isReminderOn"              );
				obj.OnlineMeetingProvider        = json.GetValueOrDefault<String   >("onlineMeetingProvider"     );
				obj.OnlineMeetingUrl             = json.GetValueOrDefault<String   >("onlineMeetingUrl"          );
				obj.OriginalEndTimeZone          = json.GetValueOrDefault<String   >("originalEndTimeZone"       );
				obj.OriginalStart                = json.GetValueOrDefault<DateTime?>("originalStart"             );
				obj.OriginalStartTimeZone        = json.GetValueOrDefault<String   >("originalStartTimeZone"     );
				obj.ReminderMinutesBeforeStart   = json.GetValueOrDefault<Int32?   >("reminderMinutesBeforeStart");
				obj.ResponseRequested            = json.GetValueOrDefault<bool?    >("responseRequested"         );
				obj.Sensitivity                  = json.GetValueOrDefault<String   >("sensitivity"               );
				obj.SeriesMasterId               = json.GetValueOrDefault<String   >("seriesMasterId"            );
				obj.ShowAs                       = json.GetValueOrDefault<String   >("showAs"                    );
				obj.Subject                      = json.GetValueOrDefault<String   >("subject"                   );
				obj.TransactionId                = json.GetValueOrDefault<String   >("transactionId"             );
				obj.Type                         = json.GetValueOrDefault<String   >("type"                      );
				obj.WebLink                      = json.GetValueOrDefault<String   >("webLink"                   );
				
				JsonValue Body                   = json.GetValue                    ("body"                      );
				JsonValue End                    = json.GetValue                    ("end"                       );
				JsonValue Location               = json.GetValue                    ("location"                  );
				JsonValue OnlineMeeting          = json.GetValue                    ("onlineMeeting"             );
				JsonValue Organizer              = json.GetValue                    ("organizer"                 );
				JsonValue Recurrence             = json.GetValue                    ("recurrence"                );
				JsonValue ResponseStatus         = json.GetValue                    ("responseStatus"            );
				JsonValue Start                  = json.GetValue                    ("start"                     );
				JsonValue Calendar               = json.GetValue                    ("calendar"                  );
				if ( Body           != null && !Body          .IsNull && Body          .IsObject ) obj.Body           = mapper.Deserialize<ItemBody           >(Body          );
				if ( End            != null && !End           .IsNull && End           .IsObject ) obj.End            = mapper.Deserialize<DateTimeTimeZone   >(End           );
				if ( Location       != null && !Location      .IsNull && Location      .IsObject ) obj.Location       = mapper.Deserialize<Location           >(Location      );
				if ( OnlineMeeting  != null && !OnlineMeeting .IsNull && OnlineMeeting .IsObject ) obj.OnlineMeeting  = mapper.Deserialize<OnlineMeetingInfo  >(OnlineMeeting );
				if ( Organizer      != null && !Organizer     .IsNull && Organizer     .IsObject ) obj.Organizer      = mapper.Deserialize<Recipient          >(Organizer     );
				if ( Recurrence     != null && !Recurrence    .IsNull && Recurrence    .IsObject ) obj.Recurrence     = mapper.Deserialize<PatternedRecurrence>(Recurrence    );
				if ( ResponseStatus != null && !ResponseStatus.IsNull && ResponseStatus.IsObject ) obj.ResponseStatus = mapper.Deserialize<ResponseStatus     >(ResponseStatus);
				if ( Start          != null && !Start         .IsNull && Start         .IsObject ) obj.Start          = mapper.Deserialize<DateTimeTimeZone   >(Start         );
				if ( Calendar       != null && !Calendar      .IsNull && Calendar      .IsObject ) obj.Calendar       = mapper.Deserialize<Calendar           >(Calendar      );
				
				JsonValue Attendees              = json.GetValue                    ("attendees"                 );
				JsonValue Locations              = json.GetValue                    ("locations"                 );
				JsonValue Attachments            = json.GetValue                    ("attachments"               );
				if ( Attendees   != null && !Attendees  .IsNull && Attendees  .IsArray  ) obj.Attendees   = mapper.Deserialize<IList<Attendee>  >(Attendees  );
				if ( Locations   != null && !Locations  .IsNull && Locations  .IsArray  ) obj.Locations   = mapper.Deserialize<IList<Location>  >(Locations  );
				if ( Attachments != null && !Attachments.IsNull && Attachments.IsArray  ) obj.Attachments = mapper.Deserialize<IList<Attachment>>(Attachments);
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

	class EventListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Event> events = new List<Event>();
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					events.Add( mapper.Deserialize<Event>(itemValue) );
				}
			}
			return events;
		}
	}

	class EventPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			EventPagination pag = new EventPagination();
			//JsonUtils.FaultCheck(json);
			if ( json != null && !json.IsNull )
			{
				pag.count     = json.GetValueOrDefault<int   >("@odata.count"    );
				pag.nextLink  = json.GetValueOrDefault<String>("@odata.nextLink" );
				pag.deltaLink = json.GetValueOrDefault<String>("@odata.deltaLink");
				//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.EventPaginationDeserializer.Deserialize " + json.ToString());
				JsonValue events  = json.GetValue("value");
				if ( events != null && !events.IsNull )
				{
					pag.events = mapper.Deserialize<IList<Event>>(events);
				}
			}
			return pag;
		}
	}
}
