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
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Threading.Tasks;

using Spring.Rest.Client;

namespace Spring.Social.Twitter.Api.Impl
{
    /// <summary>
    /// Implementation of <see cref="ISearchOperations"/>, providing a binding to Twitter's search and trend-oriented REST resources.
    /// </summary>
    /// <author>Craig Walls</author>
    /// <author>Bruno Baia (.NET)</author>
    class SearchTemplate : AbstractTwitterOperations, ISearchOperations
    {
        private RestTemplate restTemplate;

        public SearchTemplate(RestTemplate restTemplate)
        {
            this.restTemplate = restTemplate;
        }

        #region ISearchOperations Members

        public Task<SearchResults> SearchAsync(string query) 
        {
            return this.SearchAsync(query, 0, 0, 0);
	    }

        public Task<SearchResults> SearchAsync(string query, int count) 
        {
            return this.SearchAsync(query, count, 0, 0);
	    }

        public Task<SearchResults> SearchAsync(string query, int count, long sinceId, long maxId) 
        {
            NameValueCollection parameters = BuildSearchParameters(query, count, sinceId, maxId);
            return this.restTemplate.GetForObjectAsync<SearchResults>(this.BuildUrl("search/tweets.json", parameters));
	    }

        public Task<IList<SavedSearch>> GetSavedSearchesAsync() 
        {
            return this.restTemplate.GetForObjectAsync<IList<SavedSearch>>("saved_searches/list.json");
	    }

        public Task<SavedSearch> GetSavedSearchAsync(long searchId) 
        {
            return this.restTemplate.GetForObjectAsync<SavedSearch>("saved_searches/show/{searchId}.json", searchId);
	    }

        public Task<SavedSearch> CreateSavedSearchAsync(string query) 
        {		
		    NameValueCollection request = new NameValueCollection();
		    request.Add("query", query);
            return this.restTemplate.PostForObjectAsync<SavedSearch>("saved_searches/create.json", request);
	    }

        public Task<SavedSearch> DeleteSavedSearchAsync(long searchId) 
        {
            NameValueCollection request = new NameValueCollection();
            return this.restTemplate.PostForObjectAsync<SavedSearch>("saved_searches/destroy/{searchId}.json", request, searchId);
	    }

        public Task<Trends> GetTrendsAsync(long whereOnEarthId) 
        {
            return this.GetTrendsAsync(whereOnEarthId, false);
	    }

        public Task<Trends> GetTrendsAsync(long whereOnEarthId, bool excludeHashtags)
        {
            NameValueCollection parameters = new NameValueCollection();
            parameters.Add("id", whereOnEarthId.ToString());
            if (excludeHashtags)
            {
                parameters.Add("exclude", "hashtags");
            }
            return this.restTemplate.GetForObjectAsync<Trends>(this.BuildUrl("trends/place.json", parameters));
        }
        #endregion

        #region Private Methods

        private static NameValueCollection BuildSearchParameters(string query, int count, long sinceId, long maxId)
        {
            NameValueCollection parameters = new NameValueCollection();
            parameters.Add("q", query);
            if (count > 0)
            {
                parameters.Add("count", count.ToString());
            }
            if (sinceId > 0)
            {
                parameters.Add("since_id", sinceId.ToString());
            }
            if (maxId > 0)
            {
                parameters.Add("max_id", maxId.ToString());
            }
            return parameters;
        }

        #endregion
    }
}
