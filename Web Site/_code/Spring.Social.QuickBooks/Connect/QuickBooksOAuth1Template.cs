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
using Spring.Social.OAuth1;
using System.Collections.Generic;
using System.Collections.Specialized;
using Spring.Rest.Client;
using Spring.Json;
using Spring.Http;
using Spring.Http.Converters;
using Spring.Http.Converters.Xml;
using Spring.Http.Converters.Json;

namespace Spring.Social.QuickBooks.Connect
{
	public class ReconnectRequest
	{
		public String OAuthToken        { get; set; }
		public String OAuthTokenSecret  { get; set; }
		public String ErrorMessage      { get; set; }
	}

	class ReconnectRequestDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ReconnectRequest obj = new ReconnectRequest();
			obj.OAuthToken       = json.GetValueOrDefault<String>("OAuthToken"      );
			obj.OAuthTokenSecret = json.GetValueOrDefault<String>("OAuthTokenSecret");
			obj.ErrorMessage     = json.GetValueOrDefault<String>("ErrorMessage"    );
			return obj;
		}
	}

	public class QuickBooksOAuth1Template : OAuth1Template
	{
		private Uri            reconnectUrl  ;
		private string         consumerKey   ;
		private string         consumerSecret;
		private SigningSupport signingSupport;
		private RestTemplate   restTemplate  ;

		public QuickBooksOAuth1Template(string consumerKey, string consumerSecret)
			: base(consumerKey, consumerSecret
				, "https://oauth.intuit.com/oauth/v1/get_request_token"
				, "https://workplace.intuit.com/Connect/Begin"
				, "https://appcenter.intuit.com/api/v1/authenticate"
				, "https://oauth.intuit.com/oauth/v1/get_access_token")
		{
			this.consumerKey    = consumerKey   ;
			this.consumerSecret = consumerSecret;
			this.reconnectUrl   = new Uri("https://appcenter.intuit.com/api/v1/connection/reconnect?format=json");
			this.signingSupport = new SigningSupport();
			this.restTemplate = new RestTemplate();
		}

		// http://stackoverflow.com/questions/21006518/how-to-test-intuit-reconnect-api
		// https://appcenter.intuit.com/Playground/OAuth/IA/
		// https://developer.intuit.com/docs/0100_accounting/0060_authentication_and_authorization/connect_from_within_your_app
		// https://developer.intuit.com/docs/0050_quickbooks_api/0020_authentication_and_authorization/oauth_management_api#/Reconnect
		public OAuthToken ReconnectAccessToken(AuthorizedRequestToken requestToken, NameValueCollection additionalParameters)
		{
			IDictionary<string, string> tokenParameters = new Dictionary<string, string>();
			HttpEntity request = CreateReconnectTokenRequest(this.reconnectUrl, tokenParameters, additionalParameters, requestToken.Secret);
			this.restTemplate.RequestInterceptors.Add(new OAuth1RequestInterceptor(consumerKey, consumerSecret, requestToken.Value, requestToken.Secret));

			JsonMapper jsonMapper = new JsonMapper();
			jsonMapper.RegisterDeserializer(typeof(ReconnectRequest), new ReconnectRequestDeserializer());
			
			IList<IHttpMessageConverter> messageConverters = new List<IHttpMessageConverter>();
			messageConverters.Add(new XmlDocumentHttpMessageConverter());
			messageConverters.Add(new SpringJsonHttpMessageConverter(jsonMapper));
			this.restTemplate.MessageConverters = messageConverters;
			
			string sOAuthToken       = String.Empty;
			string sOAuthTokenSecret = String.Empty;
			string sErrorMessage     = String.Empty;
			// 04/27/2015 Paul.  The problem with the json response was that the query string parameter was not set properly. 
			// https://developer.intuit.com/docs/95_legacy/qbd_v3/qbd_v3_reference/010_calling_data_services/00100_requests_and_responses/0010_requests#/Data_Formats
			if ( this.reconnectUrl.AbsoluteUri.Contains("format=json") )
			{
				ReconnectRequest req = this.restTemplate.Exchange<ReconnectRequest>(this.reconnectUrl, HttpMethod.GET, request).Body;
				sOAuthToken       = req.OAuthToken      ;
				sOAuthTokenSecret = req.OAuthTokenSecret;
				sErrorMessage     = req.ErrorMessage    ;
			}
			else
			{
				// 04/27/2015 Paul.  Could not get the json response to work, so just use the XML response. 
				XmlDocument xml = this.restTemplate.Exchange<XmlDocument>(this.reconnectUrl, HttpMethod.GET, request).Body;
				foreach ( XmlNode xNode in xml.DocumentElement.ChildNodes )
				{
					switch ( xNode.Name )
					{
						case "OAuthToken"      :  sOAuthToken       = xNode.InnerText;  break;
						case "OAuthTokenSecret":  sOAuthTokenSecret = xNode.InnerText;  break;
						case "ErrorMessage"    :  sErrorMessage     = xNode.InnerText;  break;
					}
				}
			}
			if ( !String.IsNullOrEmpty(sErrorMessage) )
				throw(new Exception(sErrorMessage));
			return new OAuthToken(sOAuthToken, sOAuthTokenSecret);
		}

		private HttpEntity CreateReconnectTokenRequest(Uri tokenUrl, IDictionary<string, string> tokenParameters, NameValueCollection additionalParameters, string tokenSecret)
		{
			HttpHeaders headers = new HttpHeaders();
			headers.Add("Authorization", this.signingSupport.BuildAuthorizationHeaderValue(tokenUrl, tokenParameters, additionalParameters, this.consumerKey, this.consumerSecret, tokenSecret));
			return new HttpEntity(null, headers);
		}
	}
}
