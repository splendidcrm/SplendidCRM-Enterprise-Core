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
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Web;
using System.Diagnostics;
using SplendidCRM;

namespace Spring.Social.MailChimp
{
	public class Contact : Prospect
	{
		// 05/29/2016 Paul.  Add merge fields. 
		public Contact(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.MailChimp.Api.IMailChimp mailChimp, string list_id, Guid gPROSPECT_LIST_ID, DataTable dtMergeFields)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, mailChimp, "Contacts", list_id, gPROSPECT_LIST_ID, "CONTACTS", dtMergeFields)
		{
		}
	}
}