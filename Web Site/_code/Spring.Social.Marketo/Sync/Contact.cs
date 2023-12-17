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
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Web;
using System.Diagnostics;
using SplendidCRM;

namespace Spring.Social.Marketo
{
	public class Contact : MObject
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private ExchangeSecurity     ExchangeSecurity   ;

		#region Properties
		public String    company                      { get; set; }  // 255, ACCOUNT_NAME
		public String    billingStreet                { get; set; }  //    , ALT_ADDRESS_STREET
		public String    billingCity                  { get; set; }  // 255, ALT_ADDRESS_CITY
		public String    billingState                 { get; set; }  // 255, ALT_ADDRESS_STATE
		public String    billingCountry               { get; set; }  // 255, ALT_ADDRESS_COUNTRY
		public String    billingPostalCode            { get; set; }  // 255, ALT_ADDRESS_POSTALCODE
		public String    website                      { get; set; }  // 255, WEBSITE
		public String    mainPhone                    { get; set; }  // 255, PHONE_WORK
		public String    salutation                   { get; set; }  // 255, SALUTATION
		public String    firstName                    { get; set; }  // 255, FIRST_NAME
		public String    lastName                     { get; set; }  // 255, LAST_NAME
		public String    email                        { get; set; }  // 255, EMAIL1
		public String    phone                        { get; set; }  // 255, PHONE_HOME
		public String    mobilePhone                  { get; set; }  // 255, PHONE_MOBILE
		public String    fax                          { get; set; }  // 255, PHONE_FAX
		public String    title                        { get; set; }  // 255, TITLE
		public DateTime  dateOfBirth                  { get; set; }  //      BIRTHDATE
		public String    address                      { get; set; }  //      PRIMARY_ADDRESS_STREET
		public String    city                         { get; set; }  // 255, PRIMARY_ADDRESS_CITY
		public String    state                        { get; set; }  // 255, PRIMARY_ADDRESS_STATE
		public String    country                      { get; set; }  // 255, PRIMARY_ADDRESS_COUNTRY
		public String    postalCode                   { get; set; }  // 255, PRIMARY_ADDRESS_POSTALCODE
		public bool      emailInvalid                 { get; set; }  //      INVALID_EMAIL
		public bool      unsubscribed                 { get; set; }  //      EMAIL_OPT_OUT
		public bool      doNotCall                    { get; set; }  //      DO_NOT_CALL
		public String    department                   { get; set; }  // 255, DEPARTMENT
		public String    leadSource                   { get; set; }  // 255, LEAD_SOURCE
		public String    leadStatus                   { get; set; }  // 255, STATUS
		public String    twitterDisplayName           { get; set; }  // 255, TWITTER_SCREEN_NAME

