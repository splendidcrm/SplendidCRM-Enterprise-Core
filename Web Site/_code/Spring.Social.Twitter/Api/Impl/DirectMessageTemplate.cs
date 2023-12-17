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
    /// Implementation of <see cref="IDirectMessageOperations"/>, providing a binding to Twitter's direct message-oriented REST resources.
    /// </summary>
    /// <author>Craig Walls</author>
    /// <author>Bruno Baia (.NET)</author>
    class DirectMessageTemplate : AbstractTwitterOperations, IDirectMessageOperations
    {
        private RestTemplate restTemplate;

        public DirectMessageTemplate(RestTemplate restTemplate)
        {
            this.restTemplate = restTemplate;
        }

        #region IDirectMessageOperations Members

        public Task<IList<DirectMessage>> GetDirectMessagesReceivedAsync() 
        {
            return this.GetDirectMessagesReceivedAsync(1, 20, 0, 0);
	    }

        public Task<IList<DirectMessage>> GetDirectMessagesReceivedAsync(int page, int pageSize) 
        {
            return this.GetDirectMessagesReceivedAsync(page, pageSize, 0, 0);
	    }

        public Task<IList<DirectMessage>> GetDirectMessagesReceivedAsync(int page, int pageSize, long sinceId, long maxId) 
        {
		    NameValueCollection parameters = PagingUtils.BuildPagingParametersWithPageCount(page, pageSize, sinceId, maxId);
            return this.restTemplate.GetForObjectAsync<IList<DirectMessage>>(this.BuildUrl("direct_messages.json", parameters));
	    }

        public Task<IList<DirectMessage>> GetDirectMessagesSentAsync() 
        {
            return this.GetDirectMessagesSentAsync(1, 20, 0, 0);
	    }

        public Task<IList<DirectMessage>> GetDirectMessagesSentAsync(int page, int pageSize) 
        {
            return this.GetDirectMessagesSentAsync(page, pageSize, 0, 0);
	    }

        public Task<IList<DirectMessage>> GetDirectMessagesSentAsync(int page, int pageSize, long sinceId, long maxId) 
        {
		    NameValueCollection parameters = PagingUtils.BuildPagingParametersWithPageCount(page, pageSize, sinceId, maxId);
            return this.restTemplate.GetForObjectAsync<IList<DirectMessage>>(this.BuildUrl("direct_messages/sent.json", parameters));
	    }

        public Task<DirectMessage> GetDirectMessageAsync(long id) 
        {
            return this.restTemplate.GetForObjectAsync<DirectMessage>(this.BuildUrl("direct_messages/show.json", "id", id.ToString()));
	    }

        public Task<DirectMessage> SendDirectMessageAsync(string toScreenName, string text) 
        {
		    NameValueCollection request = new NameValueCollection();
		    request.Add("screen_name", toScreenName);
		    request.Add("text", text);
            return this.restTemplate.PostForObjectAsync<DirectMessage>("direct_messages/new.json", request);
	    }

        public Task<DirectMessage> SendDirectMessageAsync(long toUserId, string text) 
        {
		    NameValueCollection request = new NameValueCollection();
		    request.Add("user_id", toUserId.ToString());
		    request.Add("text", text);
            return this.restTemplate.PostForObjectAsync<DirectMessage>("direct_messages/new.json", request);
	    }

        public Task<DirectMessage> DeleteDirectMessageAsync(long messageId) 
        {
            NameValueCollection request = new NameValueCollection();
            request.Add("id", messageId.ToString());
            return this.restTemplate.PostForObjectAsync<DirectMessage>("direct_messages/destroy.json", request);
	    }
        #endregion
    }
}
