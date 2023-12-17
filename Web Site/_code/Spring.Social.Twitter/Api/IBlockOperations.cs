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
    /// Interface defining the operations for blocking and unblocking users
    /// </summary>
    /// <author>Craig Walls</author>
    /// <author>Bruno Baia (.NET)</author>
    public interface IBlockOperations
    {
        /// <summary>
        /// Asynchronously blocks a user. If a friendship exists with the user, it will be destroyed.
        /// </summary>
        /// <param name="userId">The ID of the user to block.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="TwitterProfile"/> of the blocked user.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<TwitterProfile> BlockAsync(long userId);

        /// <summary>
        /// Asynchronously blocks a user. If a friendship exists with the user, it will be destroyed.
        /// </summary>
        /// <param name="screenName">The screen name of the user to block.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="TwitterProfile"/> of the blocked user.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<TwitterProfile> BlockAsync(string screenName);

        /// <summary>
        /// Asynchronously unblocks a user.
        /// </summary>
        /// <param name="userId">The ID of the user to unblock.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="TwitterProfile"/> of the unblocked user.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<TwitterProfile> UnblockAsync(long userId);

        /// <summary>
        /// Asynchronously unblocks a user.
        /// </summary>
        /// <param name="screenName">The screen name of the user to unblock.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="TwitterProfile"/> of the unblocked user.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<TwitterProfile> UnblockAsync(string screenName);

        /// <summary>
        /// Asynchronously retrieves the first cursored list of users that the authenticating user has blocked.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s for the users that are blocked.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<TwitterProfile>> GetBlockedUsersAsync();

        /// <summary>
        /// Asynchronously retrieves a cursored list of users that the authenticating user has blocked.
        /// </summary>
        /// <param name="cursor">
        /// The cursor to retrieve results from. -1 will retrieve the first cursored page of results.
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of <see cref="TwitterProfile"/>s for the users that are blocked.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<TwitterProfile>> GetBlockedUsersAsync(long cursor);

        /// <summary>
        /// Asynchronously retrieves the first cursored list of user IDs for the users that the authenticating user has blocked.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs for the users that are blocked.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetBlockedUserIdsAsync();

        /// <summary>
        /// Asynchronously retrieves a cursored list of user IDs for the users that the authenticating user has blocked.
        /// </summary>
        /// <param name="cursor">
        /// The cursor to retrieve results from. -1 will retrieve the first cursored page of results.
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a cursored list of user IDs for the users that are blocked.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<CursoredList<long>> GetBlockedUserIdsAsync(long cursor);
    }
}
