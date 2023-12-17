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

namespace Spring.Social.iContact.Api
{
	[Serializable]
	public class Account
	{
		// https://app.icontact.com/icp/a/
		public String   RawContent         { get; set; }
		public String   billingStreet      { get; set; }
		public String   billingCity        { get; set; }
		public String   billingState       { get; set; }
		public String   billingPostalCode  { get; set; }
		public String   billingCountry     { get; set; }
		public String   city               { get; set; }
		public String   accountId          { get; set; }
		public String   companyName        { get; set; }
		public String   country            { get; set; }
		public String   email              { get; set; }
		public String   enabled            { get; set; }
		public String   fax                { get; set; }
		public String   firstName          { get; set; }
		public String   lastName           { get; set; }
		public String   multiClientFolder  { get; set; }
		public String   multiUser          { get; set; }
		public String   phone              { get; set; }
		public String   postalCode         { get; set; }
		public String   state              { get; set; }
		public String   street             { get; set; }
		public String   title              { get; set; }
		public String   accountType        { get; set; }
		public String   subscriberLimit    { get; set; }
	}
}
