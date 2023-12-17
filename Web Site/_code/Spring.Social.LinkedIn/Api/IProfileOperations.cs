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
using System.Threading.Tasks;

namespace Spring.Social.LinkedIn.Api
{
    /// <summary>
    /// Interface defining the operations for retrieving and performing operations on profiles.
    /// </summary>
    /// <author>Robert Drysdale</author>
    /// <author>Bruno Baia (.NET)</author>
    public interface IProfileOperations
    {
	    /// <summary>
        /// Asynchronously retrieves the authenticated user's LinkedIn profile details.
	    /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a <see cref="LinkedInProfile"/> object representing the user's profile.
        /// </returns>
        /// <exception cref="LinkedInApiException">If there is an error while communicating with LinkedIn.</exception>
	    Task<LinkedInProfile> GetUserProfileAsync();

        /// <summary>
        /// Asynchronously retrieves a specific user's LinkedIn profile details by its ID.
        /// </summary>
        /// <param name="id">The user ID for the user whose details are to be retrieved.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a <see cref="LinkedInProfile"/> object representing the user's profile.
        /// </returns>
        /// <exception cref="LinkedInApiException">If there is an error while communicating with LinkedIn.</exception>
        Task<LinkedInProfile> GetUserProfileByIdAsync(string id);

        /// <summary>
        /// Asynchronously retrieves a specific user's LinkedIn profile details by its public url.
        /// </summary>
        /// <param name="url">The user public url for the user whose details are to be retrieved.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a <see cref="LinkedInProfile"/> object representing the user's profile.
        /// </returns>
        /// <exception cref="LinkedInApiException">If there is an error while communicating with LinkedIn.</exception>
        Task<LinkedInProfile> GetUserProfileByPublicUrlAsync(string url);

        /// <summary>
        /// Asynchronously retrieves the authenticated user's LinkedIn full profile details.
        /// </summary>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a <see cref="LinkedInFullProfile"/> object representing the full user's profile.
        /// </returns>
        /// <exception cref="LinkedInApiException">If there is an error while communicating with LinkedIn.</exception>
        Task<LinkedInFullProfile> GetUserFullProfileAsync();

        /// <summary>
        /// Asynchronously retrieves a specific user's LinkedIn full profile details by its ID.
        /// </summary>
        /// <param name="id">The user ID for the user whose details are to be retrieved.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a <see cref="LinkedInFullProfile"/> object representing the full user's profile.
        /// </returns>
        /// <exception cref="LinkedInApiException">If there is an error while communicating with LinkedIn.</exception>
        Task<LinkedInFullProfile> GetUserFullProfileByIdAsync(string id);

        /// <summary>
        /// Asynchronously retrieves a specific user's LinkedIn full profile details by its public url.
        /// </summary>
        /// <param name="url">The user public url for the user whose details are to be retrieved.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// a <see cref="LinkedInFullProfile"/> object representing the full user's profile.
        /// </returns>
        /// <exception cref="LinkedInApiException">If there is an error while communicating with LinkedIn.</exception>
        Task<LinkedInFullProfile> GetUserFullProfileByPublicUrlAsync(string url);

        /// <summary>
        /// Asynchronously searches for LinkedIn profiles based on provided parameters.
        /// </summary>
        /// <param name="parameters">The profile search parameters.</param>
        /// <returns>
        /// A <code>Task</code> that represents the asynchronous operation that can return 
        /// an object containing the search results metadata and a list of matching <see cref="LinkedInProfile"/>s.
        /// </returns>
        /// <exception cref="LinkedInApiException">If there is an error while communicating with LinkedIn.</exception>
        Task<LinkedInProfiles> SearchAsync(SearchParameters parameters);
    }
}
