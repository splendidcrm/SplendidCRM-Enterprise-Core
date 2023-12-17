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
using System.Data;
using System.Text.Json;

using Microsoft.AspNetCore.Http;

namespace SplendidCRM
{
	public class HttpSessionState
	{
		public static int Timeout = 20;
		private HttpContext          Context    ;

		public HttpSessionState(IHttpContextAccessor httpContextAccessor)
		{
			this.Context     = httpContextAccessor.HttpContext;
		}

		// https://docs.microsoft.com/en-us/aspnet/core/fundamentals/app-state?view=aspnetcore-6.0
		public object this[string key]
		{
			get
			{
				object obj = null;
				try
				{
					// 06/18/2023 Paul.  Debugging with IIS express fails with Context == null. 
					if ( this.Context != null )
					{
						string value = this.Context.Session.GetString(key);
						if ( value != null )
						{
							// 12/26/2021 Paul.  JsonSerializer.Deserialize is returning JsonElement, which does not convert well to boolean. 
							if ( value == "true" )
								obj = true;
							else if ( value == "false" )
								obj = false;
							else
								obj = JsonSerializer.Deserialize<object>(value);
						}
					}
				}
				catch
				{
				}
				return obj;
			}
			set
			{
				if ( value != null )
				{
					if ( value.GetType() == typeof(DataTable) )
						throw(new Exception("HttpSessionState: Use Get/Set to serialize DataTable"));
					this.Context.Session.SetString(key, JsonSerializer.Serialize(value));
				}
				else
				{
					this.Context.Session.SetString(key, null);
				}
			}
		}

		// https://learn.microsoft.com/en-us/aspnet/core/fundamentals/app-state?view=aspnetcore-7.0
		public void SetTable(string key, DataTable value)
		{
			if ( value != null )
			{
				// 06/09/2023 Paul.  Must have table name to serialize. 
				if ( Sql.IsEmptyString(value.TableName) )
				{
					value.TableName = "[" + key + "]";
				}
				StringBuilder sb = new StringBuilder();
				using ( StringWriter wtr = new StringWriter(sb, System.Globalization.CultureInfo.InvariantCulture) )
				{
					(value as DataTable).WriteXml(wtr, XmlWriteMode.WriteSchema, false);
				}
				this.Context.Session.SetString(key, sb.ToString());
			}
			else
			{
				this.Context.Session.SetString(key, null);
			}
		}

		public DataTable GetTable(string key)
		{
			DataTable dt = null;
			string value = this.Context.Session.GetString(key);
			if ( value != null )
			{
				dt = new DataTable();
				using ( StringReader srdr = new StringReader(value) )
				{
					dt.ReadXml(srdr);
				}
			}
			return dt;
		}

		public void Remove(string key)
		{
			this.Context.Session.Remove(key);
		}

		public void Clear()
		{
			this.Context.Session.Clear();
		}

		public string Id
		{
			get { return this.Context.Session.Id; }
		}
	}
}
