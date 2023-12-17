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
	// https://developer.ibm.com/customer-engagement/docs/watson-marketing/ibm-engage-2/watson-campaign-automation-platform/xml-api/db_mgmt_user_xml_intfc/
	class ContactTemplate : IContactOperations
	{
		protected RestTemplate restTemplate;
		protected int maxResults;

		public ContactTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
			this.maxResults = 1000;
		}

		public virtual IList<HBase> GetModified(string list_id, DateTime startModifiedDate)
		{
			// 02/01/2018 Paul.  Watson cannot return a list of recipients. 
			List<HBase> all = new List<HBase>();
			return all;
		}

		public virtual IList<Contact> GetAll(string list_id, string type)
		{
			// 02/01/2018 Paul.  Watson cannot return a list of recipients. 
			List<Contact> all = new List<Contact>();
			return all;
		}

		public Contact GetById(string list_id, string id)
		{
			string sURL = "/XMLAPI";
			XmlElement xSelectRecipientData = XmlUtils.CreateEnvelope("SelectRecipientData");
			XmlUtils.SetSingleNode(xSelectRecipientData, "LIST_ID"     , list_id);
			XmlUtils.SetSingleNode(xSelectRecipientData, "RECIPIENT_ID", id     );
			return this.restTemplate.PostForObject<Contact>(sURL, xSelectRecipientData.OwnerDocument);
		}

		public ContactInsert Insert(string database_id, string list_id, Contact obj)
		{
			string sURL = "/XMLAPI";
			// https://developer.ibm.com/customer-engagement/docs/watson-marketing/ibm-engage-2/watson-campaign-automation-platform/xml-api/contact-xml-interfaces/
			XmlElement xAddRecipient = XmlUtils.CreateEnvelope("AddRecipient");
			XmlDocument xml = xAddRecipient.OwnerDocument;
			XmlUtils.SetSingleNode(xAddRecipient, "LIST_ID" , database_id);
			/*
			0 - Imported from a database
			1 - Added manually
			2 - Opted in
			3 - Created from tracking database
			*/
			XmlUtils.SetSingleNode(xAddRecipient, "CREATED_FROM"   , "1"   );
			//XmlUtils.SetSingleNode(xAddRecipient, "UPDATE_IF_FOUND", "true");
			XmlUtils.SetSingleNode(xAddRecipient, "ALLOW_HTML"     , "true");
			XmlUtils.SetSingleNode(xAddRecipient, "CONTACT_LISTS/CONTACT_LIST_ID" , list_id);
			
			foreach ( Spring.Social.Watson.Api.Contact.MergeField field in obj.MERGE_FIELDS )
			{
				XmlElement xCOLUMN = xml.CreateElement("COLUMN");
				xAddRecipient.AppendChild(xCOLUMN);
				XmlElement xNAME = xml.CreateElement("NAME");
				xCOLUMN.AppendChild(xNAME);
				XmlElement xVALUE = xml.CreateElement("VALUE");
				xCOLUMN.AppendChild(xVALUE);
				xNAME .InnerText = field.NAME ;
				xVALUE.InnerText = field.VALUE;
			}
			return this.restTemplate.PostForObject<ContactInsert>(sURL, xAddRecipient.OwnerDocument);
		}

		public void Update(string database_id, string list_id, Contact obj)
		{
			if ( String.IsNullOrEmpty(obj.ID) )
				throw (new Exception("ID must not be null during update operation."));
			string sURL = "/XMLAPI";
			XmlElement xUpdateRecipient = XmlUtils.CreateEnvelope("UpdateRecipient");
			XmlDocument xml = xUpdateRecipient.OwnerDocument;
			
			XmlUtils.SetSingleNode(xUpdateRecipient, "LIST_ID"      , database_id);
			XmlUtils.SetSingleNode(xUpdateRecipient, "RECIPIENT_ID" , obj.ID     );
			foreach ( Spring.Social.Watson.Api.Contact.MergeField field in obj.MERGE_FIELDS )
			{
				XmlElement xCOLUMN = xml.CreateElement("COLUMN");
				xUpdateRecipient.AppendChild(xCOLUMN);
				XmlElement xNAME = xml.CreateElement("NAME");
				xCOLUMN.AppendChild(xNAME);
				XmlElement xVALUE = xml.CreateElement("VALUE");
				xCOLUMN.AppendChild(xVALUE);
				xNAME .InnerText = field.NAME ;
				xVALUE.InnerText = field.VALUE;
			}
			this.restTemplate.PostForObject<ContactInsert>(sURL, xUpdateRecipient.OwnerDocument);
		}

		public void AddToContactList(string list_id, string id)
		{
			string sURL = "/XMLAPI";
			XmlElement xAddContactToContactList = XmlUtils.CreateEnvelope("AddContactToContactList");
			XmlUtils.SetSingleNode(xAddContactToContactList, "CONTACT_LIST_ID", list_id);
			XmlUtils.SetSingleNode(xAddContactToContactList, "CONTACT_ID"     , id     );
			this.restTemplate.PostForObject<Contact>(sURL, xAddContactToContactList.OwnerDocument);
		}

		public void Delete(string list_id, string email)
		{
			string sURL = "/XMLAPI";
			XmlElement xRemoveRecipient = XmlUtils.CreateEnvelope("RemoveRecipient");
			XmlUtils.SetSingleNode(xRemoveRecipient, "LIST_ID" , list_id);
			XmlUtils.SetSingleNode(xRemoveRecipient, "EMAIL"   , email  );
			this.restTemplate.PostForObject<Contact>(sURL, xRemoveRecipient.OwnerDocument);
		}
	}
}