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

namespace Google.Apis.Contacts.v3
{
	public class ContactsService : Google.Apis.Services.BaseClientService
	{
		public const string Version = "v3";
		private readonly GroupsResource   groups  ;
		private readonly ContactsResource contacts;

		public static Google.Apis.Discovery.DiscoveryVersion DiscoveryVersionUsed = Google.Apis.Discovery.DiscoveryVersion.Version_1_0;

		public ContactsService() : this( new Google.Apis.Services.BaseClientService.Initializer() )
		{
		}

		public ContactsService(Google.Apis.Services.BaseClientService.Initializer initializer) : base( initializer )
		{
			groups   = new GroupsResource  (this);
			contacts = new ContactsResource(this);
		}

		public override IList<string> Features { get { return new string[0]                     ; } }
		public override string        Name     { get { return "contacts"                        ; } }
		public override string        BaseUri  { get { return "https://www.google.com/m8/feeds/"; } }
		public override string        BasePath { get { return "m8/feeds/"                       ; } }

		public class Scope
		{
			// https://developers.google.com/google-apps/contacts/v3/?hl=en
			public static string Contacts         = "https://www.google.com/m8/feeds";
			public static string ContactsReadonly = "https://www.googleapis.com/auth/contacts.readonly";
		}

		public virtual GroupsResource   Groups   { get { return groups  ; } }
		public virtual ContactsResource Contacts { get { return contacts; } }
	}
}

