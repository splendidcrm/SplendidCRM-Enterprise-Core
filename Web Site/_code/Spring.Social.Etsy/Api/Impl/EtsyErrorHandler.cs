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

namespace Spring.Social.Etsy.Api.Impl
{
	class EtsyErrorHandler : DefaultResponseErrorHandler
	{
		private static readonly Encoding DEFAULT_CHARSET = new UTF8Encoding(false); // Remove byte Order Mask (BOM)

		public override void HandleError(Uri requestUri, HttpMethod requestMethod, HttpResponseMessage<byte[]> response)
		{
			int type = (int)response.StatusCode / 100;
			if (type == 4)
			{
				this.HandleClientErrors(requestUri, response);
			}
			else if (type == 5)
			{
				string errorDetails = DEFAULT_CHARSET.GetString(response.Body, 0, response.Body.Length);
				this.HandleServerErrors(response.StatusCode, errorDetails);
			}

			// if not otherwise handled, do default handling and wrap with EtsyApiException
			try
			{
				base.HandleError(requestUri, requestMethod, response);
			}
			catch (Exception ex)
			{
				string errorDetails = String.Empty;
				if ( response != null && response.Body != null )
				{
					errorDetails = DEFAULT_CHARSET.GetString(response.Body, 0, response.Body.Length);
				}
				errorDetails += "  " + requestUri.ToString();
				throw new EtsyApiException("Error consuming Etsy REST API. " + errorDetails, ex);
			}
		}

		private void HandleClientErrors(Uri requestUri, HttpResponseMessage<byte[]> response) 
		{
			JsonValue errorValue = this.ExtractErrorDetailsFromResponse(response);
			if (errorValue == null) 
			{
				return; // unexpected error body, can't be handled here
			}

			string errorText = null;
			if ( errorValue.ContainsName("error") )
			{
				// 04/28/2015 Paul.  The text is in a message property. 
				errorText = errorValue.GetValueOrDefault<string>("error");
				if ( errorText == "Resource not found" )
					errorText += "  " + requestUri.ToString();
				throw new EtsyApiException(errorText, EtsyApiError.ContactExists);
			}

			if ( response.StatusCode == HttpStatusCode.Unauthorized )
			{
				if ( errorText == "Could not authenticate you." )
				{
					throw new EtsyApiException("Authorization is required for the operation, but the API binding was created without authorization.", EtsyApiError.NotAuthorized);
				}
				else if ( errorText == "Could not authenticate with OAuth." )
				{
					throw new EtsyApiException("The authorization has been revoked.", EtsyApiError.NotAuthorized);
				}
				else
				{
					throw new EtsyApiException(errorText ?? response.StatusDescription, EtsyApiError.NotAuthorized);
				}
			}
			// 08/17/2016 Paul.  Provide more information with conflict error. 
			else if ( response.StatusCode == HttpStatusCode.Conflict )
			{
				throw new EtsyApiException(errorText, EtsyApiError.OperationNotPermitted);
			}
			else if ( response.StatusCode == HttpStatusCode.BadRequest )
			{
				throw new EtsyApiException(errorText, EtsyApiError.OperationNotPermitted);
			}
			else if ( response.StatusCode == HttpStatusCode.Forbidden )
			{
				throw new EtsyApiException(errorText, EtsyApiError.OperationNotPermitted);
			}
			else if ( response.StatusCode == HttpStatusCode.NotFound )
			{
				throw new EtsyApiException(errorText, EtsyApiError.ResourceNotFound);
			}
			else if ( response.StatusCode == (HttpStatusCode)420 )
			{
				throw new EtsyApiException("The rate limit has been exceeded.", EtsyApiError.RateLimitExceeded);
			}
		}

		private void HandleServerErrors(HttpStatusCode statusCode, string errorDetails)
		{
			if ( statusCode == HttpStatusCode.InternalServerError )
			{
				JsonValue errorValue = null;
				JsonValue.TryParse(errorDetails, out errorValue);
				if ( errorValue != null && !errorValue.IsNull && errorValue.ContainsName("error") && errorValue.ContainsName("error_description") )
				{
					string errorText = errorValue.GetValueOrDefault<string>("error_description");
					throw new EtsyApiException(errorText, EtsyApiError.Server);
				}
			}
			else if ( statusCode == HttpStatusCode.BadGateway )
			{
				throw new EtsyApiException("Etsy is down or is being upgraded.", EtsyApiError.ServerDown);
			}
			else if ( statusCode == HttpStatusCode.ServiceUnavailable )
			{
				throw new EtsyApiException("Etsy is overloaded with requests. Try again later.", EtsyApiError.ServerOverloaded);
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