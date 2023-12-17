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
using Google.Apis.Util;

// https://developers.google.com/google-apps/contacts/v3/reference#contact-groups-elements-reference
namespace Google.Apis.Contacts.v3.Data
{
	public class Group
	{
		//xmlns": "http://www.w3.org/2005/Atom",
		//xmlns$batch": "http://schemas.google.com/gdata/batch",
		//xmlns$gContact": "http://schemas.google.com/contact/2008",
		//xmlns$gd": "http://schemas.google.com/g/2005"
		[JsonPropertyAttribute("id"        )] public StringValue          Id         { get; set; }
		[JsonPropertyAttribute("gd$deleted")] public Nullable<bool>       Deleted    { get; set; }
		[JsonPropertyAttribute("updated"   )] public StringValue          UpdatedRaw { get; set; }
		[JsonPropertyAttribute("category"  )] public IList<CategoryValue> Categories { get; set; }
		[JsonPropertyAttribute("title"     )] public TitleValue           Title      { get; set; }
		[JsonPropertyAttribute("content"   )] public TitleValue           Notes      { get; set; }
		[JsonPropertyAttribute("link"      )] public IList<LinkValue>     Links      { get; set; }

		[JsonIgnore]
		public string IdOnly
		{
			get
			{
				string sID = String.Empty;
				if ( !String.IsNullOrEmpty(this.Id.Value) )
				{
					string[] arrId = this.Id.Value.Split('/');
					sID = arrId[arrId.Length - 1];
				}
				return sID;
			}
		}

		[JsonIgnore]
		public Nullable<System.DateTime> Updated
		{
			get
			{
				return Utilities.GetDateTimeFromString( UpdatedRaw.Value );
			}
			set
			{
				UpdatedRaw.Value = Utilities.GetStringFromDateTime( value );
			}
		}

		public Group()
		{
			this.Id         = new StringValue        ();
			this.Deleted    = new Nullable<bool>     ();
			this.UpdatedRaw = new StringValue        ();
			this.Categories = new List<CategoryValue>();
			this.Title      = new TitleValue         ();
			this.Notes      = new TitleValue         ();
			this.Links      = new List<LinkValue>    ();
		}
	}
}

