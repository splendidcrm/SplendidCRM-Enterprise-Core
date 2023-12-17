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
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Collections.Specialized;
using Spring.Json;

namespace Spring.Social.Marketo.Api
{
	// http://developers.marketo.com/documentation/rest/field-names
	// http://developers.marketo.com/documentation/rest/describe/
	[Serializable]
	public class Lead : MBase
	{
		#region Properties
		public String    company                      { get; set; }  // 255
		public String    site                         { get; set; }  // 255
		public String    billingStreet                { get; set; }
		public String    billingCity                  { get; set; }  // 255
		public String    billingState                 { get; set; }  // 255
		public String    billingCountry               { get; set; }  // 255
		public String    billingPostalCode            { get; set; }  // 255
		public String    website                      { get; set; }  // 255
		public String    mainPhone                    { get; set; }  // 255
		public Decimal?  annualRevenue                { get; set; }
		public int?      numberOfEmployees            { get; set; }
		public String    industry                     { get; set; }  // 255
		public String    sicCode                      { get; set; }  // 40
		public String    personType                   { get; set; }  // 50
		public bool?     isLead                       { get; set; }
		public bool?     isAnonymous                  { get; set; }
		public String    salutation                   { get; set; }  // 255
		public String    firstName                    { get; set; }  // 255
		public String    middleName                   { get; set; }  // 255
		public String    lastName                     { get; set; }  // 255
		public String    email                        { get; set; }  // 255
		public String    phone                        { get; set; }  // 255
		public String    mobilePhone                  { get; set; }  // 255
		public String    fax                          { get; set; }  // 255
		public String    title                        { get; set; }  // 255
		public int?      contactCompany               { get; set; }
		public DateTime? dateOfBirth                  { get; set; }
		public String    address                      { get; set; }
		public String    city                         { get; set; }  // 255
		public String    state                        { get; set; }  // 255
		public String    country                      { get; set; }  // 255
		public String    postalCode                   { get; set; }  // 255
		public String    registrationSourceType       { get; set; }  // 255
		public String    registrationSourceInfo       { get; set; }  // 2000
		public bool?     emailInvalid                 { get; set; }
		public String    emailInvalidCause            { get; set; }  // 255
		public bool?     unsubscribed                 { get; set; }
		public String    unsubscribedReason           { get; set; }  // 2000
		public bool?     doNotCall                    { get; set; }
		public String    doNotCallReason              { get; set; }  // 2000
		public String    anonymousIP                  { get; set; }  // 255
		public String    department                   { get; set; }  // 255
		public String    cookies                      { get; set; }  // 255
		public int?      leadPerson                   { get; set; }
		public String    leadRole                     { get; set; }  // 50
		public String    leadSource                   { get; set; }  // 255
		public String    leadStatus                   { get; set; }  // 255
		public int?      leadScore                    { get; set; }
		public float?    urgency                      { get; set; }
		public int?      priority                     { get; set; }
		public int?      relativeScore                { get; set; }
		public String    rating                       { get; set; }  // 255
		public int?      personPrimaryLeadInterest    { get; set; }
		public int?      leadPartitionId              { get; set; }
		public int?      leadRevenueCycleModelId      { get; set; }
		public int?      leadRevenueStageId           { get; set; }
		public String    gender                       { get; set; }  // 255
		public String    facebookDisplayName          { get; set; }  // 255
		public String    twitterDisplayName           { get; set; }  // 255
		public String    linkedInDisplayName          { get; set; }  // 255
		public String    facebookProfileURL           { get; set; }  // 2000
		public String    twitterProfileURL            { get; set; }  // 2000
		public String    linkedInProfileURL           { get; set; }  // 2000
		public String    facebookPhotoURL             { get; set; }  // 2000
		public String    twitterPhotoURL              { get; set; }  // 2000
		public String    linkedInPhotoURL             { get; set; }  // 2000
		public int?      facebookReach                { get; set; }
		public int?      twitterReach                 { get; set; }
		public int?      linkedInReach                { get; set; }
		public int?      facebookReferredVisits       { get; set; }
		public int?      twitterReferredVisits        { get; set; }
		public int?      linkedInReferredVisits       { get; set; }
		public int?      facebookReferredEnrollments  { get; set; }
		public int?      twitterReferredEnrollments   { get; set; }
		public int?      linkedInReferredEnrollments  { get; set; }
		public DateTime? lastReferredVisit            { get; set; }
		public DateTime? lastReferredEnrollment       { get; set; }
		public String    syndicationId                { get; set; }  // 2000
		public String    facebookId                   { get; set; }  // 2000
		public String    twitterId                    { get; set; }  // 2000
		public String    linkedInId                   { get; set; }  // 2000
		public int?      acquisitionProgramId         { get; set; }
		// Read-only fields
		public String    originalSourceType           { get; set; }  // 255
		public String    originalSourceInfo           { get; set; }  // 2000
		public String    originalSearchEngine         { get; set; }  // 255
		public String    originalSearchPhrase         { get; set; }  // 255
		public String    originalReferrer             { get; set; }  // 255
		public String    inferredCompany              { get; set; }  // 255
		public String    inferredCountry              { get; set; }  // 255
		public String    inferredCity                 { get; set; }  // 255
		public String    inferredStateRegion          { get; set; }  // 255
		public String    inferredPostalCode           { get; set; }  // 255
		public String    inferredMetropolitanArea     { get; set; }  // 255
		public String    inferredPhoneAreaCode        { get; set; }  // 255
		public int?      totalReferredVisits          { get; set; }
		public int?      totalReferredEnrollments     { get; set; }
		#endregion

