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
using Newtonsoft.Json;

// https://developers.google.com/google-apps/contacts/v3/reference#contact-groups-elements-reference
namespace Google.Apis.Contacts.v3.Data
{
	public class GroupEntry : Google.Apis.Requests.IDirectResponseSchema
	{
		[JsonPropertyAttribute("etag"    )] public string      ETag     { get; set; } 
		[JsonPropertyAttribute("version" )] public string      Version  { get; set; }
		[JsonPropertyAttribute("encoding")] public string      Encoding { get; set; }
		[JsonPropertyAttribute("entry"   )] public Group       Entry    { get; set; }

		public GroupEntry()
		{
			this.Entry = new Group();
		}

		public void CreateNew(string sName)
		{
			this.Version  = "1.0"  ;
			this.Encoding = "UTF-8";
			this.Entry    = new Group();
			this.Entry.Title = new TitleValue();
			this.Entry.Title.Type  = "text";
			this.Entry.Title.Value = sName;
			this.Entry.Categories  = new List<CategoryValue>();
			CategoryValue category = new CategoryValue();
			category.Scheme = "http://schemas.google.com/g/2005#kind";
			category.Term   = "http://schemas.google.com/contact/2008#group";
			this.Entry.Categories.Add(category);
		}
	}
}

