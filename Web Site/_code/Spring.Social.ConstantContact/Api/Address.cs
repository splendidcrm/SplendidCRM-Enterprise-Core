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
	public class Address
	{
		// http://developer.constantcontact.com/docs/contacts-api/contacts-resource.html
		public String    id               { get; set; }
		public String    address_type     { get; set; }
		public String    line1            { get; set; }
		public String    line2            { get; set; }
		public String    line3            { get; set; }
		public String    city             { get; set; }
		public String    state            { get; set; }
		public String    state_code       { get; set; }
		public String    postal_code      { get; set; }
		public String    sub_postal_code  { get; set; }
		public String    country_code     { get; set; }

		public Address()
		{
		}

		public Address(string address_type)
		{
			this.address_type = address_type;
		}

		public bool IsEmptyAddress()
		{
			return String.IsNullOrEmpty(this.line1          )
			    && String.IsNullOrEmpty(this.line2          )
			    && String.IsNullOrEmpty(this.line3          )
			    && String.IsNullOrEmpty(this.city           )
			    && String.IsNullOrEmpty(this.state          )
			    && String.IsNullOrEmpty(this.state_code     )
			    && String.IsNullOrEmpty(this.postal_code    )
			    && String.IsNullOrEmpty(this.sub_postal_code)
			    && String.IsNullOrEmpty(this.country_code   )
			    ;
		}
	}
}
