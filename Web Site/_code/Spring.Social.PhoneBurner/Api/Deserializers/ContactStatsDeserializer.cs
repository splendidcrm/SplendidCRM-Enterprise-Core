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

namespace Spring.Social.PhoneBurner.Api.Impl.Json
{
	class ContactStatsDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ContactStats obj = new ContactStats();

			try
			{
				obj.original_category_id = json.GetValueOrDefault<String   >("original_category_id");
				obj.archived             = json.GetValueOrDefault<String   >("archived"            );
				obj.trashed              = json.GetValueOrDefault<String   >("trashed"             );
				obj.removed              = json.GetValueOrDefault<String   >("removed"             );
				obj.viewed               = json.GetValueOrDefault<String   >("viewed"              );
				obj.rating               = json.GetValueOrDefault<String   >("rating"              );
				obj.vendor_id            = json.GetValueOrDefault<String   >("vendor_id"           );
				obj.contact_num          = json.GetValueOrDefault<String   >("contact_num"         );
				
				JsonValue contacted = json.GetValue("contacted");
				if ( contacted != null && contacted.IsString )
				{
					string sContacted = contacted.GetValue<String>();
					if ( !Sql.IsEmptyString(sContacted) && sContacted != "0000-00-00 00:00:00" )
					{
						obj.contacted = json.GetValueOrDefault<DateTime>("contacted");
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
}
