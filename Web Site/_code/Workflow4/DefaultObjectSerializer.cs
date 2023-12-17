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
using System.IO;
using System.Xml;
using System.Xml.Linq;
using System.Collections.Generic;
//using System.Runtime.Serialization;
// https://github.com/dmitrykolchev/NetDataContractSerializer
using Compat.Runtime.Serialization;

namespace SplendidCRM
{
	// https://learn.microsoft.com/en-us/dotnet/framework/wcf/samples/datacontractserializer-datacontractresolver-netdatacontractserializer
	// https://github.com/dotnet/samples/tree/main/framework/wcf/Basic/Contract/Data/NetDCSasDCSwithDCR/CS
	/*
	public class SplendidDataContractResolver : System.Runtime.Serialization.DataContractResolver
	{
		public SplendidDataContractResolver()
		{
		}

		// Used at deserialization
		// Allows users to map xsi:type name to any Type 
		public override Type ResolveName(string typeName, string typeNamespace, Type declaredType, System.Runtime.Serialization.DataContractResolver knownTypeResolver)
		{
			Type type = knownTypeResolver.ResolveName(typeName, typeNamespace, declaredType, null);
			if (type == null)
			{
				type = Type.GetType(typeName + ", " + typeNamespace);
			}
			return type;
		}

		// Used at serialization
		// Maps any Type to a new xsi:type representation
		public override bool TryResolveType(Type type, Type declaredType, System.Runtime.Serialization.DataContractResolver knownTypeResolver, out XmlDictionaryString typeName, out XmlDictionaryString typeNamespace)
		{
			if (!knownTypeResolver.TryResolveType(type, declaredType, null, out typeName, out typeNamespace))
			{
				XmlDictionary dictionary = new XmlDictionary();
				typeName = dictionary.Add(type.FullName);
				typeNamespace = dictionary.Add(type.Assembly.FullName);
			}
			return true;
		}
	}
	*/

	public class DefaultObjectSerializer : IObjectSerializer
	{
		// 09/02/2023 Paul.  NetDataContractSerializer is failing due to issue serializing System.Xml.Linq.XName. 
		NetDataContractSerializer serializer;
		// 09/02/2023 Paul.  DataContractSerializer failes on same System.Xml.Linq.XName issue. 
		// https://learn.microsoft.com/en-us/dotnet/framework/wcf/samples/datacontractserializer-datacontractresolver-netdatacontractserializer
		//DataContractSerializer serializer;

		public DefaultObjectSerializer()
		{
			this.serializer = new NetDataContractSerializer();
			// 09/02/2023 Paul.  DataContractSerializer failes on same System.Xml.Linq.XName issue. 
			//DataContractSerializerSettings dcSettings = new DataContractSerializerSettings();
			//dcSettings.DataContractResolver      = new SplendidDataContractResolver();
			//dcSettings.IgnoreExtensionDataObject = false;
			//dcSettings.PreserveObjectReferences  = true;
			//dcSettings.SerializeReadOnlyTypes    = true;
			// 09/02/2023 Paul.  ObjectGraph starts and endless loop. 
			//this.serializer = new DataContractSerializer(typeof(ObjectGraph), dcSettings);
			// 09/02/2023 Paul.  System.Xml.Linq.XName is blocked from serialization by Microsoft. 
			//this.serializer = new DataContractSerializer(typeof(Dictionary<XName, object>), dcSettings);
		}

		public Dictionary<XName, object> DeserializePropertyBag(byte[] serializedValue)
		{
			using ( MemoryStream stm = new MemoryStream(serializedValue) )
			{
				return this.DeserializePropertyBag(stm);
			}
		}

		public object DeserializeValue(byte[] serializedValue)
		{
			using ( MemoryStream stm = new MemoryStream(serializedValue) )
			{
				return this.DeserializeValue(stm);
			}
		}

