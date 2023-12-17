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
using System.Globalization;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Threading.Tasks;

using Spring.IO;
using Spring.Rest.Client;

using Spring.Social.Twitter.Api.Impl.Json;

namespace Spring.Social.Twitter.Api.Impl
{
    /// <summary>
    /// Implementation of <see cref="ITimelineOperations"/>, providing a binding to Twitter's tweet and timeline-oriented REST resources.
    /// </summary>
    /// <author>Craig Walls</author>
    /// <author>Bruno Baia (.NET)</author>
    class TimelineTemplate : AbstractTwitterOperations, ITimelineOperations
    {
        private RestTemplate restTemplate;

        public TimelineTemplate(RestTemplate restTemplate)
        {
            this.restTemplate = restTemplate;
        }

        #region ITimelineOperations Members

        public Task<IList<Tweet>> GetHomeTimelineAsync()
        {
            return this.GetHomeTimelineAsync(0, 0, 0);
        }

        public Task<IList<Tweet>> GetHomeTimelineAsync(int count)
        {
            return this.GetHomeTimelineAsync(count, 0, 0);
        }

        public Task<IList<Tweet>> GetHomeTimelineAsync(int count, long sinceId, long maxId)
        {
            NameValueCollection parameters = PagingUtils.BuildPagingParametersWithCount(count, sinceId, maxId);
            return this.restTemplate.GetForObjectAsync<IList<Tweet>>(this.BuildUrl("statuses/home_timeline.json", parameters));
        }

        public Task<IList<Tweet>> GetUserTimelineAsync()
        {
            return this.GetUserTimelineAsync(0, 0, 0);
        }

        public Task<IList<Tweet>> GetUserTimelineAsync(int count)
        {
            return this.GetUserTimelineAsync(count, 0, 0);
        }

        public Task<IList<Tweet>> GetUserTimelineAsync(int count, long sinceId, long maxId)
        {
            NameValueCollection parameters = PagingUtils.BuildPagingParametersWithCount(count, sinceId, maxId);
            return this.restTemplate.GetForObjectAsync<IList<Tweet>>(this.BuildUrl("statuses/user_timeline.json", parameters));
        }

        public Task<IList<Tweet>> GetUserTimelineAsync(string screenName)
        {
            return this.GetUserTimelineAsync(screenName, 0, 0, 0);
        }

        public Task<IList<Tweet>> GetUserTimelineAsync(string screenName, int count)
        {
            return this.GetUserTimelineAsync(screenName, count, 0, 0);
        }

        public Task<IList<Tweet>> GetUserTimelineAsync(string screenName, int count, long sinceId, long maxId)
        {
            NameValueCollection parameters = PagingUtils.BuildPagingParametersWithCount(count, sinceId, maxId);
            parameters.Add("screen_name", screenName);
            return this.restTemplate.GetForObjectAsync<IList<Tweet>>(this.BuildUrl("statuses/user_timeline.json", parameters));
        }

        public Task<IList<Tweet>> GetUserTimelineAsync(long userId)
        {
            return this.GetUserTimelineAsync(userId, 0, 0, 0);
        }

        public Task<IList<Tweet>> GetUserTimelineAsync(long userId, int count)
        {
            return this.GetUserTimelineAsync(userId, count, 0, 0);
        }

        public Task<IList<Tweet>> GetUserTimelineAsync(long userId, int count, long sinceId, long maxId)
        {
            NameValueCollection parameters = PagingUtils.BuildPagingParametersWithCount(count, sinceId, maxId);
            parameters.Add("user_id", userId.ToString());
            return this.restTemplate.GetForObjectAsync<IList<Tweet>>(this.BuildUrl("statuses/user_timeline.json", parameters));
        }

        public Task<IList<Tweet>> GetMentionsAsync()
        {
            return this.GetMentionsAsync(0, 0, 0);
        }

        public Task<IList<Tweet>> GetMentionsAsync(int count)
        {
            return this.GetMentionsAsync(count, 0, 0);
        }

        public Task<IList<Tweet>> GetMentionsAsync(int count, long sinceId, long maxId)
        {
            NameValueCollection parameters = PagingUtils.BuildPagingParametersWithCount(count, sinceId, maxId);
            return this.restTemplate.GetForObjectAsync<IList<Tweet>>(this.BuildUrl("statuses/mentions_timeline.json", parameters));
        }

        public Task<IList<Tweet>> GetRetweetsOfMeAsync()
        {
            return this.GetRetweetsOfMeAsync(0, 0, 0);
        }

        public Task<IList<Tweet>> GetRetweetsOfMeAsync(int count)
        {
            return this.GetRetweetsOfMeAsync(count, 0, 0);
        }

