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

namespace Spring.Social.PhoneBurner.Api.Impl.Json
{
	class DialSessionResultDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			DialSessionResult obj = new DialSessionResult();
			obj.RawContent = json.ToString();
			//Debug.WriteLine("Spring.Social.PhoneBurner.Api.Impl.Json.DialSessionResultDeserializer.Deserialize " + obj.RawContent);
			
			try
			{
				obj.status = json.GetValueOrDefault<String>("status");
				JsonValue dialsessions  = json.GetValue("dialsessions");
				if ( dialsessions != null && !dialsessions.IsNull )
				{
					obj.redirect_url          = dialsessions.GetValueOrDefault<String>("redirect_url"         );
					obj.errors                = dialsessions.GetValueOrDefault<String>("errors"               );
					obj.skipped_contact_count = dialsessions.GetValueOrDefault<int   >("skipped_contact_count");
					obj.contact_limit         = dialsessions.GetValueOrDefault<int   >("contact_limit"        );
					obj.total_results         = dialsessions.GetValueOrDefault<int   >("total_results"        );
					obj.page                  = dialsessions.GetValueOrDefault<int   >("page"                 );
					obj.page_size             = dialsessions.GetValueOrDefault<int   >("page_size"            );
					obj.total_pages           = dialsessions.GetValueOrDefault<int   >("total_pages"          );
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
}
