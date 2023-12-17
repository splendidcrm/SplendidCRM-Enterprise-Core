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

namespace Spring.Social.Marketo.Api.Impl.Json
{
	class LeadDeserializer : IJsonDeserializer
	{
		// 05/21/2015 Paul.  Marketo time is always GMT-5:00 (no daylight savings). 
		// https://nation.marketo.com/thread/24083
		private DateTime? ConvertMarketoToLocalTime(DateTime? value)
		{
			DateTime? dt = null;
			if ( value.HasValue )
			{
				// updatedAt: "2015-05-19 19:38:28"
				// PST correct value: 2015-05-19 17:38
				// EST correct value: 2015-05-19 20:38
				dt = DateTime.SpecifyKind(value.Value, DateTimeKind.Utc).AddHours(5);
				dt = dt.Value.ToLocalTime();
			}
			return dt;
		}

		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Lead obj = new Lead();
			obj.RawContent = json.ToString();
			
			obj.id                          = json.GetValueOrDefault<int      >("id"                         );
			obj.isDeleted                   = json.GetValueOrDefault<bool     >("isDeleted"                  );
			obj.createdAt                   = ConvertMarketoToLocalTime(json.GetValueOrDefault<DateTime?>("createdAt"));
			obj.updatedAt                   = ConvertMarketoToLocalTime(json.GetValueOrDefault<DateTime?>("updatedAt"));
			obj.company                     = json.GetValueOrDefault<String   >("company"                    );
			obj.site                        = json.GetValueOrDefault<String   >("site"                       );
			obj.billingStreet               = json.GetValueOrDefault<String   >("billingStreet"              );
			obj.billingCity                 = json.GetValueOrDefault<String   >("billingCity"                );
			obj.billingState                = json.GetValueOrDefault<String   >("billingState"               );
			obj.billingCountry              = json.GetValueOrDefault<String   >("billingCountry"             );
			obj.billingPostalCode           = json.GetValueOrDefault<String   >("billingPostalCode"          );
			obj.website                     = json.GetValueOrDefault<String   >("website"                    );
			obj.mainPhone                   = json.GetValueOrDefault<String   >("mainPhone"                  );
			obj.annualRevenue               = json.GetValueOrDefault<Decimal? >("annualRevenue"              );
			obj.numberOfEmployees           = json.GetValueOrDefault<int?     >("numberOfEmployees"          );
			obj.industry                    = json.GetValueOrDefault<String   >("industry"                   );
			obj.sicCode                     = json.GetValueOrDefault<String   >("sicCode"                    );
			obj.personType                  = json.GetValueOrDefault<String   >("personType"                 );
			obj.isLead                      = json.GetValueOrDefault<bool?    >("isLead"                     );
			obj.isAnonymous                 = json.GetValueOrDefault<bool?    >("isAnonymous"                );
			obj.salutation                  = json.GetValueOrDefault<String   >("salutation"                 );
			obj.firstName                   = json.GetValueOrDefault<String   >("firstName"                  );
			obj.middleName                  = json.GetValueOrDefault<String   >("middleName"                 );
			obj.lastName                    = json.GetValueOrDefault<String   >("lastName"                   );
			obj.email                       = json.GetValueOrDefault<String   >("email"                      );
			obj.phone                       = json.GetValueOrDefault<String   >("phone"                      );
			obj.mobilePhone                 = json.GetValueOrDefault<String   >("mobilePhone"                );
			obj.fax                         = json.GetValueOrDefault<String   >("fax"                        );
			obj.title                       = json.GetValueOrDefault<String   >("title"                      );
			obj.contactCompany              = json.GetValueOrDefault<int?     >("contactCompany"             );
			obj.dateOfBirth                 = json.GetValueOrDefault<DateTime?>("dateOfBirth"                );
			obj.address                     = json.GetValueOrDefault<String   >("address"                    );
			obj.city                        = json.GetValueOrDefault<String   >("city"                       );
			obj.state                       = json.GetValueOrDefault<String   >("state"                      );
			obj.country                     = json.GetValueOrDefault<String   >("country"                    );
			obj.postalCode                  = json.GetValueOrDefault<String   >("postalCode"                 );
			obj.registrationSourceType      = json.GetValueOrDefault<String   >("registrationSourceType"     );
			obj.registrationSourceInfo      = json.GetValueOrDefault<String   >("registrationSourceInfo"     );
			obj.emailInvalid                = json.GetValueOrDefault<bool?    >("emailInvalid"               );
			obj.emailInvalidCause           = json.GetValueOrDefault<String   >("emailInvalidCause"          );
			obj.unsubscribed                = json.GetValueOrDefault<bool?    >("unsubscribed"               );
			obj.unsubscribedReason          = json.GetValueOrDefault<String   >("unsubscribedReason"         );
			obj.doNotCall                   = json.GetValueOrDefault<bool?    >("doNotCall"                  );
			obj.doNotCallReason             = json.GetValueOrDefault<String   >("doNotCallReason"            );
			obj.anonymousIP                 = json.GetValueOrDefault<String   >("anonymousIP"                );
			obj.department                  = json.GetValueOrDefault<String   >("department"                 );
			obj.cookies                     = json.GetValueOrDefault<String   >("cookies"                    );
			obj.leadPerson                  = json.GetValueOrDefault<int?     >("leadPerson"                 );
			obj.leadRole                    = json.GetValueOrDefault<String   >("leadRole"                   );
			obj.leadSource                  = json.GetValueOrDefault<String   >("leadSource"                 );
			obj.leadStatus                  = json.GetValueOrDefault<String   >("leadStatus"                 );
			obj.leadScore                   = json.GetValueOrDefault<int?     >("leadScore"                  );
			obj.urgency                     = json.GetValueOrDefault<float?   >("urgency"                    );
			obj.priority                    = json.GetValueOrDefault<int?     >("priority"                   );
			obj.relativeScore               = json.GetValueOrDefault<int?     >("relativeScore"              );
			obj.rating                      = json.GetValueOrDefault<String   >("rating"                     );
			obj.personPrimaryLeadInterest   = json.GetValueOrDefault<int?     >("personPrimaryLeadInterest"  );
			obj.leadPartitionId             = json.GetValueOrDefault<int?     >("leadPartitionId"            );
			obj.leadRevenueCycleModelId     = json.GetValueOrDefault<int?     >("leadRevenueCycleModelId"    );
			obj.leadRevenueStageId          = json.GetValueOrDefault<int?     >("leadRevenueStageId"         );
			obj.gender                      = json.GetValueOrDefault<String   >("gender"                     );
			obj.facebookDisplayName         = json.GetValueOrDefault<String   >("facebookDisplayName"        );
			obj.twitterDisplayName          = json.GetValueOrDefault<String   >("twitterDisplayName"         );
			obj.linkedInDisplayName         = json.GetValueOrDefault<String   >("linkedInDisplayName"        );
			obj.facebookProfileURL          = json.GetValueOrDefault<String   >("facebookProfileURL"         );
			obj.twitterProfileURL           = json.GetValueOrDefault<String   >("twitterProfileURL"          );
			obj.linkedInProfileURL          = json.GetValueOrDefault<String   >("linkedInProfileURL"         );
			obj.facebookPhotoURL            = json.GetValueOrDefault<String   >("facebookPhotoURL"           );
			obj.twitterPhotoURL             = json.GetValueOrDefault<String   >("twitterPhotoURL"            );
			obj.linkedInPhotoURL            = json.GetValueOrDefault<String   >("linkedInPhotoURL"           );
			obj.facebookReach               = json.GetValueOrDefault<int?     >("facebookReach"              );
			obj.twitterReach                = json.GetValueOrDefault<int?     >("twitterReach"               );
			obj.linkedInReach               = json.GetValueOrDefault<int?     >("linkedInReach"              );
			obj.facebookReferredVisits      = json.GetValueOrDefault<int?     >("facebookReferredVisits"     );
			obj.twitterReferredVisits       = json.GetValueOrDefault<int?     >("twitterReferredVisits"      );
			obj.linkedInReferredVisits      = json.GetValueOrDefault<int?     >("linkedInReferredVisits"     );
			obj.facebookReferredEnrollments = json.GetValueOrDefault<int?     >("facebookReferredEnrollments");
			obj.twitterReferredEnrollments  = json.GetValueOrDefault<int?     >("twitterReferredEnrollments" );
			obj.linkedInReferredEnrollments = json.GetValueOrDefault<int?     >("linkedInReferredEnrollments");
			obj.lastReferredVisit           = ConvertMarketoToLocalTime(json.GetValueOrDefault<DateTime?>("lastReferredVisit"     ));
			obj.lastReferredEnrollment      = ConvertMarketoToLocalTime(json.GetValueOrDefault<DateTime?>("lastReferredEnrollment"));
			obj.syndicationId               = json.GetValueOrDefault<String   >("syndicationId"              );
			obj.facebookId                  = json.GetValueOrDefault<String   >("facebookId"                 );
			obj.twitterId                   = json.GetValueOrDefault<String   >("twitterId"                  );
			obj.linkedInId                  = json.GetValueOrDefault<String   >("linkedInId"                 );
			obj.acquisitionProgramId        = json.GetValueOrDefault<int?     >("acquisitionProgramId"       );
			// Read-only fields
			obj.originalSourceType          = json.GetValueOrDefault<String   >("originalSourceType"         );
			obj.originalSourceInfo          = json.GetValueOrDefault<String   >("originalSourceInfo"         );
			obj.originalSearchEngine        = json.GetValueOrDefault<String   >("originalSearchEngine"       );
			obj.originalSearchPhrase        = json.GetValueOrDefault<String   >("originalSearchPhrase"       );
			obj.originalReferrer            = json.GetValueOrDefault<String   >("originalReferrer"           );
			obj.inferredCompany             = json.GetValueOrDefault<String   >("inferredCompany"            );
			obj.inferredCountry             = json.GetValueOrDefault<String   >("inferredCountry"            );
			obj.inferredCity                = json.GetValueOrDefault<String   >("inferredCity"               );
			obj.inferredStateRegion         = json.GetValueOrDefault<String   >("inferredStateRegion"        );
			obj.inferredPostalCode          = json.GetValueOrDefault<String   >("inferredPostalCode"         );
			obj.inferredMetropolitanArea    = json.GetValueOrDefault<String   >("inferredMetropolitanArea"   );
			obj.inferredPhoneAreaCode       = json.GetValueOrDefault<String   >("inferredPhoneAreaCode"      );
			obj.totalReferredVisits         = json.GetValueOrDefault<int?     >("totalReferredVisits"        );
			obj.totalReferredEnrollments    = json.GetValueOrDefault<int?     >("totalReferredEnrollments"   );
			return obj;
		}
	}

	class LeadListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Lead> items = new List<Lead>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("result");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					items.Add( mapper.Deserialize<Lead>(itemValue) );
				}
			}
			return items;
		}
	}

	class LeadPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			LeadPagination pag = new LeadPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				pag.nextPageToken = json.GetValueOrDefault<string>("nextPageToken");
				pag.moreResult    = json.GetValueOrDefault<bool? >("moreResult"   );
				if ( json.ContainsName("result") )
					pag.items = mapper.Deserialize<IList<Lead>>(json);
			}
			return pag;
		}
	}
}
