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
using System.Text;
using System.Collections.Generic;

using Spring.Http;
using Spring.Json;
using Spring.Http.Converters;

namespace Spring.Social.Pardot.Api.Impl
{
	public class PardotJsonHttpMessageConverter : AbstractHttpMessageConverter
	{
		protected static readonly Encoding DEFAULT_CHARSET = new UTF8Encoding(false); // Remove byte Order Mask (BOM)

		private JsonMapper mapper;

		public JsonMapper JsonMapper
		{
			get { return mapper; }
		}

		public PardotJsonHttpMessageConverter(JsonMapper mapper) :
			base(new MediaType("application", "json"))
		{
			this.mapper = mapper;
		}

		public override bool CanRead(Type type, MediaType mediaType)
		{
			return base.CanRead(mediaType) && (typeof(JsonValue).IsAssignableFrom(type) || this.mapper.CanDeserialize(type));
		}

		public override bool CanWrite(Type type, MediaType mediaType)
		{
			return base.CanWrite(mediaType) && (typeof(JsonValue).IsAssignableFrom(type) || this.mapper.CanSerialize(type));
		}

		protected override bool Supports(Type type)
		{
			throw new InvalidOperationException();
		}

		protected override T ReadInternal<T>(IHttpInputMessage message)
		{
			Encoding encoding = GetContentTypeCharset(message.Headers.ContentType, DEFAULT_CHARSET);
			using (StreamReader reader = new StreamReader(message.Body, encoding))
			{
				JsonValue jsonValue = JsonValue.Parse(reader.ReadToEnd());
				if ( typeof(T) == typeof(JsonValue) )
				{
					return jsonValue as T;
				}
				return this.mapper.Deserialize<T>(jsonValue);
			}
		}

		protected override void WriteInternal(object content, IHttpOutputMessage message)
		{
			Encoding encoding = GetContentTypeCharset(message.Headers.ContentType, DEFAULT_CHARSET);
			JsonValue jsonValue = (content is JsonValue) ? (JsonValue)content : this.mapper.Serialize(content);
			//byte[] byteData = encoding.GetBytes(jsonValue.ToString());
			
			// 07/16/2017 Paul.  For some unknown reason, data posted is in x-www-form-urlencoded format instead of json. 
			message.Headers.ContentType = new MediaType("application", "x-www-form-urlencoded");
			StringBuilder sb = new StringBuilder();
			if ( jsonValue != null )
			{
				foreach ( string sName in jsonValue.GetNames() )
				{
					string sValue = String.Empty;
					JsonValue val = jsonValue.GetValue(sName);
					if ( !val.IsNull )
					{
						sValue = HttpUtils.FormEncode(val.GetValue<string>());
					}
					if ( sb.Length > 0 )
						sb.Append("&");
					sb.Append(sName + "=" + sValue);
				}
			}
			
			byte[] byteData = encoding.GetBytes(sb.ToString());
			message.Body = delegate(Stream stream)
			{
				stream.Write(byteData, 0, byteData.Length);
			};
		}
	}
}
