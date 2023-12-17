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
using Spring.Rest.Client;

namespace Spring.Social.LinkedIn.Api.Impl
{
    /// <summary>
    /// Implementation of <see cref="ICommunicationOperations"/>, providing a binding to LinkedIn's communications-oriented REST resources.
    /// </summary>
    /// <author>Robert Drysdale</author>
    /// <author>Bruno Baia</author>
    class CommunicationTemplate : ICommunicationOperations
    {
        private RestTemplate restTemplate;

        public CommunicationTemplate(RestTemplate restTemplate)
        {
            this.restTemplate = restTemplate;
        }

        #region ICommunicationOperations Members

        public Task SendMessageAsync(string subject, string body, string recipientId)
        {
            return this.restTemplate.PostForMessageAsync("people/~/mailbox", new Message(subject, body, new string[] { recipientId }));
        }

        public Task SendMessageAsync(string subject, string body, string[] recipientIds)
        {
            return this.restTemplate.PostForMessageAsync("people/~/mailbox", new Message(subject, body, recipientIds));
        }

        public Task ConnectToAsync(string subject, string body, string recipientId, string recipientAuthToken)
        {
            return this.restTemplate.PostForMessageAsync("people/~/mailbox", new Invitation(subject, body, new InvitationRecipient(recipientId, recipientAuthToken)));
        }

        public Task ConnectToAsync(string subject, string body, string email, string firstName, string lastName)
        {
            return this.restTemplate.PostForMessageAsync("people/~/mailbox", new Invitation(subject, body, new InvitationRecipient(email, firstName, lastName)));
        }
        #endregion
    }
}
