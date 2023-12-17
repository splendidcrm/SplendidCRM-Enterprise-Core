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

namespace Spring.Social.Twitter.Api
{
    /// <summary>
    /// Interface defining the operations for searching Twitter and retrieving trending data.
    /// </summary>
    /// <author>Craig Walls</author>
    /// <author>Bruno Baia (.NET)</author>
    public interface IUserOperations
    {
	    /// <summary>
        /// Asynchronously retrieves the authenticated user's Twitter profile details.
	    /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a <see cref="TwitterProfile"/>object representing the user's profile.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
	    Task<TwitterProfile> GetUserProfileAsync();

        /// <summary>
        /// Asynchronously retrieves a specific user's Twitter profile details. 
        /// Note that this method does not require authentication.
        /// </summary>
        /// <param name="screenName">The screen name for the user whose details are to be retrieved.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a <see cref="TwitterProfile"/> object representing the user's profile.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<TwitterProfile> GetUserProfileAsync(string screenName);

        /// <summary>
        /// Asynchronously retrieves a specific user's Twitter profile details. 
        /// Note that this method does not require authentication.
        /// </summary>
        /// <param name="userId">The user ID for the user whose details are to be retrieved.</param>
        /// <returns>A <see cref="TwitterProfile"/> object representing the user's profile.</returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<TwitterProfile> GetUserProfileAsync(long userId);

        /// <summary>
        /// Asynchronously retrieves a list of Twitter profiles for the given list of user IDs.
        /// </summary>
        /// <param name="userIds">The list of user IDs.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="TwitterProfile">user's profiles</see>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<TwitterProfile>> GetUsersAsync(params long[] userIds);

        /// <summary>
        /// Asynchronously retrieves a list of Twitter profiles for the given list of screen names.
        /// </summary>
        /// <param name="screenNames">The list of screen names.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="TwitterProfile">user's profiles</see>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<TwitterProfile>> GetUsersAsync(params string[] screenNames);

        /// <summary>
        /// Asynchronously searches for up to 20 users that match a given query.
        /// </summary>
        /// <param name="query">The search query string.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="TwitterProfile">user's profiles</see>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<TwitterProfile>> SearchForUsersAsync(string query);

        /// <summary>
        /// Asynchronously searches for users that match a given query.
        /// </summary>
        /// <param name="query">The search query string.</param>
        /// <param name="page">The page of search results to return.</param>
        /// <param name="pageSize">The number of <see cref="TwitterProfile"/>s per page. Maximum of 20 per page.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="TwitterProfile">user's profiles</see>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<TwitterProfile>> SearchForUsersAsync(string query, int page, int pageSize);

        /// <summary>
        /// Asynchronously retrieves a list of categories from which suggested users to follow may be found.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of suggestion categories.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<SuggestionCategory>> GetSuggestionCategoriesAsync();

        /// <summary>
        /// Asynchronously retrieves a list of suggestions of users to follow for a given category.
        /// </summary>
        /// <param name="slug">The category's slug.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="TwitterProfile">user's profiles</see>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<TwitterProfile>> GetSuggestionsAsync(string slug);

        /// <summary>
        /// Asynchronously retrieves the current rate limits for methods belonging to the specified resource families. 
        /// </summary>
        /// <param name="resources">
        /// The list of resource families you want to know the current rate limit disposition for. 
        /// <para/>
        /// Each resource belongs to a "resource family" which is indicated in its method documentation. 
        /// You can typically determine a method's resource family from the first component of the path after the resource version.
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the rate limits.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<RateLimitStatus>> GetRateLimitStatusAsync(params string[] resources);
    }
}
