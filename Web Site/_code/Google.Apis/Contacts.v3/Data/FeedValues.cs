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
using Newtonsoft.Json;

namespace Google.Apis.Contacts.v3.Data
{
	public class StringValue
	{
		[JsonPropertyAttribute("$t"                  )] public string         Value               { get; set; }
	}

	public class CategoryValue
	{
		[JsonPropertyAttribute("scheme"              )] public string         Scheme              { get; set; }
		[JsonPropertyAttribute("term"                )] public string         Term                { get; set; }
	}

	public class TitleValue
	{
		[JsonPropertyAttribute("type"                )] public string         Type                { get; set; }
		[JsonPropertyAttribute("$t"                  )] public string         Value               { get; set; }
	}

	// https://developers.google.com/gdata/docs/2.0/elements#gdName
	public class StructuredName
	{
		[JsonPropertyAttribute("gd$givenName"        )] public StringValue    FirstNameRaw        { get; set; }
		[JsonPropertyAttribute("gd$additionalName"   )] public StringValue    MiddleNameRaw       { get; set; }
		[JsonPropertyAttribute("gd$familyName"       )] public StringValue    LastNameRaw         { get; set; }
		[JsonPropertyAttribute("gd$namePrefix"       )] public StringValue    SalutationRaw       { get; set; }
		[JsonPropertyAttribute("gd$nameSuffix"       )] public StringValue    SuffixRaw           { get; set; }
		[JsonPropertyAttribute("gd$fullName"         )] public StringValue    FullNameRaw         { get; set; }

		[JsonIgnore]
		public string FirstName
		{
			get
			{
				return FirstNameRaw != null ? FirstNameRaw.Value : String.Empty;
			}
			set
			{
				FirstNameRaw = new StringValue();
				FirstNameRaw.Value = value;
			}
		}

		[JsonIgnore]
		public string LastName
		{
			get
			{
				return LastNameRaw != null ? LastNameRaw.Value : String.Empty;
			}
			set
			{
				LastNameRaw = new StringValue();
				LastNameRaw.Value = value;
			}
		}

		[JsonIgnore]
		public string Salutation
		{
			get
			{
				return SalutationRaw != null ? SalutationRaw.Value : String.Empty;
			}
			set
			{
				SalutationRaw = new StringValue();
				SalutationRaw.Value = value;
			}
		}

		[JsonIgnore]
		public string FullName
		{
			get
			{
				return FullNameRaw != null ? FullNameRaw.Value : String.Empty;
			}
			set
			{
				FullNameRaw = new StringValue();
				FullNameRaw.Value = value;
			}
		}
	}

	public class LinkValue
	{
		[JsonPropertyAttribute("rel"                 )] public string         Rel                 { get; set; }
		[JsonPropertyAttribute("type"                )] public string         Type                { get; set; }
		[JsonPropertyAttribute("href"                )] public string         Href                { get; set; }
	}

	public class AuthorValue
	{
		[JsonPropertyAttribute("name"                )] public StringValue    Name                { get; set; }
		[JsonPropertyAttribute("email"               )] public StringValue    Value               { get; set; }
	}

	public class GeneratorValue
	{
		[JsonPropertyAttribute("version"             )] public string         Name                { get; set; }
		[JsonPropertyAttribute("uri"                 )] public string         Uri                 { get; set; }
		[JsonPropertyAttribute("$t"                  )] public string         Value               { get; set; }
	}

	// https://developers.google.com/gdata/docs/2.0/elements#gdEmail
	public class EmailValue
	{
		[JsonPropertyAttribute("address"             )] public string         Address             { get; set; }
		[JsonPropertyAttribute("primary"             )] public Nullable<bool> Primary             { get; set; }
		[JsonPropertyAttribute("rel"                 )] public string         Rel                 { get; set; }
	}

	// https://developers.google.com/gdata/docs/2.0/elements#gdPhoneNumber
	public class PhoneNumberValue
	{
		[JsonPropertyAttribute("rel"                 )] public string         Rel                 { get; set; }
		[JsonPropertyAttribute("url"                 )] public string         Uri                 { get; set; }
		[JsonPropertyAttribute("$t"                  )] public string         Value               { get; set; }
		[JsonPropertyAttribute("primary"             )] public Nullable<bool> Primary             { get; set; }
	}

	// https://developers.google.com/gdata/docs/2.0/elements#gdOrganization
	public class OrganizationValue
	{
		[JsonPropertyAttribute("rel"                 )] public string         Rel                  { get; set; }
		[JsonPropertyAttribute("gd$orgName"          )] public StringValue    NameRaw              { get; set; }
		[JsonPropertyAttribute("gd$orgTitle"         )] public StringValue    TitleRaw             { get; set; }
		[JsonPropertyAttribute("gd$orgJobDescription")] public StringValue    JobDescriptionRaw    { get; set; }
		[JsonPropertyAttribute("gd$orgDepartment"    )] public StringValue    DepartmentRaw        { get; set; }
		[JsonPropertyAttribute("primary"             )] public Nullable<bool> Primary              { get; set; }

