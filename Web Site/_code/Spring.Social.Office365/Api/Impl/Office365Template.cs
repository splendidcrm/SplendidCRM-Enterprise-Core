/**********************************************************************************************************************
 * SplendidCRM is a Customer Relationship Management program created by SplendidCRM Software, Inc. 
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 * SplendidCRM owns all proprietary rights, including all copyrights, patents, trade secrets, and 
 * trademarks, in and to the contents of this file.  You will not link to or in any way combine the 
 * contents of this file or any derivatives with any Open Source Code in any manner that would require 
 * the contents of this file to be made available to any third party. 
 * 
 * IN NO EVENT SHALL SPLENDIDCRM BE RESPONSIBLE FOR ANY DAMAGES OF ANY KIND, INCLUDING ANY DIRECT, 
 * SPECIAL, PUNITIVE, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES.  Other limitations of liability 
 * and disclaimers set forth in the License. 
 * 
 *********************************************************************************************************************/
using System;
using System.Collections.Generic;

using Spring.Json;
using Spring.Rest.Client;
using Spring.Social.OAuth2;
using Spring.Http.Converters;
using Spring.Http.Converters.Json;

using Spring.Social.Office365.Api.Impl.Json;

namespace Spring.Social.Office365.Api.Impl
{
	public class Office365Template : AbstractOAuth2ApiBinding, IOffice365
	{
		private IMailOperations         mailOperations        ;
		private IContactOperations      contactOperations     ;
		private IEventOperations        eventOperations       ;
		private ICategoryOperations     categoryOperations    ;
		private IFolderOperations       folderOperations      ;
		private ISubscriptionOperations subscriptionOperations;
		private IMyProfileOperations    myProfileOperations   ;

		public Office365Template(string accessToken)
			: base(accessToken)
		{
			this.InitSubApis();
		}

		#region IOffice365 Members

		public IMailOperations MailOperations
		{
			get { return this.mailOperations; }
		}

		public IContactOperations ContactOperations
		{
			get { return this.contactOperations; }
		}

		public IEventOperations EventOperations
		{
			get { return this.eventOperations; }
		}

		public ICategoryOperations CategoryOperations
		{
			get { return this.categoryOperations; }
		}

		public IFolderOperations FolderOperations
		{
			get { return this.folderOperations; }
		}

		public ISubscriptionOperations SubscriptionOperations
		{
			get { return this.subscriptionOperations; }
		}

		public IMyProfileOperations MyProfileOperations
		{
			get { return this.myProfileOperations; }
		}

		public IRestOperations RestOperations
		{
			get { return this.RestTemplate; }
		}
		#endregion

		protected override void ConfigureRestTemplate(RestTemplate restTemplate)
		{
			restTemplate.BaseAddress = new Uri("https://graph.microsoft.com");
			restTemplate.ErrorHandler = new Office365ErrorHandler();
		}

		protected override OAuth2Version GetOAuth2Version()
		{
			return OAuth2Version.Bearer;
		}

		protected override IList<IHttpMessageConverter> GetMessageConverters()
		{
			IList<IHttpMessageConverter> converters = base.GetMessageConverters();
			converters.Add(new ByteArrayHttpMessageConverter());
			converters.Add(this.GetJsonMessageConverter());
			return converters;
		}

