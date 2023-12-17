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

namespace Spring.Social.QuickBooks.Api
{
	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/invoice
	public class QBase
	{
		public String                    RawContent                        { get; set; }
		public String                    Id                                { get; set; }
		public String                    SyncToken                         { get; set; }
		public ModificationMetaData      MetaData                          { get; set; }

		public DateTime TimeCreated
		{
			get { return MetaData != null ? MetaData.CreateTime      : DateTime.MinValue; }
		}

		public DateTime TimeModified
		{
			get { return MetaData != null ? MetaData.LastUpdatedTime : DateTime.MinValue; }
		}
	}

	public class QBasePagination
	{
		public IList<QBase> Items         { get; set; }
		public int          StartPosition { get; set; }
		public int          MaxResults    { get; set; }
		public int          TotalCount    { get; set; }
	}
}
