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
	class EventSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Event o = obj as Event;
			
			JsonObject json = new JsonObject();
			json.AddValue("categories", mapper.Serialize(o.Categories));
			
			o.HasAttachments = (o.Attachments != null && o.Attachments.Count > 0);
			if ( o.IsNew )
			{
				o.Importance  = "normal";
				o.IsOrganizer = true    ;
				o.ShowAs      = "busy"  ;
				o.Type        = (o.Recurrence == null ? "singleInstance" : "seriesMaster");
			}
			// Event
			json.AddValue("allowNewTimeProposals"     , (                    !o.AllowNewTimeProposals     .HasValue  ? new JsonValue(true ) : new JsonValue(o.AllowNewTimeProposals     .Value)));
			json.AddValue("bodyPreview"               , (Sql.IsEmptyString   (o.BodyPreview                        ) ? new JsonValue() : new JsonValue(o.BodyPreview                     )));
			json.AddValue("hasAttachments"            , (                    !o.HasAttachments            .HasValue  ? new JsonValue() : new JsonValue(o.HasAttachments            .Value)));
			//json.AddValue("iCalUId"                   , (Sql.IsEmptyString   (o.ICalUId                            ) ? new JsonValue() : new JsonValue(o.ICalUId                         )));
			json.AddValue("importance"                , (Sql.IsEmptyString   (o.Importance                         ) ? new JsonValue() : new JsonValue(o.Importance                      )));
			json.AddValue("isAllDay"                  , (                    !o.IsAllDay                  .HasValue  ? new JsonValue(false) : new JsonValue(o.IsAllDay                  .Value)));
			json.AddValue("isCancelled"               , (                    !o.IsCancelled               .HasValue  ? new JsonValue(false) : new JsonValue(o.IsCancelled               .Value)));
			json.AddValue("isDraft"                   , (                    !o.IsDraft                   .HasValue  ? new JsonValue(false) : new JsonValue(o.IsDraft                   .Value)));
			json.AddValue("isOnlineMeeting"           , (                    !o.IsOnlineMeeting           .HasValue  ? new JsonValue(false) : new JsonValue(o.IsOnlineMeeting           .Value)));
			json.AddValue("isOrganizer"               , (                    !o.IsOrganizer               .HasValue  ? new JsonValue(false) : new JsonValue(o.IsOrganizer               .Value)));
			json.AddValue("isReminderOn"              , (                    !o.IsReminderOn              .HasValue  ? new JsonValue(false) : new JsonValue(o.IsReminderOn              .Value)));
			//json.AddValue("onlineMeetingProvider"     , (Sql.IsEmptyString   (o.OnlineMeetingProvider              ) ? new JsonValue() : new JsonValue(o.OnlineMeetingProvider           )));
			//json.AddValue("onlineMeetingUrl"          , (Sql.IsEmptyString   (o.OnlineMeetingUrl                   ) ? new JsonValue() : new JsonValue(o.OnlineMeetingUrl                )));
			json.AddValue("originalEndTimeZone"       , (Sql.IsEmptyString   (o.OriginalEndTimeZone                ) ? new JsonValue() : new JsonValue(o.OriginalEndTimeZone             )));
			json.AddValue("originalStart"             , (Sql.IsEmptyDateTime (o.OriginalStart                      ) ? new JsonValue() : new JsonValue(o.OriginalStart             .Value.ToString(Spring.Social.Office365.Api.DateTimeTimeZone.DateTimeFormat))));
			json.AddValue("originalStartTimeZone"     , (Sql.IsEmptyString   (o.OriginalStartTimeZone              ) ? new JsonValue() : new JsonValue(o.OriginalStartTimeZone           )));
			json.AddValue("reminderMinutesBeforeStart", (                    !o.ReminderMinutesBeforeStart.HasValue  ? new JsonValue(0) : new JsonValue(o.ReminderMinutesBeforeStart.Value)));
			json.AddValue("responseRequested"         , (                    !o.ResponseRequested         .HasValue  ? new JsonValue(false) : new JsonValue(o.ResponseRequested         .Value)));
			json.AddValue("sensitivity"               , (Sql.IsEmptyString   (o.Sensitivity                        ) ? new JsonValue() : new JsonValue(o.Sensitivity                     )));
			json.AddValue("seriesMasterId"            , (Sql.IsEmptyString   (o.SeriesMasterId                     ) ? new JsonValue() : new JsonValue(o.SeriesMasterId                  )));
			json.AddValue("showAs"                    , (Sql.IsEmptyString   (o.ShowAs                             ) ? new JsonValue() : new JsonValue(o.ShowAs                          )));
			json.AddValue("subject"                   , (Sql.IsEmptyString   (o.Subject                            ) ? new JsonValue() : new JsonValue(o.Subject                         )));
			json.AddValue("transactionId"             , (Sql.IsEmptyString   (o.TransactionId                      ) ? new JsonValue() : new JsonValue(o.TransactionId                   )));
			json.AddValue("type"                      , (Sql.IsEmptyString   (o.Type                               ) ? new JsonValue() : new JsonValue(o.Type                            )));
			json.AddValue("webLink"                   , (Sql.IsEmptyString   (o.WebLink                            ) ? new JsonValue() : new JsonValue(o.WebLink                         )));
			
			json.AddValue("body"                      , (                     o.Body            == null              ? new JsonObject() : mapper.Serialize(o.Body           )));
			json.AddValue("end"                       , (                     o.End             == null              ? new JsonObject() : mapper.Serialize(o.End            )));
			json.AddValue("location"                  , (                     o.Location        == null              ? new JsonObject() : mapper.Serialize(o.Location       )));
			//json.AddValue("onlineMeeting"             , (                     o.OnlineMeeting   == null              ? new JsonObject() : mapper.Serialize(o.OnlineMeeting  )));
			json.AddValue("organizer"                 , (                     o.Organizer       == null              ? new JsonObject() : mapper.Serialize(o.Organizer      )));
			// 12/12/2020 Paul.  Recurrence can be be null, it cannot be an empty object. 
			json.AddValue("recurrence"                , (                     o.Recurrence      == null              ? new JsonValue()  : mapper.Serialize(o.Recurrence     )));
			json.AddValue("responseStatus"            , (                     o.ResponseStatus  == null              ? new JsonObject() : mapper.Serialize(o.ResponseStatus )));
			json.AddValue("start"                     , (                     o.Start           == null              ? new JsonObject() : mapper.Serialize(o.Start          )));
			json.AddValue("calendar"                  , (                     o.Calendar        == null              ? new JsonObject() : mapper.Serialize(o.Calendar       )));

			json.AddValue("attendees"                 , (                     o.Attendees       == null              ? new JsonArray() : mapper.Serialize(o.Attendees      )));
			json.AddValue("locations"                 , (                     o.Locations       == null              ? new JsonArray() : mapper.Serialize(o.Locations      )));
			json.AddValue("attachments"               , (                     o.Attachments     == null              ? new JsonArray() : mapper.Serialize(o.Attachments    )));
			return json;
		}
	}
}
