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
    /// Interface defining the operations for working with a user's lists.
    /// </summary>
    /// <author>Craig Walls</author>
    /// <author>Bruno Baia (.NET)</author>
    public interface IListOperations
    {
        /// <summary>
        /// Asynchronously retrieves user lists for the authenticated user.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="UserList"/>s for the specified user.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<UserList>> GetListsAsync();

        /// <summary>
        /// Asynchronously retrieves user lists for the given user.
        /// </summary>
        /// <param name="userId">The ID of the Twitter user.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="UserList"/>s for the specified user.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<UserList>> GetListsAsync(long userId);

        /// <summary>
        /// Asynchronously retrieves user lists for the given user.
        /// </summary>
        /// <param name="screenName">The screen name of the Twitter user.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="UserList"/>s for the specified user.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<UserList>> GetListsAsync(string screenName);

        /// <summary>
        /// Asynchronously retrieves a specific user list.
        /// </summary>
        /// <param name="listId">The ID of the list to retrieve.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the requested <see cref="UserList"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<UserList> GetListAsync(long listId);

        /// <summary>
        /// Asynchronously retrieves a specific user list.
        /// </summary>
        /// <param name="screenName">The screen name of the list owner.</param>
        /// <param name="listSlug">The lists's slug.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the requested <see cref="UserList"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<UserList> GetListAsync(string screenName, string listSlug);

        /// <summary>
        /// Asynchronously retrieves the timeline tweets for the given user list.
        /// </summary>
        /// <param name="listId">The ID of the list to retrieve.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/> objects for the items in the user list timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetListStatusesAsync(long listId);

        /// <summary>
        /// Asynchronously retrieves the timeline tweets for the given user list.
        /// </summary>
        /// <param name="listId">The ID of the list to retrieve.</param>
        /// <param name="count">The number of <see cref="Tweet"/>s to retrieve.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/> objects for the items in the user list timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetListStatusesAsync(long listId, int count);

        /// <summary>
        /// Asynchronously retrieves the timeline tweets for the given user list.
        /// </summary>
        /// <param name="listId">The ID of the list to retrieve.</param>
        /// <param name="count">The number of <see cref="Tweet"/>s to retrieve.</param>
        /// <param name="sinceId">The minimum <see cref="Tweet"/> ID to return in the results.</param>
        /// <param name="maxId">The maximum <see cref="Tweet"/> ID to return in the results.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/> objects for the items in the user list timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetListStatusesAsync(long listId, int count, long sinceId, long maxId);

        /// <summary>
        /// Asynchronously retrieves the timeline tweets for the given user list.
        /// </summary>
        /// <param name="screenName">The screen name of the Twitter user.</param>
        /// <param name="listSlug">The list's slug.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/> objects for the items in the user list timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetListStatusesAsync(string screenName, string listSlug);

        /// <summary>
        /// Asynchronously retrieves the timeline tweets for the given user list.
        /// </summary>
        /// <param name="screenName">The screen name of the Twitter user.</param>
        /// <param name="listSlug">The list's slug.</param>
        /// <param name="count">The number of <see cref="Tweet"/>s to retrieve.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/> objects for the items in the user list timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetListStatusesAsync(string screenName, string listSlug, int count);

        /// <summary>
        /// Asynchronously retrieves the timeline tweets for the given user list.
        /// </summary>
        /// <param name="screenName">The screen name of the Twitter user.</param>
        /// <param name="listSlug">The list's slug.</param>
        /// <param name="count">The number of <see cref="Tweet"/>s to retrieve.</param>
        /// <param name="sinceId">The minimum <see cref="Tweet"/> ID to return in the results.</param>
        /// <param name="maxId">The maximum <see cref="Tweet"/> ID to return in the results.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="Tweet"/> objects for the items in the user list timeline.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<Tweet>> GetListStatusesAsync(string screenName, string listSlug, int count, long sinceId, long maxId);

        /// <summary>
        /// Asynchronously creates a new user list.
        /// </summary>
        /// <param name="name">The name of the list.</param>
        /// <param name="description">The list description.</param>
        /// <param name="isPublic">If true, the list will be public; if false the list will be private.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the newly created <see cref="UserList"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<UserList> CreateListAsync(string name, string description, bool isPublic);

        /// <summary>
        /// Asynchronously updates an existing user list
        /// </summary>
        /// <param name="listId">The ID of the list.</param>
        /// <param name="name">The new name of the list.</param>
        /// <param name="description">The new list description.</param>
        /// <param name="isPublic">If true, the list will be public; if false the list will be private.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the newly updated <see cref="UserList"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<UserList> UpdateListAsync(long listId, string name, string description, bool isPublic);

        /// <summary>
        /// Asynchronously removes a user list.
        /// </summary>
        /// <param name="listId">The ID of the list to be removed.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the deleted <see cref="UserList"/>, if successful.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<UserList> DeleteListAsync(long listId);

	    /// <summary>
        /// Asynchronously retrieves a list of Twitter profiles whose users are members of the list.
	    /// </summary>
        /// <param name="listId">The ID of the list.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<TwitterProfile>> GetListMembersAsync(long listId);

        /// <summary>
        /// Asynchronously retrieves a list of Twitter profiles whose users are members of the list.
        /// </summary>
        /// <param name="screenName">The screen name of the list owner.</param>
        /// <param name="listSlug">The slug of the list.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="TwitterProfile"/>s.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<TwitterProfile>> GetListMembersAsync(string screenName, string listSlug);

        /// <summary>
        /// Asynchronously adds one or more new members to a user list.
        /// </summary>
        /// <param name="listId">The ID of the list.</param>
        /// <param name="newMemberIds">One or more profile IDs of the Twitter profiles to add to the list.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="UserList"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<UserList> AddToListAsync(long listId, params long[] newMemberIds);

        /// <summary>
        /// Asynchronously adds one or more new members to a user list.
        /// </summary>
        /// <param name="listId">The ID of the list.</param>
        /// <param name="newMemberScreenNames">One or more profile IDs of the Twitter profiles to add to the list.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="UserList"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<UserList> AddToListAsync(long listId, params string[] newMemberScreenNames);

	    /// <summary>
        /// Asynchronously removes a member from a user list.
	    /// </summary>
        /// <param name="listId">The ID of the list.</param>
        /// <param name="memberId">The ID of the member to be removed.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task RemoveFromListAsync(long listId, long memberId);

        /// <summary>
        /// Asynchronously removes a member from a user list.
        /// </summary>
        /// <param name="listId">The ID of the list.</param>
        /// <param name="memberScreenName">The screen name of the member to be removed.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task RemoveFromListAsync(long listId, string memberScreenName);

	    /// <summary>
        /// Asynchronously subscribes the authenticating user to a list.
	    /// </summary>
        /// <param name="listId">The ID of the list.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="UserList"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<UserList> SubscribeAsync(long listId);

        /// <summary>
        /// Asynchronously subscribes the authenticating user to a list.
        /// </summary>
        /// <param name="screenName">The screen name of the list owner.</param>
        /// <param name="listSlug">The slug of the list.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="UserList"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<UserList> SubscribeAsync(string screenName, string listSlug);

        /// <summary>
        /// Asynchronously unsubscribes the authenticating user from a list.
        /// </summary>
        /// <param name="listId">The ID of the list.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="UserList"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<UserList> UnsubscribeAsync(long listId);

        /// <summary>
        /// Asynchronously unsubscribes the authenticating user from a list.
        /// </summary>
        /// <param name="screenName">The screen name of the list owner.</param>
        /// <param name="listSlug">The slug of the list.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="UserList"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<UserList> UnsubscribeAsync(string screenName, string listSlug);

        /// <summary>
        /// Asynchronously retrieves the subscribers to a list.
        /// </summary>
        /// <param name="listId">The ID of the list.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="TwitterProfile"/>s for the list's subscribers.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<TwitterProfile>> GetListSubscribersAsync(long listId);

        /// <summary>
        /// Asynchronously retrieves the subscribers to a list.
        /// </summary>
        /// <param name="screenName">The screen name of the list owner.</param>
        /// <param name="listSlug">The slug of the list.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="TwitterProfile"/>s for the list's subscribers.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<TwitterProfile>> GetListSubscribersAsync(string screenName, string listSlug);

	    /// <summary>
        /// Asynchronously retrieves the lists that a given user is a member of.
	    /// </summary>
        /// <param name="userId">The user ID.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="UserList"/>s that the user is a member of.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<UserList>> GetMembershipsAsync(long userId);

        /// <summary>
        /// Asynchronously retrieves the lists that a given user is a member of.
        /// </summary>
        /// <param name="screenName">The user's screen name.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="UserList"/>s that the user is a member of.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<UserList>> GetMembershipsAsync(string screenName);

        /// <summary>
        /// Asynchronously retrieves the lists that a given user is subscribed to.
        /// </summary>
        /// <param name="userId">The user ID.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="UserList"/>s that the user is subscribed to.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<UserList>> GetSubscriptionsAsync(long userId);

        /// <summary>
        /// Asynchronously retrieves the lists that a given user is subscribed to.
        /// </summary>
        /// <param name="screenName">The user's screen name.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a list of <see cref="UserList"/>s that the user is subscribed to.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<UserList>> GetSubscriptionsAsync(string screenName);

        /// <summary>
        /// Asynchronously checks to see if a given user is a member of a given list.
        /// </summary>
        /// <param name="listId">The list ID.</param>
        /// <param name="memberId">The user ID to check for membership.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a value indicating whether or not the user is a member of the list.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<bool> IsMemberAsync(long listId, long memberId);
	
        /// <summary>
        /// Asynchronously checks to see if a given user is a member of a given list.
        /// </summary>
        /// <param name="screenName">The screen name of the list's owner.</param>
        /// <param name="listSlug">The list's slug.</param>
        /// <param name="memberScreenName">The screenName to check for membership.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a value indicating whether or not the user is a member of the list.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<bool> IsMemberAsync(string screenName, string listSlug, string memberScreenName);

        /// <summary>
        /// Asynchronously checks to see if a given user subscribes to a given list.
        /// </summary>
        /// <param name="listId">The list ID.</param>
        /// <param name="subscriberId">The user ID to check for subscribership.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a value indicating whether or not the user subscribes to the list.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<bool> IsSubscriberAsync(long listId, long subscriberId);
	
        /// <summary>
        /// Asynchronously checks to see if a given user subscribes to a given list.
        /// </summary>
        /// <param name="screenName">The screen name of the list's owner.</param>
        /// <param name="listSlug">The list's slug.</param>
        /// <param name="subscriberScreenName">The screenName to check for subscribership.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a value indicating whether or not the user subscribes to the list.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<bool> IsSubscriberAsync(string screenName, string listSlug, string subscriberScreenName);
    }
}
