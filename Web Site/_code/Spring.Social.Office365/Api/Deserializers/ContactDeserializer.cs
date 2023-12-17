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
	class ContactDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Contact obj = new Contact();
			obj.RawContent = json.ToString();
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.ContactDeserializer.Deserialize " + obj.RawContent);
			
			try
			{
				// Entity
				obj.Id                           = json.GetValueOrDefault<String>   ("id"                        );
				// 01/12/2021 Paul.  Record is deleted if @removed is provided. 
				obj.Deleted                      = json.ContainsName("@removed");
				JsonValue AdditionalData         = json.GetValue                    ("additionalData"            );
				if ( AdditionalData != null && !AdditionalData.IsNull && AdditionalData.IsObject )
					obj.AdditionalData = mapper.Deserialize<AdditionalData>(AdditionalData);
				
				// OutlookItem
				obj.CreatedDateTime              = json.GetValueOrDefault<DateTime?>("createdDateTime"           );
				obj.LastModifiedDateTime         = json.GetValueOrDefault<DateTime?>("lastModifiedDateTime"      );
				obj.ChangeKey                    = json.GetValueOrDefault<String>   ("changeKey"                 );
				JsonValue Categories             = json.GetValue                    ("categories"                );
				if ( Categories != null && !Categories.IsNull && Categories.IsArray )
					obj.Categories  = mapper.Deserialize<IList<String>>(Categories );
				
				// Contact
				obj.AssistantName                = json.GetValueOrDefault<String>   ("assistantName"   );
				obj.Birthday                     = json.GetValueOrDefault<DateTime?>("birthday"        );
				obj.BusinessHomePage             = json.GetValueOrDefault<String>   ("businessHomePage");
				obj.CompanyName                  = json.GetValueOrDefault<String>   ("companyName"     );
				obj.Department                   = json.GetValueOrDefault<String>   ("department"      );
				obj.DisplayName                  = json.GetValueOrDefault<String>   ("displayName"     );
				obj.FileAs                       = json.GetValueOrDefault<String>   ("fileAs"          );
				obj.Generation                   = json.GetValueOrDefault<String>   ("generation"      );
				obj.GivenName                    = json.GetValueOrDefault<String>   ("givenName"       );
				obj.Initials                     = json.GetValueOrDefault<String>   ("initials"        );
				obj.JobTitle                     = json.GetValueOrDefault<String>   ("jobTitle"        );
				obj.Manager                      = json.GetValueOrDefault<String>   ("manager"         );
				obj.MiddleName                   = json.GetValueOrDefault<String>   ("middleName"      );
				obj.MobilePhone                  = json.GetValueOrDefault<String>   ("mobilePhone"     );
				obj.NickName                     = json.GetValueOrDefault<String>   ("nickName"        );
				obj.OfficeLocation               = json.GetValueOrDefault<String>   ("officeLocation"  );
				obj.ParentFolderId               = json.GetValueOrDefault<String>   ("parentFolderId"  );
				obj.PersonalNotes                = json.GetValueOrDefault<String>   ("personalNotes"   );
				obj.Profession                   = json.GetValueOrDefault<String>   ("profession"      );
				obj.SpouseName                   = json.GetValueOrDefault<String>   ("spouseName"      );
				obj.Surname                      = json.GetValueOrDefault<String>   ("surname"         );
				obj.Title                        = json.GetValueOrDefault<String>   ("title"           );
				obj.YomiCompanyName              = json.GetValueOrDefault<String>   ("yomiCompanyName" );
				obj.YomiGivenName                = json.GetValueOrDefault<String>   ("yomiGivenName"   );
				obj.YomiSurname                  = json.GetValueOrDefault<String>   ("yomiSurname"     );

				JsonValue BusinessAddress        = json.GetValue                    ("businessAddress" );
				JsonValue HomeAddress            = json.GetValue                    ("homeAddress"     );
				JsonValue OtherAddress           = json.GetValue                    ("otherAddress"    );
				JsonValue Photo                  = json.GetValue                    ("photo"           );
				if ( BusinessAddress != null && !BusinessAddress.IsNull && BusinessAddress.IsObject ) obj.BusinessAddress = mapper.Deserialize<PhysicalAddress    >(BusinessAddress);
				if ( HomeAddress     != null && !HomeAddress    .IsNull && HomeAddress    .IsObject ) obj.HomeAddress     = mapper.Deserialize<PhysicalAddress    >(HomeAddress    );
				if ( OtherAddress    != null && !OtherAddress   .IsNull && OtherAddress   .IsObject ) obj.OtherAddress    = mapper.Deserialize<PhysicalAddress    >(OtherAddress   );
				if ( Photo           != null && !Photo          .IsNull && Photo          .IsObject ) obj.Photo           = mapper.Deserialize<ProfilePhoto       >(Photo          );

				JsonValue BusinessPhones         = json.GetValue                    ("businessPhones"  );
				JsonValue Children               = json.GetValue                    ("children"        );
				JsonValue HomePhones             = json.GetValue                    ("homePhones"      );
				JsonValue ImAddresses            = json.GetValue                    ("imAddresses"     );
				JsonValue EmailAddresses         = json.GetValue                    ("emailAddresses"  );
				if ( BusinessPhones  != null && !BusinessPhones .IsNull && BusinessPhones .IsArray ) obj.BusinessPhones  = mapper.Deserialize<IList<String       >>(BusinessPhones );
				if ( Children        != null && !Children       .IsNull && Children       .IsArray ) obj.Children        = mapper.Deserialize<IList<String       >>(Children       );
				if ( HomePhones      != null && !HomePhones     .IsNull && HomePhones     .IsArray ) obj.HomePhones      = mapper.Deserialize<IList<String       >>(HomePhones     );
				if ( ImAddresses     != null && !ImAddresses    .IsNull && ImAddresses    .IsArray ) obj.ImAddresses     = mapper.Deserialize<IList<String       >>(ImAddresses    );
				if ( EmailAddresses  != null && !EmailAddresses .IsNull && EmailAddresses .IsArray ) obj.EmailAddresses  = mapper.Deserialize<IList<EmailAddress >>(EmailAddresses );
			}
			catch(Exception ex)
			{
				System.Diagnostics.Debug.WriteLine(ex.Message);
				System.Diagnostics.Debug.WriteLine(ex.StackTrace);
				throw;
			}
			return obj;
		}
	}

	class ContactListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Contact> contacts = new List<Contact>();
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					contacts.Add( mapper.Deserialize<Contact>(itemValue) );
				}
			}
			return contacts;
		}
	}

	class ContactPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ContactPagination pag = new ContactPagination();
			//JsonUtils.FaultCheck(json);
			if ( json != null && !json.IsNull )
			{
				pag.count     = json.GetValueOrDefault<int   >("@odata.count"    );
				pag.nextLink  = json.GetValueOrDefault<String>("@odata.nextLink" );
				pag.deltaLink = json.GetValueOrDefault<String>("@odata.deltaLink");
				//Debug.WriteLine("Spring.Social.Office365.Api.Impl.Json.ContactPaginationDeserializer.Deserialize " + json.ToString());
				JsonValue contacts  = json.GetValue("value");
				if ( contacts != null && !contacts.IsNull )
				{
					pag.contacts = mapper.Deserialize<IList<Contact>>(contacts);
				}
			}
			return pag;
		}
	}
}
