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
	class ProspectListTemplate : IProspectListOperations
	{
		protected RestTemplate restTemplate;
		protected int          maxResults  ;

		public ProspectListTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
			this.maxResults   = 1000        ;
		}

		public virtual IList<HBase> GetModified(DateTime startModifiedDate)
		{
			string sURL = "/XMLAPI";
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
			XmlUtils.SetSingleNode(xGetLists, "LIST_TYPE" , "18");
			
			IList<ProspectList> all = this.restTemplate.PostForObject<IList<ProspectList>>(sURL, xGetLists.OwnerDocument);
			List<HBase> modified = new List<HBase>();
			foreach ( ProspectList list in all )
			{
				if ( startModifiedDate == DateTime.MinValue || list.LAST_MODIFIED > startModifiedDate )
					modified.Insert(0, list);
			}
			return modified;
		}

		public virtual IList<ProspectList> GetAll()
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
			XmlUtils.SetSingleNode(xGetLists, "LIST_TYPE" , "18");
			
			IList<ProspectList> all = this.restTemplate.PostForObject<IList<ProspectList>>(sURL, xGetLists.OwnerDocument);
			return all;
		}

		public ProspectList GetById(string id)
		{
			string sURL = "/XMLAPI";
			// https://developer.ibm.com/customer-engagement/docs/watson-marketing/ibm-engage-2/watson-campaign-automation-platform/xml-api/db_mgmt_user_xml_intfc/#Getdatabasedetails
			XmlElement xGetLists = XmlUtils.CreateEnvelope("GetListMetaData");
			XmlUtils.SetSingleNode(xGetLists, "LIST_ID" , id);
			
			ProspectList obj = this.restTemplate.PostForObject<ProspectList>(sURL, xGetLists.OwnerDocument);
			return obj;
		}

		public ProspectListInsert Insert(string database_id, ProspectList obj)
		{
			string sURL = "/XMLAPI";
			// https://developer.ibm.com/customer-engagement/docs/watson-marketing/ibm-engage-2/watson-campaign-automation-platform/xml-api/db_mgmt_user_xml_intfc/#Createacontactlist
			XmlElement xCreateContactList = XmlUtils.CreateEnvelope("CreateContactList");
			XmlUtils.SetSingleNode(xCreateContactList, "DATABASE_ID"       ,  database_id);
			XmlUtils.SetSingleNode(xCreateContactList, "CONTACT_LIST_NAME" ,  obj.NAME   );
			XmlUtils.SetSingleNode(xCreateContactList, "VISIBILITY"        , (obj.VISIBILITY.HasValue ? obj.VISIBILITY.Value : 0).ToString());
			if ( !Sql.IsEmptyString(obj.PARENT_NAME) )
				XmlUtils.SetSingleNode(xCreateContactList, "PARENT_FOLDER_PATH",  obj.PARENT_FOLDER_PATH);
			return this.restTemplate.PostForObject<ProspectListInsert>(sURL, xCreateContactList.OwnerDocument);
		}

		public void Update(string database_id, ProspectList obj)
		{
			throw(new Exception("Not implemented"));
			//if ( String.IsNullOrEmpty(obj.ID) )
			//	throw(new Exception("ID must not be null during update operation."));
			//string sURL = "/XMLAPI";
			////this.restTemplate.PostForObject<List>(sURL, obj);
			//// 04/08/2016 Paul.  PATCH method is used instead of POST. 
			//HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(Spring.Social.Watson.Api.ProspectList), this.restTemplate.MessageConverters);
			//MessageConverterResponseExtractor<ProspectList> responseExtractor = new MessageConverterResponseExtractor<Spring.Social.Watson.Api.ProspectList>(this.restTemplate.MessageConverters);
			//this.restTemplate.Execute<ProspectList>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
		}

		public void Delete(string database_id, string id)
		{
			throw(new Exception("Not implemented"));
			//string sURL = "/XMLAPI";
			//this.restTemplate.Delete(sURL);
		}

		public IList<Spring.Social.Watson.Api.Contact> GetContacts(string id)
		{
			//XmlElement xSelectRecipientData = XmlUtils.CreateEnvelope("SelectRecipientData");
			//XmlUtils.SetSingleNode(xSelectRecipientData, "LIST_ID" , id);
			//IList<Contact> all = this.restTemplate.PostForObject<IList<Contact>>(sURL, xSelectRecipientData.OwnerDocument);
			
			// 02/01/2018 Paul.  Watson cannot return a list of recipients. The only method is CSV generation and download via FTP. 
			List<Contact> all = new List<Contact>();
			return all;
		}
	}
}
