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
using System.Xml;
using System.Net;
using System.Collections.Generic;
using System.Collections.Specialized;

using Spring.Json;
using Spring.Http;
using Spring.Rest.Client;
using Spring.Rest.Client.Support;

namespace Spring.Social.Watson.Api.Impl
{
	class DatabaseTemplate : IDatabaseOperations
	{
		protected RestTemplate restTemplate;
		protected int          maxResults  ;

		public DatabaseTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
			this.maxResults   = 1000        ;
		}

		public virtual IList<Database> GetAll()
		{
			string sURL = "/XMLAPI";
			// https://developer.ibm.com/customer-engagement/docs/watson-marketing/ibm-engage-2/watson-campaign-automation-platform/xml-api/db_mgmt_user_xml_intfc/#Getalistofdatabases
			XmlElement xGetLists = XmlUtils.CreateEnvelope("GetLists");
			XmlUtils.SetSingleNode(xGetLists, "VISIBILITY", "1" );
			/*
			Defines the type of entity to return. Supported values are:
			 0 – Databases
			 1 – Queries
			 2 – Databases, Contact Lists and Queries
			 5 – Test Lists
			 6 – Seed Lists
			13 – Suppression Lists
			15 – Relational Tables
			18 – Contact Lists
			*/
			XmlUtils.SetSingleNode(xGetLists, "LIST_TYPE" , "0");
			
			IList<Database> all = this.restTemplate.PostForObject<IList<Database>>(sURL, xGetLists.OwnerDocument);
			return all;
		}

		public Database GetById(string id)
		{
			string sURL = "/XMLAPI";
			// https://developer.ibm.com/customer-engagement/docs/watson-marketing/ibm-engage-2/watson-campaign-automation-platform/xml-api/db_mgmt_user_xml_intfc/#Getdatabasedetails
			XmlElement xGetLists = XmlUtils.CreateEnvelope("GetListMetaData");
			XmlUtils.SetSingleNode(xGetLists, "LIST_ID" , id);
			
			Database obj = this.restTemplate.PostForObject<Database>(sURL, xGetLists.OwnerDocument);
			return obj;
		}
	}
}
