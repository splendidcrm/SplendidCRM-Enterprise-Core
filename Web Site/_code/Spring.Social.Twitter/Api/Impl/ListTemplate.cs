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
using System.Threading;
using System.Threading.Tasks;

using Spring.Http;
using Spring.Rest.Client;

namespace Spring.Social.Twitter.Api.Impl
{
    /// <summary>
    /// Implementation of <see cref="IListOperations"/>, providing a binding to Twitter's list-oriented REST resources.
    /// </summary>
    /// <author>Craig Walls</author>
    /// <author>Bruno Baia (.NET)</author>
    class ListTemplate : AbstractTwitterOperations, IListOperations
    {
        private RestTemplate restTemplate;

        public ListTemplate(RestTemplate restTemplate)
        {
            this.restTemplate = restTemplate;
        }

        #region IListOperations Members

        public Task<IList<UserList>> GetListsAsync()
        {
            return this.restTemplate.GetForObjectAsync<IList<UserList>>("lists/list.json");
        }

        public Task<IList<UserList>> GetListsAsync(long userId) 
        {
            return this.restTemplate.GetForObjectAsync<IList<UserList>>(this.BuildUrl("lists/list.json", "user_id", userId.ToString()));
	    }

        public Task<IList<UserList>> GetListsAsync(string screenName) 
        {
            return this.restTemplate.GetForObjectAsync<IList<UserList>>(this.BuildUrl("lists/list.json", "screen_name", screenName));
	    }

        public Task<UserList> GetListAsync(long listId) 
        {
            return this.restTemplate.GetForObjectAsync<UserList>(this.BuildUrl("lists/show.json", "list_id", listId.ToString()));
	    }

        public Task<UserList> GetListAsync(string screenName, string listSlug) 
        {
		    NameValueCollection parameters = new NameValueCollection();
		    parameters.Add("owner_screen_name", screenName);
		    parameters.Add("slug", listSlug);
            return this.restTemplate.GetForObjectAsync<UserList>(this.BuildUrl("lists/show.json", parameters));
	    }

        public Task<IList<Tweet>> GetListStatusesAsync(long listId) 
        {
            return this.GetListStatusesAsync(listId, 0, 0, 0);
	    }

        public Task<IList<Tweet>> GetListStatusesAsync(long listId, int count) 
        {
            return this.GetListStatusesAsync(listId, count, 0, 0);
	    }

        public Task<IList<Tweet>> GetListStatusesAsync(long listId, int count, long sinceId, long maxId) 
        {
		    NameValueCollection parameters = PagingUtils.BuildPagingParametersWithCount(count, sinceId, maxId);
		    parameters.Add("list_id", listId.ToString());
            return this.restTemplate.GetForObjectAsync<IList<Tweet>>(this.BuildUrl("lists/statuses.json", parameters));
	    }

        public Task<IList<Tweet>> GetListStatusesAsync(string screenName, string listSlug) 
        {
            return this.GetListStatusesAsync(screenName, listSlug, 0, 0, 0);
	    }

        public Task<IList<Tweet>> GetListStatusesAsync(string screenName, string listSlug, int count) 
        {
            return this.GetListStatusesAsync(screenName, listSlug, count, 0, 0);
	    }

        public Task<IList<Tweet>> GetListStatusesAsync(string screenName, string listSlug, int count, long sinceId, long maxId) 
        {
		    NameValueCollection parameters = PagingUtils.BuildPagingParametersWithCount(count, sinceId, maxId);
		    parameters.Add("owner_screen_name", screenName);
		    parameters.Add("slug", listSlug);
            return this.restTemplate.GetForObjectAsync<IList<Tweet>>(this.BuildUrl("lists/statuses.json", parameters));
	    }

        public Task<UserList> CreateListAsync(string name, string description, bool isPublic) 
        {	
		    NameValueCollection request = BuildListParameters(name, description, isPublic);
            return this.restTemplate.PostForObjectAsync<UserList>("lists/create.json", request);
	    }

