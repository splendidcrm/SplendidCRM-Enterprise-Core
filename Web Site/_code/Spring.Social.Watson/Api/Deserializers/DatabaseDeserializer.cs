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
using System.Globalization;
using System.Collections.Generic;
using System.Diagnostics;
using Spring.Xml;

namespace Spring.Social.Watson.Api.Impl
{
	class DatabaseDeserializer : IXmlElementDeserializer
	{
		public object Deserialize(XmlElement xml, XmlElementMapper mapper)
		{
			Database obj = new Database();
			// 01/25/2018 Paul.  Can be a single or a list item serializer. 
			XmlNode xBody = xml.SelectSingleNode("Body");
			if ( xBody != null )
			{
				XmlNode xResult = xBody.SelectSingleNode("RESULT");
				if ( xResult != null )
				{
					xml = xResult as XmlElement;
				}
				/*
				<ID>602759</ID>
				<NAME>Main Lead Database</NAME>
				<TYPE>0</TYPE>
				<SIZE>16</SIZE>
				<NUM_OPT_OUTS>0</NUM_OPT_OUTS>
				<NUM_UNDELIVERABLE>0</NUM_UNDELIVERABLE>
				<LAST_MODIFIED>01/25/18 05:43 PM</LAST_MODIFIED>
				<LAST_CONFIGURED>01/25/18 05:43 PM</LAST_CONFIGURED>
				<CREATED>01/02/18 07:01 AM</CREATED>
				<VISIBILITY>1</VISIBILITY>
				<USER_ID>4ff7827e-15fa7cc1721-6681ada67421f5d3ed5e65517ed2e77a</USER_ID>
				<ORGANIZATION_ID>5de6cc26-15f7237d8ea-6681ada67421f5d3ed5e65517ed2e77a</ORGANIZATION_ID>
				<PARENT_DATABASE_ID />
				<OPT_IN_FORM_DEFINED>false</OPT_IN_FORM_DEFINED>
				<OPT_OUT_FORM_DEFINED>false</OPT_OUT_FORM_DEFINED>
				<PROFILE_FORM_DEFINED>false</PROFILE_FORM_DEFINED>
				<OPT_IN_AUTOREPLY_DEFINED>false</OPT_IN_AUTOREPLY_DEFINED>
				<PROFILE_AUTOREPLY_DEFINED>false</PROFILE_AUTOREPLY_DEFINED>
				<COLUMNS>
					<COLUMN><NAME>LIST_ID</NAME></COLUMN>
					<COLUMN><NAME>MAILING_ID</NAME></COLUMN>
					<COLUMN><NAME>RECIPIENT_ID</NAME></COLUMN>
					<COLUMN><NAME>EMAIL</NAME></COLUMN>
					<COLUMN><NAME>CRM Lead Source</NAME></COLUMN>
					<COLUMN><NAME>ACTIVITY_STATUS</NAME></COLUMN>
					<COLUMN><NAME>CONTACT_ADDRESS</NAME></COLUMN>
					<COLUMN><NAME>CONTACT_CITY</NAME></COLUMN>
					<COLUMN><NAME>CONTACT_FNAME</NAME></COLUMN>
					<COLUMN><NAME>CONTACT_GENDER</NAME></COLUMN>
					<COLUMN><NAME>CONTACT_LNAME</NAME></COLUMN>
					<COLUMN><NAME>CONTACT_RELATIONSHIP</NAME></COLUMN>
					<COLUMN><NAME>CONTACT_STATE</NAME></COLUMN>
					<COLUMN><NAME>CONTACT_ZIPCODE</NAME></COLUMN>
					<COLUMN><NAME>C_ID</NAME></COLUMN>
				</COLUMNS>
				<KEY_COLUMNS>
					<COLUMN><NAME>LEAD_ID</NAME></COLUMN>
				</KEY_COLUMNS>
				*/
			}
			else
			{
				/*
				<ID>602759</ID>
				<NAME>Main Lead Database</NAME>
				<TYPE>0</TYPE>
				<SIZE>16</SIZE>
				<NUM_OPT_OUTS>0</NUM_OPT_OUTS>
				<NUM_UNDELIVERABLE>0</NUM_UNDELIVERABLE>
				<LAST_MODIFIED>01/25/18 05:43 PM</LAST_MODIFIED>
				<VISIBILITY>1</VISIBILITY>
				<PARENT_NAME />
				<USER_ID>4ff7827e-15fa7cc1721-6681ada67421f5d3ed5e65517ed2e77a</USER_ID>
				<PARENT_FOLDER_ID>440271</PARENT_FOLDER_ID>
				<IS_FOLDER>false</IS_FOLDER>
				<FLAGGED_FOR_BACKUP>false</FLAGGED_FOR_BACKUP>
				<SUPPRESSION_LIST_ID>0</SUPPRESSION_LIST_ID>
				*/
			}
			obj.RawContent                = xml.InnerXml;
			obj.ID                        = XmlUtils.SelectSingleNode(xml, "ID"                       );
			obj.CREATED                   = XmlUtils.SelectSingleDate(xml, "CREATED"                  );
			obj.LAST_MODIFIED             = XmlUtils.SelectSingleDate(xml, "LAST_MODIFIED"            );
			obj.NAME                      = XmlUtils.SelectSingleNode(xml, "NAME"                     );
			obj.TYPE                      = XmlUtils.SelectSingleInt (xml, "TYPE"                     );
			obj.SIZE                      = XmlUtils.SelectSingleInt (xml, "SIZE"                     );
			obj.NUM_OPT_OUTS              = XmlUtils.SelectSingleInt (xml, "NUM_OPT_OUTS"             );
			obj.NUM_UNDELIVERABLE         = XmlUtils.SelectSingleInt (xml, "NUM_UNDELIVERABLE"        );
			obj.VISIBILITY                = XmlUtils.SelectSingleInt (xml, "VISIBILITY"               );
			obj.PARENT_DATABASE_ID        = XmlUtils.SelectSingleNode(xml, "PARENT_DATABASE_ID"       );
			obj.PARENT_NAME               = XmlUtils.SelectSingleNode(xml, "PARENT_NAME"              );
			obj.ORGANIZATION_ID           = XmlUtils.SelectSingleNode(xml, "ORGANIZATION_ID"          );
			obj.USER_ID                   = XmlUtils.SelectSingleNode(xml, "USER_ID"                  );
			obj.PARENT_FOLDER_ID          = XmlUtils.SelectSingleNode(xml, "PARENT_FOLDER_ID"         );
			obj.IS_FOLDER                 = XmlUtils.SelectSingleBool(xml, "IS_FOLDER"                );
			obj.FLAGGED_FOR_BACKUP        = XmlUtils.SelectSingleBool(xml, "FLAGGED_FOR_BACKUP"       );
			obj.SUPPRESSION_LIST_ID       = XmlUtils.SelectSingleNode(xml, "SUPPRESSION_LIST_ID"      );
			obj.OPT_IN_FORM_DEFINED       = XmlUtils.SelectSingleBool(xml, "OPT_IN_FORM_DEFINED"      );
			obj.OPT_OUT_FORM_DEFINED      = XmlUtils.SelectSingleBool(xml, "OPT_OUT_FORM_DEFINED"     );
			obj.PROFILE_FORM_DEFINED      = XmlUtils.SelectSingleBool(xml, "PROFILE_FORM_DEFINED"     );
			obj.OPT_IN_AUTOREPLY_DEFINED  = XmlUtils.SelectSingleBool(xml, "OPT_IN_AUTOREPLY_DEFINED" );
			obj.PROFILE_AUTOREPLY_DEFINED = XmlUtils.SelectSingleBool(xml, "PROFILE_AUTOREPLY_DEFINED");
			obj.COLUMNS = new List<string>();
			XmlNodeList nlColumns = xml.SelectNodes("COLUMNS/COLUMN/NAME");
			foreach ( XmlNode xName in nlColumns )
			{
				obj.COLUMNS.Add(xName.InnerText);
			}
			nlColumns = xml.SelectNodes("KEY_COLUMNS/COLUMN/NAME");
			foreach ( XmlNode xName in nlColumns )
			{
				obj.COLUMNS.Add(xName.InnerText);
			}
			return obj;
		}
	}

	class DatabaseListDeserializer : IXmlElementDeserializer
	{
		public object Deserialize(XmlElement xml, XmlElementMapper mapper)
		{
			IList<Spring.Social.Watson.Api.Database> items = new List<Spring.Social.Watson.Api.Database>();
			XmlUtils.FaultCheck(xml);
			XmlNode xBody = xml.SelectSingleNode("Body");
			if ( xBody != null )
			{
				XmlNode xResult = xBody.SelectSingleNode("RESULT");
				if ( xResult != null )
				{
					XmlNodeList xList = xResult.SelectNodes("LIST");
					foreach ( XmlNode xItem in xList )
					{
						Spring.Social.Watson.Api.Database item = mapper.Deserialize<Spring.Social.Watson.Api.Database>(xItem as XmlElement);
						if ( item != null )
							items.Add(item);
					}
				}
			}
			return items;
		}
	}
}
