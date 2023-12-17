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

namespace Spring.Social.QuickBooks.Api
{
	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/020_key_concepts/0700_other_topics#ReferenceType
	[Serializable]
	public class ReferenceType
	{
		public String Name  { get; set; }
		public String Type  { get; set; }
		public String Value { get; set; }

		public ReferenceType()
		{
		}

		public ReferenceType(string sValue)
		{
			this.Value = sValue;
		}
	}

	[Serializable]
	public class MemoRef
	{
		public String Name  { get; set; }
		public String Value { get; set; }

		public MemoRef()
		{
		}

		public MemoRef(string sValue)
		{
			this.Value = sValue;
		}
	}

	[Serializable]
	public class EntityTypeRef
	{
		public EntityTypeEnum? Type             { get; set; }
		public ReferenceType   EntityRef        { get; set; }
	}

	[Serializable]
	public class UOMRef
	{
		public String        Unit              { get; set; }
		public ReferenceType UOMSetRef         { get; set; }
	}
}
