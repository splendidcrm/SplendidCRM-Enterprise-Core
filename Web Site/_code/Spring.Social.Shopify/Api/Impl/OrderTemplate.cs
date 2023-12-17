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
	class OrderTemplate : QBaseTemplate<Order>, IOrderOperations
	{
		public OrderTemplate(RestTemplate restTemplate) : base(restTemplate, "order")
		{
		}

		protected override string BuildGraph(int max, string cursor, string query)
		{
			// 03/09/2022 Paul.  Having a rate limit issue, so remove description and tags. 
			// https://shopify.dev/concepts/about-apis/rate-limits
			string sGraph = @"
			{
				orders (first: " + this.maxResults.ToString() + (!Sql.IsEmptyString(cursor) ? ", after: " + cursor : String.Empty) + (!Sql.IsEmptyString(query) ? ", query: \"" + query + "\"": String.Empty) + @")
				{
					edges
					{
						node
						{
							id
							createdAt
							updatedAt
							cancelledAt
							closedAt
							processedAt
							closed
							confirmed
							fullyPaid
							unpaid
							currencyCode
							currentSubtotalLineItemsQuantity
							taxesIncluded
							currentTotalPriceSet
							{
								shopMoney
								{
									amount
									currencyCode
								}
							}
							currentTotalWeight
							customer
							{
								id
								firstName
								lastName
								displayName
								email
								phone
							}
							customerLocale
							discountCode
							email
							phone
							note
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
				order (id: " + id + @")
				{
					id
					createdAt
					updatedAt
					cancelledAt
					closedAt
					processedAt
					closed
					confirmed
					fullyPaid
					unpaid
					currencyCode
					currentCartDiscountAmountSet
					{
						shopMoney
						{
							amount
							currencyCode
						}
					}
					currentSubtotalLineItemsQuantity
					currentSubtotalPriceSet
					{
						shopMoney
						{
							amount
							currencyCode
						}
					}
					taxesIncluded
					currentTotalDiscountsSet
					{
						shopMoney
						{
							amount
							currencyCode
						}
					}
					currentTotalDutiesSet
					{
						shopMoney
						{
							amount
							currencyCode
						}
					}
					currentTotalPriceSet
					{
						shopMoney
						{
							amount
							currencyCode
						}
					}
					currentTotalTaxSet
					{
						shopMoney
						{
							amount
							currencyCode
						}
					}
					currentTotalWeight
					customer
					{
						id
						firstName
						lastName
						displayName
						email
						phone
					}
					customerLocale
					discountCode
					email
					phone
					note
					billingAddress
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
					shippingAddress
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
					shippingLines
					{
						edges
						{
							node
							{
								id
								title
								carrierIdentifier
								code
								deliveryCategory
								originalPriceSet
								{
									shopMoney
									{
										amount
										currencyCode
									}
								}
							}
						}
					}
					lineItems
					{
						edges
						{
							node
							{
								id
								sku
								name
								title
								vendor
								currentQuantity
								quantity
								requiresShipping
								taxable
								originalTotalSet
								{
									shopMoney
									{
										amount
										currencyCode
									}
								}
								originalUnitPriceSet
								{
									shopMoney
									{
										amount
										currencyCode
									}
								}
								product
								{
									id
									title
								}
							}
						}
					}
				}
			}";
			return sGraph;
		}

		public Order GetById(string id)
		{
			return this.restTemplate.GetForObject<Order>("company/{companyId}/" + this.tableName + "/{id}", companyId, id);
		}

		public Order Insert(Order obj)
		{
			string sURL = "company/" + companyId + "/" + this.tableName;
			return this.restTemplate.PostForObject<Order>(sURL, obj);
		}

		public Order Update(Order obj)
		{
			string sURL = "company/" + companyId + "/" + this.tableName + "?operation=update";
			return this.restTemplate.PostForObject<Order>(sURL, obj);
		}

		public Order Delete(string id)
		{
			string sURL = "company/" + companyId + "/" + this.tableName + "?operation=delete";
			Order obj = GetById(id);
			// 02/13/2015 Paul.  In order to delete, we must send the entire object, not just the Id and SyncToken. 
			//NameValueCollection data = new NameValueCollection();
			//data.Add("Id"       , id           );
			//data.Add("SyncToken", obj.SyncToken);
			return this.restTemplate.PostForObject<Order>(sURL, obj);
		}
	}
}