        public Task<UserList> UpdateListAsync(long listId, string name, string description, bool isPublic) 
        {
		    NameValueCollection request = BuildListParameters(name, description, isPublic);
		    request.Add("list_id", listId.ToString());
            return this.restTemplate.PostForObjectAsync<UserList>("lists/update.json", request);
	    }

        public Task<UserList> DeleteListAsync(long listId) 
        {
            NameValueCollection request = new NameValueCollection();
            request.Add("list_id", listId.ToString());
            return this.restTemplate.PostForObjectAsync<UserList>("lists/destroy.json", request);
	    }

        public Task<IList<TwitterProfile>> GetListMembersAsync(long listId) 
        {
            return this.restTemplate.GetForObjectAsync<IList<TwitterProfile>>(this.BuildUrl("lists/members.json", "list_id", listId.ToString()));
	    }

        public Task<IList<TwitterProfile>> GetListMembersAsync(string screenName, string listSlug) 
        {
		    NameValueCollection parameters = new NameValueCollection();
		    parameters.Add("owner_screen_name", screenName);
		    parameters.Add("slug", listSlug);
            return this.restTemplate.GetForObjectAsync<IList<TwitterProfile>>(this.BuildUrl("lists/members.json", parameters));
	    }

        public Task<UserList> AddToListAsync(long listId, params long[] newMemberIds) 
        {
		    NameValueCollection request = new NameValueCollection();
		    request.Add("user_id", ArrayUtils.Join(newMemberIds));
		    request.Add("list_id", listId.ToString());
            return this.restTemplate.PostForObjectAsync<UserList>("lists/members/create_all.json", request);
	    }

        public Task<UserList> AddToListAsync(long listId, params string[] newMemberScreenNames) 
        {
		    NameValueCollection request = new NameValueCollection();
		    request.Add("screen_name", ArrayUtils.Join(newMemberScreenNames));
		    request.Add("list_id", listId.ToString());
            return this.restTemplate.PostForObjectAsync<UserList>("lists/members/create_all.json", request);
	    }

        public Task RemoveFromListAsync(long listId, long memberId) 
        {
		    NameValueCollection request = new NameValueCollection();
		    request.Add("user_id", memberId.ToString()); 
		    request.Add("list_id", listId.ToString());
            return this.restTemplate.PostForMessageAsync("lists/members/destroy.json", request);
	    }

        public Task RemoveFromListAsync(long listId, string memberScreenName) 
        {
		    NameValueCollection request = new NameValueCollection();
		    request.Add("screen_name", memberScreenName); 
		    request.Add("list_id", listId.ToString());
            return this.restTemplate.PostForMessageAsync("lists/members/destroy.json", request);
	    }

        public Task<IList<TwitterProfile>> GetListSubscribersAsync(long listId) 
        {
            return this.restTemplate.GetForObjectAsync<IList<TwitterProfile>>(this.BuildUrl("lists/subscribers.json", "list_id", listId.ToString()));
	    }

        public Task<IList<TwitterProfile>> GetListSubscribersAsync(string screenName, string listSlug) 
        {
		    NameValueCollection parameters = new NameValueCollection();
		    parameters.Add("owner_screen_name", screenName);
		    parameters.Add("slug", listSlug);
            return this.restTemplate.GetForObjectAsync<IList<TwitterProfile>>(this.BuildUrl("lists/subscribers.json", parameters));
	    }

        public Task<UserList> SubscribeAsync(long listId) 
        {
		    NameValueCollection request = new NameValueCollection();
		    request.Add("list_id", listId.ToString());
            return this.restTemplate.PostForObjectAsync<UserList>("lists/subscribers/create.json", request);
	    }

        public Task<UserList> SubscribeAsync(string ownerScreenName, string listSlug) 
        {
		    NameValueCollection request = new NameValueCollection();
		    request.Add("owner_screen_name", ownerScreenName);
		    request.Add("slug", listSlug);
            return this.restTemplate.PostForObjectAsync<UserList>("lists/subscribers/create.json", request);
	    }

