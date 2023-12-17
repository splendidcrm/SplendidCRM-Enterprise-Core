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
    /// Interface defining the Twitter operations for working with direct messages.
    /// </summary>
    /// <author>Craig Walls</author>
    /// <author>Bruno Baia (.NET)</author>
    public interface IDirectMessageOperations
    {
        /// <summary>
        /// Asynchronously retrieves the 20 most recently received direct messages for the authenticating user. 
        /// The most recently received messages are listed first.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a collection of <see cref="DirectMessage"/> with the authenticating user as the recipient.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<DirectMessage>> GetDirectMessagesReceivedAsync();

        /// <summary>
        /// Asynchronously retrieves received direct messages for the authenticating user. 
        /// The most recently received messages are listed first.
        /// </summary>
        /// <param name="page">The page to return.</param>
        /// <param name="pageSize">
        /// The number of <see cref="DirectMessage"/>s per page. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200.)
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a collection of <see cref="DirectMessage"/> with the authenticating user as the recipient.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<DirectMessage>> GetDirectMessagesReceivedAsync(int page, int pageSize);

        /// <summary>
        /// Asynchronously retrieves received direct messages for the authenticating user. 
        /// The most recently received messages are listed first.
        /// </summary>
        /// <param name="page">The page to return.</param>
        /// <param name="pageSize">
        /// The number of <see cref="DirectMessage"/>s per page. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200.)
        /// </param>
        /// <param name="sinceId">The minimum <see cref="DirectMessage"/> ID to return in the results.</param>
        /// <param name="maxId">The maximum <see cref="DirectMessage"/> ID to return in the results.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a collection of <see cref="DirectMessage"/> with the authenticating user as the recipient.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<DirectMessage>> GetDirectMessagesReceivedAsync(int page, int pageSize, long sinceId, long maxId);

        /// <summary>
        /// Asynchronously retrieves the 20 most recent direct messages sent by the authenticating user. 
        /// The most recently sent messages are listed first.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a collection of <see cref="DirectMessage"/> with the authenticating user as the sender.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<DirectMessage>> GetDirectMessagesSentAsync();

        /// <summary>
        /// Asynchronously retrieves direct messages sent by the authenticating user. 
        /// The most recently sent messages are listed first.
        /// </summary>
        /// <param name="page">The page to return.</param>
        /// <param name="pageSize">
        /// The number of <see cref="DirectMessage"/>s per page. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200.)
        /// </param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a collection of <see cref="DirectMessage"/> with the authenticating user as the sender.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<DirectMessage>> GetDirectMessagesSentAsync(int page, int pageSize);

        /// <summary>
        /// Asynchronously retrieves direct messages sent by the authenticating user. 
        /// The most recently sent messages are listed first.
        /// </summary>
        /// <param name="page">The page to return.</param>
        /// <param name="pageSize">
        /// The number of <see cref="DirectMessage"/>s per page. Should be less than or equal to 200. 
        /// (Will return at most 200 entries, even if pageSize is greater than 200.)
        /// </param>
        /// <param name="sinceId">The minimum <see cref="DirectMessage"/> ID to return in the results.</param>
        /// <param name="maxId">The maximum <see cref="DirectMessage"/> ID to return in the results.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a collection of <see cref="DirectMessage"/> with the authenticating user as the sender.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<IList<DirectMessage>> GetDirectMessagesSentAsync(int page, int pageSize, long sinceId, long maxId);

        /// <summary>
        /// Asynchronously retrieves a direct message by its ID. The message must be readable by the authenticating user.
        /// </summary>
        /// <param name="id">The message ID.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="DirectMessage"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<DirectMessage> GetDirectMessageAsync(long id);
       
        /// <summary>
        /// Asynchronously sends a direct message to another Twitter user. 
        /// <para/>
        /// The recipient of the message must follow the authenticated user in order for the message to be delivered. 
        /// <para/>
        /// If the recipient is not following the authenticated user, an <see cref="TwitterApiException"/> will be thrown.
        /// </summary>
        /// <param name="toScreenName">The screen name of the recipient of the messages.</param>
        /// <param name="text">The message text.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="DirectMessage"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        /// <exception cref="TwitterApiException">If the recipient is not following the authenticating user.</exception>
        /// <exception cref="TwitterApiException">If the message duplicates a previously sent message.</exception>
        /// <exception cref="TwitterApiException">If the message length exceeds Twitter's 140 character limit.</exception>
        Task<DirectMessage> SendDirectMessageAsync(string toScreenName, string text);

        /// <summary>
        /// Asynchronously sends a direct message to another Twitter user.
        /// <para/>
        /// The recipient of the message must follow the authenticated user in order for the message to be delivered. 
        /// <para/>
        /// If the recipient is not following the authenticated user, an <see cref="TwitterApiException"/> will be thrown.
        /// </summary>
        /// <param name="toUserId">The Twitter user ID of the recipient of the messages.</param>
        /// <param name="text">The message text.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the <see cref="DirectMessage"/>.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        /// <exception cref="TwitterApiException">If the recipient is not following the authenticating user.</exception>
        /// <exception cref="TwitterApiException">If the message duplicates a previously sent message.</exception>
        /// <exception cref="TwitterApiException">If the message length exceeds Twitter's 140 character limit.</exception>
        Task<DirectMessage> SendDirectMessageAsync(long toUserId, string text);

        /// <summary>
        /// Asynchronously deletes a direct message for the authenticated user.
        /// </summary>
        /// <param name="messageId">The ID of the message to be removed.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// the deleted <see cref="DirectMessage"/>, if successful.
        /// </returns>
        /// <exception cref="TwitterApiException">If there is an error while communicating with Twitter.</exception>
        Task<DirectMessage> DeleteDirectMessageAsync(long messageId);
    }
}
