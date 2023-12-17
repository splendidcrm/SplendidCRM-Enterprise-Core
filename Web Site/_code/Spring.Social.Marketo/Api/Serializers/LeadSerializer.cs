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

namespace Spring.Social.Marketo.Api.Impl.Json
{
	class LeadSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Lead o = obj as Lead;
			
			JsonObject json       = new JsonObject();
			JsonArray  jsonInput  = new JsonArray();
			JsonObject jsonInput1 = new JsonObject();
			// 05/20/2015 Paul.  Record is not getting updated using the default settings.  Try updateOnly instead. 
			if ( o.id.HasValue )
			{
				json.AddValue("action"     , new JsonValue("updateOnly"));
				json.AddValue("lookupField", new JsonValue("id"        ));
			}
			else
			{
				json.AddValue("action"     , new JsonValue("createOnly"));
			}
			
			if ( o.id                          .HasValue ) jsonInput1.AddValue("id"                         , new JsonValue(o.id                         .Value));
			if ( o.company                     != null   ) jsonInput1.AddValue("company"                    , new JsonValue(o.company                          ));
			if ( o.site                        != null   ) jsonInput1.AddValue("site"                       , new JsonValue(o.site                             ));
			if ( o.billingStreet               != null   ) jsonInput1.AddValue("billingStreet"              , new JsonValue(o.billingStreet                    ));
			if ( o.billingCity                 != null   ) jsonInput1.AddValue("billingCity"                , new JsonValue(o.billingCity                      ));
			if ( o.billingState                != null   ) jsonInput1.AddValue("billingState"               , new JsonValue(o.billingState                     ));
			if ( o.billingCountry              != null   ) jsonInput1.AddValue("billingCountry"             , new JsonValue(o.billingCountry                   ));
			if ( o.billingPostalCode           != null   ) jsonInput1.AddValue("billingPostalCode"          , new JsonValue(o.billingPostalCode                ));
			if ( o.website                     != null   ) jsonInput1.AddValue("website"                    , new JsonValue(o.website                          ));
			if ( o.mainPhone                   != null   ) jsonInput1.AddValue("mainPhone"                  , new JsonValue(o.mainPhone                        ));
			if ( o.annualRevenue               .HasValue ) jsonInput1.AddValue("annualRevenue"              , new JsonValue(o.annualRevenue              .Value));
			if ( o.numberOfEmployees           .HasValue ) jsonInput1.AddValue("numberOfEmployees"          , new JsonValue(o.numberOfEmployees          .Value));
			if ( o.industry                    != null   ) jsonInput1.AddValue("industry"                   , new JsonValue(o.industry                         ));
			if ( o.sicCode                     != null   ) jsonInput1.AddValue("sicCode"                    , new JsonValue(o.sicCode                          ));
			if ( o.personType                  != null   ) jsonInput1.AddValue("personType"                 , new JsonValue(o.personType                       ));
			if ( o.isLead                      .HasValue ) jsonInput1.AddValue("isLead"                     , new JsonValue(o.isLead                     .Value));
			if ( o.isAnonymous                 .HasValue ) jsonInput1.AddValue("isAnonymous"                , new JsonValue(o.isAnonymous                .Value));
			if ( o.salutation                  != null   ) jsonInput1.AddValue("salutation"                 , new JsonValue(o.salutation                       ));
			if ( o.firstName                   != null   ) jsonInput1.AddValue("firstName"                  , new JsonValue(o.firstName                        ));
			if ( o.middleName                  != null   ) jsonInput1.AddValue("middleName"                 , new JsonValue(o.middleName                       ));
			if ( o.lastName                    != null   ) jsonInput1.AddValue("lastName"                   , new JsonValue(o.lastName                         ));
			if ( o.email                       != null   ) jsonInput1.AddValue("email"                      , new JsonValue(o.email                            ));
			if ( o.phone                       != null   ) jsonInput1.AddValue("phone"                      , new JsonValue(o.phone                            ));
			if ( o.mobilePhone                 != null   ) jsonInput1.AddValue("mobilePhone"                , new JsonValue(o.mobilePhone                      ));
			if ( o.fax                         != null   ) jsonInput1.AddValue("fax"                        , new JsonValue(o.fax                              ));
			if ( o.title                       != null   ) jsonInput1.AddValue("title"                      , new JsonValue(o.title                            ));
			if ( o.contactCompany              .HasValue ) jsonInput1.AddValue("contactCompany"             , new JsonValue(o.contactCompany             .Value));
			if ( o.dateOfBirth                 .HasValue ) jsonInput1.AddValue("dateOfBirth"                , new JsonValue(o.dateOfBirth                .Value.ToString("yyyy-MM-dd")));
			if ( o.address                     != null   ) jsonInput1.AddValue("address"                    , new JsonValue(o.address                          ));
			if ( o.city                        != null   ) jsonInput1.AddValue("city"                       , new JsonValue(o.city                             ));
			if ( o.state                       != null   ) jsonInput1.AddValue("state"                      , new JsonValue(o.state                            ));
			if ( o.country                     != null   ) jsonInput1.AddValue("country"                    , new JsonValue(o.country                          ));
			if ( o.postalCode                  != null   ) jsonInput1.AddValue("postalCode"                 , new JsonValue(o.postalCode                       ));
			if ( o.registrationSourceType      != null   ) jsonInput1.AddValue("registrationSourceType"     , new JsonValue(o.registrationSourceType           ));
			if ( o.registrationSourceInfo      != null   ) jsonInput1.AddValue("registrationSourceInfo"     , new JsonValue(o.registrationSourceInfo           ));
			if ( o.emailInvalid                .HasValue ) jsonInput1.AddValue("emailInvalid"               , new JsonValue(o.emailInvalid               .Value));
			if ( o.emailInvalidCause           != null   ) jsonInput1.AddValue("emailInvalidCause"          , new JsonValue(o.emailInvalidCause                ));
			if ( o.unsubscribed                .HasValue ) jsonInput1.AddValue("unsubscribed"               , new JsonValue(o.unsubscribed               .Value));
			if ( o.unsubscribedReason          != null   ) jsonInput1.AddValue("unsubscribedReason"         , new JsonValue(o.unsubscribedReason               ));
			if ( o.doNotCall                   .HasValue ) jsonInput1.AddValue("doNotCall"                  , new JsonValue(o.doNotCall                  .Value));
			if ( o.doNotCallReason             != null   ) jsonInput1.AddValue("doNotCallReason"            , new JsonValue(o.doNotCallReason                  ));
			if ( o.anonymousIP                 != null   ) jsonInput1.AddValue("anonymousIP"                , new JsonValue(o.anonymousIP                      ));
			if ( o.department                  != null   ) jsonInput1.AddValue("department"                 , new JsonValue(o.department                       ));
			if ( o.cookies                     != null   ) jsonInput1.AddValue("cookies"                    , new JsonValue(o.cookies                          ));
			if ( o.leadPerson                  .HasValue ) jsonInput1.AddValue("leadPerson"                 , new JsonValue(o.leadPerson                 .Value));
			if ( o.leadRole                    != null   ) jsonInput1.AddValue("leadRole"                   , new JsonValue(o.leadRole                         ));
			if ( o.leadSource                  != null   ) jsonInput1.AddValue("leadSource"                 , new JsonValue(o.leadSource                       ));
			if ( o.leadStatus                  != null   ) jsonInput1.AddValue("leadStatus"                 , new JsonValue(o.leadStatus                       ));
			if ( o.leadScore                   .HasValue ) jsonInput1.AddValue("leadScore"                  , new JsonValue(o.leadScore                  .Value));
			if ( o.urgency                     .HasValue ) jsonInput1.AddValue("urgency"                    , new JsonValue(o.urgency                    .Value));
			if ( o.priority                    .HasValue ) jsonInput1.AddValue("priority"                   , new JsonValue(o.priority                   .Value));
			if ( o.relativeScore               .HasValue ) jsonInput1.AddValue("relativeScore"              , new JsonValue(o.relativeScore              .Value));
			if ( o.rating                      != null   ) jsonInput1.AddValue("rating"                     , new JsonValue(o.rating                           ));
			if ( o.personPrimaryLeadInterest   .HasValue ) jsonInput1.AddValue("personPrimaryLeadInterest"  , new JsonValue(o.personPrimaryLeadInterest  .Value));
			if ( o.leadPartitionId             .HasValue ) jsonInput1.AddValue("leadPartitionId"            , new JsonValue(o.leadPartitionId            .Value));
			if ( o.leadRevenueCycleModelId     .HasValue ) jsonInput1.AddValue("leadRevenueCycleModelId"    , new JsonValue(o.leadRevenueCycleModelId    .Value));
			if ( o.leadRevenueStageId          .HasValue ) jsonInput1.AddValue("leadRevenueStageId"         , new JsonValue(o.leadRevenueStageId         .Value));
			if ( o.gender                      != null   ) jsonInput1.AddValue("gender"                     , new JsonValue(o.gender                           ));
			if ( o.facebookDisplayName         != null   ) jsonInput1.AddValue("facebookDisplayName"        , new JsonValue(o.facebookDisplayName              ));
			if ( o.twitterDisplayName          != null   ) jsonInput1.AddValue("twitterDisplayName"         , new JsonValue(o.twitterDisplayName               ));
			if ( o.linkedInDisplayName         != null   ) jsonInput1.AddValue("linkedInDisplayName"        , new JsonValue(o.linkedInDisplayName              ));
			if ( o.facebookProfileURL          != null   ) jsonInput1.AddValue("facebookProfileURL"         , new JsonValue(o.facebookProfileURL               ));
			if ( o.twitterProfileURL           != null   ) jsonInput1.AddValue("twitterProfileURL"          , new JsonValue(o.twitterProfileURL                ));
			if ( o.linkedInProfileURL          != null   ) jsonInput1.AddValue("linkedInProfileURL"         , new JsonValue(o.linkedInProfileURL               ));
			if ( o.facebookPhotoURL            != null   ) jsonInput1.AddValue("facebookPhotoURL"           , new JsonValue(o.facebookPhotoURL                 ));
			if ( o.twitterPhotoURL             != null   ) jsonInput1.AddValue("twitterPhotoURL"            , new JsonValue(o.twitterPhotoURL                  ));
			if ( o.linkedInPhotoURL            != null   ) jsonInput1.AddValue("linkedInPhotoURL"           , new JsonValue(o.linkedInPhotoURL                 ));
			if ( o.facebookReach               .HasValue ) jsonInput1.AddValue("facebookReach"              , new JsonValue(o.facebookReach              .Value));
			if ( o.twitterReach                .HasValue ) jsonInput1.AddValue("twitterReach"               , new JsonValue(o.twitterReach               .Value));
			if ( o.linkedInReach               .HasValue ) jsonInput1.AddValue("linkedInReach"              , new JsonValue(o.linkedInReach              .Value));
			if ( o.facebookReferredVisits      .HasValue ) jsonInput1.AddValue("facebookReferredVisits"     , new JsonValue(o.facebookReferredVisits     .Value));
			if ( o.twitterReferredVisits       .HasValue ) jsonInput1.AddValue("twitterReferredVisits"      , new JsonValue(o.twitterReferredVisits      .Value));
			if ( o.linkedInReferredVisits      .HasValue ) jsonInput1.AddValue("linkedInReferredVisits"     , new JsonValue(o.linkedInReferredVisits     .Value));
			if ( o.facebookReferredEnrollments .HasValue ) jsonInput1.AddValue("facebookReferredEnrollments", new JsonValue(o.facebookReferredEnrollments.Value));
			if ( o.twitterReferredEnrollments  .HasValue ) jsonInput1.AddValue("twitterReferredEnrollments" , new JsonValue(o.twitterReferredEnrollments .Value));
			if ( o.linkedInReferredEnrollments .HasValue ) jsonInput1.AddValue("linkedInReferredEnrollments", new JsonValue(o.linkedInReferredEnrollments.Value));
			if ( o.lastReferredVisit           .HasValue ) jsonInput1.AddValue("lastReferredVisit"          , new JsonValue(o.lastReferredVisit          .Value.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss")));
			if ( o.lastReferredEnrollment      .HasValue ) jsonInput1.AddValue("lastReferredEnrollment"     , new JsonValue(o.lastReferredEnrollment     .Value.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss")));
			if ( o.syndicationId               != null   ) jsonInput1.AddValue("syndicationId"              , new JsonValue(o.syndicationId                    ));
			if ( o.facebookId                  != null   ) jsonInput1.AddValue("facebookId"                 , new JsonValue(o.facebookId                       ));
			if ( o.twitterId                   != null   ) jsonInput1.AddValue("twitterId"                  , new JsonValue(o.twitterId                        ));
			if ( o.linkedInId                  != null   ) jsonInput1.AddValue("linkedInId"                 , new JsonValue(o.linkedInId                       ));
			if ( o.acquisitionProgramId        .HasValue ) jsonInput1.AddValue("acquisitionProgramId"       , new JsonValue(o.acquisitionProgramId       .Value));
			jsonInput.AddValue(jsonInput1);
			json.AddValue("input", jsonInput);
			o.RawContent = json.ToString();
			return json;
		}
	}
}
