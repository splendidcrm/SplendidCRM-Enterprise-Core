if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwQUOTES_DOCUMENTS')
	Drop View dbo.vwQUOTES_DOCUMENTS;
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
-- 01/16/2013 Paul.  Fix SELECTED_DOCUMENT_REVISION_ID. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwQUOTES_DOCUMENTS
as
select QUOTES.ID                   as QUOTE_ID
     , QUOTES.NAME                 as QUOTE_NAME
     , QUOTES.ASSIGNED_USER_ID     as QUOTE_ASSIGNED_USER_ID
     , QUOTES.ASSIGNED_SET_ID      as QUOTE_ASSIGNED_SET_ID
     , DOCUMENT_REVISIONS.ID       as SELECTED_DOCUMENT_REVISION_ID
     , DOCUMENT_REVISIONS.REVISION as SELECTED_REVISION
     , vwDOCUMENTS.ID              as DOCUMENT_ID
     , vwDOCUMENTS.*
  from            QUOTES
       inner join DOCUMENTS_QUOTES
               on DOCUMENTS_QUOTES.QUOTE_ID       = QUOTES.ID
              and DOCUMENTS_QUOTES.DELETED        = 0
       inner join vwDOCUMENTS
               on vwDOCUMENTS.ID                  = DOCUMENTS_QUOTES.DOCUMENT_ID
  left outer join DOCUMENT_REVISIONS
               on DOCUMENT_REVISIONS.ID           = DOCUMENTS_QUOTES.DOCUMENT_REVISION_ID
              and DOCUMENT_REVISIONS.DELETED      = 0
 where QUOTES.DELETED = 0

GO

Grant Select on dbo.vwQUOTES_DOCUMENTS to public;
GO

