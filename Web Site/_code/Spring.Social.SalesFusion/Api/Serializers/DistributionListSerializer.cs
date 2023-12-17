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

namespace Spring.Social.SalesFusion.Api.Impl.Json
{
	class DistributionListSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			DistributionList o = obj as DistributionList;
			
			JsonObject json           = new JsonObject();
			if ( o.owner_id                     .HasValue ) json.AddValue("owner_id"                     , new JsonValue(o.owner_id                     .Value));
			if ( o.crm_id                       != null   ) json.AddValue("crm_id"                       , new JsonValue(o.crm_id                             ));

			//if ( o.list_id                      .HasValue ) json.AddValue("list_id"                      , new JsonValue(o.list_id                      .Value));
			if ( o.list_name                    != null   ) json.AddValue("list_name"                    , new JsonValue(o.list_name                          ));
			//if ( o.list                         != null   ) json.AddValue("list"                         , new JsonValue(o.list                               ));
			if ( o.list_type                    != null   ) json.AddValue("list_type"                    , new JsonValue(o.list_type                          ));
			if ( o.description                  != null   ) json.AddValue("description"                  , new JsonValue(o.description                        ));
			o.RawContent = json.ToString();
			return json;
		}
	}
}
