if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwKBDOCUMENT_ATTACHMENTS')
	Drop View dbo.vwKBDOCUMENT_ATTACHMENTS;
GO

if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwKBDOCUMENTS_ATTACHMENTS')
	Drop View dbo.vwKBDOCUMENTS_ATTACHMENTS;
GO


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
 *********************************************************************************************************************/
Create View dbo.vwKBDOCUMENTS_ATTACHMENTS
as
select NOTE_ATTACHMENTS.ID
     , NOTE_ATTACHMENTS.DESCRIPTION
     , NOTE_ATTACHMENTS.NOTE_ID         as KBDOCUMENT_ID
     , NOTE_ATTACHMENTS.FILENAME
     , NOTE_ATTACHMENTS.FILE_MIME_TYPE
     , NOTE_ATTACHMENTS.DATE_ENTERED 
     , USERS_CREATED_BY.USER_NAME       as CREATED_BY
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
  from            NOTE_ATTACHMENTS
  left outer join USERS USERS_CREATED_BY
               on USERS_CREATED_BY.ID = NOTE_ATTACHMENTS.CREATED_BY
 where NOTE_ATTACHMENTS.DELETED = 0

GO

Grant Select on dbo.vwKBDOCUMENTS_ATTACHMENTS to public;
GO

