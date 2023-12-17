if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwLINKED_DOCUMENTS')
	Drop View dbo.vwLINKED_DOCUMENTS;
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
Create View dbo.vwLINKED_DOCUMENTS
as
select LEADS.ID                              as LEAD_ID
     , LEADS.ASSIGNED_USER_ID                as LEAD_ASSIGNED_USER_ID
     , LEADS.ASSIGNED_SET_ID                 as LEAD_ASSIGNED_SET_ID
     , dbo.fnFullName(LEADS.FIRST_NAME, LEADS.LAST_NAME) as LEAD_NAME
     , LINKED_DOCUMENTS.PARENT_TYPE          as PARENT_TYPE
     , vwDOCUMENTS.ID                        as DOCUMENT_ID
     , vwDOCUMENTS.*
  from           LEADS
      inner join LINKED_DOCUMENTS
              on LINKED_DOCUMENTS.PARENT_ID = LEADS.ID
             and LINKED_DOCUMENTS.DELETED   = 0
      inner join vwDOCUMENTS
              on vwDOCUMENTS.ID             = LINKED_DOCUMENTS.DOCUMENT_ID
 where LEADS.DELETED = 0

GO

Grant Select on dbo.vwLINKED_DOCUMENTS to public;
GO


