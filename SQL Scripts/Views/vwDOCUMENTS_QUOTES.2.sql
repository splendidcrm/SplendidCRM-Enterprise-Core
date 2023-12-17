if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDOCUMENTS_QUOTES')
	Drop View dbo.vwDOCUMENTS_QUOTES;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwDOCUMENTS_QUOTES
as
select DOCUMENTS.ID                   as DOCUMENT_ID
     , DOCUMENTS.DOCUMENT_NAME        as DOCUMENT_NAME
     , DOCUMENTS.ASSIGNED_USER_ID     as DOCUMENT_ASSIGNED_USER_ID
     , DOCUMENTS.ASSIGNED_SET_ID      as DOCUMENT_ASSIGNED_SET_ID
     , DOCUMENT_REVISIONS.REVISION    as REVISION
     , DOCUMENT_REVISIONS.ID          as SELECTED_DOCUMENT_REVISION_ID
     , DOCUMENT_REVISIONS.REVISION    as SELECTED_REVISION
     , vwQUOTES.ID                    as QUOTE_ID
     , vwQUOTES.NAME                  as QUOTE_NAME
     , vwQUOTES.*
  from           DOCUMENTS
      inner join DOCUMENTS_QUOTES
              on DOCUMENTS_QUOTES.DOCUMENT_ID = DOCUMENTS.ID
             and DOCUMENTS_QUOTES.DELETED     = 0
      inner join vwQUOTES
              on vwQUOTES.ID                  = DOCUMENTS_QUOTES.QUOTE_ID
  left outer join DOCUMENT_REVISIONS
               on DOCUMENT_REVISIONS.ID       = DOCUMENTS_QUOTES.DOCUMENT_REVISION_ID
              and DOCUMENT_REVISIONS.DELETED  = 0
 where DOCUMENTS.DELETED = 0

GO

Grant Select on dbo.vwDOCUMENTS_QUOTES to public;
GO


