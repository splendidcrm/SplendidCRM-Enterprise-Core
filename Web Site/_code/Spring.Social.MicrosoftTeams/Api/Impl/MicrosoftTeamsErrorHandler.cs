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
using System.Net;
using System.Text;

using Spring.Json;
using Spring.Http;
using Spring.Rest.Client;
using Spring.Rest.Client.Support;

namespace Spring.Social.MicrosoftTeams.Api.Impl
{
	class MicrosoftTeamsErrorHandler : DefaultResponseErrorHandler
	{
		private static readonly Encoding DEFAULT_CHARSET = new UTF8Encoding(false); // Remove byte Order Mask (BOM)

		public override void HandleError(Uri requestUri, HttpMethod requestMethod, HttpResponseMessage<byte[]> response)
		{
			int type = (int)response.StatusCode / 100;
			if (type == 4)
			{
				this.HandleClientErrors(response);
			}
			else if (type == 5)
			{
				string errorDetails = DEFAULT_CHARSET.GetString(response.Body, 0, response.Body.Length);
				this.HandleServerErrors(response.StatusCode, errorDetails);
			}

			// if not otherwise handled, do default handling and wrap with MicrosoftTeamsApiException
			try
			{
				base.HandleError(requestUri, requestMethod, response);
			}
			catch (Exception ex)
			{
				throw new MicrosoftTeamsApiException("Error consuming MicrosoftTeams REST API.", ex);
			}
		}

		private void HandleClientErrors(HttpResponseMessage<byte[]> response) 
		{
			JsonValue body = this.ExtractErrorDetailsFromResponse(response);
			if ( body == null)  
			{
				return; // unexpected error body, can't be handled here
			}

			string errorText = null;
			if ( body.ContainsName("error") )
			{
				JsonValue errorValue = body.GetValue("error");
				// 09/03/2020 Paul.  Message is in the debug_codes. 
				// {"error": {"code": "UnableToDeserializePostBody","message": "were unable to deserialize ","innerError": {"date": "2020-12-10T08:22:15","request-id": "9a47ee37-b85b-4302-96c0-a001bf1a288c","client-request-id": "56903f12-a757-2728-d7c1-68d07d8fc030"}}}
				if ( errorValue.ContainsName("message") )
				{
					errorText = errorValue.GetValueOrDefault<string>("message");
				}
				if ( Sql.IsEmptyString(errorText) )
				{
					errorText = errorValue.GetValueOrDefault<string>("code");
					if ( errorText == "404" )
						errorText += " - Not Found";
				}
				throw new MicrosoftTeamsApiException(errorText, MicrosoftTeamsApiError.ContactExists);
			}

			if ( response.StatusCode == HttpStatusCode.Unauthorized )
			{
				if ( errorText == "Could not authenticate you." )
				{
					throw new MicrosoftTeamsApiException("Authorization is required for the operation, but the API binding was created without authorization.", MicrosoftTeamsApiError.NotAuthorized);
				}
				else if ( errorText == "Could not authenticate with OAuth." )
				{
					throw new MicrosoftTeamsApiException("The authorization has been revoked.", MicrosoftTeamsApiError.NotAuthorized);
				}
				else
				{
					throw new MicrosoftTeamsApiException(errorText ?? response.StatusDescription, MicrosoftTeamsApiError.NotAuthorized);
				}
			}
			else if ( response.StatusCode == HttpStatusCode.BadRequest )
			{
				throw new MicrosoftTeamsApiException(errorText, MicrosoftTeamsApiError.OperationNotPermitted);
			}
			else if ( response.StatusCode == HttpStatusCode.Forbidden )
			{
				throw new MicrosoftTeamsApiException(errorText, MicrosoftTeamsApiError.OperationNotPermitted);
			}
			else if ( response.StatusCode == HttpStatusCode.NotFound )
			{
				throw new MicrosoftTeamsApiException(errorText, MicrosoftTeamsApiError.ResourceNotFound);
			}
			else if ( response.StatusCode == (HttpStatusCode)420 )
			{
				throw new MicrosoftTeamsApiException("The rate limit has been exceeded.", MicrosoftTeamsApiError.RateLimitExceeded);
			}
		}

		private void HandleServerErrors(HttpStatusCode statusCode, string errorDetails)
		{
			if ( statusCode == HttpStatusCode.InternalServerError )
			{
				JsonValue body = null;
				JsonValue.TryParse(errorDetails, out body);
				if ( body.ContainsName("error") )
				{
					JsonValue errorValue = body.GetValue("error");
					// {"error": {"code": "UnableToDeserializePostBody","message": "were unable to deserialize ","innerError": {"date": "2020-12-10T08:22:15","request-id": "9a47ee37-b85b-4302-96c0-a001bf1a288c","client-request-id": "56903f12-a757-2728-d7c1-68d07d8fc030"}}}
					if ( errorValue.ContainsName("message") )
					{
						string errorText = errorValue.GetValueOrDefault<string>("message");
						throw new MicrosoftTeamsApiException(errorText, MicrosoftTeamsApiError.Server);
					}
				}
				throw new MicrosoftTeamsApiException(errorDetails, MicrosoftTeamsApiError.Server);
			}
			else if ( statusCode == HttpStatusCode.BadGateway )
			{
				throw new MicrosoftTeamsApiException("MicrosoftTeams is down or is being upgraded.", MicrosoftTeamsApiError.ServerDown);
			}
			else if ( statusCode == HttpStatusCode.ServiceUnavailable )
			{
				throw new MicrosoftTeamsApiException("MicrosoftTeams is overloaded with requests. Try again later.", MicrosoftTeamsApiError.ServerOverloaded);
			}
		}

		private JsonValue ExtractErrorDetailsFromResponse(HttpResponseMessage<byte[]> response)
		{
			if ( response.Body == null )
			{
				return null;
			}
			MediaType contentType = response.Headers.ContentType;
			Encoding charset = (contentType != null && contentType.CharSet != null) ? contentType.CharSet : DEFAULT_CHARSET;
			string errorDetails = charset.GetString(response.Body, 0, response.Body.Length);

			JsonValue result;
			return JsonValue.TryParse(errorDetails, out result) ? result : null;
		}
	}
}