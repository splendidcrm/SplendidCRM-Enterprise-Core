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
	class AttachmentSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Attachment o = obj as Attachment;
			
			JsonObject json = new JsonObject();
			// 03/01/2021 Paul.  Must specify attachement type. 
			json.AddValue("@odata.type"         , new JsonValue(o.ODataType));
			// ItemAttachment fields. 
			json.AddValue("contentType"         , (Sql.IsEmptyString  (o.ContentType                  ) ? new JsonValue() : new JsonValue(o.ContentType         )));
			json.AddValue("name"                , (Sql.IsEmptyString  (o.Name                         ) ? new JsonValue() : new JsonValue(o.Name                )));
			json.AddValue("size"                , (                   !o.Size                .HasValue  ? new JsonValue() : new JsonValue(o.Size                .Value)));
			json.AddValue("isInline"            , (                   !o.IsInline            .HasValue  ? new JsonValue() : new JsonValue(o.IsInline            .Value)));
			json.AddValue("lastModifiedDateTime", (Sql.IsEmptyDateTime(o.LastModifiedDateTime         ) ? new JsonValue() : new JsonValue(o.LastModifiedDateTime.Value.ToString(Spring.Social.Office365.Api.DateTimeTimeZone.DateTimeFormat))));
			// FileAttachment fields. 
			json.AddValue("contentId"           , (Sql.IsEmptyString  (o.ContentId                    ) ? new JsonValue() : new JsonValue(o.ContentId           )));
			json.AddValue("contentLocation"     , (Sql.IsEmptyString  (o.ContentLocation              ) ? new JsonValue() : new JsonValue(o.ContentLocation     )));
			json.AddValue("contentBytes"        , (Sql.IsEmptyString  (o.ContentBytes                 ) ? new JsonValue() : new JsonValue(Convert.ToBase64String(o.ContentBytes))));
			return json;
		}
	}

	// 03/01/2021 Paul.  Need attachment list serializer. 
	class AttachmentListSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			IList<Attachment> lst = obj as IList<Attachment>;
			JsonArray json = new JsonArray();
			if ( lst != null )
			{
				foreach ( Attachment o in lst )
				{
					json.AddValue(mapper.Serialize(o));
				}
			}
			return json;
		}
	}
}
