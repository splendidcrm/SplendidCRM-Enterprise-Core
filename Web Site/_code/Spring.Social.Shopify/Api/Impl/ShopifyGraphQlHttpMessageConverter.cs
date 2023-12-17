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

namespace Spring.Social.Shopify.Api.Impl
{
	public class ShopifyGraphQl
	{
		public string s;

		public ShopifyGraphQl(string s)
		{
			this.s = s;
		}

		public override string ToString()
		{
			return s;
		}
	}

	public class ShopifyGraphQlHttpMessageConverter : AbstractHttpMessageConverter
	{
		protected static readonly Encoding DEFAULT_CHARSET = Encoding.GetEncoding("ISO-8859-1");

		public ShopifyGraphQlHttpMessageConverter() : base(new MediaType("application", "graphql"))
		{
		}

		protected override bool Supports(Type type)
		{
			return type.Equals(typeof(ShopifyGraphQl));
		}

		public override bool CanRead(Type type, MediaType mediaType)
		{
			return false;
		}

		protected override T ReadInternal<T>(IHttpInputMessage message)
		{
			throw new InvalidOperationException();
		}

		protected override void WriteInternal(object content, IHttpOutputMessage message)
		{
			Encoding encoding = GetContentTypeCharset(message.Headers.ContentType, DEFAULT_CHARSET);

			byte[] byteData = encoding.GetBytes(content.ToString());
			message.Body = delegate(Stream stream) 
			{
				stream.Write(byteData, 0, byteData.Length);
			};
		}
	}
}
