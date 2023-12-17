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

namespace Spring.Social.Shopify.Api.Impl
{
	class ShopifyErrorHandler : DefaultResponseErrorHandler
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

			// if not otherwise handled, do default handling and wrap with ShopifyApiException
			try
			{
				base.HandleError(requestUri, requestMethod, response);
			}
			catch (Exception ex)
			{
				throw new ShopifyApiException("Error consuming Shopify REST API.", ex);
			}
		}

		private void HandleClientErrors(HttpResponseMessage<byte[]> response) 
		{
			JsonValue errorValue = this.ExtractErrorDetailsFromResponse(response);
			if (errorValue == null) 
			{
				return; // unexpected error body, can't be handled here
			}

			string errorText = null;
			if ( errorValue.ContainsName("errors") )
			{
				JsonValue errors = errorValue.GetValue("errors");
				if ( errors.ContainsName("query") )
				{
					errorText = errors.GetValueOrDefault<string>("query");
					throw new ShopifyApiException(errorText, ShopifyApiError.ContactExists);
				}
			}

			if ( response.StatusCode == HttpStatusCode.Unauthorized )
			{
				if ( errorText == "Could not authenticate you." )
				{
					throw new ShopifyApiException("Authorization is required for the operation, but the API binding was created without authorization.", ShopifyApiError.NotAuthorized);
				}
				else if ( errorText == "Could not authenticate with OAuth." )
				{
					throw new ShopifyApiException("The authorization has been revoked.", ShopifyApiError.NotAuthorized);
				}
				else
				{
					throw new ShopifyApiException(errorText ?? response.StatusDescription, ShopifyApiError.NotAuthorized);
				}
			}
			// 08/17/2016 Paul.  Provide more information with conflict error. 
			else if ( response.StatusCode == HttpStatusCode.Conflict )
			{
				throw new ShopifyApiException(errorText, ShopifyApiError.OperationNotPermitted);
			}
			else if ( response.StatusCode == HttpStatusCode.BadRequest )
			{
				throw new ShopifyApiException(errorText, ShopifyApiError.OperationNotPermitted);
			}
			else if ( response.StatusCode == HttpStatusCode.Forbidden )
			{
				throw new ShopifyApiException(errorText, ShopifyApiError.OperationNotPermitted);
			}
			else if ( response.StatusCode == HttpStatusCode.NotFound )
			{
				throw new ShopifyApiException(errorText, ShopifyApiError.ResourceNotFound);
			}
			else if ( response.StatusCode == (HttpStatusCode)420 )
			{
				throw new ShopifyApiException("The rate limit has been exceeded.", ShopifyApiError.RateLimitExceeded);
			}
		}

		private void HandleServerErrors(HttpStatusCode statusCode, string errorDetails)
		{
			if ( statusCode == HttpStatusCode.InternalServerError )
			{
				JsonValue errorValue = null;
				JsonValue.TryParse(errorDetails, out errorValue);
				if ( errorValue != null && !errorValue.IsNull && errorValue.GetValueOrDefault<string>("status") == "error" )
				{
					// 04/28/2015 Paul.  The text is in a message property. 
					string errorText = errorValue.GetValueOrDefault<string>("message");
					if ( errorValue.ContainsName("validationResults") )
					{
						JsonValue validationResults = errorValue.GetValue("validationResults");
						if ( validationResults.IsArray )
						{
							if ( !Sql.IsEmptyString(errorText) )
								errorText += "." + ControlChars.CrLf;
							foreach ( JsonValue itemValue in validationResults.GetValues() )
							{
								string sFieldName         = itemValue.GetValueOrDefault<string>("name"   );
								string sValidationMessage = itemValue.GetValueOrDefault<string>("message");
								errorText += sFieldName + ": " + sValidationMessage + ControlChars.CrLf;
							}
						}
					}
					throw new ShopifyApiException(errorText, ShopifyApiError.Server);
				}
				else if ( errorValue != null && !errorValue.IsNull && errorValue.ContainsName("error_msg") )
				{
					string errorText = errorValue.GetValue<string>("error_msg");
					throw new ShopifyApiException(errorText, ShopifyApiError.Server);
				}
				else
				{
					//throw new ShopifyApiException("Something is broken at Shopify. Please see http://developer.Shopify.com/ to report the issue.", ShopifyApiError.Server);
				}
			}
			else if ( statusCode == HttpStatusCode.BadGateway )
			{
				throw new ShopifyApiException("Shopify is down or is being upgraded.", ShopifyApiError.ServerDown);
			}
			else if ( statusCode == HttpStatusCode.ServiceUnavailable )
			{
				throw new ShopifyApiException("Shopify is overloaded with requests. Try again later.", ShopifyApiError.ServerOverloaded);
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