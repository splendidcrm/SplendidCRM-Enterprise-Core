if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDOCUMENT_REVISIONS')
	Drop View dbo.vwDOCUMENT_REVISIONS;
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
-- 04/26/2012 Paul.  Add NAME, ASSIGNED_USER_ID and ASSIGNED_TO_NAME. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwDOCUMENT_REVISIONS
as
select DOCUMENT_REVISIONS.ID
     , DOCUMENT_REVISIONS.CHANGE_LOG
     , DOCUMENT_REVISIONS.DOCUMENT_ID
     , DOCUMENT_REVISIONS.FILENAME
     , DOCUMENT_REVISIONS.FILE_MIME_TYPE
     , DOCUMENT_REVISIONS.REVISION
     , DOCUMENT_REVISIONS.DATE_ENTERED 
     , DOCUMENTS.DOCUMENT_NAME          as NAME
     , DOCUMENTS.ASSIGNED_USER_ID
     , USERS_ASSIGNED.USER_NAME         as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME       as CREATED_BY
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , ASSIGNED_SETS.ID                   as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME    as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST    as ASSIGNED_SET_LIST
  from            DOCUMENT_REVISIONS
  left outer join DOCUMENTS
               on DOCUMENTS.ID               = DOCUMENT_REVISIONS.DOCUMENT_ID
  left outer join USERS                        USERS_ASSIGNED
               on USERS_ASSIGNED.ID          = DOCUMENTS.ASSIGNED_USER_ID
  left outer join USERS                        USERS_CREATED_BY
               on USERS_CREATED_BY.ID        = DOCUMENT_REVISIONS.CREATED_BY
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID           = DOCUMENTS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED      = 0
 where DOCUMENT_REVISIONS.DELETED = 0

GO

Grant Select on dbo.vwDOCUMENT_REVISIONS to public;
GO

