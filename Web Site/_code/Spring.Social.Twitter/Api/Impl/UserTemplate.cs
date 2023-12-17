#region License

/*
 * Copyright 2002-2012 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#endregion

using System;
using System.Net;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Threading.Tasks;

using Spring.Http;
using Spring.Rest.Client;

namespace Spring.Social.Twitter.Api.Impl
{
    /// <summary>
    /// Implementation of <see cref="IUserOperations"/>, providing binding to Twitters' user-oriented REST resources.
    /// </summary>
    /// <author>Craig Walls</author>
    /// <author>Bruno Baia (.NET)</author>
    class UserTemplate : AbstractTwitterOperations, IUserOperations
    {
        private RestTemplate restTemplate;

        public UserTemplate(RestTemplate restTemplate)
        {
            this.restTemplate = restTemplate;
        }

        #region IUserOperations Members

        public Task<TwitterProfile> GetUserProfileAsync() 
        {
		    return this.restTemplate.GetForObjectAsync<TwitterProfile>("account/verify_credentials.json");
	    }

        public Task<TwitterProfile> GetUserProfileAsync(string screenName) 
        {
            return this.restTemplate.GetForObjectAsync<TwitterProfile>(this.BuildUrl("users/show.json", "screen_name", screenName));
	    }

        public Task<TwitterProfile> GetUserProfileAsync(long userId) 
        {
            return this.restTemplate.GetForObjectAsync<TwitterProfile>(this.BuildUrl("users/show.json", "user_id", userId.ToString()));
	    }

        public Task<IList<TwitterProfile>> GetUsersAsync(params long[] userIds) 
        {
		    string joinedIds = ArrayUtils.Join(userIds);
		    return this.restTemplate.GetForObjectAsync<IList<TwitterProfile>>(this.BuildUrl("users/lookup.json", "user_id", joinedIds));
	    }

        public Task<IList<TwitterProfile>> GetUsersAsync(params string[] screenNames) 
        {
		    string joinedScreenNames = ArrayUtils.Join(screenNames);
		    return this.restTemplate.GetForObjectAsync<IList<TwitterProfile>>(this.BuildUrl("users/lookup.json", "screen_name", joinedScreenNames));
	    }

        public Task<IList<TwitterProfile>> SearchForUsersAsync(string query) 
        {
		    return this.SearchForUsersAsync(query, 1, 20);
	    }

        public Task<IList<TwitterProfile>> SearchForUsersAsync(string query, int page, int pageSize) 
        {
		    NameValueCollection parameters = PagingUtils.BuildPagingParametersWithPerPage(page, pageSize, 0, 0);
		    parameters.Add("q", query);
		    return this.restTemplate.GetForObjectAsync<IList<TwitterProfile>>(this.BuildUrl("users/search.json", parameters));
	    }

        public Task<IList<SuggestionCategory>> GetSuggestionCategoriesAsync() 
        {
		    return this.restTemplate.GetForObjectAsync<IList<SuggestionCategory>>("users/suggestions.json");
	    }

        public Task<IList<TwitterProfile>> GetSuggestionsAsync(String slug) 
        {
		    return this.restTemplate.GetForObjectAsync<IList<TwitterProfile>>("users/suggestions/{slug}.json", slug);
	    }

        public Task<IList<RateLimitStatus>> GetRateLimitStatusAsync(params string[] resources) 
        {
            NameValueCollection parameters = new NameValueCollection();
            if (resources.Length > 0)
            {
                parameters.Add("resources", ArrayUtils.Join(resources));
            }
            return this.restTemplate.GetForObjectAsync<IList<RateLimitStatus>>(this.BuildUrl("application/rate_limit_status.json", parameters));
	    }
        #endregion
    }
}
