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
using System.IO;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Collections.Specialized;
using Spring.Json;

namespace Spring.Social.Office365.Api
{
	public class Attachment : Entity
	{
		// ItemAttachment fields. 
		public String            ContentType          { get; set; }
		public String            Name                 { get; set; }
		public long?             Size                 { get; set; }
		public bool?             IsInline             { get; set; }
		public DateTimeOffset?   LastModifiedDateTime { get; set; }
		// FileAttachment fields. 
		public String            ContentId            { get; set; }
		public String            ContentLocation      { get; set; }
		public byte[]            ContentBytes         { get; set; }  // base64

		public Attachment()
		{
			this.ODataType = "#microsoft.graph.fileAttachment";
		}

		public Attachment(string sName, string sContentType, Stream stmContent)
		{
			this.ODataType = "#microsoft.graph.fileAttachment";
			this.Name         = sName       ;
			this.ContentType  = sContentType;
			this.ContentBytes = new byte[stmContent.Length];
			// 03/01/2021 Paul.  Size is required. 
			this.Size         = stmContent.Length;
			// 03/01/2021 paul.  IsInline is required. 
			this.IsInline     = false;
			stmContent.Seek(0, SeekOrigin.Begin);
			stmContent.Read (this.ContentBytes, 0, (int) stmContent.Length);
		}
	}
}
