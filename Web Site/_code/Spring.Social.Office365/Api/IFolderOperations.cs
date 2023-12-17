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

namespace Spring.Social.Office365.Api
{
	public interface IFolderOperations
	{
		// 10/28/2022 Paul.  Mailbox may include subfolders. 
		IList<MailFolder>   GetAll            (string     sMAILBOX);
		MailFolder          GetById           (string     id    );
		MailFolder          Insert            (string parentFolderId, string displayName);
		MailFolder          Update            (MailFolder obj   );
		void                Delete            (string     id    );
		// 10/28/2022 Paul.  Change name to reflect function.  The entire message is not returned, just the ids. 
		MessagePagination   GetMessageIds     (string     id, string search, string sort, int nPageOffset, int nPageSize);
		MessagePagination   GetMessagesDelta  (string     id, string stateToken, int nPageSize);
		// 10/28/2022 Paul.  Mailbox may include subfolders. 
		IList<MailFolder>   GetChildFolders   (string     id, string sMAILBOX);
		MailFolder          GetWellKnownFolder(string     folderName);
	}
}
