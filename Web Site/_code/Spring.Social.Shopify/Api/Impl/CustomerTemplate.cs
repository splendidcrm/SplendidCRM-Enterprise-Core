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
using System.Collections.Specialized;
using Spring.Http;
using Spring.Rest.Client;

namespace Spring.Social.Shopify.Api.Impl
{
	class CustomerTemplate : QBaseTemplate<Customer>, ICustomerOperations
	{
		public CustomerTemplate(RestTemplate restTemplate) : base(restTemplate, "customer")
		{
		}

		protected override string BuildGraph(int max, string cursor, string query)
		{
			// 03/09/2022 Paul.  Having a rate limit issue, so remove description and tags. 
			// https://shopify.dev/concepts/about-apis/rate-limits
			string sGraph = @"
			{
				customers (first: " + this.maxResults.ToString() + (!Sql.IsEmptyString(cursor) ? ", after: " + cursor : String.Empty) + (!Sql.IsEmptyString(query) ? ", query: \"" + query + "\"": String.Empty) + @")
				{
					edges
					{
						node
						{
							id
							createdAt
							updatedAt
							firstName
							lastName
							displayName
							email
							phone
							locale
							note
							taxExempt
							validEmailAddress 
							verifiedEmail
							state
							tags
							defaultAddress
							{
								id
								firstName
								lastName
								phone
								company
								address1
								address2
								city
								province
								provinceCode
								country
								countryCode
								zip
								latitude
								longitude
							}
							addresses
							{
								id
								firstName
								lastName
								phone
								company
								address1
								address2
								city
								province
								provinceCode
								country
								countryCode
								zip
								latitude
								longitude
							}
						}
						cursor
					}
					pageInfo
					{
						hasNextPage
					}
				}
			}";
			return sGraph;
		}

		protected override string BuildGraph(string id)
		{
			// 03/09/2022 Paul.  Having a rate limit issue, so remove description and tags. 
			// https://shopify.dev/concepts/about-apis/rate-limits
			string sGraph = @"
			{
				customers (id: " + id + @")
				{
					id
					createdAt
					updatedAt
					firstName
					lastName
					displayName
					email
					phone
					locale
					note
					taxExempt
					validEmailAddress 
					verifiedEmail
					state
					image
					{
						id
						url
						altText
						width
						height
					}
					tags
					defaultAddress
					{
						id
						firstName
						lastName
						phone
						company
						address1
						address2
						city
						province
						provinceCode
						country
						countryCode
						zip
						latitude
						longitude
					}
					addresses
					{
						id
						firstName
						lastName
						phone
						company
						address1
						address2
						city
						province
						provinceCode
						country
						countryCode
						zip
						latitude
						longitude
					}
					orders
					{
						edges
						{
							node
							{
								id
								createdAt
								updatedAt
							}
						}
					}
				}
			}";
			return sGraph;
		}

		public Customer GetById(string id)
		{
			// https://qb.sbfinance.intuit.com/v3/company/{companyId}/customer/{id}
			return this.restTemplate.GetForObject<Customer>("company/{companyId}/" + this.tableName + "/{id}", companyId, id);
		}

		public Customer Insert(Customer obj)
		{
			string sURL = "company/" + companyId + "/" + this.tableName;
			return this.restTemplate.PostForObject<Customer>(sURL, obj);
		}

		public Customer Update(Customer obj)
		{
			string sURL = "company/" + companyId + "/" + this.tableName + "?operation=update";
			return this.restTemplate.PostForObject<Customer>(sURL, obj);
		}

		public Customer Delete(string id)
		{
			string sURL = "company/" + companyId + "/" + this.tableName + "?operation=update";
			NameValueCollection data = new NameValueCollection();
			data.Add("Id"    , id     );
			data.Add("Active", "false");
			return this.restTemplate.PostForObject<Customer>(sURL, data);
		}
	}
}
