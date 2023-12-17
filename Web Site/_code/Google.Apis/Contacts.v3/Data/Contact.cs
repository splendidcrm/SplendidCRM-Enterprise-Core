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
using System.Collections.Generic;
using System.Globalization;
using Newtonsoft.Json;
using Google.Apis.Util;

// https://developers.google.com/google-apps/contacts/v3/reference
namespace Google.Apis.Contacts.v3.Data
{
	// https://developers.google.com/gdata/docs/2.0/elements
	public class Contact
	{
		//"xmlns":"http://www.w3.org/2005/Atom"
		//"xmlns$batch":"http://schemas.google.com/gdata/batch"
		//"xmlns$gContact":"http://schemas.google.com/contact/2008"
		//"xmlns$gd":"http://schemas.google.com/g/2005"
		[JsonPropertyAttribute("id"                          )] public StringValue                    Id                        { get; set; }
		// 09/17/2015 Paul.  We are getting an empty object, not a boolean.  Just the existence of gd$deleted means it was deleted. 
		[JsonPropertyAttribute("gd$deleted"                  )] public object                         DeletedRaw                { get; set; }
		[JsonPropertyAttribute("updated"                     )] public StringValue                    UpdatedRaw                { get; set; }
		[JsonPropertyAttribute("category"                    )] public IList<CategoryValue>           Categories                { get; set; }
		[JsonPropertyAttribute("title"                       )] public TitleValue                     TitleRaw                  { get; set; }
		// 09/17/2015 Paul.  Must include v=3.0 query parameter to get StructuredName. 
		[JsonPropertyAttribute("gd$name"                     )] public StructuredName                 Name                      { get; set; }
		[JsonPropertyAttribute("content"                     )] public TitleValue                     NotesRaw                  { get; set; }
		[JsonPropertyAttribute("link"                        )] public IList<LinkValue>               Links                     { get; set; }
		[JsonPropertyAttribute("gd$organization"             )] public IList<OrganizationValue>       Organizations             { get; set; }
		[JsonPropertyAttribute("gd$email"                    )] public IList<EmailValue>              Emails                    { get; set; }
		[JsonPropertyAttribute("gd$phoneNumber"              )] public IList<PhoneNumberValue>        PhoneNumbers              { get; set; }
		//[JsonPropertyAttribute("gd$postalAddress"            )] public IList<PostalAddressValue>      PostalAddresses           { get; set; }
		// 09/17/2015 Paul.  Must include v=3.0 query parameter to get StructuredPostalAddress. 
		[JsonPropertyAttribute("gd$structuredPostalAddress"  )] public IList<StructuredPostalAddress> StructuredPostalAddresses { get; set; }
		[JsonPropertyAttribute("gContact$groupMembershipInfo")] public IList<GroupMembership>         GroupMemberships          { get; set; }
		[JsonPropertyAttribute("gContact$birthday"           )] public StringValue                    BirthdayRaw               { get; set; }

		[JsonIgnore]
		public string IdOnly
		{
			get
			{
				string sID = String.Empty;
				if ( !String.IsNullOrEmpty(this.Id.Value) )
				{
					string[] arrId = this.Id.Value.Split('/');
					sID = arrId[arrId.Length - 1];
				}
				return sID;
			}
		}

		[JsonIgnore]
		public Nullable<System.DateTime> Updated
		{
			get
			{
				return Utilities.GetDateTimeFromString( UpdatedRaw.Value );
			}
			set
			{
				UpdatedRaw.Value = Utilities.GetStringFromDateTime( value );
			}
		}

		[JsonIgnore]
		public Nullable<System.DateTime> Birthday
		{
			get
			{
				DateTime dt = DateTime.MinValue;
				if ( BirthdayRaw != null && !String.IsNullOrEmpty(BirthdayRaw.Value) )
				{
					DateTime.TryParseExact(BirthdayRaw.Value, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out dt);
				}
				return dt;
			}
			set
			{
				if ( value.HasValue && value.Value != DateTime.MinValue )
					BirthdayRaw.Value = value.Value.ToString("yyyy-MM-dd");
				else
					BirthdayRaw = null;
			}
		}

		[JsonIgnore]
		public bool Deleted
		{
			get
			{
				// 09/17/2015 Paul.  We are getting an empty object, not a boolean.  Just the existence of gd$deleted means it was deleted. 
				return (DeletedRaw != null);
			}
			set
			{
				if ( value )
					DeletedRaw = new object();
				else
					DeletedRaw = null;
			}
		}

		[JsonIgnore]
		public string Notes
		{
			get
			{
				return NotesRaw != null ? NotesRaw.Value : String.Empty;
			}
			set
			{
				NotesRaw = new TitleValue();
				NotesRaw.Value = value;
			}
		}

		[JsonIgnore]
		public string Title
		{
			get
			{
				return TitleRaw != null ? TitleRaw.Value : String.Empty;
			}
			set
			{
				TitleRaw = new TitleValue();
				TitleRaw.Value = value;
			}
		}

		public Contact()
		{
			this.Id                        = new StringValue                  ();
			this.UpdatedRaw                = new StringValue                  ();
			this.Categories                = new List<CategoryValue>          ();
			this.TitleRaw                  = new TitleValue                   ();
			this.Name                      = new StructuredName               ();
			this.NotesRaw                  = new TitleValue                   ();
			this.Links                     = new List<LinkValue>              ();
			this.Organizations             = new List<OrganizationValue>      ();
			this.Emails                    = new List<EmailValue>             ();
			this.PhoneNumbers              = new List<PhoneNumberValue>       ();
			//this.PostalAddresses           = new List<PostalAddressValue>     ();
			this.StructuredPostalAddresses = new List<StructuredPostalAddress>();
			this.GroupMemberships          = new List<GroupMembership>        ();
		}
	}
}

