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
	class QuestionAndAnswerSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			QuestionAndAnswer o = obj as QuestionAndAnswer;
			
			JsonObject json = new JsonObject();
			if ( o.question != null )
			{
				JsonArray arr = new JsonArray();
				foreach ( string s in o.question )
				{
					arr.AddValue(new JsonValue(s));
				}
				json.AddValue("question", arr);
			}
			if ( o.answer   != null )
			{
				JsonArray arr = new JsonArray();
				foreach ( string s in o.question )
				{
					arr.AddValue(new JsonValue(s));
				}
				json.AddValue("answer", arr);
			}
			return json;
		}
	}

	class QuestionAndAnswerListSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			IList<QuestionAndAnswer> lst = obj as IList<QuestionAndAnswer>;
			JsonArray json = new JsonArray();
			if ( lst != null )
			{
				foreach ( QuestionAndAnswer o in lst )
				{
					json.AddValue(mapper.Serialize(o));
				}
			}
			return json;
		}
	}
}