		[JsonIgnore]
		public string Name
		{
			get
			{
				return NameRaw != null ? NameRaw.Value : String.Empty;
			}
			set
			{
				NameRaw = new StringValue();
				NameRaw.Value = value;
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
				TitleRaw = new StringValue();
				TitleRaw.Value = value;
			}
		}

		[JsonIgnore]
		public string JobDescription
		{
			get
			{
				return JobDescriptionRaw != null ? JobDescriptionRaw.Value : String.Empty;
			}
			set
			{
				JobDescriptionRaw = new StringValue();
				JobDescriptionRaw.Value = value;
			}
		}

		[JsonIgnore]
		public string Department
		{
			get
			{
				return DepartmentRaw != null ? DepartmentRaw.Value : String.Empty;
			}
			set
			{
				DepartmentRaw = new StringValue();
				DepartmentRaw.Value = value;
			}
		}
	}

	// https://developers.google.com/gdata/docs/2.0/elements#gdPostalAddress
	public class PostalAddressValue
	{
		[JsonPropertyAttribute("rel"                 )] public string         Rel                 { get; set; }
		[JsonPropertyAttribute("$t"                  )] public string         Value               { get; set; }
		[JsonPropertyAttribute("primary"             )] public Nullable<bool> Primary             { get; set; }
	}

	// https://developers.google.com/gdata/docs/2.0/elements?csw=1#gdStructuredPostalAddress
	public class StructuredPostalAddress
	{
		[JsonPropertyAttribute("rel"                 )] public string         Rel                 { get; set; }
		//[JsonPropertyAttribute("primary"             )] public Nullable<bool> Primary             { get; set; }
		[JsonPropertyAttribute("gd$agent"            )] public StringValue    AgentRaw            { get; set; }
		[JsonPropertyAttribute("gd$housename"        )] public StringValue    HouseNameRaw        { get; set; }
		[JsonPropertyAttribute("gd$street"           )] public StringValue    StreetRaw           { get; set; }
		[JsonPropertyAttribute("gd$pobox"            )] public StringValue    POBoxRaw            { get; set; }
		[JsonPropertyAttribute("gd$neighborhood"     )] public StringValue    NeighborhoodRaw     { get; set; }
		[JsonPropertyAttribute("gd$city"             )] public StringValue    CityRaw             { get; set; }
		[JsonPropertyAttribute("gd$subregion"        )] public StringValue    CountyRaw           { get; set; }
		[JsonPropertyAttribute("gd$region"           )] public StringValue    StateRaw            { get; set; }
		[JsonPropertyAttribute("gd$postcode"         )] public StringValue    PostalCodeRaw       { get; set; }
		[JsonPropertyAttribute("gd$country"          )] public StringValue    CountryRaw          { get; set; }
		[JsonPropertyAttribute("gd$formattedAddress" )] public StringValue    FormattedAddressRaw { get; set; }

		[JsonIgnore]
		public string Street
		{
			get
			{
				return StreetRaw != null ? StreetRaw.Value : String.Empty;
			}
			set
			{
				StreetRaw = new StringValue();
				StreetRaw.Value = value;
			}
		}

		[JsonIgnore]
		public string POBox
		{
			get
			{
				return POBoxRaw != null ? POBoxRaw.Value : String.Empty;
			}
			set
			{
				POBoxRaw = new StringValue();
				POBoxRaw.Value = value;
			}
		}

		[JsonIgnore]
		public string City
		{
			get
			{
				return CityRaw != null ? CityRaw.Value : String.Empty;
			}
			set
			{
				CityRaw = new StringValue();
				CityRaw.Value = value;
			}
		}

		[JsonIgnore]
		public string State
		{
			get
			{
				return StateRaw != null ? StateRaw.Value : String.Empty;
			}
			set
			{
				StateRaw = new StringValue();
				StateRaw.Value = value;
			}
		}

		[JsonIgnore]
		public string PostalCode
		{
			get
			{
				return PostalCodeRaw != null ? PostalCodeRaw.Value : String.Empty;
			}
			set
			{
				PostalCodeRaw = new StringValue();
				PostalCodeRaw.Value = value;
			}
		}

		[JsonIgnore]
		public string Country
		{
			get
			{
				return CountryRaw != null ? CountryRaw.Value : String.Empty;
			}
			set
			{
				CountryRaw = new StringValue();
				CountryRaw.Value = value;
			}
		}

		[JsonIgnore]
		public string FormattedAddress
		{
			get
			{
				return FormattedAddressRaw != null ? FormattedAddressRaw.Value : String.Empty;
			}
			set
			{
				FormattedAddressRaw = new StringValue();
				FormattedAddressRaw.Value = value;
			}
		}

	}

	public class GroupMembership
	{
		[JsonPropertyAttribute("deleted"             )] public Nullable<bool> Deleted             { get; set; }
		[JsonPropertyAttribute("href"                )] public string         Href                { get; set; }
	}
}

