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
using System.Net;

using Spring.Json;
using Spring.Social.OAuth2;
using Spring.Social.Pardot.Api;
using Spring.Social.Pardot.Api.Impl;

namespace Spring.Social.Pardot.Connect
{
	public class PardotServiceProvider : AbstractOAuth2ServiceProvider<IPardot>
	{
		private string ApiUserKey = String.Empty;

		public PardotServiceProvider(string sApiUserKey)
			: base(new PardotOAuth2Template())
		{
			this.ApiUserKey = sApiUserKey;
		}

		public override IPardot GetApi(String accessToken)
		{
			// 07/15/2017 Paul.  Pardot does not use an accessToken.  Instead, it uses header values for App User Key, API Username and API Password. 
			return new PardotTemplate(this.ApiUserKey, accessToken);
		}

		public string GetAccessToken(string sApiUsername, string sApiPassword)
		{
			string request = String.Empty;
			request += "format=json";
			request += "&email="    + sApiUsername;
			request += "&password=" + sApiPassword;
			request += "&user_key=" + this.ApiUserKey;
			
			HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create("https://pi.pardot.com/api/login/version/4");
			objRequest.Method      = "POST";
			objRequest.Timeout     = 15000;  //15 seconds
			objRequest.Accept      = "*/*";
			objRequest.ContentType = "application/x-www-form-urlencoded";
			byte[] by = System.Text.Encoding.UTF8.GetBytes(request);
			objRequest.ContentLength = by.Length;
			objRequest.GetRequestStream().Write(by, 0, by.Length);
			
			string sAccessToken = String.Empty;
			JsonValue jsonValue = new JsonValue();
			using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
			{
				if ( objResponse != null )
				{
					if ( objResponse.StatusCode != HttpStatusCode.OK && objResponse.StatusCode != HttpStatusCode.Redirect )
					{
						throw(new Exception(objResponse.StatusCode + " " + objResponse.StatusDescription));
					}
					else
					{
						using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
						{
							string sResponse = readStream.ReadToEnd();
							jsonValue = JsonValue.Parse(sResponse);
							// {"@attributes":{"stat":"fail","version":1,"err_code":15},"err":"Login failed"}
							if ( jsonValue.ContainsName("err") )
							{
								string sError = jsonValue.GetValueOrDefault<string>("err");
								throw(new Exception(sError));
							}
							// {"@attributes":{"stat":"ok","version":1},"api_key":"46b2ae3b2af2439e0de2c7336f7e51ea","version":4}
							sAccessToken = jsonValue.GetValueOrDefault<string>("api_key");
						}
					}
				}
			}
			return sAccessToken;
		}
	}
}
