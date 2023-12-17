if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDOCUMENTS_OPPORTUNITIES')
	Drop View dbo.vwDOCUMENTS_OPPORTUNITIES;
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
Create View dbo.vwDOCUMENTS_OPPORTUNITIES
as
select DOCUMENTS.ID                   as DOCUMENT_ID
     , DOCUMENTS.DOCUMENT_NAME        as DOCUMENT_NAME
     , DOCUMENTS.ASSIGNED_USER_ID     as DOCUMENT_ASSIGNED_USER_ID
     , DOCUMENTS.ASSIGNED_SET_ID      as DOCUMENT_ASSIGNED_SET_ID
     , DOCUMENT_REVISIONS.REVISION    as REVISION
     , DOCUMENT_REVISIONS.ID          as SELECTED_DOCUMENT_REVISION_ID
     , DOCUMENT_REVISIONS.REVISION    as SELECTED_REVISION
     , vwOPPORTUNITIES.ID             as OPPORTUNITY_ID
     , vwOPPORTUNITIES.NAME           as OPPORTUNITY_NAME
     , vwOPPORTUNITIES.*
  from            DOCUMENTS
       inner join OPPORTUNITIES_DOCUMENTS
               on OPPORTUNITIES_DOCUMENTS.DOCUMENT_ID = DOCUMENTS.ID
              and OPPORTUNITIES_DOCUMENTS.DELETED     = 0
       inner join vwOPPORTUNITIES
               on vwOPPORTUNITIES.ID                  = OPPORTUNITIES_DOCUMENTS.OPPORTUNITY_ID
  left outer join DOCUMENT_REVISIONS
               on DOCUMENT_REVISIONS.ID               = OPPORTUNITIES_DOCUMENTS.DOCUMENT_REVISION_ID
              and DOCUMENT_REVISIONS.DELETED          = 0
 where DOCUMENTS.DELETED = 0
GO

Grant Select on dbo.vwDOCUMENTS_OPPORTUNITIES to public;
GO

