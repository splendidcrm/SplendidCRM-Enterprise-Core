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
    /// Implementation of <see cref="IFriendOperations"/>, providing a binding to Twitter's friends and followers-oriented REST resources.
    /// </summary>
    /// <author>Craig Walls</author>
    /// <author>Bruno Baia (.NET)</author>
    class FriendTemplate : AbstractTwitterOperations, IFriendOperations
    {
        private RestTemplate restTemplate;

        public FriendTemplate(RestTemplate restTemplate)
        {
            this.restTemplate = restTemplate;
        }

        #region IFriendOperations Members

        public Task<CursoredList<TwitterProfile>> GetFriendsAsync() 
        {
            return this.GetFriendsInCursorAsync(-1);
	    }

        public Task<CursoredList<TwitterProfile>> GetFriendsInCursorAsync(long cursor)
        {
            return this.restTemplate.GetForObjectAsync<CursoredList<TwitterProfile>>(this.BuildUrl("friends/list.json", "cursor", cursor.ToString()));
        }

        public Task<CursoredList<TwitterProfile>> GetFriendsAsync(long userId) 
        {
            return this.GetFriendsInCursorAsync(userId, -1);
	    }

        public Task<CursoredList<TwitterProfile>> GetFriendsInCursorAsync(long userId, long cursor) 
        {
            NameValueCollection parameters = new NameValueCollection();
            parameters.Add("cursor", cursor.ToString());
            parameters.Add("user_id", userId.ToString());
            return this.restTemplate.GetForObjectAsync<CursoredList<TwitterProfile>>(this.BuildUrl("friends/list.json", parameters));
	    }

        public Task<CursoredList<TwitterProfile>> GetFriendsAsync(string screenName) 
        {
            return this.GetFriendsInCursorAsync(screenName, -1);
	    }

        public Task<CursoredList<TwitterProfile>> GetFriendsInCursorAsync(string screenName, long cursor) 
        {
            NameValueCollection parameters = new NameValueCollection();
            parameters.Add("cursor", cursor.ToString());
            parameters.Add("screen_name", screenName);
            return this.restTemplate.GetForObjectAsync<CursoredList<TwitterProfile>>(this.BuildUrl("friends/list.json", parameters));
	    }

        public Task<CursoredList<long>> GetFriendIdsAsync() 
        {
            return this.GetFriendIdsInCursorAsync(-1);
	    }

        public Task<CursoredList<long>> GetFriendIdsInCursorAsync(long cursor) 
        {
            return this.restTemplate.GetForObjectAsync<CursoredList<long>>(this.BuildUrl("friends/ids.json", "cursor", cursor.ToString()));
	    }

        public Task<CursoredList<long>> GetFriendIdsAsync(long userId) 
        {
            return this.GetFriendIdsInCursorAsync(userId, -1);
	    }

        public Task<CursoredList<long>> GetFriendIdsInCursorAsync(long userId, long cursor) 
        {
		    NameValueCollection parameters = new NameValueCollection();
		    parameters.Add("cursor", cursor.ToString());
		    parameters.Add("user_id", userId.ToString());
            return this.restTemplate.GetForObjectAsync<CursoredList<long>>(this.BuildUrl("friends/ids.json", parameters));
	    }

        public Task<CursoredList<long>> GetFriendIdsAsync(string screenName) 
        {
            return this.GetFriendIdsInCursorAsync(screenName, -1);
	    }

        public Task<CursoredList<long>> GetFriendIdsInCursorAsync(string screenName, long cursor) 
        {
		    NameValueCollection parameters = new NameValueCollection();
		    parameters.Add("cursor", cursor.ToString());
		    parameters.Add("screen_name", screenName);
            return this.restTemplate.GetForObjectAsync<CursoredList<long>>(this.BuildUrl("friends/ids.json", parameters));
	    }

        public Task<CursoredList<TwitterProfile>> GetFollowersAsync() 
        {
            return this.GetFollowersInCursorAsync(-1);
	    }

        public Task<CursoredList<TwitterProfile>> GetFollowersInCursorAsync(long cursor) 
        {
            return this.restTemplate.GetForObjectAsync<CursoredList<TwitterProfile>>(this.BuildUrl("followers/list.json", "cursor", cursor.ToString()));
	    }

        public Task<CursoredList<TwitterProfile>> GetFollowersAsync(long userId) 
        {
            return this.GetFollowersInCursorAsync(userId, -1);
	    }

        public Task<CursoredList<TwitterProfile>> GetFollowersInCursorAsync(long userId, long cursor) 
        {
            NameValueCollection parameters = new NameValueCollection();
            parameters.Add("cursor", cursor.ToString());
            parameters.Add("user_id", userId.ToString());
            return this.restTemplate.GetForObjectAsync<CursoredList<TwitterProfile>>(this.BuildUrl("followers/list.json", parameters));
	    }

        public Task<CursoredList<TwitterProfile>> GetFollowersAsync(string screenName) 
        {
            return this.GetFollowersInCursorAsync(screenName, -1);
	    }

        public Task<CursoredList<TwitterProfile>> GetFollowersInCursorAsync(string screenName, long cursor) 
        {
            NameValueCollection parameters = new NameValueCollection();
            parameters.Add("cursor", cursor.ToString());
            parameters.Add("screen_name", screenName);
            return this.restTemplate.GetForObjectAsync<CursoredList<TwitterProfile>>(this.BuildUrl("followers/list.json", parameters));
	    }

        public Task<CursoredList<long>> GetFollowerIdsAsync() 
        {
            return this.GetFollowerIdsInCursorAsync(-1);
	    }

        public Task<CursoredList<long>> GetFollowerIdsInCursorAsync(long cursor) 
        {
            return this.restTemplate.GetForObjectAsync<CursoredList<long>>(this.BuildUrl("followers/ids.json", "cursor", cursor.ToString()));
	    }

        public Task<CursoredList<long>> GetFollowerIdsAsync(long userId) 
        {
            return this.GetFollowerIdsInCursorAsync(userId, -1);
	    }

        public Task<CursoredList<long>> GetFollowerIdsInCursorAsync(long userId, long cursor) 
        {
		    NameValueCollection parameters = new NameValueCollection();
		    parameters.Add("cursor", cursor.ToString());
		    parameters.Add("user_id", userId.ToString());
            return this.restTemplate.GetForObjectAsync<CursoredList<long>>(this.BuildUrl("followers/ids.json", parameters));
	    }

        public Task<CursoredList<long>> GetFollowerIdsAsync(string screenName) 
        {
            return this.GetFollowerIdsInCursorAsync(screenName, -1);
	    }

        public Task<CursoredList<long>> GetFollowerIdsInCursorAsync(string screenName, long cursor) 
        {
		    NameValueCollection parameters = new NameValueCollection();
		    parameters.Add("cursor", cursor.ToString());
		    parameters.Add("screen_name", screenName);
            return this.restTemplate.GetForObjectAsync<CursoredList<long>>(this.BuildUrl("followers/ids.json", parameters));
	    }

        public Task<TwitterProfile> FollowAsync(long userId) 
        {
            NameValueCollection request = new NameValueCollection();
            request.Add("user_id", userId.ToString());
            return this.restTemplate.PostForObjectAsync<TwitterProfile>("friendships/create.json", request);
	    }

        public Task<TwitterProfile> FollowAsync(string screenName) 
        {
            NameValueCollection request = new NameValueCollection();
            request.Add("screen_name", screenName);
            return this.restTemplate.PostForObjectAsync<TwitterProfile>("friendships/create.json", request);
	    }

        public Task<TwitterProfile> UnfollowAsync(long userId) 
        {
            NameValueCollection request = new NameValueCollection();
            request.Add("user_id", userId.ToString());
            return this.restTemplate.PostForObjectAsync<TwitterProfile>("friendships/destroy.json", request);
	    }

        public Task<TwitterProfile> UnfollowAsync(string screenName) 
        {
            NameValueCollection request = new NameValueCollection();
            request.Add("screen_name", screenName);
            return this.restTemplate.PostForObjectAsync<TwitterProfile>("friendships/destroy.json", request);
	    }

        public Task EnableNotificationsAsync(long userId) 
        {
            NameValueCollection request = new NameValueCollection();
            request.Add("user_id", userId.ToString());
            request.Add("device", "true");
            return this.restTemplate.PostForMessageAsync("friendships/update.json", request);
	    }

        public Task EnableNotificationsAsync(string screenName) 
        {
            NameValueCollection request = new NameValueCollection();
            request.Add("screen_name", screenName);
            request.Add("device", "true");
            return this.restTemplate.PostForMessageAsync("friendships/update.json", request);
	    }

        public Task DisableNotificationsAsync(long userId) 
        {
            NameValueCollection request = new NameValueCollection();
            request.Add("user_id", userId.ToString());
            request.Add("device", "false");
            return this.restTemplate.PostForMessageAsync("friendships/update.json", request);
	    }

        public Task DisableNotificationsAsync(string screenName) 
        {
            NameValueCollection request = new NameValueCollection();
            request.Add("screen_name", screenName);
            request.Add("device", "false");
            return this.restTemplate.PostForMessageAsync("friendships/update.json", request);
	    }

        public Task<CursoredList<long>> GetIncomingFriendshipsAsync() 
        {
            return this.GetIncomingFriendshipsAsync(-1);
	    }

        public Task<CursoredList<long>> GetIncomingFriendshipsAsync(long cursor) 
        {
            return this.restTemplate.GetForObjectAsync<CursoredList<long>>(this.BuildUrl("friendships/incoming.json", "cursor", cursor.ToString()));
	    }

        public Task<CursoredList<long>> GetOutgoingFriendshipsAsync() 
        {
            return this.GetOutgoingFriendshipsAsync(-1);
	    }

        public Task<CursoredList<long>> GetOutgoingFriendshipsAsync(long cursor) 
        {
            return this.restTemplate.GetForObjectAsync<CursoredList<long>>(this.BuildUrl("friendships/outgoing.json", "cursor", cursor.ToString()));
	    }
        #endregion
    }
}
