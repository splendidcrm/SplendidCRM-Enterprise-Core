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

namespace Spring.Social.Etsy.Api.Impl
{
	class OrderTemplate : QBaseTemplate<Order>, IOrderOperations
	{
		// 03/24/2022 Paul.  Receipts are for sellers, orders are for buyers. 
		public OrderTemplate(RestTemplate restTemplate, string shop_id) : base(restTemplate, shop_id, "receipts")
		{
		}

		public Order GetById(string id)
		{
			return this.restTemplate.GetForObject<Order>("company/{shop_id}/" + this.moduleBase + "/{id}", shop_id, id);
		}

		public Order Insert(Order obj)
		{
			string sURL = "shops/" + shop_id + "/" + this.moduleBase;
			return this.restTemplate.PostForObject<Order>(sURL, obj);
		}

		public Order Update(Order obj)
		{
			string sURL = "shops/" + shop_id + "/" + this.moduleBase + "?operation=update";
			return this.restTemplate.PostForObject<Order>(sURL, obj);
		}

		public Order Delete(string id)
		{
			string sURL = "shops/" + shop_id + "/" + this.moduleBase + "?operation=delete";
			Order obj = GetById(id);
			// 02/13/2015 Paul.  In order to delete, we must send the entire object, not just the Id and SyncToken. 
			//NameValueCollection data = new NameValueCollection();
			//data.Add("Id"       , id           );
			//data.Add("SyncToken", obj.SyncToken);
			return this.restTemplate.PostForObject<Order>(sURL, obj);
		}
	}
}
