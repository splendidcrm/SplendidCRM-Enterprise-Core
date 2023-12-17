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
using System.Net;
using System.Collections.Generic;
using System.Collections.Specialized;

using Spring.Json;
using Spring.Http;
using Spring.Rest.Client;
using Spring.Rest.Client.Support;
using Spring.Social.Etsy.Api.Impl.Json;

namespace Spring.Social.Etsy.Api.Impl
{
	class ProductTemplate : QBaseTemplate<Product>, IProductOperations
	{
		public ProductTemplate(RestTemplate restTemplate, string shop_id) : base(restTemplate, shop_id, "listings")
		{
		}

		public Product GetById(string id)
		{
			string sURL = this.moduleBase + "/" + id;
			return this.restTemplate.PostForObject<Product>(this.moduleBase, sURL);
		}

		public Product Insert(Product obj)
		{
			JsonMapper jsonMapper = new JsonMapper();
			jsonMapper.RegisterSerializer  (typeof(List<String>       ), new StringListSerializer         ());
			ProductSerializer serializer = new ProductSerializer();
			JsonValue json = serializer.Serialize(obj, jsonMapper);
			// https://shopify.dev/api/examples/customer
			string sGraph = @"
			{
				mutation
				{
					productCreate(input: " + json.ToString() + @")
					{
						id
						createdAt
						updatedAt
					}
				}
			}";
			return this.restTemplate.PostForObject<Product>(this.moduleBase, sGraph);
		}

		public Product Update(Product obj)
		{
			if ( obj.id == null )
				throw(new Exception("id must not be null during update operation."));
			JsonMapper jsonMapper = new JsonMapper();
			jsonMapper.RegisterSerializer  (typeof(List<String>       ), new StringListSerializer         ());
			ProductSerializer serializer = new ProductSerializer();
			JsonValue json = serializer.Serialize(obj, jsonMapper);
			// https://shopify.dev/api/examples/customer
			string sGraph = @"
			{
				mutation
				{
					productUpdate(input: " + json.ToString() + @")
					{
						product
						{
							id
							createdAt
							updatedAt
						}
					}
				}
			}";
			return this.restTemplate.PostForObject<Product>(this.moduleBase, sGraph);
		}

		public void Delete(string id)
		{
			// https://shopify.dev/api/examples/customer
			string sGraph = @"
			{
				mutation
				{
					productDelete(input: {id: " + id + @"})
					{
						deletedProductId
					}
				}
			}";
			this.restTemplate.PostForObject<Product>(this.moduleBase, sGraph);
		}
	}
}