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

namespace Spring.Social.Etsy.Api
{
	public class QBase
	{
		public String    RawContent           { get; set; }
		public string    id                   { get; set; }
		public string    cursor               { get; set; }
		public DateTime? createdAt            { get; set; }
		public DateTime? updatedAt            { get; set; }

		public string Id
		{
			get { return id; }
			set { id = value; }
		}

		public DateTime TimeCreated
		{
			get { return createdAt.HasValue ? createdAt.Value : DateTime.MinValue; }
			set { createdAt = value; }
		}

		public DateTime TimeModified
		{
			get { return updatedAt.HasValue ? updatedAt.Value : DateTime.MinValue; }
			set { updatedAt = value; }
		}

		public override string ToString()
		{
			StringBuilder sb = new StringBuilder();
			sb.AppendLine("QBase");
			sb.AppendLine("   id              : " +  this.id       );
			sb.AppendLine("   cursor          : " +  this.cursor   );
			sb.AppendLine("   createdAt       : " + (this.createdAt  .HasValue ? this.createdAt  .Value.ToString() : String.Empty));
			sb.AppendLine("   updatedAt       : " + (this.updatedAt  .HasValue ? this.updatedAt  .Value.ToString() : String.Empty));
			return sb.ToString();
		}
	}

	public class QBasePagination<T>
	{
		public IList<T>       items       { get; set; }
		public PageInfo       pageInfo    { get; set; }
		public int            count       { get; set; }
	}
}
