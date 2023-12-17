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
using System.Net;
using System.Text;

using Spring.Http;
using Spring.Rest.Client;
using Spring.Rest.Client.Support;

namespace Spring.Social.Watson.Api.Impl
{
	class WatsonErrorHandler : DefaultResponseErrorHandler
	{
		private static readonly Encoding DEFAULT_CHARSET = new UTF8Encoding(false); // Remove byte Order Mask (BOM)

		public override void HandleError(Uri requestUri, HttpMethod requestMethod, HttpResponseMessage<byte[]> response)
		{
			int type = (int)response.StatusCode / 100;
			if ( type == 4 || type == 5 )
			{
				this.HandleClientErrors(response);
			}

			// if not otherwise handled, do default handling and wrap with WatsonApiException
			try
			{
				base.HandleError(requestUri, requestMethod, response);
			}
			catch (Exception ex)
			{
				throw new WatsonApiException("Error consuming Watson REST API.", ex);
			}
		}

		private void HandleClientErrors(HttpResponseMessage<byte[]> response) 
		{
			if ( response.Body == null )
			{
				return; // unexpected error body, can't be handled here
			}
			MediaType contentType = response.Headers.ContentType;
			Encoding charset = (contentType != null && contentType.CharSet != null) ? contentType.CharSet : DEFAULT_CHARSET;
			string sBody = charset.GetString(response.Body, 0, response.Body.Length);

			string sError = String.Empty;
			if ( sBody.StartsWith("<html>") )
			{
				sError = sBody;
				sError = sError.Replace("<html>"  , String.Empty);
				sError = sError.Replace("</html>" , String.Empty);
				sError = sError.Replace("<style>" , String.Empty);
				sError = sError.Replace("</style>", String.Empty);
				sError = sError.Replace("<head>"  , String.Empty);
				sError = sError.Replace("</head>" , String.Empty);
				sError = sError.Replace("<body>"  , String.Empty);
				sError = sError.Replace("</body>" , String.Empty);
				sError = sError.Replace("<HR size=\"1\" noshade=\"noshade\">", String.Empty);
			}
			else
			{
				XmlDocument xml = new XmlDocument();
				xml.LoadXml(sBody);
				XmlNode xBody = xml.DocumentElement.SelectSingleNode("Body");
				if ( xBody != null )
				{
					XmlNode xResult = xBody.SelectSingleNode("RESULT");
					if ( xResult != null )
					{
						XmlNode xSuccess = xResult.SelectSingleNode("SUCCESS");
						if ( xSuccess != null )
						{
							if ( xSuccess.InnerText.ToLower() == "false" )
							{
								sError = XmlUtils.SelectSingleNode(xBody, "Fault/FaultString");
							}
						}
						else
						{
							sError = "Response Body/RESULT does not contain a SUCCESS tag." + xml.OuterXml;
						}
					}
					else
					{
						sError = "Response Body does not contain a RESULT tag." + xml.OuterXml;
					}
				}
				else
				{
					sError = "Response does not start with a Body tag. " + xml.OuterXml;
				}
			}
			if ( !Sql.IsEmptyString(sError) )
				throw(new Exception(sError));

			string errorText = null;
			if ( response.StatusCode == HttpStatusCode.Unauthorized )
			{
				if ( errorText == "Could not authenticate you." )
				{
					throw new WatsonApiException("Authorization is required for the operation, but the API binding was created without authorization.", WatsonApiError.NotAuthorized);
				}
				else if ( errorText == "Could not authenticate with OAuth." )
				{
					throw new WatsonApiException("The authorization has been revoked.", WatsonApiError.NotAuthorized);
				}
				else
				{
					throw new WatsonApiException(errorText ?? response.StatusDescription, WatsonApiError.NotAuthorized);
				}
			}
			else if ( response.StatusCode == HttpStatusCode.BadRequest )
			{
				throw new WatsonApiException(errorText, WatsonApiError.OperationNotPermitted);
			}
			else if ( response.StatusCode == HttpStatusCode.Forbidden )
			{
				throw new WatsonApiException(errorText, WatsonApiError.OperationNotPermitted);
			}
			else if ( response.StatusCode == HttpStatusCode.NotFound )
			{
				throw new WatsonApiException(errorText, WatsonApiError.ResourceNotFound);
			}
			else if ( response.StatusCode == (HttpStatusCode)420 )
			{
				throw new WatsonApiException("The rate limit has been exceeded.", WatsonApiError.RateLimitExceeded);
			}
		}
	}
}