		public DateTime CreatedAt
		{
			get { return this.createdAt.HasValue ? this.createdAt.Value : DateTime.MinValue; }
			set { this.createdAt = value; }
		}

		public DateTime UpdatedAt
		{
			get { return this.updatedAt.HasValue ? this.updatedAt.Value : DateTime.MinValue; }
			set { this.updatedAt = value; }
		}

		public DateTime DateOfBirth
		{
			get { return this.dateOfBirth.HasValue ? this.dateOfBirth.Value : DateTime.MinValue; }
			set { this.dateOfBirth = value; }
		}

		public bool EmailInvalid
		{
			get { return this.emailInvalid.HasValue ? this.emailInvalid.Value : false; }
			set { this.emailInvalid = value; }
		}

		public bool Unsubscribed
		{
			get { return this.unsubscribed.HasValue ? this.unsubscribed.Value : false; }
			set { this.unsubscribed = value; }
		}

		public bool DoNotCall
		{
			get { return this.doNotCall.HasValue ? this.doNotCall.Value : false; }
			set { this.doNotCall = value; }
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                         , Type.GetType("System.Int64"   ));
			dt.Columns.Add("isDeleted"                  , Type.GetType("System.Boolean" ));
			dt.Columns.Add("createdAt"                  , Type.GetType("System.DateTime"));
			dt.Columns.Add("updatedAt"                  , Type.GetType("System.DateTime"));
			dt.Columns.Add("company"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("site"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("billingStreet"              , Type.GetType("System.String"  ));
			dt.Columns.Add("billingCity"                , Type.GetType("System.String"  ));
			dt.Columns.Add("billingState"               , Type.GetType("System.String"  ));
			dt.Columns.Add("billingCountry"             , Type.GetType("System.String"  ));
			dt.Columns.Add("billingPostalCode"          , Type.GetType("System.String"  ));
			dt.Columns.Add("website"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("mainPhone"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("annualRevenue"              , Type.GetType("System.Decimal" ));
			dt.Columns.Add("numberOfEmployees"          , Type.GetType("System.Int64"   ));
			dt.Columns.Add("industry"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("sicCode"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("personType"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("isLead"                     , Type.GetType("System.Boolean" ));
			dt.Columns.Add("isAnonymous"                , Type.GetType("System.Boolean" ));
			dt.Columns.Add("salutation"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("firstName"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("middleName"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("lastName"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("email"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("phone"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("mobilePhone"                , Type.GetType("System.String"  ));
			dt.Columns.Add("fax"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("title"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("contactCompany"             , Type.GetType("System.Int64"   ));
			dt.Columns.Add("dateOfBirth"                , Type.GetType("System.DateTime"));
			dt.Columns.Add("address"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("city"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("state"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("country"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("postalCode"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("registrationSourceType"     , Type.GetType("System.String"  ));
			dt.Columns.Add("registrationSourceInfo"     , Type.GetType("System.String"  ));
			dt.Columns.Add("emailInvalid"               , Type.GetType("System.Boolean" ));
			dt.Columns.Add("emailInvalidCause"          , Type.GetType("System.String"  ));
			dt.Columns.Add("unsubscribed"               , Type.GetType("System.Boolean" ));
			dt.Columns.Add("unsubscribedReason"         , Type.GetType("System.String"  ));
			dt.Columns.Add("doNotCall"                  , Type.GetType("System.Boolean" ));
			dt.Columns.Add("doNotCallReason"            , Type.GetType("System.String"  ));
			dt.Columns.Add("anonymousIP"                , Type.GetType("System.String"  ));
			dt.Columns.Add("department"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("cookies"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("leadPerson"                 , Type.GetType("System.Int64"   ));
			dt.Columns.Add("leadRole"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("leadSource"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("leadStatus"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("leadScore"                  , Type.GetType("System.Int64"   ));
			dt.Columns.Add("urgency"                    , Type.GetType("System.Double"  ));
			dt.Columns.Add("priority"                   , Type.GetType("System.Int64"   ));
			dt.Columns.Add("relativeScore"              , Type.GetType("System.Int64"   ));
			dt.Columns.Add("rating"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("personPrimaryLeadInterest"  , Type.GetType("System.Int64"   ));
			dt.Columns.Add("leadPartitionId"            , Type.GetType("System.Int64"   ));
			dt.Columns.Add("leadRevenueCycleModelId"    , Type.GetType("System.Int64"   ));
			dt.Columns.Add("leadRevenueStageId"         , Type.GetType("System.Int64"   ));
			dt.Columns.Add("gender"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("facebookDisplayName"        , Type.GetType("System.String"  ));
			dt.Columns.Add("twitterDisplayName"         , Type.GetType("System.String"  ));
			dt.Columns.Add("linkedInDisplayName"        , Type.GetType("System.String"  ));
			dt.Columns.Add("facebookProfileURL"         , Type.GetType("System.String"  ));
			dt.Columns.Add("twitterProfileURL"          , Type.GetType("System.String"  ));
			dt.Columns.Add("linkedInProfileURL"         , Type.GetType("System.String"  ));
			dt.Columns.Add("facebookPhotoURL"           , Type.GetType("System.String"  ));
			dt.Columns.Add("twitterPhotoURL"            , Type.GetType("System.String"  ));
			dt.Columns.Add("linkedInPhotoURL"           , Type.GetType("System.String"  ));
			dt.Columns.Add("facebookReach"              , Type.GetType("System.Int64"   ));
			dt.Columns.Add("twitterReach"               , Type.GetType("System.Int64"   ));
			dt.Columns.Add("linkedInReach"              , Type.GetType("System.Int64"   ));
			dt.Columns.Add("facebookReferredVisits"     , Type.GetType("System.Int64"   ));
			dt.Columns.Add("twitterReferredVisits"      , Type.GetType("System.Int64"   ));
			dt.Columns.Add("linkedInReferredVisits"     , Type.GetType("System.Int64"   ));
			dt.Columns.Add("facebookReferredEnrollments", Type.GetType("System.Int64"   ));
			dt.Columns.Add("twitterReferredEnrollments" , Type.GetType("System.Int64"   ));
			dt.Columns.Add("linkedInReferredEnrollments", Type.GetType("System.Int64"   ));
			dt.Columns.Add("lastReferredVisit"          , Type.GetType("System.DateTime"));
			dt.Columns.Add("lastReferredEnrollment"     , Type.GetType("System.DateTime"));
			dt.Columns.Add("syndicationId"              , Type.GetType("System.String"  ));
			dt.Columns.Add("facebookId"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("twitterId"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("linkedInId"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("acquisitionProgramId"       , Type.GetType("System.Int64"   ));
			// Read-only fields
			dt.Columns.Add("originalSourceType"         , Type.GetType("System.String"  ));
			dt.Columns.Add("originalSourceInfo"         , Type.GetType("System.String"  ));
			dt.Columns.Add("originalSearchEngine"       , Type.GetType("System.String"  ));
			dt.Columns.Add("originalSearchPhrase"       , Type.GetType("System.String"  ));
			dt.Columns.Add("originalReferrer"           , Type.GetType("System.String"  ));
			dt.Columns.Add("inferredCompany"            , Type.GetType("System.String"  ));
			dt.Columns.Add("inferredCountry"            , Type.GetType("System.String"  ));
			dt.Columns.Add("inferredCity"               , Type.GetType("System.String"  ));
			dt.Columns.Add("inferredStateRegion"        , Type.GetType("System.String"  ));
			dt.Columns.Add("inferredPostalCode"         , Type.GetType("System.String"  ));
			dt.Columns.Add("inferredMetropolitanArea"   , Type.GetType("System.String"  ));
			dt.Columns.Add("inferredPhoneAreaCode"      , Type.GetType("System.String"  ));
			dt.Columns.Add("totalReferredVisits"        , Type.GetType("System.Int64"   ));
			dt.Columns.Add("totalReferredEnrollments"   , Type.GetType("System.Int64"   ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id                          .HasValue ) row["id"                         ] = Sql.ToDBInteger (this.id                         .Value);
			if ( this.isDeleted                   .HasValue ) row["isDeleted"                  ] = Sql.ToDBBoolean (this.isDeleted                  .Value);
			if ( this.createdAt                   .HasValue ) row["createdAt"                  ] = Sql.ToDBDateTime(this.createdAt                  .Value);
			if ( this.updatedAt                   .HasValue ) row["updatedAt"                  ] = Sql.ToDBDateTime(this.updatedAt                  .Value);
			if ( this.company                     != null   ) row["company"                    ] = Sql.ToDBString  (this.company                          );
			if ( this.site                        != null   ) row["site"                       ] = Sql.ToDBString  (this.site                             );
			if ( this.billingStreet               != null   ) row["billingStreet"              ] = Sql.ToDBString  (this.billingStreet                    );
			if ( this.billingCity                 != null   ) row["billingCity"                ] = Sql.ToDBString  (this.billingCity                      );
			if ( this.billingState                != null   ) row["billingState"               ] = Sql.ToDBString  (this.billingState                     );
			if ( this.billingCountry              != null   ) row["billingCountry"             ] = Sql.ToDBString  (this.billingCountry                   );
			if ( this.billingPostalCode           != null   ) row["billingPostalCode"          ] = Sql.ToDBString  (this.billingPostalCode                );
			if ( this.website                     != null   ) row["website"                    ] = Sql.ToDBString  (this.website                          );
			if ( this.mainPhone                   != null   ) row["mainPhone"                  ] = Sql.ToDBString  (this.mainPhone                        );
			if ( this.annualRevenue               .HasValue ) row["annualRevenue"              ] = Sql.ToDBDecimal (this.annualRevenue              .Value);
			if ( this.numberOfEmployees           .HasValue ) row["numberOfEmployees"          ] = Sql.ToDBInteger (this.numberOfEmployees          .Value);
			if ( this.industry                    != null   ) row["industry"                   ] = Sql.ToDBString  (this.industry                         );
			if ( this.sicCode                     != null   ) row["sicCode"                    ] = Sql.ToDBString  (this.sicCode                          );
			if ( this.personType                  != null   ) row["personType"                 ] = Sql.ToDBString  (this.personType                       );
			if ( this.isLead                      .HasValue ) row["isLead"                     ] = Sql.ToDBBoolean (this.isLead                     .Value);
			if ( this.isAnonymous                 .HasValue ) row["isAnonymous"                ] = Sql.ToDBBoolean (this.isAnonymous                .Value);
			if ( this.salutation                  != null   ) row["salutation"                 ] = Sql.ToDBString  (this.salutation                       );
			if ( this.firstName                   != null   ) row["firstName"                  ] = Sql.ToDBString  (this.firstName                        );
			if ( this.middleName                  != null   ) row["middleName"                 ] = Sql.ToDBString  (this.middleName                       );
			if ( this.lastName                    != null   ) row["lastName"                   ] = Sql.ToDBString  (this.lastName                         );
			if ( this.email                       != null   ) row["email"                      ] = Sql.ToDBString  (this.email                            );
			if ( this.phone                       != null   ) row["phone"                      ] = Sql.ToDBString  (this.phone                            );
			if ( this.mobilePhone                 != null   ) row["mobilePhone"                ] = Sql.ToDBString  (this.mobilePhone                      );
			if ( this.fax                         != null   ) row["fax"                        ] = Sql.ToDBString  (this.fax                              );
			if ( this.title                       != null   ) row["title"                      ] = Sql.ToDBString  (this.title                            );
			if ( this.contactCompany              .HasValue ) row["contactCompany"             ] = Sql.ToDBInteger (this.contactCompany             .Value);
			if ( this.dateOfBirth                 .HasValue ) row["dateOfBirth"                ] = Sql.ToDBDateTime(this.dateOfBirth                .Value);
			if ( this.address                     != null   ) row["address"                    ] = Sql.ToDBString  (this.address                          );
			if ( this.city                        != null   ) row["city"                       ] = Sql.ToDBString  (this.city                             );
			if ( this.state                       != null   ) row["state"                      ] = Sql.ToDBString  (this.state                            );
			if ( this.country                     != null   ) row["country"                    ] = Sql.ToDBString  (this.country                          );
			if ( this.postalCode                  != null   ) row["postalCode"                 ] = Sql.ToDBString  (this.postalCode                       );
			if ( this.registrationSourceType      != null   ) row["registrationSourceType"     ] = Sql.ToDBString  (this.registrationSourceType           );
			if ( this.registrationSourceInfo      != null   ) row["registrationSourceInfo"     ] = Sql.ToDBString  (this.registrationSourceInfo           );
			if ( this.emailInvalid                .HasValue ) row["emailInvalid"               ] = Sql.ToDBBoolean (this.emailInvalid               .Value);
			if ( this.emailInvalidCause           != null   ) row["emailInvalidCause"          ] = Sql.ToDBString  (this.emailInvalidCause                );
			if ( this.unsubscribed                .HasValue ) row["unsubscribed"               ] = Sql.ToDBBoolean (this.unsubscribed               .Value);
			if ( this.unsubscribedReason          != null   ) row["unsubscribedReason"         ] = Sql.ToDBString  (this.unsubscribedReason               );
			if ( this.doNotCall                   .HasValue ) row["doNotCall"                  ] = Sql.ToDBBoolean (this.doNotCall                  .Value);
			if ( this.doNotCallReason             != null   ) row["doNotCallReason"            ] = Sql.ToDBString  (this.doNotCallReason                  );
			if ( this.anonymousIP                 != null   ) row["anonymousIP"                ] = Sql.ToDBString  (this.anonymousIP                      );
			if ( this.department                  != null   ) row["department"                 ] = Sql.ToDBString  (this.department                       );
			if ( this.cookies                     != null   ) row["cookies"                    ] = Sql.ToDBString  (this.cookies                          );
			if ( this.leadPerson                  .HasValue ) row["leadPerson"                 ] = Sql.ToDBInteger (this.leadPerson                 .Value);
			if ( this.leadRole                    != null   ) row["leadRole"                   ] = Sql.ToDBString  (this.leadRole                         );
			if ( this.leadSource                  != null   ) row["leadSource"                 ] = Sql.ToDBString  (this.leadSource                       );
			if ( this.leadStatus                  != null   ) row["leadStatus"                 ] = Sql.ToDBString  (this.leadStatus                       );
			if ( this.leadScore                   .HasValue ) row["leadScore"                  ] = Sql.ToDBInteger (this.leadScore                  .Value);
			if ( this.urgency                     .HasValue ) row["urgency"                    ] = Sql.ToDBFloat   (this.urgency                    .Value);
			if ( this.priority                    .HasValue ) row["priority"                   ] = Sql.ToDBInteger (this.priority                   .Value);
			if ( this.relativeScore               .HasValue ) row["relativeScore"              ] = Sql.ToDBInteger (this.relativeScore              .Value);
			if ( this.rating                      != null   ) row["rating"                     ] = Sql.ToDBString  (this.rating                           );
			if ( this.personPrimaryLeadInterest   .HasValue ) row["personPrimaryLeadInterest"  ] = Sql.ToDBInteger (this.personPrimaryLeadInterest  .Value);
			if ( this.leadPartitionId             .HasValue ) row["leadPartitionId"            ] = Sql.ToDBInteger (this.leadPartitionId            .Value);
			if ( this.leadRevenueCycleModelId     .HasValue ) row["leadRevenueCycleModelId"    ] = Sql.ToDBInteger (this.leadRevenueCycleModelId    .Value);
			if ( this.leadRevenueStageId          .HasValue ) row["leadRevenueStageId"         ] = Sql.ToDBInteger (this.leadRevenueStageId         .Value);
			if ( this.gender                      != null   ) row["gender"                     ] = Sql.ToDBString  (this.gender                           );
			if ( this.facebookDisplayName         != null   ) row["facebookDisplayName"        ] = Sql.ToDBString  (this.facebookDisplayName              );
			if ( this.twitterDisplayName          != null   ) row["twitterDisplayName"         ] = Sql.ToDBString  (this.twitterDisplayName               );
			if ( this.linkedInDisplayName         != null   ) row["linkedInDisplayName"        ] = Sql.ToDBString  (this.linkedInDisplayName              );
			if ( this.facebookProfileURL          != null   ) row["facebookProfileURL"         ] = Sql.ToDBString  (this.facebookProfileURL               );
			if ( this.twitterProfileURL           != null   ) row["twitterProfileURL"          ] = Sql.ToDBString  (this.twitterProfileURL                );
			if ( this.linkedInProfileURL          != null   ) row["linkedInProfileURL"         ] = Sql.ToDBString  (this.linkedInProfileURL               );
			if ( this.facebookPhotoURL            != null   ) row["facebookPhotoURL"           ] = Sql.ToDBString  (this.facebookPhotoURL                 );
			if ( this.twitterPhotoURL             != null   ) row["twitterPhotoURL"            ] = Sql.ToDBString  (this.twitterPhotoURL                  );
			if ( this.linkedInPhotoURL            != null   ) row["linkedInPhotoURL"           ] = Sql.ToDBString  (this.linkedInPhotoURL                 );
			if ( this.facebookReach               .HasValue ) row["facebookReach"              ] = Sql.ToDBInteger (this.facebookReach              .Value);
			if ( this.twitterReach                .HasValue ) row["twitterReach"               ] = Sql.ToDBInteger (this.twitterReach               .Value);
			if ( this.linkedInReach               .HasValue ) row["linkedInReach"              ] = Sql.ToDBInteger (this.linkedInReach              .Value);
			if ( this.facebookReferredVisits      .HasValue ) row["facebookReferredVisits"     ] = Sql.ToDBInteger (this.facebookReferredVisits     .Value);
			if ( this.twitterReferredVisits       .HasValue ) row["twitterReferredVisits"      ] = Sql.ToDBInteger (this.twitterReferredVisits      .Value);
			if ( this.linkedInReferredVisits      .HasValue ) row["linkedInReferredVisits"     ] = Sql.ToDBInteger (this.linkedInReferredVisits     .Value);
			if ( this.facebookReferredEnrollments .HasValue ) row["facebookReferredEnrollments"] = Sql.ToDBInteger (this.facebookReferredEnrollments.Value);
			if ( this.twitterReferredEnrollments  .HasValue ) row["twitterReferredEnrollments" ] = Sql.ToDBInteger (this.twitterReferredEnrollments .Value);
			if ( this.linkedInReferredEnrollments .HasValue ) row["linkedInReferredEnrollments"] = Sql.ToDBInteger (this.linkedInReferredEnrollments.Value);
			if ( this.lastReferredVisit           .HasValue ) row["lastReferredVisit"          ] = Sql.ToDBDateTime(this.lastReferredVisit          .Value);
			if ( this.lastReferredEnrollment      .HasValue ) row["lastReferredEnrollment"     ] = Sql.ToDBDateTime(this.lastReferredEnrollment     .Value);
			if ( this.syndicationId               != null   ) row["syndicationId"              ] = Sql.ToDBString  (this.syndicationId                    );
			if ( this.facebookId                  != null   ) row["facebookId"                 ] = Sql.ToDBString  (this.facebookId                       );
			if ( this.twitterId                   != null   ) row["twitterId"                  ] = Sql.ToDBString  (this.twitterId                        );
			if ( this.linkedInId                  != null   ) row["linkedInId"                 ] = Sql.ToDBString  (this.linkedInId                       );
			if ( this.acquisitionProgramId        .HasValue ) row["acquisitionProgramId"       ] = Sql.ToDBInteger (this.acquisitionProgramId       .Value);
			// Read-only fields
			if ( this.originalSourceType          != null   ) row["originalSourceType"         ] = Sql.ToDBString  (this.originalSourceType               );
			if ( this.originalSourceInfo          != null   ) row["originalSourceInfo"         ] = Sql.ToDBString  (this.originalSourceInfo               );
			if ( this.originalSearchEngine        != null   ) row["originalSearchEngine"       ] = Sql.ToDBString  (this.originalSearchEngine             );
			if ( this.originalSearchPhrase        != null   ) row["originalSearchPhrase"       ] = Sql.ToDBString  (this.originalSearchPhrase             );
			if ( this.originalReferrer            != null   ) row["originalReferrer"           ] = Sql.ToDBString  (this.originalReferrer                 );
			if ( this.inferredCompany             != null   ) row["inferredCompany"            ] = Sql.ToDBString  (this.inferredCompany                  );
			if ( this.inferredCountry             != null   ) row["inferredCountry"            ] = Sql.ToDBString  (this.inferredCountry                  );
			if ( this.inferredCity                != null   ) row["inferredCity"               ] = Sql.ToDBString  (this.inferredCity                     );
			if ( this.inferredStateRegion         != null   ) row["inferredStateRegion"        ] = Sql.ToDBString  (this.inferredStateRegion              );
			if ( this.inferredPostalCode          != null   ) row["inferredPostalCode"         ] = Sql.ToDBString  (this.inferredPostalCode               );
			if ( this.inferredMetropolitanArea    != null   ) row["inferredMetropolitanArea"   ] = Sql.ToDBString  (this.inferredMetropolitanArea         );
			if ( this.inferredPhoneAreaCode       != null   ) row["inferredPhoneAreaCode"      ] = Sql.ToDBString  (this.inferredPhoneAreaCode            );
			if ( this.totalReferredVisits         .HasValue ) row["totalReferredVisits"        ] = Sql.ToDBInteger (this.totalReferredVisits        .Value);
			if ( this.totalReferredEnrollments    .HasValue ) row["totalReferredEnrollments"   ] = Sql.ToDBInteger (this.totalReferredEnrollments   .Value);
		}

		public static DataRow ConvertToRow(Lead obj)
		{
			DataTable dt = Lead.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Lead> leads)
		{
			DataTable dt = Lead.CreateTable();
			if ( leads != null )
			{
				foreach ( Lead lead in leads )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					lead.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class LeadPagination
	{
		public IList<Lead>    items         { get; set; }
		public string         nextPageToken { get; set; }
		public bool?          moreResult    { get; set; }
	}
}
