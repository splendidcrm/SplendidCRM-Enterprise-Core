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
using System.IO;
using System.Collections.Generic;
using System.Threading.Tasks;

using Spring.IO;

namespace Spring.Social.Twitter.Api
{
    /// <summary>
    /// Interface defining the operations for sending and retrieving tweets.
    /// </summary>
    /// <author>Craig Walls</author>
    /// <author>Bruno Baia (.NET)</author>
    public interface ITimelineOperations
    {
        /// <summary>
        /// Asynchronously retrieves the 20 most recently posted tweets, including retweets, from the authenticating user's home timeline. 
        /// The home timeline includes tweets from the user's timeline and the timeline of anyone that they follow.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s in the authenticating user's home timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetHomeTimelineAsync();

        /// <summary>
        /// Asynchronously retrieves tweets, including retweets, from the authenticating user's home timeline. 
        /// The home timeline includes tweets from the user's timeline and the timeline of anyone that they follow.
        /// </summary>
        /// <param name="count">
        /// The number of <see cref="Tweet"/>s to retrieve. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200)
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s in the authenticating user's home timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetHomeTimelineAsync(int count);

        /// <summary>
        /// Asynchronously retrieves tweets, including retweets, from the authenticating user's home timeline. 
        /// The home timeline includes tweets from the user's timeline and the timeline of anyone that they follow.
        /// </summary>
        /// <param name="count">
        /// The number of <see cref="Tweet"/>s to retrieve. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200)
        /// </param>
        /// <param name="sinceId">The minimum <see cref="Tweet"/> ID to return in the results.</param>
        /// <param name="maxId">The maximum <see cref="Tweet"/> ID to return in the results.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s in the authenticating user's home timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetHomeTimelineAsync(int count, long sinceId, long maxId);

        /// <summary>
        /// Asynchronously retrieves the 20 most recent tweets posted by the authenticating user.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s that have been posted by the authenticating user.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetUserTimelineAsync();

        /// <summary>
        /// Asynchronously retrieves tweets posted by the authenticating user. The most recent tweets are listed first.
        /// </summary>
        /// <param name="count">
        /// The number of <see cref="Tweet"/>s to retrieve. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200)
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s that have been posted by the authenticating user.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetUserTimelineAsync(int count);

        /// <summary>
        /// Asynchronously retrieves tweets posted by the authenticating user. The most recent tweets are listed first.
        /// </summary>
        /// <param name="count">
        /// The number of <see cref="Tweet"/>s to retrieve. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200)
        /// </param>
        /// <param name="sinceId">The minimum <see cref="Tweet"/> ID to return in the results.</param>
        /// <param name="maxId">The maximum <see cref="Tweet"/> ID to return in the results.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s that have been posted by the authenticating user.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetUserTimelineAsync(int count, long sinceId, long maxId);

        /// <summary>
        /// Asynchronously retrieves the 20 most recent tweets posted by the given user.
        /// </summary>
        /// <param name="screenName">The screen name of the user whose timeline is being requested.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s from the specified user's timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetUserTimelineAsync(string screenName);

        /// <summary>
        /// Asynchronously retrieves tweets posted by the given user. The most recent tweets are listed first.
        /// </summary>
        /// <param name="screenName">The screen name of the user whose timeline is being requested.</param>
        /// <param name="count">
        /// The number of <see cref="Tweet"/>s to retrieve. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200)
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s from the specified user's timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetUserTimelineAsync(string screenName, int count);

        /// <summary>
        /// Asynchronously retrieves tweets posted by the given user. The most recent tweets are listed first.
        /// </summary>
        /// <param name="screenName">The screen name of the user whose timeline is being requested.</param>
        /// <param name="count">
        /// The number of <see cref="Tweet"/>s to retrieve. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200)
        /// </param>
        /// <param name="sinceId">The minimum <see cref="Tweet"/> ID to return in the results.</param>
        /// <param name="maxId">The maximum <see cref="Tweet"/> ID to return in the results.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s from the specified user's timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetUserTimelineAsync(string screenName, int count, long sinceId, long maxId);

        /// <summary>
        /// Asynchronously retrieves the 20 most recent tweets posted by the given user.
        /// </summary>
        /// <param name="userId">The user ID of the user whose timeline is being requested.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s from the specified user's timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetUserTimelineAsync(long userId);

