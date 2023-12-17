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

namespace Spring.Social.MailChimp.Api
{
	public class MergeField
	{
		public class MergeOptions
		{
			public int?         default_country { get; set; }
			public String       phone_format    { get; set; }
			public String       date_format     { get; set; }
			public int?         size            { get; set; }
			public List<String> choices         { get; set; }
		}

		public String       RawContent        { get; set; }
		public int          merge_id          { get; set; }
		public String       tag               { get; set; }
		public String       name              { get; set; }
		public String       type              { get; set; }
		public bool?        required          { get; set; }
		public String       default_value     { get; set; }
		public bool?        is_public         { get; set; }
		public int?         display_order     { get; set; }
		public String       help_text         { get; set; }
		public MergeOptions options           { get; set; }

		public MergeField()
		{
			this.merge_id      = 0;
			this.tag           = String.Empty;
			this.name          = String.Empty;
			this.type          = String.Empty;
			this.required      = false       ;
			this.default_value = String.Empty;
			this.is_public     = true        ;
			this.help_text     = String.Empty;
			this.options = new MergeOptions();
		}
	}

	// 02/16/2017 Paul.  MergeFieldPagination. 
	public class MergeFieldPagination
	{
		public IList<MergeField> items      { get; set; }
		public int               total      { get; set; }
	}

}
