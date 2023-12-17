if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwKBDOCUMENTS')
	Drop View dbo.vwKBDOCUMENTS;
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
-- 10/26/2009 Paul.  Knowledge Base attachments will be stored in the Note Attachments table. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 08/01/2010 Paul.  Add ASSIGNED_TO_NAME so that we can display the full name in lists like Sugar. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 08/19/2016 Paul.  Add support for Business Processes. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwKBDOCUMENTS
as
select KBDOCUMENTS.ID
     , KBDOCUMENTS.NAME
     , KBDOCUMENTS.ACTIVE_DATE
     , KBDOCUMENTS.EXP_DATE
     , KBDOCUMENTS.STATUS
     , KBDOCUMENTS.REVISION
     , KBDOCUMENTS.DATE_ENTERED
     , KBDOCUMENTS.DATE_MODIFIED
     , KBDOCUMENTS.DATE_MODIFIED_UTC
     , KBDOCUMENTS.KBDOC_APPROVER_ID
     , KBDOCUMENTS.IS_EXTERNAL_ARTICLE
     , KBDOCUMENTS.ASSIGNED_USER_ID
     , (case when exists(select * from NOTE_ATTACHMENTS where NOTE_ID = KBDOCUMENTS.ID)
             then 1
             else 0
        end)                            as HAS_ATTACHMENTS
     , cast(null as nvarchar(max))      as KBTAG_NAME
     , TEAMS.ID                         as TEAM_ID
     , TEAMS.NAME                       as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME         as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME       as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME      as MODIFIED_BY
     , KBDOC_APPROVER.USER_NAME         as KBDOC_APPROVER_NAME
     , KBDOCUMENTS.CREATED_BY           as CREATED_BY_ID
     , KBDOCUMENTS.MODIFIED_USER_ID
     , TEAM_SETS.ID                     as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME          as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST          as TEAM_SET_LIST
     , KBDOCUMENTS.DESCRIPTION
     , KBDOCUMENTS.KBTAG_SET_LIST
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ASSIGNED_SETS.ID                as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST as ASSIGNED_SET_LIST
     , TAG_SETS.TAG_SET_NAME
     , vwPROCESSES_Pending.ID      as PENDING_PROCESS_ID
     , KBDOCUMENTS_CSTM.*
  from            KBDOCUMENTS
  left outer join TEAMS
               on TEAMS.ID                   = KBDOCUMENTS.TEAM_ID
              and TEAMS.DELETED              = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID               = KBDOCUMENTS.TEAM_SET_ID
              and TEAM_SETS.DELETED          = 0
  left outer join TAG_SETS
               on TAG_SETS.BEAN_ID           = KBDOCUMENTS.ID
              and TAG_SETS.DELETED           = 0
  left outer join USERS                        USERS_ASSIGNED
               on USERS_ASSIGNED.ID          = KBDOCUMENTS.ASSIGNED_USER_ID
  left outer join USERS                        KBDOC_APPROVER
               on KBDOC_APPROVER.ID          = KBDOCUMENTS.KBDOC_APPROVER_ID
  left outer join USERS                        USERS_CREATED_BY
               on USERS_CREATED_BY.ID        = KBDOCUMENTS.CREATED_BY
  left outer join USERS                        USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID       = KBDOCUMENTS.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID           = KBDOCUMENTS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED      = 0
  left outer join KBDOCUMENTS_CSTM
               on KBDOCUMENTS_CSTM.ID_C      = KBDOCUMENTS.ID
  left outer join vwPROCESSES_Pending
               on vwPROCESSES_Pending.PARENT_ID = KBDOCUMENTS.ID
 where KBDOCUMENTS.DELETED = 0

GO

Grant Select on dbo.vwKBDOCUMENTS to public;
GO

 
