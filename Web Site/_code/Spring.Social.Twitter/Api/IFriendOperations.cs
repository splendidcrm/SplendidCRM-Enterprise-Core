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
    /// Interface defining the operations for working with a user's friends and followers.
    /// </summary>
    /// <author>Craig Walls</author>
    /// <author>Bruno Baia (.NET)</author>
    public interface IFriendOperations
    {
        /// <summary>
        /// Asynchronously retrieves a list of up to 20 users that the authenticated user follows.
        /// <para/>
        /// Call GetFriendsInCursor() with a cursor value to get the next/previous page of entries.
        /// <para/>
        /// If all you need is the friend IDs, consider calling GetFriendIds() instead.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<TwitterProfile>> GetFriendsAsync();

        /// <summary>
        /// Asynchronously retrieves a list of up to 20 users that the authenticated user follows.
        /// <para/>
        /// If all you need is the friend IDs, consider calling GetFriendIds() instead.
        /// </summary>
        /// <param name="cursor">The cursor used to fetch the friend IDs.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<TwitterProfile>> GetFriendsInCursorAsync(long cursor);

        /// <summary>
        /// Asynchronously retrieves a list of up to 20 users that the given user follows.
        /// <para/>
        /// Call GetFriendsInCursor() with a cursor value to get the next/previous page of entries.
        /// <para/>
        /// If all you need is the friend IDs, consider calling GetFriendIds() instead.
        /// </summary>
        /// <param name="userId">The user's Twitter ID.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<TwitterProfile>> GetFriendsAsync(long userId);

        /// <summary>
        /// Asynchronously retrieves a list of up to 20 users that the given user follows.
        /// <para/>
        /// If all you need is the friend IDs, consider calling GetFriendIds() instead.
        /// </summary>
        /// <param name="userId">The user's Twitter ID.</param>
        /// <param name="cursor">The cursor used to fetch the friend IDs.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>        
        Task<CursoredList<TwitterProfile>> GetFriendsInCursorAsync(long userId, long cursor);

        /// <summary>
        /// Asynchronously retrieves a list of up to 20 users that the given user follows.
        /// <para/>
        /// Call GetFriendsInCursor() with a cursor value to get the next/previous page of entries.
        /// <para/>
        /// If all you need is the friend IDs, consider calling GetFriendIds() instead.
        /// </summary>
        /// <param name="screenName">The user's Twitter screen name.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<TwitterProfile>> GetFriendsAsync(string screenName);

        /// <summary>
        /// Asynchronously retrieves a list of up to 20 users that the given user follows.
        /// <para/>
        /// If all you need is the friend IDs, consider calling GetFriendIds() instead.
        /// </summary>
        /// <param name="screenName">The user's Twitter screen name.</param>
        /// <param name="cursor">The cursor used to fetch the friend IDs.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<TwitterProfile>> GetFriendsInCursorAsync(string screenName, long cursor);

        /// <summary>
        /// Asynchronously retrieves a list of up to 5000 IDs for the Twitter users that the authenticated user follows.
        /// <para/>
        /// Call GetFriendIdsInCursor() with a cursor value to get the next/previous page of entries.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetFriendIdsAsync();

        /// <summary>
        /// Asynchronously retrieves a list of up to 5000 IDs for the Twitter users that the authenticated user follows.
        /// </summary>
        /// <param name="cursor">
        /// The cursor value to fetch a specific page of entries. Use -1 for the first page of entries.
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetFriendIdsInCursorAsync(long cursor);

        /// <summary>
        /// Asynchronously retrieves a list of up to 5000 IDs for the Twitter users that the given user follows.
        /// <para/>
        /// Call GetFriendIdsInCursor() with a cursor value to get the next/previous page of entries.
        /// </summary>
        /// <param name="userId">The user's Twitter ID.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetFriendIdsAsync(long userId);

        /// <summary>
        /// Asynchronously retrieves a list of up to 5000 IDs for the Twitter users that the given user follows.
        /// </summary>
        /// <param name="userId">The user's Twitter ID.</param>
        /// <param name="cursor">The cursor value to fetch a specific page of entries. Use -1 for the first page of entries.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetFriendIdsInCursorAsync(long userId, long cursor);

        /// <summary>
        /// Asynchronously retrieves a list of up to 5000 IDs for the Twitter users that the given user follows.
        /// <para/>
        /// Call GetFriendIdsInCursor() with a cursor value to get the next/previous page of entries.
        /// </summary>
        /// <param name="screenName">The user's Twitter screen name.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetFriendIdsAsync(string screenName);

        /// <summary>
        /// Asynchronously retrieves a list of up to 5000 IDs for the Twitter users that the given user follows.
        /// </summary>
        /// <param name="screenName">The user's Twitter screen name.</param>
        /// <param name="cursor">The cursor value to fetch a specific page of entries. Use -1 for the first page of entries.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetFriendIdsInCursorAsync(string screenName, long cursor);

        /// <summary>
        /// Asynchronously retrieves a list of up to 20 users that the authenticated user is being followed by.
        /// <para/>
        /// Call GetFollowersInCursor() with a cursor value to get the next/previous page of entries.
        /// <para/>
        /// If all you need is the follower IDs, consider calling GetFollowerIds() instead.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<TwitterProfile>> GetFollowersAsync();

        /// <summary>
        /// Asynchronously retrieves a list of up to 20 users that the authenticated user is being followed by.
        /// <para/>
        /// If all you need is the follower IDs, consider calling GetFollowerIds() instead.
        /// </summary>
        /// <param name="cursor">The cursor used to fetch the follower IDs.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>        
        Task<CursoredList<TwitterProfile>> GetFollowersInCursorAsync(long cursor);

        /// <summary>
        /// Asynchronously retrieves a list of up to 20 users that the given user is being followed by.
        /// <para/>
        /// Call GetFollowersInCursor() with a cursor value to get the next/previous page of entries.
        /// <para/>
        /// If all you need is the follower IDs, consider calling GetFollowerIds() instead.
        /// </summary>
        /// <param name="userId">The user's Twitter ID.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<TwitterProfile>> GetFollowersAsync(long userId);

        /// <summary>
        /// Asynchronously retrieves a list of up to 20 users that the given user is being followed by.
        /// <para/>
        /// If all you need is the follower IDs, consider calling GetFollowerIds() instead.
        /// </summary>
        /// <param name="userId">The user's Twitter ID.</param>
        /// <param name="cursor">The cursor used to fetch the follower IDs.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<TwitterProfile>> GetFollowersInCursorAsync(long userId, long cursor);

        /// <summary>
        /// Asynchronously retrieves a list of up to 20 users that the given user is being followed by.
        /// <para/>
        /// Call GetFollowersInCursor() with a cursor value to get the next/previous page of entries.
        /// <para/>
        /// If all you need is the follower IDs, consider calling GetFollowerIds() instead.
        /// </summary>
        /// <param name="screenName">The user's Twitter screen name.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<TwitterProfile>> GetFollowersAsync(string screenName);

        /// <summary>
        /// Asynchronously retrieves a list of up to 20 users that the given user is being followed by.
        /// <para/>
        /// If all you need is the follower IDs, consider calling GetFollowerIds() instead.
        /// </summary>
        /// <param name="screenName">The user's Twitter screen name.</param>
        /// <param name="cursor">The cursor used to fetch the follower IDs.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>        
        Task<CursoredList<TwitterProfile>> GetFollowersInCursorAsync(string screenName, long cursor);

        /// <summary>
        /// Asynchronously retrieves a list of up to 5000 IDs for the Twitter users that follow the authenticated user.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetFollowerIdsAsync();

        /// <summary>
        /// Asynchronously retrieves a list of up to 5000 IDs for the Twitter users that follow the authenticated user.
        /// </summary>
        /// <param name="cursor">The cursor value to fetch a specific page of entries. Use -1 for the first page of entries.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetFollowerIdsInCursorAsync(long cursor);

        /// <summary>
        /// Asynchronously retrieves a list of up to 5000 IDs for the Twitter users that follow the given user.
        /// </summary>
        /// <param name="userId">The user's Twitter ID.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetFollowerIdsAsync(long userId);

        /// <summary>
        /// Asynchronously retrieves a list of up to 5000 IDs for the Twitter users that follow the given user.
        /// </summary>
        /// <param name="userId">The user's Twitter ID.</param>
        /// <param name="cursor">The cursor value to fetch a specific page of entries. Use -1 for the first page of entries.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetFollowerIdsInCursorAsync(long userId, long cursor);

        /// <summary>
        /// Asynchronously retrieves a list of up to 5000 IDs for the Twitter users that follow the given user.
        /// </summary>
        /// <param name="screenName">The user's Twitter screen name.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetFollowerIdsAsync(string screenName);

        /// <summary>
        /// Asynchronously retrieves a list of up to 5000 IDs for the Twitter users that follow the given user.
        /// </summary>
        /// <param name="screenName">The user's Twitter screen name.</param>
        /// <param name="cursor">The cursor value to fetch a specific page of entries. Use -1 for the first page of entries.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetFollowerIdsInCursorAsync(string screenName, long cursor);

        /// <summary>
        /// Asynchronously allows the authenticated user to follow (create a friendship) with another user.
        /// </summary>
        /// <param name="userId">The Twitter ID of the user to follow.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="TwitterProfile"/> of the followed user if successful.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception> 
        Task<TwitterProfile> FollowAsync(long userId);

        /// <summary>
        /// Asynchronously allows the authenticated user to follow (create a friendship) with another user.
        /// </summary>
        /// <param name="screenName">The screen name of the user to follow.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="TwitterProfile"/> of the followed user if successful.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<TwitterProfile> FollowAsync(string screenName);

        /// <summary>
        /// Asynchronously allows the authenticated user to follow (create a friendship) with another user.
        /// </summary>
        /// <param name="userId">The Twitter ID of the user to unfollow.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="TwitterProfile"/> of the unfollowed user if successful.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<TwitterProfile> UnfollowAsync(long userId);

        /// <summary>
        /// Asynchronously allows the authenticated use to unfollow (destroy a friendship) with another user.
        /// </summary>
        /// <param name="screenName">The screen name of the user to unfollow.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="TwitterProfile"/> of the unfollowed user if successful.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<TwitterProfile> UnfollowAsync(string screenName);

        /// <summary>
        /// Asynchronously enables mobile device notifications from Twitter for the specified user.
        /// </summary>
        /// <param name="userId">The Twitter ID of the user to receive notifications for.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task EnableNotificationsAsync(long userId);

        /// <summary>
        /// Asynchronously enables mobile device notifications from Twitter for the specified user.
        /// </summary>
        /// <param name="screenName">The Twitter screen name of the user to receive notifications for.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task EnableNotificationsAsync(string screenName);

        /// <summary>
        /// Asynchronously disable mobile device notifications from Twitter for the specified user.
        /// </summary>
        /// <param name="userId">The Twitter ID of the user to stop notifications for.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task DisableNotificationsAsync(long userId);

        /// <summary>
        /// Asynchronously disable mobile device notifications from Twitter for the specified user.
        /// </summary>
        /// <param name="screenName">The Twitter screen name of the user to stop notifications for.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task DisableNotificationsAsync(string screenName);

        /// <summary>
        /// Asynchronously returns an array of numeric IDs for every user who has a pending request to follow the authenticating user.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user ids.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetIncomingFriendshipsAsync();

        /// <summary>
        /// Asynchronously returns an array of numeric IDs for every user who has a pending request to follow the authenticating user.
        /// </summary>
        /// <param name="cursor">The cursor of the page to retrieve.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user ids.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>    
        Task<CursoredList<long>> GetIncomingFriendshipsAsync(long cursor);
     
        /// <summary>
        /// Asynchronously returns an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user ids.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetOutgoingFriendshipsAsync();

        /// <summary>
        /// Asynchronously returns an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request.
        /// </summary>
        /// <param name="cursor">The cursor of the page to retrieve.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user ids.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetOutgoingFriendshipsAsync(long cursor);
    }
}
