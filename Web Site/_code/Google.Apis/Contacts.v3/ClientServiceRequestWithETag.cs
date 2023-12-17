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
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.IO;
using System.Text;
using System.Threading;
using System.Diagnostics;

using Google.Apis.Services;
using Google.Apis.Http;
using Google.Apis.Util;
using Google.Apis.Discovery;
using Google.Apis.Requests;
using Google.Apis.Requests.Parameters;

namespace Google.Apis.Contacts.v3
{
	public abstract class ClientServiceRequestWithETag<TResponse>
	{
		private readonly IClientService service;

		#region IClientServiceRequest Properties
		public ETagAction ETagAction { get; set; }
		public string     ETag       { get; set; }
		public abstract string     MethodName { get; }
		public abstract string     RestPath   { get; }
		public abstract string     HttpMethod { get; }

		public IDictionary<string, IParameter> RequestParameters { get; private set; }
		public IClientService                  Service           { get { return service; } }
		#endregion

		protected ClientServiceRequestWithETag(IClientService service)
		{
			this.service = service;
		}

		protected virtual void InitParameters()
		{
			RequestParameters = new Dictionary<string, IParameter>();
		}

		#region Execution
		public TResponse Execute()
		{
			return Execute(CancellationToken.None);
		}

		public TResponse Execute(CancellationToken cancellationToken)
		{
			using (var response = ExecuteUnparsed(cancellationToken) )
			{
				cancellationToken.ThrowIfCancellationRequested();
				return ParseResponse(response);
			}
		}

		#region Helpers
		private HttpResponseMessage ExecuteUnparsed(CancellationToken cancellationToken)
		{
			using ( var request = CreateRequest() )
			{
				return service.HttpClient.SendAsync(request, cancellationToken).Result;
			}
		}

		/// <summary>Parses the response and deserialize the content into the requested response object. </summary>
		private TResponse ParseResponse(HttpResponseMessage response)
		{
			if (response.IsSuccessStatusCode)
			{
				return service.DeserializeResponse<TResponse>(response).Result;
			}
			// 09/12/2015 Paul.  The Contacts API is returning HTML on error instead of JSON, so we have to handle differently. 
			var error = DeserializeError(response);
			throw new GoogleApiException(service.Name, error.ToString())
			{
				HttpStatusCode = response.StatusCode
			};
		}

		public RequestError DeserializeError(HttpResponseMessage response)
		{
			StandardResponse<object> errorResponse = null;
			try
			{
				var str = response.Content.ReadAsStringAsync().Result;
				if ( str.StartsWith("<html>") )
				{
					errorResponse = new StandardResponse<object>();
					errorResponse.Error = new RequestError();
					errorResponse.Error.Message = response.ReasonPhrase;
				}
				else if ( !str.StartsWith("{") )
				{
					errorResponse = new StandardResponse<object>();
					errorResponse.Error = new RequestError();
					errorResponse.Error.Message = str;
				}
				else
				{
					errorResponse = service.Serializer.Deserialize<StandardResponse<object>>(str);
					if ( errorResponse.Error == null )
					{
						throw new GoogleApiException(service.Name, "error response is null");
					}
				}
			}
			catch (Exception ex)
			{
				// exception will be thrown in case the response content is empty or it can't be deserialized to 
				// Standard response (which contains data and error properties)
				throw new GoogleApiException(service.Name, "An Error occurred, but the error response could not be deserialized", ex);
			}
			return errorResponse.Error;
		}

		#endregion

		#endregion

		public HttpRequestMessage CreateRequest(Nullable<bool> overrideGZipEnabled = null)
		{
			var    builder = CreateBuilder();
			var    request = builder.CreateRequest();
			object body    = GetBody();
			request.SetRequestSerailizedContent(service, body, overrideGZipEnabled.HasValue ? overrideGZipEnabled.Value : service.GZipEnabled);
			AddETag(request);
			return request;
		}