		protected virtual SpringJsonHttpMessageConverter GetJsonMessageConverter()
		{
			JsonMapper jsonMapper = new JsonMapper();
			jsonMapper.RegisterDeserializer(typeof(AccessToken                 ), new AccessTokenDeserializer              ());
			jsonMapper.RegisterDeserializer(typeof(AdditionalData              ), new AdditionalDataDeserializer           ());
			jsonMapper.RegisterDeserializer(typeof(MyProfile                   ), new MyProfileDeserializer                ());
			jsonMapper.RegisterDeserializer(typeof(IList<String>               ), new StringListDeserializer               ());
			jsonMapper.RegisterSerializer  (typeof(List<String>                ), new StringListSerializer                 ());

			// OutlookItem
			jsonMapper.RegisterDeserializer(typeof(IList<Entity>               ), new EntityDeserializer                   ());
			jsonMapper.RegisterDeserializer(typeof(EntityPagination            ), new EntityPaginationDeserializer         ());
			jsonMapper.RegisterDeserializer(typeof(IList<OutlookItem>          ), new OutlookItemDeserializer              ());
			jsonMapper.RegisterDeserializer(typeof(OutlookItemPagination       ), new OutlookItemPaginationDeserializer    ());
			// 11/22/2023 Paul.  When unsyncing, we need to immediately clear the remote flag. 
			jsonMapper.RegisterSerializer  (typeof(OutlookItem                 ), new OutlookItemSerializer                ());

			// Mail
			jsonMapper.RegisterDeserializer(typeof(EmailAddress                ), new EmailAddressDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(ItemBody                    ), new ItemBodyDeserializer                 ());
			jsonMapper.RegisterDeserializer(typeof(FollowupFlag                ), new FollowupFlagDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(Recipient                   ), new RecipientDeserializer                ());
			jsonMapper.RegisterDeserializer(typeof(Attachment                  ), new AttachmentDeserializer               ());
			jsonMapper.RegisterDeserializer(typeof(InternetMessageHeader       ), new InternetMessageHeaderDeserializer    ());
			jsonMapper.RegisterDeserializer(typeof(Message                     ), new MessageDeserializer                  ());
			jsonMapper.RegisterDeserializer(typeof(IList<EmailAddress>         ), new EmailAddressListDeserializer         ());
			jsonMapper.RegisterDeserializer(typeof(IList<Recipient>            ), new RecipientListDeserializer            ());
			jsonMapper.RegisterDeserializer(typeof(IList<Attachment>           ), new AttachmentListDeserializer           ());
			jsonMapper.RegisterDeserializer(typeof(IList<InternetMessageHeader>), new InternetMessageHeaderListDeserializer());
			jsonMapper.RegisterDeserializer(typeof(IList<Message>              ), new MessageListDeserializer              ());
			jsonMapper.RegisterDeserializer(typeof(MessagePagination           ), new MessagePaginationDeserializer        ());

			jsonMapper.RegisterSerializer  (typeof(ItemBody                    ), new ItemBodySerializer                   ());
			jsonMapper.RegisterSerializer  (typeof(EmailAddress                ), new EmailAddressSerializer               ());
			jsonMapper.RegisterSerializer  (typeof(List<EmailAddress>          ), new EmailAddressListSerializer           ());
			jsonMapper.RegisterSerializer  (typeof(FollowupFlag                ), new FollowupFlagSerializer               ());
			jsonMapper.RegisterSerializer  (typeof(Message                     ), new MessageSerializer                    ());
			jsonMapper.RegisterSerializer  (typeof(SendMessage                 ), new SendMessageSerializer                ());

			// Contact
			jsonMapper.RegisterDeserializer(typeof(ProfilePhoto                ), new ProfilePhotoDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(PhysicalAddress             ), new PhysicalAddressDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(Contact                     ), new ContactDeserializer                  ());
			jsonMapper.RegisterDeserializer(typeof(IList<Contact>              ), new ContactListDeserializer              ());
			jsonMapper.RegisterDeserializer(typeof(ContactPagination           ), new ContactPaginationDeserializer        ());

			jsonMapper.RegisterSerializer  (typeof(PhysicalAddress             ), new PhysicalAddressSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(Contact                     ), new ContactSerializer                    ());

			// Event
			jsonMapper.RegisterDeserializer(typeof(Phone                       ), new PhoneDeserializer                    ());
			jsonMapper.RegisterDeserializer(typeof(Location                    ), new LocationDeserializer                 ());
			jsonMapper.RegisterDeserializer(typeof(ResponseStatus              ), new ResponseStatusDeserializer           ());
			jsonMapper.RegisterDeserializer(typeof(OutlookGeoCoordinates       ), new OutlookGeoCoordinatesDeserializer    ());
			jsonMapper.RegisterDeserializer(typeof(OnlineMeetingInfo           ), new OnlineMeetingInfoDeserializer        ());
			jsonMapper.RegisterDeserializer(typeof(DateTimeTimeZone            ), new DateTimeTimeZoneDeserializer         ());
			jsonMapper.RegisterDeserializer(typeof(RecurrenceRange             ), new RecurrenceRangeDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(RecurrencePattern           ), new RecurrencePatternDeserializer        ());
			jsonMapper.RegisterDeserializer(typeof(PatternedRecurrence         ), new PatternedRecurrenceDeserializer      ());
			jsonMapper.RegisterDeserializer(typeof(TimeSlot                    ), new TimeSlotDeserializer                 ());
			jsonMapper.RegisterDeserializer(typeof(Attendee                    ), new AttendeeDeserializer                 ());
			jsonMapper.RegisterDeserializer(typeof(Calendar                    ), new CalendarDeserializer                 ());
			jsonMapper.RegisterDeserializer(typeof(Event                       ), new EventDeserializer                    ());
			jsonMapper.RegisterDeserializer(typeof(IList<Location>             ), new LocationListDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(IList<Attendee>             ), new AttendeeListDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(IList<Event>                ), new EventListDeserializer                ());
			jsonMapper.RegisterDeserializer(typeof(EventPagination             ), new EventPaginationDeserializer          ());

			jsonMapper.RegisterSerializer  (typeof(Phone                       ), new PhoneSerializer                      ());
			jsonMapper.RegisterSerializer  (typeof(DateTimeTimeZone            ), new DateTimeTimeZoneSerializer           ());
			jsonMapper.RegisterSerializer  (typeof(OnlineMeetingInfo           ), new OnlineMeetingInfoSerializer          ());
			jsonMapper.RegisterSerializer  (typeof(Recipient                   ), new RecipientSerializer                  ());
			jsonMapper.RegisterSerializer  (typeof(List<Recipient>             ), new RecipientListSerializer              ());
			jsonMapper.RegisterSerializer  (typeof(PatternedRecurrence         ), new PatternedRecurrenceSerializer        ());
			jsonMapper.RegisterSerializer  (typeof(RecurrencePattern           ), new RecurrencePatternSerializer          ());
			jsonMapper.RegisterSerializer  (typeof(RecurrenceRange             ), new RecurrenceRangeSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(ResponseStatus              ), new ResponseStatusSerializer             ());
			jsonMapper.RegisterSerializer  (typeof(Calendar                    ), new CalendarSerializer                   ());
			jsonMapper.RegisterSerializer  (typeof(TimeSlot                    ), new TimeSlotSerializer                   ());
			jsonMapper.RegisterSerializer  (typeof(Attendee                    ), new AttendeeSerializer                   ());
			jsonMapper.RegisterSerializer  (typeof(List<Attendee>              ), new AttendeeListSerializer               ());
			jsonMapper.RegisterSerializer  (typeof(Location                    ), new LocationSerializer                   ());
			jsonMapper.RegisterSerializer  (typeof(List<Location>              ), new LocationListSerializer               ());
			jsonMapper.RegisterSerializer  (typeof(OutlookGeoCoordinates       ), new OutlookGeoCoordinatesSerializer      ());
			jsonMapper.RegisterSerializer  (typeof(Attachment                  ), new AttachmentSerializer                 ());
			jsonMapper.RegisterSerializer  (typeof(List<Attachment>            ), new AttachmentListSerializer             ());
			jsonMapper.RegisterSerializer  (typeof(Event                       ), new EventSerializer                      ());

			// Categories
			jsonMapper.RegisterDeserializer(typeof(OutlookCategory             ), new CategoryDeserializer                 ());
			jsonMapper.RegisterDeserializer(typeof(IList<OutlookCategory>      ), new CategoryListDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(OutlookCategoryPagination   ), new CategoryPaginationDeserializer       ());
			jsonMapper.RegisterSerializer  (typeof(OutlookCategory             ), new CategorySerializer                   ());

			// Folders
			jsonMapper.RegisterDeserializer(typeof(MailFolder                  ), new FolderDeserializer                   ());
			jsonMapper.RegisterDeserializer(typeof(IList<MailFolder>           ), new FolderListDeserializer               ());
			jsonMapper.RegisterDeserializer(typeof(MailFolderPagination        ), new FolderPaginationDeserializer         ());
			jsonMapper.RegisterSerializer  (typeof(MailFolder                  ), new FolderSerializer                     ());

			// SingleValueLegacyExtendedProperty
			jsonMapper.RegisterDeserializer(typeof(SingleValueLegacyExtendedProperty       ), new SingleValuePropertyDeserializer                  ());
			jsonMapper.RegisterDeserializer(typeof(IList<SingleValueLegacyExtendedProperty>), new SingleValueLegacyExtendedPropertyListDeserializer());
			jsonMapper.RegisterSerializer  (typeof(SingleValueLegacyExtendedProperty       ), new SingleValuePropertySerializer                    ());
			jsonMapper.RegisterSerializer  (typeof(List<SingleValueLegacyExtendedProperty> ), new SingleValuePropertyListSerializer                ());

			// Subscription
			jsonMapper.RegisterDeserializer(typeof(Subscription                ), new SubscriptionDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(IList<Subscription>         ), new SubscriptionListDeserializer         ());
			jsonMapper.RegisterDeserializer(typeof(SubscriptionPagination      ), new SubscriptionPaginationDeserializer   ());
			jsonMapper.RegisterSerializer  (typeof(Subscription                ), new SubscriptionSerializer               ());
			return new SpringJsonHttpMessageConverter(jsonMapper);
		}

		private void InitSubApis()
		{
			this.mailOperations         = new MailTemplate        (this.RestTemplate);
			this.contactOperations      = new ContactTemplate     (this.RestTemplate);
			this.eventOperations        = new EventTemplate       (this.RestTemplate);
			this.categoryOperations     = new CategoryTemplate    (this.RestTemplate);
			this.folderOperations       = new FolderTemplate      (this.RestTemplate);
			this.subscriptionOperations = new SubscriptionTemplate(this.RestTemplate);
			this.myProfileOperations    = new MyProfileTemplate   (this.RestTemplate);
		}
	}
}