		//public String    site                         { get; set; }  // 255
		//public Decimal?  annualRevenue                { get; set; }  // 
		//public int?      numberOfEmployees            { get; set; }  // 
		//public String    industry                     { get; set; }  // 255
		//public String    sicCode                      { get; set; }  // 40
		//public String    personType                   { get; set; }  // 50
		//public bool?     isLead                       { get; set; }  // 
		//public bool?     isAnonymous                  { get; set; }  // 
		//public String    middleName                   { get; set; }  // 255
		//public int?      contactCompany               { get; set; }
		//public String    registrationSourceType       { get; set; }  // 255
		//public String    registrationSourceInfo       { get; set; }  // 2000
		//public String    emailInvalidCause            { get; set; }  // 255
		//public String    unsubscribedReason           { get; set; }  // 2000
		//public String    doNotCallReason              { get; set; }  // 2000
		//public String    anonymousIP                  { get; set; }  // 255
		//public String    cookies                      { get; set; }  // 255
		//public int?      leadPerson                   { get; set; }
		//public String    leadRole                     { get; set; }  // 50
		//public int?      leadScore                    { get; set; }  // 
		//public float?    urgency                      { get; set; }  // 
		//public int?      priority                     { get; set; }  // 
		//public int?      relativeScore                { get; set; }  // 
		//public String    rating                       { get; set; }  // 255
		//public int?      personPrimaryLeadInterest    { get; set; }  // 
		//public int?      leadPartitionId              { get; set; }  // 
		//public int?      leadRevenueCycleModelId      { get; set; }  // 
		//public int?      leadRevenueStageId           { get; set; }  // 
		//public String    gender                       { get; set; }  // 255
		//public String    facebookDisplayName          { get; set; }  // 255
		//public String    linkedInDisplayName          { get; set; }  // 255
		//public String    facebookProfileURL           { get; set; }  // 2000
		//public String    twitterProfileURL            { get; set; }  // 2000
		//public String    linkedInProfileURL           { get; set; }  // 2000
		//public String    facebookPhotoURL             { get; set; }  // 2000
		//public String    twitterPhotoURL              { get; set; }  // 2000
		//public String    linkedInPhotoURL             { get; set; }  // 2000
		//public int?      facebookReach                { get; set; }  // 
		//public int?      twitterReach                 { get; set; }  // 
		//public int?      linkedInReach                { get; set; }  // 
		//public int?      facebookReferredVisits       { get; set; }  // 
		//public int?      twitterReferredVisits        { get; set; }  // 
		//public int?      linkedInReferredVisits       { get; set; }  // 
		//public int?      facebookReferredEnrollments  { get; set; }  // 
		//public int?      twitterReferredEnrollments   { get; set; }  // 
		//public int?      linkedInReferredEnrollments  { get; set; }  // 
		//public DateTime? lastReferredVisit            { get; set; }  // 
		//public DateTime? lastReferredEnrollment       { get; set; }  // 
		//public String    syndicationId                { get; set; }  // 2000
		//public String    facebookId                   { get; set; }  // 2000
		//public String    twitterId                    { get; set; }  // 2000
		//public String    linkedInId                   { get; set; }  // 2000
		//public int?      acquisitionProgramId         { get; set; }  // 
		#endregion

		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.Marketo.Api.IMarketo marketo, string fields)
			: base(Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, marketo, "Contacts", "Name", "Contacts", "CONTACTS", "NAME", true, fields)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
		}

		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.Marketo.Api.IMarketo marketo, string fields, string sMarketoTableName, string sMarketoTableSort, string sCRMModuleName, string sCRMTableName, string sCRMTableSort, bool bCRMAssignedUser)
			: base(Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, marketo, sMarketoTableName, sMarketoTableSort, sCRMModuleName, sCRMTableName, sCRMTableSort, bCRMAssignedUser, fields)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
		}

		public override void Reset()
		{
			base.Reset();
			this.company            = String.Empty;
			this.billingStreet      = String.Empty;
			this.billingCity        = String.Empty;
			this.billingState       = String.Empty;
			this.billingCountry     = String.Empty;
			this.billingPostalCode  = String.Empty;
			this.website            = String.Empty;
			this.mainPhone          = String.Empty;
			this.salutation         = String.Empty;
			this.firstName          = String.Empty;
			this.lastName           = String.Empty;
			this.email              = String.Empty;
			this.phone              = String.Empty;
			this.mobilePhone        = String.Empty;
			this.fax                = String.Empty;
			this.title              = String.Empty;
			this.dateOfBirth        = DateTime.MinValue;
			this.address            = String.Empty;
			this.city               = String.Empty;
			this.state              = String.Empty;
			this.country            = String.Empty;
			this.postalCode         = String.Empty;
			this.emailInvalid       = false       ;
			this.unsubscribed       = false       ;
			this.doNotCall          = false       ;
			this.department         = String.Empty;
			this.leadSource         = String.Empty;
			this.leadStatus         = String.Empty;
			this.twitterDisplayName = String.Empty;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			
			this.id       = Sql.ToInteger(sID);
			this.LOCAL_ID = Sql.ToGuid  (row["ID"  ]);
			this.name     = Sql.ToString(row["NAME"]);
			if ( Sql.IsEmptyString(sID) )
			{
				this.company            = Sql.ToString  (row["ACCOUNT_NAME"               ]);
				this.billingStreet      = Sql.ToString  (row["ALT_ADDRESS_STREET"         ]);
				this.billingCity        = Sql.ToString  (row["ALT_ADDRESS_CITY"           ]);
				this.billingState       = Sql.ToString  (row["ALT_ADDRESS_STATE"          ]);
				this.billingCountry     = Sql.ToString  (row["ALT_ADDRESS_COUNTRY"        ]);
				this.billingPostalCode  = Sql.ToString  (row["ALT_ADDRESS_POSTALCODE"     ]);
				this.website            = Sql.ToString  (row["WEBSITE"                    ]);
				this.mainPhone          = Sql.ToString  (row["PHONE_WORK"                 ]);
				this.salutation         = Sql.ToString  (row["SALUTATION"                 ]);
				this.firstName          = Sql.ToString  (row["FIRST_NAME"                 ]);
				this.lastName           = Sql.ToString  (row["LAST_NAME"                  ]);
				this.email              = Sql.ToString  (row["EMAIL1"                     ]);
				this.phone              = Sql.ToString  (row["PHONE_HOME"                 ]);
				this.mobilePhone        = Sql.ToString  (row["PHONE_MOBILE"               ]);
				this.fax                = Sql.ToString  (row["PHONE_FAX"                  ]);
				this.title              = Sql.ToString  (row["TITLE"                      ]);
				this.dateOfBirth        = Sql.ToDateTime(row["BIRTHDATE"                  ]);
				this.address            = Sql.ToString  (row["PRIMARY_ADDRESS_STREET"     ]);
				this.city               = Sql.ToString  (row["PRIMARY_ADDRESS_CITY"       ]);
				this.state              = Sql.ToString  (row["PRIMARY_ADDRESS_STATE"      ]);
				this.country            = Sql.ToString  (row["PRIMARY_ADDRESS_COUNTRY"    ]);
				this.postalCode         = Sql.ToString  (row["PRIMARY_ADDRESS_POSTALCODE" ]);
				this.emailInvalid       = Sql.ToBoolean (row["INVALID_EMAIL"              ]);
				this.unsubscribed       = Sql.ToBoolean (row["EMAIL_OPT_OUT"              ]);
				this.doNotCall          = Sql.ToBoolean (row["DO_NOT_CALL"                ]);
				this.department         = Sql.ToString  (row["DEPARTMENT"                 ]);
				this.leadSource         = Sql.ToString  (row["LEAD_SOURCE"                ]);
				this.leadStatus         = Sql.ToString  (row["STATUS"                     ]);
				this.twitterDisplayName = Sql.ToString  (row["TWITTER_SCREEN_NAME"        ]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.company           , row["ACCOUNT_NAME"               ], "ACCOUNT_NAME"               , sbChanges) ) { this.company            = Sql.ToString  (row["ACCOUNT_NAME"               ]);  bChanged = true; }
				if ( Compare(this.billingStreet     , row["ALT_ADDRESS_STREET"         ], "ALT_ADDRESS_STREET"         , sbChanges) ) { this.billingStreet      = Sql.ToString  (row["ALT_ADDRESS_STREET"         ]);  bChanged = true; }
				if ( Compare(this.billingCity       , row["ALT_ADDRESS_CITY"           ], "ALT_ADDRESS_CITY"           , sbChanges) ) { this.billingCity        = Sql.ToString  (row["ALT_ADDRESS_CITY"           ]);  bChanged = true; }
				if ( Compare(this.billingState      , row["ALT_ADDRESS_STATE"          ], "ALT_ADDRESS_STATE"          , sbChanges) ) { this.billingState       = Sql.ToString  (row["ALT_ADDRESS_STATE"          ]);  bChanged = true; }
				if ( Compare(this.billingCountry    , row["ALT_ADDRESS_COUNTRY"        ], "ALT_ADDRESS_COUNTRY"        , sbChanges) ) { this.billingCountry     = Sql.ToString  (row["ALT_ADDRESS_COUNTRY"        ]);  bChanged = true; }
				if ( Compare(this.billingPostalCode , row["ALT_ADDRESS_POSTALCODE"     ], "ALT_ADDRESS_POSTALCODE"     , sbChanges) ) { this.billingPostalCode  = Sql.ToString  (row["ALT_ADDRESS_POSTALCODE"     ]);  bChanged = true; }
				if ( Compare(this.website           , row["WEBSITE"                    ], "WEBSITE"                    , sbChanges) ) { this.website            = Sql.ToString  (row["WEBSITE"                    ]);  bChanged = true; }
				if ( Compare(this.mainPhone         , row["PHONE_WORK"                 ], "PHONE_WORK"                 , sbChanges) ) { this.mainPhone          = Sql.ToString  (row["PHONE_WORK"                 ]);  bChanged = true; }
				if ( Compare(this.salutation        , row["SALUTATION"                 ], "SALUTATION"                 , sbChanges) ) { this.salutation         = Sql.ToString  (row["SALUTATION"                 ]);  bChanged = true; }
				if ( Compare(this.firstName         , row["FIRST_NAME"                 ], "FIRST_NAME"                 , sbChanges) ) { this.firstName          = Sql.ToString  (row["FIRST_NAME"                 ]);  bChanged = true; }
				if ( Compare(this.lastName          , row["LAST_NAME"                  ], "LAST_NAME"                  , sbChanges) ) { this.lastName           = Sql.ToString  (row["LAST_NAME"                  ]);  bChanged = true; }
				if ( Compare(this.email             , row["EMAIL1"                     ], "EMAIL1"                     , sbChanges) ) { this.email              = Sql.ToString  (row["EMAIL1"                     ]);  bChanged = true; }
				if ( Compare(this.phone             , row["PHONE_HOME"                 ], "PHONE_HOME"                 , sbChanges) ) { this.phone              = Sql.ToString  (row["PHONE_HOME"                 ]);  bChanged = true; }
				if ( Compare(this.mobilePhone       , row["PHONE_MOBILE"               ], "PHONE_MOBILE"               , sbChanges) ) { this.mobilePhone        = Sql.ToString  (row["PHONE_MOBILE"               ]);  bChanged = true; }
				if ( Compare(this.fax               , row["PHONE_FAX"                  ], "PHONE_FAX"                  , sbChanges) ) { this.fax                = Sql.ToString  (row["PHONE_FAX"                  ]);  bChanged = true; }
				if ( Compare(this.title             , row["TITLE"                      ], "TITLE"                      , sbChanges) ) { this.title              = Sql.ToString  (row["TITLE"                      ]);  bChanged = true; }
				if ( Compare(this.dateOfBirth       , row["BIRTHDATE"                  ], "BIRTHDATE"                  , sbChanges) ) { this.dateOfBirth        = Sql.ToDateTime(row["BIRTHDATE"                  ]);  bChanged = true; }
				if ( Compare(this.address           , row["PRIMARY_ADDRESS_STREET"     ], "PRIMARY_ADDRESS_STREET"     , sbChanges) ) { this.address            = Sql.ToString  (row["PRIMARY_ADDRESS_STREET"     ]);  bChanged = true; }
				if ( Compare(this.city              , row["PRIMARY_ADDRESS_CITY"       ], "PRIMARY_ADDRESS_CITY"       , sbChanges) ) { this.city               = Sql.ToString  (row["PRIMARY_ADDRESS_CITY"       ]);  bChanged = true; }
				if ( Compare(this.state             , row["PRIMARY_ADDRESS_STATE"      ], "PRIMARY_ADDRESS_STATE"      , sbChanges) ) { this.state              = Sql.ToString  (row["PRIMARY_ADDRESS_STATE"      ]);  bChanged = true; }
				if ( Compare(this.country           , row["PRIMARY_ADDRESS_COUNTRY"    ], "PRIMARY_ADDRESS_COUNTRY"    , sbChanges) ) { this.country            = Sql.ToString  (row["PRIMARY_ADDRESS_COUNTRY"    ]);  bChanged = true; }
				if ( Compare(this.postalCode        , row["PRIMARY_ADDRESS_POSTALCODE" ], "PRIMARY_ADDRESS_POSTALCODE" , sbChanges) ) { this.postalCode         = Sql.ToString  (row["PRIMARY_ADDRESS_POSTALCODE" ]);  bChanged = true; }
				if ( Compare(this.emailInvalid      , row["INVALID_EMAIL"              ], "INVALID_EMAIL"              , sbChanges) ) { this.emailInvalid       = Sql.ToBoolean (row["INVALID_EMAIL"              ]);  bChanged = true; }
				if ( Compare(this.unsubscribed      , row["EMAIL_OPT_OUT"              ], "EMAIL_OPT_OUT"              , sbChanges) ) { this.unsubscribed       = Sql.ToBoolean (row["EMAIL_OPT_OUT"              ]);  bChanged = true; }
				if ( Compare(this.doNotCall         , row["DO_NOT_CALL"                ], "DO_NOT_CALL"                , sbChanges) ) { this.doNotCall          = Sql.ToBoolean (row["DO_NOT_CALL"                ]);  bChanged = true; }
				if ( Compare(this.department        , row["DEPARTMENT"                 ], "DEPARTMENT"                 , sbChanges) ) { this.department         = Sql.ToString  (row["DEPARTMENT"                 ]);  bChanged = true; }
				if ( Compare(this.leadSource        , row["LEAD_SOURCE"                ], "LEAD_SOURCE"                , sbChanges) ) { this.leadSource         = Sql.ToString  (row["LEAD_SOURCE"                ]);  bChanged = true; }
				if ( Compare(this.leadStatus        , row["STATUS"                     ], "STATUS"                     , sbChanges) ) { this.leadStatus         = Sql.ToString  (row["STATUS"                     ]);  bChanged = true; }
				if ( Compare(this.twitterDisplayName, row["TWITTER_SCREEN_NAME"        ], "TWITTER_SCREEN_NAME"        , sbChanges) ) { this.twitterDisplayName = Sql.ToString  (row["TWITTER_SCREEN_NAME"        ]);  bChanged = true; }
			}
			return bChanged;
		}

		public override void SetFromMarketo(int nId)
		{
			Spring.Social.Marketo.Api.Lead obj = this.Marketo.LeadOperations.GetById(nId, this.MarketoFields);
			SetFromMarketo(obj);
		}

		public void SetFromMarketo(Spring.Social.Marketo.Api.Lead obj)
		{
			this.Reset();
			this.RawContent         = obj.RawContent        ;
			this.id                 = obj.id.Value          ;
			this.name               = (Sql.ToString(obj.firstName) + " " + Sql.ToString(obj.lastName)).Trim();
			this.createdAt          = obj.CreatedAt         ;
			this.updatedAt          = obj.UpdatedAt         ;
			this.company            = obj.company           ;
			this.billingStreet      = obj.billingStreet     ;
			this.billingCity        = obj.billingCity       ;
			this.billingState       = obj.billingState      ;
			this.billingCountry     = obj.billingCountry    ;
			this.billingPostalCode  = obj.billingPostalCode ;
			this.website            = obj.website           ;
			this.mainPhone          = obj.mainPhone         ;
			this.salutation         = obj.salutation        ;
			this.firstName          = obj.firstName         ;
			this.lastName           = obj.lastName          ;
			this.email              = obj.email             ;
			this.phone              = obj.phone             ;
			this.mobilePhone        = obj.mobilePhone       ;
			this.fax                = obj.fax               ;
			this.title              = obj.title             ;
			this.dateOfBirth        = obj.DateOfBirth       ;
			this.address            = obj.address           ;
			this.city               = obj.city              ;
			this.state              = obj.state             ;
			this.country            = obj.country           ;
			this.postalCode         = obj.postalCode        ;
			this.emailInvalid       = obj.EmailInvalid      ;
			this.unsubscribed       = obj.Unsubscribed      ;
			this.doNotCall          = obj.DoNotCall         ;
			this.department         = obj.department        ;
			this.leadSource         = obj.leadSource        ;
			this.leadStatus         = obj.leadStatus        ;
			this.twitterDisplayName = obj.twitterDisplayName;
		}

		public override void Update()
		{
			Spring.Social.Marketo.Api.Lead obj = this.Marketo.LeadOperations.GetById(this.id, this.MarketoFields);
			obj.id                 = this.id                ;
			obj.company            = this.company           ;
			obj.billingStreet      = this.billingStreet     ;
			obj.billingCity        = this.billingCity       ;
			obj.billingState       = this.billingState      ;
			obj.billingCountry     = this.billingCountry    ;
			obj.billingPostalCode  = this.billingPostalCode ;
			obj.website            = this.website           ;
			obj.mainPhone          = this.mainPhone         ;
			obj.salutation         = this.salutation        ;
			obj.firstName          = this.firstName         ;
			obj.lastName           = this.lastName          ;
			obj.email              = this.email             ;
			obj.phone              = this.phone             ;
			obj.mobilePhone        = this.mobilePhone       ;
			obj.fax                = this.fax               ;
			obj.title              = this.title             ;
			obj.dateOfBirth        = this.dateOfBirth       ;
			obj.address            = this.address           ;
			obj.city               = this.city              ;
			obj.state              = this.state             ;
			obj.country            = this.country           ;
			obj.postalCode         = this.postalCode        ;
			obj.emailInvalid       = this.emailInvalid      ;
			obj.unsubscribed       = this.unsubscribed      ;
			obj.doNotCall          = this.doNotCall         ;
			obj.department         = this.department        ;
			obj.leadSource         = this.leadSource        ;
			obj.leadStatus         = this.leadStatus        ;
			obj.twitterDisplayName = this.twitterDisplayName;
			
			this.Marketo.LeadOperations.Update(obj);
			// 05/18/2015 Paul.  Update does not return the last modified date. Get the record again. 
			obj = this.Marketo.LeadOperations.GetById(this.id, String.Empty);
			this.RawContent       = obj.RawContent          ;
			this.updatedAt        = obj.UpdatedAt           ;
		}

		public override string Insert()
		{
			this.id = 0;
			
			Spring.Social.Marketo.Api.Lead obj = new Spring.Social.Marketo.Api.Lead();
			obj.company            = this.company           ;
			obj.billingStreet      = this.billingStreet     ;
			obj.billingCity        = this.billingCity       ;
			obj.billingState       = this.billingState      ;
			obj.billingCountry     = this.billingCountry    ;
			obj.billingPostalCode  = this.billingPostalCode ;
			obj.website            = this.website           ;
			obj.mainPhone          = this.mainPhone         ;
			obj.salutation         = this.salutation        ;
			obj.firstName          = this.firstName         ;
			obj.lastName           = this.lastName          ;
			obj.email              = this.email             ;
			obj.phone              = this.phone             ;
			obj.mobilePhone        = this.mobilePhone       ;
			obj.fax                = this.fax               ;
			obj.title              = this.title             ;
			obj.dateOfBirth        = this.dateOfBirth       ;
			obj.address            = this.address           ;
			obj.city               = this.city              ;
			obj.state              = this.state             ;
			obj.country            = this.country           ;
			obj.postalCode         = this.postalCode        ;
			obj.emailInvalid       = this.emailInvalid      ;
			obj.unsubscribed       = this.unsubscribed      ;
			obj.doNotCall          = this.doNotCall         ;
			obj.department         = this.department        ;
			obj.leadSource         = this.leadSource        ;
			obj.leadStatus         = this.leadStatus        ;
			obj.twitterDisplayName = this.twitterDisplayName;

			obj.id = this.Marketo.LeadOperations.Insert(obj);
			// 05/18/2015 Paul.  Insert does not return the last modified date. Get the record again. 
			obj = this.Marketo.LeadOperations.GetById(obj.id.Value, String.Empty);
			this.RawContent       = obj.RawContent          ;
			this.id               = obj.id.Value            ;
			this.updatedAt        = obj.UpdatedAt           ;
			return Sql.ToString(this.id);
		}

		public override void Delete()
		{
			this.Marketo.LeadOperations.Delete(this.id);
		}

		public override void Get(string sID)
		{
			Spring.Social.Marketo.Api.Lead obj = this.Marketo.LeadOperations.GetById(Sql.ToInteger(sID), this.MarketoFields);
			if ( obj.id.HasValue )
			{
				this.SetFromMarketo(obj);
			}
			else
			{
				this.Deleted = true;
			}
		}

		public override IList<Spring.Social.Marketo.Api.MBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.Marketo.Api.MBase> lst = this.Marketo.LeadOperations.GetModified(dtStartModifiedDate);
			return lst;
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			// 05/19/2015 Paul.  The email is treated as a primary key. 
			Sql.AppendParameter(cmd, Sql.ToString(this.email), "EMAIL1");
		}

		// 12/22/2007 Paul.  Inside the timer event, there is no current context, so we need to pass the application. 
		public Guid GetAccountID(string sNAME)
		{
			Guid gACCOUNT_ID = Guid.Empty;
			if ( !Sql.IsEmptyString(sNAME) )
			{
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select ID          " + ControlChars.CrLf
					     + "  from vwACCOUNTS  " + ControlChars.CrLf
					     + " where NAME = @NAME" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@NAME", sNAME);
						gACCOUNT_ID = Sql.ToGuid(cmd.ExecuteScalar());
					}
				}
			}
			return gACCOUNT_ID;
		}

		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = this.InitUpdateProcedure(spUpdate, row, gUSER_ID, gTEAM_ID);
			
			Guid gACCOUNT_ID = GetAccountID(this.company);
			foreach(IDbDataParameter par in spUpdate.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
				string sColumnName = Sql.ExtractDbName(spUpdate, par.ParameterName).ToUpper();
				if ( SplendidInit.bEnableACLFieldSecurity )
				{
					acl = ExchangeSecurity.GetUserFieldSecurity(Session, this.CRMModuleName, sColumnName, gASSIGNED_USER_ID);
				}
				if ( acl.IsWriteable() )
				{
					try
					{
						// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
						object oValue = null;
						switch ( sColumnName )
						{
							case "ACCOUNT_ID"                :  oValue = Sql.ToDBGuid    (     gACCOUNT_ID       );  break;
							case "ACCOUNT_NAME"              :  oValue = Sql.ToDBString  (this.company           );  break;
							case "ALT_ADDRESS_STREET"        :  oValue = Sql.ToDBString  (this.billingStreet     );  break;
							case "ALT_ADDRESS_CITY"          :  oValue = Sql.ToDBString  (this.billingCity       );  break;
							case "ALT_ADDRESS_STATE"         :  oValue = Sql.ToDBString  (this.billingState      );  break;
							case "ALT_ADDRESS_COUNTRY"       :  oValue = Sql.ToDBString  (this.billingCountry    );  break;
							case "ALT_ADDRESS_POSTALCODE"    :  oValue = Sql.ToDBString  (this.billingPostalCode );  break;
							case "WEBSITE"                   :  oValue = Sql.ToDBString  (this.website           );  break;
							case "PHONE_WORK"                :  oValue = Sql.ToDBString  (this.mainPhone         );  break;
							case "SALUTATION"                :  oValue = Sql.ToDBString  (this.salutation        );  break;
							case "FIRST_NAME"                :  oValue = Sql.ToDBString  (this.firstName         );  break;
							case "LAST_NAME"                 :  oValue = Sql.ToDBString  (this.lastName          );  break;
							case "EMAIL1"                    :  oValue = Sql.ToDBString  (this.email             );  break;
							case "PHONE_HOME"                :  oValue = Sql.ToDBString  (this.phone             );  break;
							case "PHONE_MOBILE"              :  oValue = Sql.ToDBString  (this.mobilePhone       );  break;
							case "PHONE_FAX"                 :  oValue = Sql.ToDBString  (this.fax               );  break;
							case "TITLE"                     :  oValue = Sql.ToDBString  (this.title             );  break;
							case "BIRTHDATE"                 :  oValue = Sql.ToDBDateTime(this.dateOfBirth       );  break;
							case "PRIMARY_ADDRESS_STREET"    :  oValue = Sql.ToDBString  (this.address           );  break;
							case "PRIMARY_ADDRESS_CITY"      :  oValue = Sql.ToDBString  (this.city              );  break;
							case "PRIMARY_ADDRESS_STATE"     :  oValue = Sql.ToDBString  (this.state             );  break;
							case "PRIMARY_ADDRESS_COUNTRY"   :  oValue = Sql.ToDBString  (this.country           );  break;
							case "PRIMARY_ADDRESS_POSTALCODE":  oValue = Sql.ToDBString  (this.postalCode        );  break;
							case "INVALID_EMAIL"             :  oValue = Sql.ToDBBoolean (this.emailInvalid      );  break;
							case "EMAIL_OPT_OUT"             :  oValue = Sql.ToDBBoolean (this.unsubscribed      );  break;
							case "DO_NOT_CALL"               :  oValue = Sql.ToDBBoolean (this.doNotCall         );  break;
							case "DEPARTMENT"                :  oValue = Sql.ToDBString  (this.department        );  break;
							case "LEAD_SOURCE"               :  oValue = Sql.ToDBString  (this.leadSource        );  break;
							case "STATUS"                    :  oValue = Sql.ToDBString  (this.leadStatus        );  break;
							case "TWITTER_SCREEN_NAME"       :  oValue = Sql.ToDBString  (this.twitterDisplayName);  break;
							case "MODIFIED_USER_ID"          :  oValue = gUSER_ID                                 ;  break;
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						// 02/17/2015 Paul.  Modified User ID does not count as a changed field. 
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "ACCOUNT_NAME"              :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "ALT_ADDRESS_STREET"        :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "ALT_ADDRESS_CITY"          :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "ALT_ADDRESS_STATE"         :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "ALT_ADDRESS_COUNTRY"       :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "ALT_ADDRESS_POSTALCODE"    :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "WEBSITE"                   :  bChanged = ParameterChanged(par, oValue,  255, sbChanges);  break;
									case "PHONE_WORK"                :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "SALUTATION"                :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "FIRST_NAME"                :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "LAST_NAME"                 :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "EMAIL1"                    :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PHONE_HOME"                :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_MOBILE"              :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PHONE_FAX"                 :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "TITLE"                     :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PRIMARY_ADDRESS_STREET"    :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "PRIMARY_ADDRESS_CITY"      :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PRIMARY_ADDRESS_STATE"     :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PRIMARY_ADDRESS_COUNTRY"   :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "PRIMARY_ADDRESS_POSTALCODE":  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "DEPARTMENT"                :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "LEAD_SOURCE"               :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "STATUS"                    :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "TWITTER_SCREEN_NAME"       :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									default                          :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
								}
							}
							par.Value = oValue;
						}
					}
					catch
					{
						// 03/27/2010 Paul.  Some fields are not available.  Lets just ignore them. 
					}
				}
			}
			return bChanged;
		}
	}
}
