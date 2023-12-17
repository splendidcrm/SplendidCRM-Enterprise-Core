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

namespace SplendidCRM
{
	[Serializable]
	public class AlertAttachment
	{
		protected string sFileName     ;
		protected string sExtension    ;
		protected string sFileMimeType ;
		protected byte[] byContent     ;

		public string FileName
		{
			get { return sFileName; }
			set { sFileName = value; }
		}

		public string Extension
		{
			get { return sExtension; }
			set { sExtension = value; }
		}

		public string FileMimeType
		{
			get { return sFileMimeType; }
			set { sFileMimeType = value; }
		}

		public byte[] Content
		{
			get { return byContent; }
			set { byContent = value; }
		}

		public AlertAttachment(string sFileName, string sExtension, string sFileMimeType, byte[] byContent)
		{
			this.sFileName     = sFileName    ;
			this.sExtension    = sExtension   ;
			this.sFileMimeType = sFileMimeType;
			this.byContent     = byContent    ;
		}
	}
}
