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
	class MyProfileDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			MyProfile obj = new MyProfile();
			obj.RawContent = json.ToString();
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.MyProfileDeserializer.Deserialize " + obj.RawContent);
			
			try
			{
				obj.Id                   = json.GetValueOrDefault<String>   ("id"               );
				obj.UserPrincipalName    = json.GetValueOrDefault<String>   ("userPrincipalName");
				obj.DisplayName          = json.GetValueOrDefault<String>   ("displayName"      );
				obj.GivenName            = json.GetValueOrDefault<String>   ("givenName"        );
				obj.Surname              = json.GetValueOrDefault<String>   ("surname"          );
				obj.JobTitle             = json.GetValueOrDefault<String>   ("jobTitle"         );
				obj.Mail                 = json.GetValueOrDefault<String>   ("mail"             );
				obj.MobilePhone          = json.GetValueOrDefault<String>   ("mobilePhone"      );
				obj.OfficeLocation       = json.GetValueOrDefault<String>   ("officeLocation"   );
				obj.PreferredLanguage    = json.GetValueOrDefault<String>   ("preferredLanguage");
				
				JsonValue BusinessPhones = json.GetValue                    ("businessPhones"   );
				if ( BusinessPhones != null && !BusinessPhones .IsNull && BusinessPhones .IsArray ) obj.BusinessPhones = mapper.Deserialize<IList<String>>(BusinessPhones);
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
