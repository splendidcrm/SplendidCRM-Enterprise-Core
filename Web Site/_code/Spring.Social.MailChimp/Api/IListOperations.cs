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
using System.Collections.Generic;
using Spring.Rest.Client;
using Spring.Http;

namespace Spring.Social.MailChimp.Api
{
	public interface IListOperations
	{
		IList<HBase>                              GetModified(DateTime startModifiedDate);
		IList<Spring.Social.MailChimp.Api.List>   GetAll     ();
		Spring.Social.MailChimp.Api.List          GetById    (string   id );
		Spring.Social.MailChimp.Api.List          Insert     (Spring.Social.MailChimp.Api.List     obj);
		void                                      Update     (Spring.Social.MailChimp.Api.List     obj);
		void                                      Delete     (string   id );
		IList<Spring.Social.MailChimp.Api.Member> GetMembers (string   id );
		// 05/29/2016 Paul.  Add merge fields. 
		IList<Spring.Social.MailChimp.Api.MergeField> GetMergeFields(string id);
		Spring.Social.MailChimp.Api.MergeField        AddMergeField (string id, Spring.Social.MailChimp.Api.MergeField obj);
	}
}
