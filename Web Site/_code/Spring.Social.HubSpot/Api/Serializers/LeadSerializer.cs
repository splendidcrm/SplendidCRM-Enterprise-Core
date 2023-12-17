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
	class LeadSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Lead o = obj as Lead;
			
			JsonObject json           = new JsonObject();
			JsonArray  jsonProperties = new JsonArray();
			if ( o.hubspot_owner_id                       .HasValue ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("hubspot_owner_id"                      , new JsonValue(o.hubspot_owner_id                      .Value)));
			if ( o.firstname                              != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("firstname"                             , new JsonValue(o.firstname                                   )));
			if ( o.lastname                               != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("lastname"                              , new JsonValue(o.lastname                                    )));
			if ( o.salutation                             != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("salutation"                            , new JsonValue(o.salutation                                  )));
			if ( o.email                                  != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("email"                                 , new JsonValue(o.email                                       )));
			if ( o.phone                                  != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("phone"                                 , new JsonValue(o.phone                                       )));
			if ( o.mobilephone                            != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("mobilephone"                           , new JsonValue(o.mobilephone                                 )));
			if ( o.fax                                    != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("fax"                                   , new JsonValue(o.fax                                         )));
			if ( o.address                                != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("address"                               , new JsonValue(o.address                                     )));
			if ( o.city                                   != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("city"                                  , new JsonValue(o.city                                        )));
			if ( o.state                                  != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("state"                                 , new JsonValue(o.state                                       )));
			if ( o.zip                                    != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("zip"                                   , new JsonValue(o.zip                                         )));
			if ( o.country                                != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("country"                               , new JsonValue(o.country                                     )));
			if ( o.jobtitle                               != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("jobtitle"                              , new JsonValue(o.jobtitle                                    )));
			if ( o.closedate                              .HasValue ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("closedate"                             , new JsonValue(JsonUtils.ToUnixTicks(o.closedate.Value)      )));
			if ( o.lifecyclestage                         != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("lifecyclestage"                        , new JsonValue(o.lifecyclestage                              )));
			if ( o.website                                != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("website"                               , new JsonValue(o.website                                     )));
			if ( o.company                                != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("company"                               , new JsonValue(o.company                                     )));
			if ( o.message                                != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("message"                               , new JsonValue(o.message                                     )));
			if ( o.photo                                  != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("photo"                                 , new JsonValue(o.photo                                       )));
			if ( o.numemployees                           != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("numemployees"                          , new JsonValue(o.numemployees                                )));
			if ( o.annualrevenue                          != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("annualrevenue"                         , new JsonValue(o.annualrevenue                               )));
			if ( o.industry                               != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("industry"                              , new JsonValue(o.industry                                    )));
			if ( o.hs_persona                             != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("hs_persona"                            , new JsonValue(o.hs_persona                                  )));
			if ( o.hs_facebookid                          != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("hs_facebookid"                         , new JsonValue(o.hs_facebookid                               )));
			if ( o.hs_googleplusid                        != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("hs_googleplusid"                       , new JsonValue(o.hs_googleplusid                             )));
			if ( o.hs_linkedinid                          != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("hs_linkedinid"                         , new JsonValue(o.hs_linkedinid                               )));
			if ( o.hs_twitterid                           != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("hs_twitterid"                          , new JsonValue(o.hs_twitterid                                )));
			if ( o.twitterhandle                          != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("twitterhandle"                         , new JsonValue(o.twitterhandle                               )));
			if ( o.twitterprofilephoto                    != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("twitterprofilephoto"                   , new JsonValue(o.twitterprofilephoto                         )));
			if ( o.linkedinbio                            != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("linkedinbio"                           , new JsonValue(o.linkedinbio                                 )));
			if ( o.twitterbio                             != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("twitterbio"                            , new JsonValue(o.twitterbio                                  )));
			if ( o.blog_default_hubspot_blog_subscription != null   ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("blog_default_hubspot_blog_subscription", new JsonValue(o.blog_default_hubspot_blog_subscription      )));
			if ( o.followercount                          .HasValue ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("followercount"                         , new JsonValue(o.followercount                         .Value)));
			if ( o.linkedinconnections                    .HasValue ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("linkedinconnections"                   , new JsonValue(o.linkedinconnections                   .Value)));
			if ( o.kloutscoregeneral                      .HasValue ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("kloutscoregeneral"                     , new JsonValue(o.kloutscoregeneral                     .Value)));
			// 09/27/2020 Paul.  Value of 0 is not valid. 
			if ( o.associatedcompanyid                    .HasValue && o.associatedcompanyid > 0 ) jsonProperties.AddValue(JsonUtils.CreatePropertyValue("associatedcompanyid"                   , new JsonValue(o.associatedcompanyid                   .Value)));
			json.AddValue("properties", jsonProperties);
			o.RawContent = json.ToString();
			return json;
		}
	}
}