        /// <summary>
        /// Asynchronously retrieves tweets posted by the given user. The most recent tweets are listed first.
        /// </summary>
        /// <param name="userId">The user ID of the user whose timeline is being requested.</param>
        /// <param name="count">
        /// The number of <see cref="Tweet"/>s to retrieve. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200)
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s from the specified user's timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetUserTimelineAsync(long userId, int count);

        /// <summary>
        /// Asynchronously retrieves tweets posted by the given user. The most recent tweets are listed first.
        /// </summary>
        /// <param name="userId">The user ID of the user whose timeline is being requested.</param>
        /// <param name="count">
        /// The number of <see cref="Tweet"/>s to retrieve. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200)
        /// </param>
        /// <param name="sinceId">The minimum <see cref="Tweet"/> ID to return in the results.</param>
        /// <param name="maxId">The maximum <see cref="Tweet"/> ID to return in the results.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s from the specified user's timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetUserTimelineAsync(long userId, int count, long sinceId, long maxId);

        /// <summary>
        /// Asynchronously retrieves the 20 most recent tweets that mention the authenticated user.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s that mention the authenticated user.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetMentionsAsync();

        /// <summary>
        /// Asynchronously retrieves tweets that mention the authenticated user. The most recent tweets are listed first.
        /// </summary>
        /// <param name="count">
        /// The number of <see cref="Tweet"/>s to retrieve. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200)
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s that mention the authenticated user.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetMentionsAsync(int count);

        /// <summary>
        /// Asynchronously retrieves tweets that mention the authenticated user. The most recent tweets are listed first.
        /// </summary>
        /// <param name="count">
        /// The number of <see cref="Tweet"/>s to retrieve. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200)
        /// </param>
        /// <param name="sinceId">The minimum <see cref="Tweet"/> ID to return in the results.</param>
        /// <param name="maxId">The maximum <see cref="Tweet"/> ID to return in the results.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s that mention the authenticated user.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetMentionsAsync(int count, long sinceId, long maxId);

        /// <summary>
        /// Asynchronously retrieves the 20 most recent tweets of the authenticated user that have been retweeted by others.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s from the authenticated user that have been retweeted by others.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetRetweetsOfMeAsync();

        /// <summary>
        /// Asynchronously retrieves tweets of the authenticated user that have been retweeted by others. The most recent tweets are listed first.
        /// </summary>
        /// <param name="count">
        /// The number of <see cref="Tweet"/>s to retrieve. Should be less than or equal to 100. 
        /// (Will return at most 100 entries, even if pageSize is greater than 100)
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s from the authenticated user that have been retweeted by others.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetRetweetsOfMeAsync(int count);

        /// <summary>
        /// Asynchronously retrieves tweets of the authenticated user that have been retweeted by others. The most recent tweets are listed first.
        /// </summary>
        /// <param name="count">
        /// The number of <see cref="Tweet"/>s to retrieve. Should be less than or equal to 100. 
        /// (Will return at most 100 entries, even if pageSize is greater than 100)
        /// </param>
        /// <param name="sinceId">The minimum <see cref="Tweet"/> ID to return in the results.</param>
        /// <param name="maxId">The maximum <see cref="Tweet"/> ID to return in the results.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s from the authenticated user that have been retweeted by others.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetRetweetsOfMeAsync(int count, long sinceId, long maxId);

        /// <summary>
        /// Asynchronously returns a single tweet.
        /// </summary>
        /// <param name="tweetId">The tweet's ID.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="Tweet"/> from the specified ID.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<Tweet> GetStatusAsync(long tweetId);

        /// <summary>
        /// Asynchronously updates the user's status.
        /// </summary>
        /// <param name="status">The status message.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the created <see cref="Tweet"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        /// <exception cref="TwitterApiException">If the status message duplicates a previously posted status.</exception>
        /// <exception cref="TwitterApiException">If the length of the status message exceeds Twitter's 140 character limit.</exception>
        Task<Tweet> UpdateStatusAsync(string status);

