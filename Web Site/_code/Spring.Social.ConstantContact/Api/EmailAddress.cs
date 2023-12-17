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
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Collections.Specialized;
using Spring.Json;

namespace Spring.Social.ConstantContact.Api
{
	[Serializable]
	public class EmailAddress
	{
		// http://developer.constantcontact.com/docs/contacts-api/contacts-resource.html
		// 11/11/2019 Paul.  Updated to v3. 
		// https://v3.developer.constantcontact.com/api_reference/index.html#!/Contacts/getContacts
		public String    permission_to_send { get; set; }
		public String    confirm_status     { get; set; }
		public String    address            { get; set; }
		public DateTime? opt_in_date        { get; set; }
		public String    opt_in_source      { get; set; }
		public String    opt_out_date       { get; set; }
		public String    opt_out_source     { get; set; }

		public EmailAddress()
		{
		}

		public EmailAddress(string email_address)
		{
			this.address = email_address;
		}
	}
}
