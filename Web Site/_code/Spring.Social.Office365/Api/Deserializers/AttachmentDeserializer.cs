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
	class AttachmentDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Attachment obj = new Attachment();
			obj.RawContent = json.ToString();

			try
			{
				// Entity
				obj.ODataType                    = json.GetValueOrDefault<String>   ("@odata.type"               );
				obj.Id                           = json.GetValueOrDefault<String>   ("id"                        );
				JsonValue AdditionalData         = json.GetValue                    ("additionalData"            );
				if ( AdditionalData != null && !AdditionalData.IsNull && AdditionalData.IsObject )
					obj.AdditionalData = mapper.Deserialize<AdditionalData>(AdditionalData);
				
				// ItemAttachment
				obj.ContentType                  = json.GetValueOrDefault<String>   ("contentType"               );
				obj.Name                         = json.GetValueOrDefault<String>   ("name"                      );
				obj.Size                         = json.GetValueOrDefault<long?>    ("size"                      );
				obj.IsInline                     = json.GetValueOrDefault<bool?>    ("isInline"                  );
				obj.LastModifiedDateTime         = json.GetValueOrDefault<DateTime?>("lastModifiedDateTime"      );

				// FileAttachment
				if ( obj.ODataType == "#microsoft.graph.fileAttachment" )
				{
					obj.ContentId                    = json.GetValueOrDefault<String>   ("contentId"                 );
					obj.ContentLocation              = json.GetValueOrDefault<String>   ("contentLocation"           );
					string ContentBytes              = json.GetValueOrDefault<String>   ("contentBytes"              );
					if ( !String.IsNullOrEmpty(ContentBytes) )
					{
						obj.ContentBytes = Convert.FromBase64String(ContentBytes);
					}
				}
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

	class AttachmentListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Attachment> attachments = new List<Attachment>();
			//JsonUtils.FaultCheck(json);
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					attachments.Add( mapper.Deserialize<Attachment>(itemValue) );
				}
			}
			return attachments;
		}
	}
}