        /// <summary>
        /// Asynchronously updates the user's status along with a picture.
        /// </summary>
        /// <param name="status">The status message.</param>
        /// <param name="photo">
        /// A <see cref="IResource"/> for the photo data. It must contain GIF, JPG, or PNG data.
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the created <see cref="Tweet"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        /// <exception cref="TwitterApiException">If the status message duplicates a previously posted status.</exception>
        /// <exception cref="TwitterApiException">If the length of the status message exceeds Twitter's 140 character limit.</exception>
        /// <exception cref="TwitterApiException">If the photo resource isn't a GIF, JPG, or PNG.</exception>
        Task<Tweet> UpdateStatusAsync(string status, IResource photo);

        /// <summary>
        /// Asynchronously updates the user's status, including additional metadata concerning the status.
        /// </summary>
        /// <param name="status">The status message.</param>
        /// <param name="details">The metadata pertaining to the status.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the created <see cref="Tweet"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        /// <exception cref="TwitterApiException">If the status message duplicates a previously posted status.</exception>
        /// <exception cref="TwitterApiException">If the length of the status message exceeds Twitter's 140 character limit.</exception>
        Task<Tweet> UpdateStatusAsync(string status, StatusDetails details);

        /// <summary>
        /// Asynchronously updates the user's status, including a picture and additional metadata concerning the status.
        /// </summary>
        /// <param name="status">The status message.</param>
        /// <param name="photo">
        /// A <see cref="IResource"/> for the photo data. It must contain GIF, JPG, or PNG data.
        /// </param>
        /// <param name="details">The metadata pertaining to the status.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the created <see cref="Tweet"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        /// <exception cref="TwitterApiException">If the status message duplicates a previously posted status.</exception>
        /// <exception cref="TwitterApiException">If the length of the status message exceeds Twitter's 140 character limit.</exception>
        /// <exception cref="TwitterApiException">If the photo resource isn't a GIF, JPG, or PNG.</exception>
        Task<Tweet> UpdateStatusAsync(string status, IResource photo, StatusDetails details);

        /// <summary>
        /// Asynchronously removes a status entry.
        /// </summary>
        /// <param name="tweetId">The tweet's ID to be removed.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the deleted <see cref="Tweet"/>, if successful.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<Tweet> DeleteStatusAsync(long tweetId);

        /// <summary>
        /// Asynchronously posts a retweet of an existing tweet.
        /// </summary>
        /// <param name="tweetId">The tweet's ID to be retweeted.</param>
        /// <returns>A <code>Task</code> that represents the asynchronous operation.</returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task RetweetAsync(long tweetId);

        /// <summary>
        /// Asynchronously retrieves up to 100 retweets of a specific tweet.
        /// </summary>
        /// <param name="tweetId">The tweet's ID.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the retweets of the specified tweet.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetRetweetsAsync(long tweetId);

        /// <summary>
        /// Asynchronously retrieves retweets of a specific tweet.
        /// </summary>
        /// <param name="tweetId">The tweet's ID.</param>
        /// <param name="count">
        /// The maximum number of retweets to return. Should be less than or equal to 100. 
        /// (Will return at most 100 entries, even if pageSize is greater than 100)
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the retweets of the specified tweet.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetRetweetsAsync(long tweetId, int count);

        /// <summary>
        /// Asynchronously retrieves the 20 most recent tweets favorited by the authenticated user.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s from the specified user's favorite timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetFavoritesAsync();

        /// <summary>
        /// Asynchronously retrieves tweets favorited by the authenticated user.
        /// </summary>
        /// <param name="count">The number of <see cref="Tweet"/>s to retrieve.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/>s from the specified user's favorite timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetFavoritesAsync(int count);

        /// <summary>
        /// Asynchronously adds a tweet to the user's collection of favorite tweets.
        /// </summary>
        /// <param name="tweetId">The tweet's ID.</param>
        /// <returns>A <code>Task</code> that represents the asynchronous operation.</returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task AddToFavoritesAsync(long tweetId);

        /// <summary>
        /// Asynchronously removes a tweet from the user's collection of favorite tweets.
        /// </summary>
        /// <param name="tweetId">The tweet's ID.</param>
        /// <returns>A <code>Task</code> that represents the asynchronous operation.</returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task RemoveFromFavoritesAsync(long tweetId);
    }
}
