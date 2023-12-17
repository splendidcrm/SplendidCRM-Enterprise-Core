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

namespace Google.Apis.Contacts.v3.Data
{
	public class ContactFeed
	{
		[JsonPropertyAttribute("id"                     )] public StringValue          Id              { get; set; }
		[JsonPropertyAttribute("updated"                )] public StringValue          UpdatedRaw      { get; set; }
		[JsonPropertyAttribute("category"               )] public IList<CategoryValue> Categories      { get; set; }
		[JsonPropertyAttribute("title"                  )] public TitleValue           Title           { get; set; }
		[JsonPropertyAttribute("link"                   )] public IList<LinkValue>     Links           { get; set; }
		[JsonPropertyAttribute("author"                 )] public IList<AuthorValue>   Authors         { get; set; }
		[JsonPropertyAttribute("generator"              )] public GeneratorValue       Generator       { get; set; }
		[JsonPropertyAttribute("openSearch$totalResults")] public StringValue          TotalResultsRaw { get; set; }
		[JsonPropertyAttribute("openSearch$startIndex"  )] public StringValue          StartIndexRaw   { get; set; }
		[JsonPropertyAttribute("openSearch$itemsPerPage")] public StringValue          ItemsPerPageRaw { get; set; }
		[JsonPropertyAttribute("entry"                  )] public IList<Contact>       Items           { get; set; }

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

		[JsonIgnore]
		public long TotalResults
		{
			get
			{
				long n = 0;
				if ( this.TotalResultsRaw != null && this.TotalResultsRaw.Value != null )
					Int64.TryParse(this.TotalResultsRaw.Value, out n);
				return n;
			}
		}

		[JsonIgnore]
		public long StartIndex
		{
			get
			{
				long n = 0;
				if ( this.StartIndexRaw != null && this.StartIndexRaw.Value != null )
					Int64.TryParse(this.StartIndexRaw.Value, out n);
				return n;
			}
		}

		[JsonIgnore]
		public long ItemsPerPage
		{
			get
			{
				long n = 0;
				if ( this.ItemsPerPageRaw != null && this.ItemsPerPageRaw.Value != null )
					Int64.TryParse(this.ItemsPerPageRaw.Value, out n);
				return n;
			}
		}

		public ContactFeed()
		{
			this.Id              = new StringValue        ();
			this.UpdatedRaw      = new StringValue        ();
			this.Categories      = new List<CategoryValue>();
			this.Title           = new TitleValue         ();
			this.Links           = new List<LinkValue>    ();
			this.Authors         = new List<AuthorValue>  ();
			this.Generator       = new GeneratorValue     ();
			this.TotalResultsRaw = new StringValue        ();
			this.StartIndexRaw   = new StringValue        ();
			this.ItemsPerPageRaw = new StringValue        ();
			this.Items           = new List<Contact>      ();
		}
	}
}

