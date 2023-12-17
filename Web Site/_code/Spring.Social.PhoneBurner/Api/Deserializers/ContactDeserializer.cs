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

namespace Spring.Social.PhoneBurner.Api.Impl.Json
{
	class ContactDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Contact obj = new Contact();
			obj.RawContent = json.ToString();
			//Debug.WriteLine("Spring.Social.PhoneBurner.Api.Impl.Json.ContactDeserializer.Deserialize " + obj.RawContent);
			
			try
			{
				// 08/24/2020 Paul.  GetById() will return the single contact as part of a paginated arr
				JsonValue contacts  = json.GetValue("contacts");
				if ( contacts != null && !contacts.IsNull )
				{
					contacts  = contacts.GetValue("contacts");
					if ( contacts != null && contacts.IsArray )
					{
						foreach ( JsonValue itemValue in contacts.GetValues() )
						{
							json = itemValue;
							break;
						}
					}
				}

				//System.Globalization.DateTimeFormatInfo dateInfo = System.Threading.Thread.CurrentThread.CurrentCulture.DateTimeFormat;
				//obj.date_added = DateTime.ParseExact(json.GetValueOrDefault<String>("date_added"), "yyyy-MM-dd HH:mm:ss", dateInfo);
				//obj.id                       = json.GetValueOrDefault<String>  ("unique_id"               );
				obj.id                       = json.GetValueOrDefault<String>  ("contact_user_id"         );
				obj.date_added               = json.GetValueOrDefault<DateTime>("date_added"              );
				obj.date_modified            = json.GetValueOrDefault<DateTime>("date_modified"           );
				obj.trashed                  = json.GetValueOrDefault<String>  ("trashed"                 );
				obj.owner_id                 = json.GetValueOrDefault<int>     ("owner_id"                );
				obj.owner_username           = json.GetValueOrDefault<String>  ("owner_username"          );
				obj.email                    = json.GetValueOrDefault<String>  ("email"                   );
				obj.first_name               = json.GetValueOrDefault<String>  ("first_name"              );
				obj.last_name                = json.GetValueOrDefault<String>  ("last_name"               );
				obj.phone                    = json.GetValueOrDefault<String>  ("phone"                   );
				obj.phone_type               = json.GetValueOrDefault<int>     ("phone_type"              );
				obj.phone_label              = json.GetValueOrDefault<String>  ("phone_label"             );
				obj.address1                 = json.GetValueOrDefault<String>  ("address1"                );
				obj.address2                 = json.GetValueOrDefault<String>  ("address2"                );
				obj.city                     = json.GetValueOrDefault<String>  ("city"                    );
				obj.state                    = json.GetValueOrDefault<String>  ("state"                   );
				obj.state_other              = json.GetValueOrDefault<String>  ("state_other"             );
				obj.zip                      = json.GetValueOrDefault<String>  ("zip"                     );
				obj.country                  = json.GetValueOrDefault<String>  ("country"                 );
				obj.ad_code                  = json.GetValueOrDefault<String>  ("ad_code"                 );
				obj.viewed                   = json.GetValueOrDefault<String>  ("viewed"                  );
				obj.category_id              = json.GetValueOrDefault<String>  ("category_id"             );
				obj.token                    = json.GetValueOrDefault<String>  ("token"                   );
				obj.return_lead_token        = json.GetValueOrDefault<String>  ("return_lead_token"       );
				obj.lead_id                  = json.GetValueOrDefault<String>  ("lead_id"                 );
				obj.order_number             = json.GetValueOrDefault<String>  ("order_number"            );
				obj.lead_vendor_product_name = json.GetValueOrDefault<String>  ("lead_vendor_product_name");
				obj.allow_duplicates         = json.GetValueOrDefault<String>  ("allow_duplicates"        );
				obj.rating                   = json.GetValueOrDefault<String>  ("rating"                  );
				obj.total_calls              = json.GetValueOrDefault<int>     ("total_calls"             );
				obj.source_code              = json.GetValueOrDefault<String>  ("source_code"             );
				obj.language                 = json.GetValueOrDefault<String>  ("language"                );
				obj.region                   = json.GetValueOrDefault<String>  ("region"                  );
				obj.time_zone                = json.GetValueOrDefault<String>  ("time_zone"               );
				obj.location_name            = json.GetValueOrDefault<String>  ("location_name"           );
				obj.latitude                 = json.GetValueOrDefault<String>  ("latitude"                );
				obj.longitude                = json.GetValueOrDefault<String>  ("longitude"               );
				obj.do_not_call              = json.GetValueOrDefault<String>  ("do_not_call"             );

				JsonValue additional_name  = json.GetValue("additional_name"         );
				JsonValue additional_phone = json.GetValue("additional_phone"        );
				JsonValue tags             = json.GetValue("tags"                    );
				JsonValue q_and_a          = json.GetValue("q_and_a"                 );
				JsonValue custom_fields    = json.GetValue("custom_fields"           );
				JsonValue social_accounts  = json.GetValue("social_accounts"         );
				JsonValue phones           = json.GetValue("phones"                  );
				JsonValue emails           = json.GetValue("emails"                  );
				JsonValue addresses        = json.GetValue("addresses"               );
				JsonValue primary_email    = json.GetValue("primary_email"           );
				JsonValue primary_phone    = json.GetValue("primary_phone"           );
				JsonValue primary_address  = json.GetValue("primary_address"         );
				JsonValue notes            = json.GetValue("notes"                   );
				JsonValue category         = json.GetValue("category"                );
				JsonValue stats            = json.GetValue("contact"                 );
				JsonValue last_login       = json.GetValue("last_login"              );
				JsonValue last_call_time   = json.GetValue("last_call_time"          );
				if ( additional_name  != null && !additional_name .IsNull && additional_name .IsArray ) obj.additional_name  = mapper.Deserialize<IList<AdditionalName   >>(additional_name );
				if ( additional_phone != null && !additional_phone.IsNull && additional_phone.IsArray ) obj.additional_phone = mapper.Deserialize<IList<AdditionalPhone  >>(additional_phone);
				if ( tags             != null && !tags            .IsNull && tags            .IsArray )
				{
					obj.tags = new List<String>();
					foreach ( JsonValue itemValue in tags.GetValues() )
					{
						obj.tags.Add(itemValue.GetValue<String>());
					}
				}
				if ( q_and_a          != null && !q_and_a        .IsNull && q_and_a         .IsArray  ) obj.q_and_a          = mapper.Deserialize<IList<QuestionAndAnswer>>(q_and_a         );
				if ( custom_fields    != null && !custom_fields  .IsNull && custom_fields   .IsArray  ) obj.custom_fields    = mapper.Deserialize<IList<CustomField      >>(custom_fields   );
				if ( social_accounts  != null && !social_accounts.IsNull && social_accounts .IsArray  ) obj.social_accounts  = mapper.Deserialize<IList<SocialAccount    >>(social_accounts );
				if ( phones           != null && !phones         .IsNull && phones          .IsArray  ) obj.phones           = mapper.Deserialize<IList<Phone            >>(phones          );
				if ( emails           != null && !emails         .IsNull && emails          .IsArray  )
				{
					// 09/03/2020 Paul.  Emails can be an array of objects or strings. 
					//obj.emails = mapper.Deserialize<IList<Email>>(emails);
					foreach ( JsonValue itemValue in tags.GetValues() )
					{
						obj.emails = new List<Email>();
						if ( itemValue.IsObject )
						{
							Email email = mapper.Deserialize<Email>(itemValue);
						}
						else if ( itemValue.IsString )
						{
							Email email = new Email();
							email.email_address = itemValue.GetValue<String>();
							obj.emails.Add(email);
						}
					}
				}
				if ( addresses        != null && !addresses      .IsNull && addresses       .IsArray  ) obj.addresses        = mapper.Deserialize<IList<Address          >>(addresses       );
				if ( primary_email    != null && !primary_email  .IsNull && primary_email   .IsObject ) obj.primary_email    = mapper.Deserialize<PrimaryEmail            >(primary_email   );
				if ( primary_phone    != null && !primary_phone  .IsNull && primary_phone   .IsObject ) obj.primary_phone    = mapper.Deserialize<PrimaryPhone            >(primary_phone   );
				if ( primary_address  != null && !primary_address.IsNull && primary_address .IsObject ) obj.primary_address  = mapper.Deserialize<PrimaryAddress          >(primary_address );
				if ( notes            != null && !notes          .IsNull && notes           .IsObject ) obj.notes            = mapper.Deserialize<Note                    >(notes           );
				if ( category         != null && !category       .IsNull && category        .IsObject ) obj.category         = mapper.Deserialize<Category                >(category        );
				if ( stats            != null && !stats          .IsNull && stats           .IsObject ) obj.stats            = mapper.Deserialize<ContactStats            >(stats           );

				// 09/03/2020 Paul.  During CallDone, notes is a string. 
				if ( notes != null && !notes.IsNull && notes.IsString )
				{
					obj.notes = new Note();
					obj.notes.notes = notes.GetValue<string>();
				}
				// 09/03/2020 Paul.  During CallBegin, primary_email is a string. 
				if ( primary_email != null && !primary_email.IsNull && primary_email.IsString )
				{
					obj.primary_email = new PrimaryEmail();
					obj.primary_email.email_address = primary_email.GetValue<string>();
				}
				if ( obj.primary_email != null )
				{
					obj.email = obj.primary_email.email_address;
				}
				if ( obj.primary_phone != null )
				{
					obj.phone = obj.primary_phone.phone;
				}
				if ( obj.primary_address != null )
				{
					obj.address1 = obj.primary_address.address  ;
					obj.address2 = obj.primary_address.address_2;
					obj.city     = obj.primary_address.city     ;
					obj.state    = obj.primary_address.state    ;
					obj.zip      = obj.primary_address.zip      ;
					obj.country  = obj.primary_address.country  ;
				}
				if ( obj.category != null )
				{
					obj.category_id = obj.category.category_id;
				}
				if ( obj.stats != null )
				{
					obj.category_id = obj.stats.original_category_id;
					obj.trashed     = obj.stats.trashed             ;
					obj.viewed      = obj.stats.viewed              ;
					obj.rating      = obj.stats.rating              ;
				}
				if ( last_login != null && last_login.IsString )
				{
					string sLastLogin = last_login.GetValue<String>();
					if ( !Sql.IsEmptyString(sLastLogin) && sLastLogin != "0000-00-00 00:00:00" )
					{
						obj.last_login = json.GetValueOrDefault<DateTime>("last_login");
					}
				}
				if ( last_call_time != null && last_call_time.IsString )
				{
					string sLastCallTime = last_call_time.GetValue<String>();
					if ( !Sql.IsEmptyString(sLastCallTime) && sLastCallTime != "0000-00-00 00:00:00" )
					{
						obj.last_call_time = json.GetValueOrDefault<DateTime>("last_call_time");
					}
				}
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
			IList<Contact> items = new List<Contact>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("contacts");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					items.Add( mapper.Deserialize<Contact>(itemValue) );
				}
			}
			return items;
		}
	}

	class ContactPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ContactPagination pag = new ContactPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null && !json.IsNull )
			{
				//Debug.WriteLine("Spring.Social.PhoneBurner.Api.Impl.Json.ContactPaginationDeserializer.Deserialize " + json.ToString());
				JsonValue contacts  = json.GetValue("contacts");
				if ( contacts != null && !contacts.IsNull )
				{
					pag.total_results = contacts.GetValueOrDefault<int>("total_results");
					pag.total_pages   = contacts.GetValueOrDefault<int>("total_pages"  );
					pag.page          = contacts.GetValueOrDefault<int>("page"         );
					pag.items = mapper.Deserialize<IList<Contact>>(contacts);
				}
			}
			return pag;
		}
	}
}