        public Task<UserList> UnsubscribeAsync(long listId) 
        {
		    NameValueCollection request = new NameValueCollection();
		    request.Add("list_id", listId.ToString());
            return this.restTemplate.PostForObjectAsync<UserList>("lists/subscribers/destroy.json", request);
	    }

        public Task<UserList> UnsubscribeAsync(string ownerScreenName, string listSlug) 
        {
		    NameValueCollection request = new NameValueCollection();
		    request.Add("owner_screen_name", ownerScreenName);
		    request.Add("slug", listSlug);
            return this.restTemplate.PostForObjectAsync<UserList>("lists/subscribers/destroy.json", request);
	    }

        public Task<CursoredList<UserList>> GetMembershipsAsync(long userId) 
        {
            return this.restTemplate.GetForObjectAsync<CursoredList<UserList>>(this.BuildUrl("lists/memberships.json", "user_id", userId.ToString()));
	    }

        public Task<CursoredList<UserList>> GetMembershipsAsync(string screenName) 
        {
            return this.restTemplate.GetForObjectAsync<CursoredList<UserList>>(this.BuildUrl("lists/memberships.json", "screen_name", screenName));
	    }

        public Task<CursoredList<UserList>> GetSubscriptionsAsync(long userId) 
        {
            return this.restTemplate.GetForObjectAsync<CursoredList<UserList>>(this.BuildUrl("lists/subscriptions.json", "user_id", userId.ToString()));
	    }

        public Task<CursoredList<UserList>> GetSubscriptionsAsync(string screenName) 
        {
            return this.restTemplate.GetForObjectAsync<CursoredList<UserList>>(this.BuildUrl("lists/subscriptions.json", "screen_name", screenName));
	    }

        public Task<bool> IsMemberAsync(long listId, long memberId) 
        {
		    NameValueCollection parameters = new NameValueCollection();
		    parameters.Add("list_id", listId.ToString());
		    parameters.Add("user_id", memberId.ToString());
            return this.CheckListConnectionAsync(this.BuildUrl("lists/members/show.json", parameters));
	    }

        public Task<bool> IsMemberAsync(string screenName, string listSlug, string memberScreenName) 
        {
		    NameValueCollection parameters = new NameValueCollection();
		    parameters.Add("owner_screen_name", screenName);
		    parameters.Add("slug", listSlug);
		    parameters.Add("screen_name", memberScreenName);
            return this.CheckListConnectionAsync(this.BuildUrl("lists/members/show.json", parameters));
	    }

        public Task<bool> IsSubscriberAsync(long listId, long subscriberId) 
        {
		    NameValueCollection parameters = new NameValueCollection();
		    parameters.Add("list_id", listId.ToString());
		    parameters.Add("user_id", subscriberId.ToString());
            return this.CheckListConnectionAsync(this.BuildUrl("lists/subscribers/show.json", parameters));
	    }

        public Task<bool> IsSubscriberAsync(string screenName, string listSlug, string subscriberScreenName) 
        {
		    NameValueCollection parameters = new NameValueCollection();
            parameters.Add("owner_screen_name", screenName);
            parameters.Add("slug", listSlug);
            parameters.Add("screen_name", subscriberScreenName);
		    return this.CheckListConnectionAsync(this.BuildUrl("lists/subscribers/show.json", parameters));
	    }
        #endregion

        #region Private Methods

        private Task<bool> CheckListConnectionAsync(string url) 
        {
            return this.restTemplate.ExchangeAsync(url, HttpMethod.GET, null, CancellationToken.None)
                .ContinueWith<bool>(task =>
                {
                    return task.Result.StatusCode != HttpStatusCode.NotFound;
                }, TaskContinuationOptions.ExecuteSynchronously);
        }

        private static NameValueCollection BuildListParameters(string name, string description, bool isPublic) 
        {
		    NameValueCollection parameters = new NameValueCollection();
		    parameters.Add("name", name);
		    parameters.Add("description", description);
		    parameters.Add("mode", isPublic ? "public" : "private");
		    return parameters;
	    }
        #endregion
    }
}
