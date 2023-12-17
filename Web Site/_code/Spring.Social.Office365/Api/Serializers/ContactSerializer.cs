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
	class ContactSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Contact o = obj as Contact;
			
			JsonObject json = new JsonObject();
			json.AddValue("categories", mapper.Serialize(o.Categories));

			// Contact
			json.AddValue("assistantName"   , (Sql.IsEmptyString  (o.AssistantName         ) ? new JsonValue() : new JsonValue(o.AssistantName     )));
			json.AddValue("birthday"        , (Sql.IsEmptyDateTime(o.Birthday              ) ? new JsonValue() : new JsonValue(o.Birthday.Value.ToString(Spring.Social.Office365.Api.DateTimeTimeZone.DateTimeFormat))));
			json.AddValue("businessHomePage", (Sql.IsEmptyString  (o.BusinessHomePage      ) ? new JsonValue() : new JsonValue(o.BusinessHomePage  )));
			json.AddValue("companyName"     , (Sql.IsEmptyString  (o.CompanyName           ) ? new JsonValue() : new JsonValue(o.CompanyName       )));
			json.AddValue("department"      , (Sql.IsEmptyString  (o.Department            ) ? new JsonValue() : new JsonValue(o.Department        )));
			json.AddValue("displayName"     , (Sql.IsEmptyString  (o.DisplayName           ) ? new JsonValue() : new JsonValue(o.DisplayName       )));
			json.AddValue("fileAs"          , (Sql.IsEmptyString  (o.FileAs                ) ? new JsonValue() : new JsonValue(o.FileAs            )));
			json.AddValue("generation"      , (Sql.IsEmptyString  (o.Generation            ) ? new JsonValue() : new JsonValue(o.Generation        )));
			json.AddValue("givenName"       , (Sql.IsEmptyString  (o.GivenName             ) ? new JsonValue() : new JsonValue(o.GivenName         )));
			json.AddValue("initials"        , (Sql.IsEmptyString  (o.Initials              ) ? new JsonValue() : new JsonValue(o.Initials          )));
			json.AddValue("jobTitle"        , (Sql.IsEmptyString  (o.JobTitle              ) ? new JsonValue() : new JsonValue(o.JobTitle          )));
			json.AddValue("manager"         , (Sql.IsEmptyString  (o.Manager               ) ? new JsonValue() : new JsonValue(o.Manager           )));
			json.AddValue("middleName"      , (Sql.IsEmptyString  (o.MiddleName            ) ? new JsonValue() : new JsonValue(o.MiddleName        )));
			json.AddValue("mobilePhone"     , (Sql.IsEmptyString  (o.MobilePhone           ) ? new JsonValue() : new JsonValue(o.MobilePhone       )));
			json.AddValue("nickName"        , (Sql.IsEmptyString  (o.NickName              ) ? new JsonValue() : new JsonValue(o.NickName          )));
			json.AddValue("officeLocation"  , (Sql.IsEmptyString  (o.OfficeLocation        ) ? new JsonValue() : new JsonValue(o.OfficeLocation    )));
			json.AddValue("parentFolderId"  , (Sql.IsEmptyString  (o.ParentFolderId        ) ? new JsonValue() : new JsonValue(o.ParentFolderId    )));
			json.AddValue("personalNotes"   , (Sql.IsEmptyString  (o.PersonalNotes         ) ? new JsonValue() : new JsonValue(o.PersonalNotes     )));
			json.AddValue("profession"      , (Sql.IsEmptyString  (o.Profession            ) ? new JsonValue() : new JsonValue(o.Profession        )));
			json.AddValue("spouseName"      , (Sql.IsEmptyString  (o.SpouseName            ) ? new JsonValue() : new JsonValue(o.SpouseName        )));
			json.AddValue("surname"         , (Sql.IsEmptyString  (o.Surname               ) ? new JsonValue() : new JsonValue(o.Surname           )));
			json.AddValue("title"           , (Sql.IsEmptyString  (o.Title                 ) ? new JsonValue() : new JsonValue(o.Title             )));
			json.AddValue("yomiCompanyName" , (Sql.IsEmptyString  (o.YomiCompanyName       ) ? new JsonValue() : new JsonValue(o.YomiCompanyName   )));
			json.AddValue("yomiGivenName"   , (Sql.IsEmptyString  (o.YomiGivenName         ) ? new JsonValue() : new JsonValue(o.YomiGivenName     )));
			json.AddValue("yomiSurname"     , (Sql.IsEmptyString  (o.YomiSurname           ) ? new JsonValue() : new JsonValue(o.YomiSurname       )));

			json.AddValue("businessAddress" , (                    o.BusinessAddress == null ? new JsonObject() : mapper.Serialize(o.BusinessAddress)));
			json.AddValue("homeAddress"     , (                    o.HomeAddress     == null ? new JsonObject() : mapper.Serialize(o.HomeAddress    )));
			json.AddValue("otherAddress"    , (                    o.OtherAddress    == null ? new JsonObject() : mapper.Serialize(o.OtherAddress   )));
			//json.AddValue("photo"           , (                    o.Photo           == null ? new JsonObject() : mapper.Serialize(o.Photo          )));

			json.AddValue("businessPhones"  , (                    o.BusinessPhones  == null ? new JsonArray() : mapper.Serialize(o.BusinessPhones )));
			json.AddValue("children"        , (                    o.Children        == null ? new JsonArray() : mapper.Serialize(o.Children       )));
			json.AddValue("homePhones"      , (                    o.HomePhones      == null ? new JsonArray() : mapper.Serialize(o.HomePhones     )));
			json.AddValue("imAddresses"     , (                    o.ImAddresses     == null ? new JsonArray() : mapper.Serialize(o.ImAddresses    )));
			json.AddValue("emailAddresses"  , (                    o.EmailAddresses  == null ? new JsonArray() : mapper.Serialize(o.EmailAddresses )));

			return json;
		}
	}
}
