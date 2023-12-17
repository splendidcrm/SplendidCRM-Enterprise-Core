/*
 * Copyright (C) 2018 SplendidCRM Software, Inc. All Rights Reserved. 
 *
 * Any use of the contents of this file are subject to the SplendidCRM Professional Source Code License 
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
 */
using System;
using System.Xml;
using System.Globalization;
using System.Collections.Generic;
using System.Diagnostics;
using Spring.Xml;

namespace Spring.Social.Watson.Api.Impl
{
	class ContactDeserializer : IXmlElementDeserializer
	{
		public object Deserialize(XmlElement xml, XmlElementMapper mapper)
		{
			Contact obj = new Contact();
			/*
			<Envelope>
				<Body>
					<RESULT>
						<SUCCESS>TRUE</SUCCESS>
						<EMAIL>paul@splendidcrm.com</EMAIL>
						<Email>paul@splendidcrm.com</Email>
						<RecipientId>5804</RecipientId>
						<EmailType>0</EmailType>
						<LastModified>2/4/18 2:48 AM</LastModified>
						<CreatedFrom>1</CreatedFrom>
						<OptedIn>2/4/18 2:48 AM</OptedIn>
						<OptedOut />
						<ResumeSendDate />
						<ORGANIZATION_ID>5de6cc26</ORGANIZATION_ID>
						<CRMLeadSource />
						<COLUMNS>
							<COLUMN>
								<NAME>ACTIVITY_STATUS</NAME>
								<VALUE />
							</COLUMN>
						</COLUMNS>
					</RESULT>
				</Body>
			</Envelope>
			*/
			XmlUtils.FaultCheck(xml);
			XmlNode xBody = xml.SelectSingleNode("Body");
			if ( xBody != null )
			{
				XmlNode xResult = xBody.SelectSingleNode("RESULT");
				if ( xResult != null )
				{
					xml = xResult as XmlElement;
				}
			}
			obj.RawContent = xml.InnerXml;
			obj.ID                        = XmlUtils.SelectSingleNode(xml, "RecipientId"   );
			obj.EMAIL                     = XmlUtils.SelectSingleNode(xml, "EMAIL"         );
			obj.LAST_MODIFIED             = XmlUtils.SelectSingleDate(xml, "LastModified"  );
			obj.EmailType                 = XmlUtils.SelectSingleInt (xml, "EmailType"     );
			obj.CreatedFrom               = XmlUtils.SelectSingleInt (xml, "CreatedFrom"   );
			obj.OptedInDate               = XmlUtils.SelectSingleDate(xml, "OptedIn"       );
			obj.OptedOutDate              = XmlUtils.SelectSingleDate(xml, "OptedOut"      );
			obj.ResumeSendDate            = XmlUtils.SelectSingleDate(xml, "ResumeSendDate");
			obj.CRMLeadSource             = XmlUtils.SelectSingleNode(xml, "CRMLeadSource" );
			
			obj.MERGE_FIELDS = new List<Contact.MergeField>();
			Contact.MergeField fld = new Contact.MergeField("EMAIL", obj.EMAIL);
			obj.MERGE_FIELDS.Add(fld);
			
			XmlNodeList nlColumns = xml.SelectNodes("COLUMNS/COLUMN");
			foreach ( XmlNode xColumn in nlColumns )
			{
				string sNAME  = XmlUtils.SelectSingleNode(xColumn, "NAME" );
				string sVALUE = XmlUtils.SelectSingleNode(xColumn, "VALUE");
				fld = new Contact.MergeField(sNAME, sVALUE);
				obj.MERGE_FIELDS.Add(fld);
			}
			return obj;
		}
	}

	class ContactListDeserializer : IXmlElementDeserializer
	{
		public object Deserialize(XmlElement xml, XmlElementMapper mapper)
		{
			IList<Contact> items = new List<Contact>();
			XmlUtils.FaultCheck(xml);
			return items;
		}
	}

	class ContactInsertDeserializer : IXmlElementDeserializer
	{
		public object Deserialize(XmlElement xml, XmlElementMapper mapper)
		{
			ContactInsert obj = new ContactInsert();
			/*
			<Envelope>
				<Body>
					<RESULT>
						<SUCCESS>TRUE</SUCCESS>
						<RecipientId>672316</RecipientId>
					</RESULT>
				</Body>
			</Envelope>
			*/
			XmlUtils.FaultCheck(xml);
			XmlNode xBody = xml.SelectSingleNode("Body");
			if ( xBody != null )
			{
				XmlNode xResult = xBody.SelectSingleNode("RESULT");
				if ( xResult != null )
				{
					xml = xResult as XmlElement;
				}
			}
			obj.RawContent = xml.InnerXml;
			obj.ID         = XmlUtils.SelectSingleNode(xml, "RecipientId");
			return obj;
		}
	}

}
