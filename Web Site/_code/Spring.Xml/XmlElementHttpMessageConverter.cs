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
using System.Collections.Generic;
using Spring.Xml;

namespace Spring.Http.Converters.Xml
{
	public class XmlElementHttpMessageConverter : AbstractXmlHttpMessageConverter
	{
		private XmlElementMapper mapper;

		public XmlElementMapper XmlElementMapper
		{
			get { return mapper; }
		}

		// 01/24/2018 Paul.  Watson requires text/xml be the default. 
		public XmlElementHttpMessageConverter() : base( new MediaType[] { MediaType.TEXT_XML, MediaType.APPLICATION_XML } )
		{
			this.mapper = new XmlElementMapper();
		}

		// 01/24/2018 Paul.  Watson requires text/xml be the default. 
		public XmlElementHttpMessageConverter(XmlElementMapper mapper) : base( new MediaType[] { MediaType.TEXT_XML, MediaType.APPLICATION_XML } )
		{
			this.mapper = mapper;
		}

		protected override bool Supports(Type type)
		{
			// 01/24/2018 Paul.  The type can be XmlElement or it can be a SplendidCRM Watson class.  Just accept all as this is very common in the Spring library. 
			//return type.Equals(typeof(XmlDocument)) || type.Equals(typeof(XmlElement));
			return true;
		}

		protected override T ReadXml<T>(XmlReader xmlReader)
		{
			XmlDocument document = new XmlDocument();
			document.Load(xmlReader);
			return this.mapper.Deserialize<T>(document.DocumentElement);
		}

		protected override void WriteXml(XmlWriter xmlWriter, object content)
		{
			XmlElement document = this.mapper.Serialize(content);
			document.WriteTo(xmlWriter);
		}
	}
}
