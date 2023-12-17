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

namespace Spring.Social.HubSpot.Api.Impl.Json
{
	class CompanySerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Company o = obj as Company;
			
			JsonObject json           = new JsonObject();
			JsonArray  jsonProperties = new JsonArray();
			if ( o.hubspot_owner_id                       .HasValue ) jsonProperties.AddValue(JsonUtils.CreateNameValue("hubspot_owner_id"                      , new JsonValue(o.hubspot_owner_id                      .Value)));
			if ( o.name                                   != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("name"                                  , new JsonValue(o.name                                        )));
			if ( o.phone                                  != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("phone"                                 , new JsonValue(o.phone                                       )));
			if ( o.address                                != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("address"                               , new JsonValue(o.address                                     )));
			if ( o.address2                               != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("address2"                              , new JsonValue(o.address2                                    )));
			if ( o.city                                   != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("city"                                  , new JsonValue(o.city                                        )));
			if ( o.state                                  != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("state"                                 , new JsonValue(o.state                                       )));
			if ( o.zip                                    != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("zip"                                   , new JsonValue(o.zip                                         )));
			if ( o.country                                != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("country"                               , new JsonValue(o.country                                     )));
			if ( o.timezone                               != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("timezone"                              , new JsonValue(o.timezone                                    )));
			if ( o.website                                != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("website"                               , new JsonValue(o.website                                     )));
			if ( o.domain                                 != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("domain"                                , new JsonValue(o.domain                                      )));
			if ( o.about_us                               != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("about_us"                              , new JsonValue(o.about_us                                    )));
			if ( o.founded_year                           != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("founded_year"                          , new JsonValue(o.founded_year                                )));
			if ( o.is_public                              .HasValue ) jsonProperties.AddValue(JsonUtils.CreateNameValue("is_public"                             , new JsonValue(o.is_public                             .Value)));
			if ( o.numberofemployees                      .HasValue ) jsonProperties.AddValue(JsonUtils.CreateNameValue("numberofemployees"                     , new JsonValue(o.numberofemployees                     .Value)));
			if ( o.industry                               != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("industry"                              , new JsonValue(o.industry                                    )));
			if ( o.type                                   != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("type"                                  , new JsonValue(o.type                                        )));
			if ( o.description                            != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("description"                           , new JsonValue(o.description                                 )));
			if ( o.total_money_raised                     != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("total_money_raised"                    , new JsonValue(o.total_money_raised                          )));
			if ( o.annualrevenue                          .HasValue ) jsonProperties.AddValue(JsonUtils.CreateNameValue("annualrevenue"                         , new JsonValue(o.annualrevenue                         .Value)));
			if ( o.closedate                              .HasValue ) jsonProperties.AddValue(JsonUtils.CreateNameValue("closedate"                             , new JsonValue(JsonUtils.ToUnixTicks(o.closedate.Value)      )));
			if ( o.lifecyclestage                         != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("lifecyclestage"                        , new JsonValue(o.lifecyclestage                              )));
			if ( o.hs_lead_status                         != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("hs_lead_status"                        , new JsonValue(o.hs_lead_status                              )));
			if ( o.twitterhandle                          != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("twitterhandle"                         , new JsonValue(o.twitterhandle                               )));
			if ( o.twitterbio                             != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("twitterbio"                            , new JsonValue(o.twitterbio                                  )));
			if ( o.twitterfollowers                       .HasValue ) jsonProperties.AddValue(JsonUtils.CreateNameValue("twitterfollowers"                      , new JsonValue(o.twitterfollowers                      .Value)));
			if ( o.facebook_company_page                  != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("facebook_company_page"                 , new JsonValue(o.facebook_company_page                       )));
			if ( o.facebookfans                           .HasValue ) jsonProperties.AddValue(JsonUtils.CreateNameValue("facebookfans"                          , new JsonValue(o.facebookfans                          .Value)));
			if ( o.linkedin_company_page                  != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("linkedin_company_page"                 , new JsonValue(o.linkedin_company_page                       )));
			if ( o.linkedinbio                            != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("linkedinbio"                           , new JsonValue(o.linkedinbio                                 )));
			if ( o.googleplus_page                        != null   ) jsonProperties.AddValue(JsonUtils.CreateNameValue("googleplus_page"                       , new JsonValue(o.googleplus_page                             )));
			json.AddValue("properties", jsonProperties);
			o.RawContent = json.ToString();
			return json;
		}
	}
}
