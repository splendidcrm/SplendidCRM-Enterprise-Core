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
	class FolderDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			MailFolder obj = new MailFolder();
			obj.RawContent = json.ToString();
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.FolderDeserializer.Deserialize " + obj.RawContent);
			
			try
			{
				// Entity
				obj.Id                           = json.GetValueOrDefault<String>   ("id"                        );
				// 01/12/2021 Paul.  Record is deleted if @removed is provided. 
				obj.Deleted                      = json.ContainsName("@removed");
				
				// Folder
				obj.DisplayName                  = json.GetValueOrDefault<String>   ("displayName"               );
				obj.ParentFolderId               = json.GetValueOrDefault<String>   ("parentFolderId"            );
				obj.ChildFolderCount             = json.GetValueOrDefault<int>      ("childFolderCount"          );
				obj.UnreadItemCount              = json.GetValueOrDefault<int>      ("unreadItemCount"           );
				obj.TotalItemCount               = json.GetValueOrDefault<int>      ("totalItemCount"            );
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

	class FolderListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<MailFolder> folders = new List<MailFolder>();
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					folders.Add( mapper.Deserialize<MailFolder>(itemValue) );
				}
			}
			return folders;
		}
	}

	class FolderPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			MailFolderPagination pag = new MailFolderPagination();
			//JsonUtils.FaultCheck(json);
			if ( json != null && !json.IsNull )
			{
				pag.count = json.GetValueOrDefault<int>("@odata.count");
				//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.CategoryPaginationDeserializer.Deserialize " + json.ToString());
				JsonValue folders  = json.GetValue("value");
				if ( folders != null && !folders.IsNull )
				{
					pag.folders = mapper.Deserialize<IList<MailFolder>>(folders);
				}
			}
			return pag;
		}
	}
}