        public Task<IList<Tweet>> GetRetweetsOfMeAsync(int count, long sinceId, long maxId)
        {
            NameValueCollection parameters = PagingUtils.BuildPagingParametersWithCount(count, sinceId, maxId);
            return this.restTemplate.GetForObjectAsync<IList<Tweet>>(this.BuildUrl("statuses/retweets_of_me.json", parameters));
        }

        public Task<Tweet> GetStatusAsync(long tweetId)
        {
            return this.restTemplate.GetForObjectAsync<Tweet>("statuses/show/{tweetId}.json", tweetId);
        }

        public Task<Tweet> UpdateStatusAsync(string status)
        {
            return this.UpdateStatusAsync(status, new StatusDetails());
        }

        public Task<Tweet> UpdateStatusAsync(string status, IResource photo)
        {
            return this.UpdateStatusAsync(status, photo, new StatusDetails());
        }

        public Task<Tweet> UpdateStatusAsync(string status, StatusDetails details)
        {
            NameValueCollection request = new NameValueCollection();
            request.Add("status", status);
            AddStatusDetailsTo(request, details);
            return this.restTemplate.PostForObjectAsync<Tweet>("statuses/update.json", request);
        }

        public Task<Tweet> UpdateStatusAsync(string status, IResource photo, StatusDetails details)
        {
            IDictionary<string, object> request = new Dictionary<string, object>();
            request.Add("status", status);
            AddStatusDetailsTo(request, details);
            request.Add("media", photo);
            return this.restTemplate.PostForObjectAsync<Tweet>("statuses/update_with_media.json", request);
        }

        public Task<Tweet> DeleteStatusAsync(long tweetId)
        {
            NameValueCollection request = new NameValueCollection();
            return this.restTemplate.PostForObjectAsync<Tweet>("statuses/destroy/{tweetId}.json", request, tweetId);
        }

        public Task RetweetAsync(long tweetId)
        {
            NameValueCollection request = new NameValueCollection();
            return this.restTemplate.PostForMessageAsync("statuses/retweet/{tweetId}.json", request, tweetId);
        }

        public Task<IList<Tweet>> GetRetweetsAsync(long tweetId)
        {
            return this.GetRetweetsAsync(tweetId, 100);
        }

        public Task<IList<Tweet>> GetRetweetsAsync(long tweetId, int count)
        {
            return this.restTemplate.GetForObjectAsync<IList<Tweet>>("statuses/retweets/{tweetId}.json?count={count}", tweetId, count);
        }

        public Task<IList<Tweet>> GetFavoritesAsync()
        {
            return this.GetFavoritesAsync(0);
        }

        public Task<IList<Tweet>> GetFavoritesAsync(int count)
        {
            NameValueCollection parameters = PagingUtils.BuildPagingParametersWithCount(count, 0, 0);
            return this.restTemplate.GetForObjectAsync<IList<Tweet>>(this.BuildUrl("favorites/list.json", parameters));
        }

        public Task AddToFavoritesAsync(long tweetId)
        {
            NameValueCollection request = new NameValueCollection();
            request.Add("id", tweetId.ToString());
            return this.restTemplate.PostForMessageAsync("favorites/create.json", request);
        }

        public Task RemoveFromFavoritesAsync(long tweetId)
        {
            NameValueCollection request = new NameValueCollection();
            request.Add("id", tweetId.ToString());
            return this.restTemplate.PostForMessageAsync("favorites/destroy.json", request);
        }
        #endregion

        #region Private Methods

        private static void AddStatusDetailsTo(NameValueCollection parameters, StatusDetails details)
        {
            if (details.Latitude.HasValue && details.Longitude.HasValue)
            {
                parameters.Add("lat", details.Latitude.Value.ToString(CultureInfo.InvariantCulture));
                parameters.Add("long", details.Longitude.Value.ToString(CultureInfo.InvariantCulture));
            }
            if (details.DisplayCoordinates)
            {
                parameters.Add("display_coordinates", "true");
            }
            if (details.InReplyToStatusId.HasValue)
            {
                parameters.Add("in_reply_to_status_id", details.InReplyToStatusId.Value.ToString());
            }
            if (details.WrapLinks)
            {
                parameters.Add("wrap_links", "true");
            }
        }

        private static void AddStatusDetailsTo(IDictionary<string, object> parameters, StatusDetails details)
        {
            if (details.Latitude.HasValue && details.Longitude.HasValue)
            {
                parameters.Add("lat", details.Latitude.Value.ToString(CultureInfo.InvariantCulture));
                parameters.Add("long", details.Longitude.Value.ToString(CultureInfo.InvariantCulture));
            }
            if (details.DisplayCoordinates)
            {
                parameters.Add("display_coordinates", "true");
            }
            if (details.InReplyToStatusId.HasValue)
            {
                parameters.Add("in_reply_to_status_id", details.InReplyToStatusId.Value.ToString());
            }
            if (details.WrapLinks)
            {
                parameters.Add("wrap_links", "true");
            }
        }

        #endregion
    }
}