		public ArraySegment<byte> SerializePropertyBag(Dictionary<XName, object> value)
		{
			using ( MemoryStream stm = new MemoryStream(4096) )
			{
				this.SerializePropertyBag(stm, value);
				return new ArraySegment<byte>(stm.GetBuffer(), 0, Convert.ToInt32(stm.Length));
			}
		}

		public ArraySegment<byte> SerializeValue(object value)
		{
			using ( MemoryStream stm = new MemoryStream(4096) )
			{
				this.SerializeValue(stm, value);
				return new ArraySegment<byte>(stm.GetBuffer(), 0, Convert.ToInt32(stm.Length));
			}
		}

		protected virtual Dictionary<XName, object> DeserializePropertyBag(Stream stream)
		{
			using ( XmlDictionaryReader rdr = XmlDictionaryReader.CreateBinaryReader(stream, XmlDictionaryReaderQuotas.Max) )
			{
				Dictionary<XName, object> propertyBag = new Dictionary<XName, object>();
				if ( rdr.ReadToDescendant("Property") )
				{
					do
					{
						rdr.Read();
						// 09/02/2023 Paul.  ObjectGraph starts and endless loop. 
						//ObjectGraph propertyGraph = (ObjectGraph) this.serializer.ReadObject(rdr, true);
						//KeyValuePair<XName, object> property = new KeyValuePair<XName, object>("", propertyGraph.Data);
						//throw(new Exception("Unknown property name: " + propertyGraph.DataAsString));
						KeyValuePair<XName, object> property = (KeyValuePair<XName, object>) this.serializer.ReadObject(rdr);
						propertyBag.Add(property.Key, property.Value);
					}
					while (rdr.ReadToNextSibling("Property"));
				}

				return propertyBag;
			}
		}

		protected virtual object DeserializeValue(Stream stream)
		{
			using ( XmlDictionaryReader rdr = XmlDictionaryReader.CreateBinaryReader(stream, XmlDictionaryReaderQuotas.Max) )
			{
				// 09/02/2023 Paul.  ObjectGraph starts and endless loop. 
				//ObjectGraph propertyGraph = (ObjectGraph) this.serializer.ReadObject(rdr, true);
				//KeyValuePair<XName, object> property = new KeyValuePair<XName, object>("", propertyGraph.Data);
				//throw(new Exception("Unknown property name: " + propertyGraph.DataAsString));
				//return property;
				return this.serializer.ReadObject(rdr);
			}
		}

		protected virtual void SerializePropertyBag(Stream stream, Dictionary<XName, object> propertyBag)
		{
			using ( XmlDictionaryWriter wtr = XmlDictionaryWriter.CreateBinaryWriter(stream, null, null, false) )
			{
				wtr.WriteStartElement("Properties");
				foreach (KeyValuePair<XName, object> property in propertyBag)
				{
					wtr.WriteStartElement("Property");
					// 09/02/2023 Paul.  ObjectGraph starts and endless loop. 
					//this.serializer.WriteObject(wtr, graph);
					//wtr.WriteEndElement();
					// 09/02/2023 Paul.  System.Xml.Linq.XName is blocked from serialization by Microsoft. 
					this.serializer.WriteObject(wtr, property);
					wtr.WriteEndElement();
				}
				wtr.WriteEndElement();
			}
		}

		protected virtual void SerializeValue(Stream stream, object value)
		{
			using ( XmlDictionaryWriter dictionaryWriter = XmlDictionaryWriter.CreateBinaryWriter(stream, null, null, false) )
			{
				// 09/02/2023 Paul.  ObjectGraph starts and endless loop. 
				//ObjectGraph graph = ObjectGraphWalker.Create(value);
				//this.serializer.WriteObject(dictionaryWriter, graph);
				// 09/02/2023 Paul.  System.Xml.Linq.XName is blocked from serialization by Microsoft. 
				this.serializer.WriteObject(dictionaryWriter, value);
			}
		}
	}
}
