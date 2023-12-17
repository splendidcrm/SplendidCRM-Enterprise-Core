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

namespace Spring.Xml
{
	public class XmlElementMapper
	{
		private IDictionary<Type, IXmlElementDeserializer> deserializers;
		private IDictionary<Type, IXmlElementSerializer  > serializers  ;

		public XmlElementMapper()
		{
			this.deserializers = new Dictionary<Type, IXmlElementDeserializer>();
			this.serializers   = new Dictionary<Type, IXmlElementSerializer  >();
		}

		public void RegisterDeserializer(Type type, IXmlElementDeserializer deserializer)
		{
			this.deserializers[type] = deserializer;
		}

		public void RegisterSerializer(Type type, IXmlElementSerializer serializer)
		{
			this.serializers[type] = serializer;
		}

		public bool CanDeserialize(Type type)
		{
			if ( type == typeof(XmlElement) || this.deserializers.ContainsKey(type) )
			{
				return true;
			}
			return false;
		}

		public bool CanSerialize(Type type)
		{
			if ( type == typeof(XmlElement) || this.serializers.ContainsKey(type) )
			{
				return true;
			}
			return false;
		}

		public T Deserialize<T>(XmlElement value)
		{
			IXmlElementDeserializer deserializer;
			if ( this.deserializers.TryGetValue(typeof(T), out deserializer) )
			{
				return (T) deserializer.Deserialize(value, this);
			}
			throw new XmlException(String.Format("Could not find deserializer for type '{0}'.", typeof(T)));
		}

		public XmlElement Serialize(object obj)
		{
			Type objType = obj.GetType();
			IXmlElementSerializer serializer;
			if ( this.serializers.TryGetValue(objType, out serializer) )
			{
				return serializer.Serialize(obj, this);
			}
			throw new XmlException(String.Format("Could not find serializer for type '{0}'.", objType));
		}
	}
}