		private RequestBuilder CreateBuilder()
		{
			var builder = new RequestBuilder()
			{
				BaseUri = new Uri(Service.BaseUri),
				Path = RestPath,
				Method = HttpMethod,
			};

			builder.AddParameter(RequestParameterType.Query, "key", service.ApiKey);
			var parameters = ParameterUtils.CreateParameterDictionary(this);
			AddParameters(builder, ParameterCollection.FromDictionary(parameters));
			return builder;
		}

		protected string GenerateRequestUri()
		{
			return CreateBuilder().BuildUri().ToString();
		}

		protected virtual object GetBody()
		{
			return null;
		}

		#region ETag

		private void AddETag(HttpRequestMessage request)
		{
			// 09/12/2015 Paul.  Body should not be required to use ETag. 
			string etag = String.Empty;
			IDirectResponseSchema body = GetBody() as IDirectResponseSchema;
			if ( body != null && !string.IsNullOrEmpty(body.ETag) )
				etag = body.ETag;
			else
				etag = this.ETag;
			if ( !String.IsNullOrEmpty(this.ETag) )
			{
				ETagAction action = (ETagAction == ETagAction.Default ? GetDefaultETagAction(HttpMethod) : ETagAction);
				try
				{
					switch ( action )
					{
						case ETagAction.IfMatch:
							// 09/12/2015 Paul.  * is special and should not be quoted. 
							if ( etag == "*" )
								request.Headers.Add("If-Match", etag);
							else
								request.Headers.IfMatch.Add(new EntityTagHeaderValue(etag));
							break;
						case ETagAction.IfNoneMatch:
							request.Headers.IfNoneMatch.Add(new EntityTagHeaderValue(etag));
							break;
					}
				}
				catch (FormatException ex)
				{
					Debug.WriteLine(String.Format("Can't set {0}. Etag is: {1}. {2}", action, etag, ex.Message));
				}
			}
		}

		public static ETagAction GetDefaultETagAction(string httpMethod)
		{
			switch ( httpMethod )
			{
				case HttpConsts.Get:
					return ETagAction.IfNoneMatch;
				case HttpConsts.Put:
				case HttpConsts.Post:
				case HttpConsts.Patch:
				case HttpConsts.Delete:
					return ETagAction.IfMatch;

				default:
					return ETagAction.Ignore;
			}
		}
		#endregion

		#region Parameters

		private void AddParameters(RequestBuilder requestBuilder, ParameterCollection inputParameters)
		{
			foreach (var parameter in inputParameters)
			{
				IParameter parameterDefinition = null;
				if ( !RequestParameters.TryGetValue(parameter.Key, out parameterDefinition) )
				{
					throw new GoogleApiException(Service.Name,
						String.Format("Invalid parameter \"{0}\" was specified", parameter.Key));
				}

				string value = parameter.Value;
				string error = String.Empty;
				if ( !ParameterValidator.ValidateParameter(parameterDefinition, value, out error) )
				{
					throw new GoogleApiException(Service.Name,
						string.Format("Parameter validation failed for \"{0}\": {1}", parameterDefinition.Name, error));
				}

				if ( value == null ) // If the parameter is null, use the default value.
				{
					value = parameterDefinition.DefaultValue;
				}

				switch (parameterDefinition.ParameterType)
				{
					case "path":
						requestBuilder.AddParameter(RequestParameterType.Path, parameter.Key, value);
						break;
					case "query":
						if ( !Object.Equals(value, parameterDefinition.DefaultValue) || parameterDefinition.IsRequired )
						{
							requestBuilder.AddParameter(RequestParameterType.Query, parameter.Key, value);
						}
						break;
					default:
						throw new GoogleApiException(service.Name,
							string.Format("Unsupported parameter type \"{0}\" for \"{1}\"",
							parameterDefinition.ParameterType, parameterDefinition.Name));
				}
			}

			foreach (var parameter in RequestParameters.Values)
			{
				if (parameter.IsRequired && !inputParameters.ContainsKey(parameter.Name))
				{
					throw new GoogleApiException(service.Name,
						string.Format("Parameter \"{0}\" is missing", parameter.Name));
				}
			}
		}
		#endregion
	}
}

