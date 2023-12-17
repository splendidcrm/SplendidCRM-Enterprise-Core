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
using System.Xml.Linq;
using System.Activities.DurableInstancing;
using System.Collections.Generic;
using System.Activities.Runtime.DurableInstancing;

namespace SplendidCRM
{
	public static class SerializationUtilities
	{
		[Serializable]
		struct DeletedMetadataValue
		{
		}

		public static Dictionary<XName, InstanceValue> DeserializeMetadataPropertyBag(byte[] serializedMetadataProperties)
		{
			IObjectSerializer serializer = new DefaultObjectSerializer();
			Dictionary<XName, InstanceValue> metadataProperties = new Dictionary<XName, InstanceValue>();

			if ( serializedMetadataProperties != null )
			{
				Dictionary<XName, object> propertyBag = serializer.DeserializePropertyBag(serializedMetadataProperties);
				foreach ( KeyValuePair<XName, object> property in propertyBag )
				{
					metadataProperties.Add(property.Key, new InstanceValue(property.Value));
				}
			}
			return metadataProperties;
		}

		public static ArraySegment<byte> SerializeMetadataPropertyBag(SaveWorkflowCommand saveWorkflowCommand, InstancePersistenceContext context)
		{
			IObjectSerializer serializer = new DefaultObjectSerializer();
			Dictionary<XName, object> propertyBagToSerialize = new Dictionary<XName, object>();

			if ( context.InstanceView.InstanceMetadataConsistency == InstanceValueConsistency.None )
			{
				foreach ( KeyValuePair<XName, InstanceValue> metadataProperty in context.InstanceView.InstanceMetadata )
				{
					if ( (metadataProperty.Value.Options & InstanceValueOptions.WriteOnly) == 0 )
					{
						propertyBagToSerialize.Add(metadataProperty.Key, metadataProperty.Value.Value);
					}
				}
			}
			foreach ( KeyValuePair<XName, InstanceValue> metadataChange in saveWorkflowCommand.InstanceMetadataChanges )
			{
				if ( metadataChange.Value.IsDeletedValue )
				{
					if (context.InstanceView.InstanceMetadataConsistency == InstanceValueConsistency.None)
					{
						propertyBagToSerialize.Remove(metadataChange.Key);
					}
					else
					{
						propertyBagToSerialize[metadataChange.Key] = new DeletedMetadataValue();
					}
				}
				else if ( (metadataChange.Value.Options & InstanceValueOptions.WriteOnly) == 0 )
				{
					propertyBagToSerialize[metadataChange.Key] = metadataChange.Value.Value;
				}
			}
			if ( propertyBagToSerialize.Count > 0 )
			{
				return serializer.SerializePropertyBag(propertyBagToSerialize);
			}
			return new ArraySegment<byte>();
		}

		public static ArraySegment<byte>[] SerializePropertyBag(IDictionary<XName, InstanceValue> properties)
		{
			ArraySegment<byte>[] dataArrays = new ArraySegment<byte>[4];
			if ( properties.Count > 0 )
			{
				IObjectSerializer serializer = new DefaultObjectSerializer();
				XmlPropertyBag              primitiveProperties          = new XmlPropertyBag();
				XmlPropertyBag              primitiveWriteOnlyProperties = new XmlPropertyBag();
				Dictionary<XName, object>   complexProperties            = new Dictionary<XName, object>();
				Dictionary<XName, object>   complexWriteOnlyProperties   = new Dictionary<XName, object>();
				Dictionary<XName, object>[] propertyBags = new Dictionary<XName, object>[] { primitiveProperties, complexProperties, primitiveWriteOnlyProperties, complexWriteOnlyProperties };

				foreach ( KeyValuePair<XName, InstanceValue> property in properties )
				{
					bool isComplex = (XmlPropertyBag.GetPrimitiveType(property.Value.Value) == PrimitiveType.Unavailable);
					bool isWriteOnly = (property.Value.Options & InstanceValueOptions.WriteOnly) == InstanceValueOptions.WriteOnly;
					int index = (isWriteOnly ? 2 : 0) + (isComplex ? 1 : 0);
					propertyBags[index].Add(property.Key, property.Value.Value);
				}

				// Remove the properties that are already stored as individual columns from the serialized blob
				primitiveWriteOnlyProperties.Remove(SqlWorkflowInstanceStoreConstants.StatusPropertyName                 );
				primitiveWriteOnlyProperties.Remove(SqlWorkflowInstanceStoreConstants.LastUpdatePropertyName             );
				primitiveWriteOnlyProperties.Remove(SqlWorkflowInstanceStoreConstants.PendingTimerExpirationPropertyName );
				complexWriteOnlyProperties  .Remove(SqlWorkflowInstanceStoreConstants.BinaryBlockingBookmarksPropertyName);

				for ( int i = 0; i < propertyBags.Length; i++ )
				{
					if ( propertyBags[i].Count > 0 )
					{
						if ( propertyBags[i] is XmlPropertyBag )
						{
							dataArrays[i] = serializer.SerializeValue(propertyBags[i]);
						}
						else
						{
							dataArrays[i] = serializer.SerializePropertyBag(propertyBags[i]);
						}
					}
				}
			}
			return dataArrays;
		}

		public static Dictionary<XName, InstanceValue> DeserializePropertyBag(byte[] primitiveDataProperties, byte[] complexDataProperties)
		{
			IObjectSerializer serializer = new DefaultObjectSerializer();
			Dictionary<XName, InstanceValue> properties = new Dictionary<XName, InstanceValue>();
			Dictionary<XName, object>[] propertyBags = new Dictionary<XName, object>[2];

			if ( primitiveDataProperties != null )
			{
				propertyBags[0] = (Dictionary<XName, object>)serializer.DeserializeValue(primitiveDataProperties);
			}
			if ( complexDataProperties != null )
			{
				propertyBags[1] = serializer.DeserializePropertyBag(complexDataProperties);
			}
			foreach ( Dictionary<XName, object> propertyBag in propertyBags )
			{
				if ( propertyBag != null )
				{
					foreach ( KeyValuePair<XName, object> property in propertyBag )
					{
						properties.Add(property.Key, new InstanceValue(property.Value));
					}
				}
			}
			return properties;
		}
	}
}
