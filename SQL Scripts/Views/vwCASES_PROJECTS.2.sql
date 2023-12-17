if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCASES_PROJECTS')
	Drop View dbo.vwCASES_PROJECTS;
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
Create View dbo.vwCASES_PROJECTS
as
select CASES.ID                    as CASE_ID
     , CASES.NAME                  as CASE_NAME
     , CASES.ASSIGNED_USER_ID      as CASE_ASSIGNED_USER_ID
     , CASES.ASSIGNED_SET_ID       as CASE_ASSIGNED_SET_ID
     , vwPROJECTS.ID               as PROJECT_ID
     , vwPROJECTS.NAME             as PROJECT_NAME
     , vwPROJECTS.*
  from           CASES
      inner join PROJECTS_CASES
              on PROJECTS_CASES.CASE_ID      = CASES.ID
             and PROJECTS_CASES.DELETED      = 0
      inner join vwPROJECTS
              on vwPROJECTS.ID               = PROJECTS_CASES.PROJECT_ID
 left outer join USERS
              on USERS.ID                    = vwPROJECTS.ASSIGNED_USER_ID
             and USERS.DELETED               = 0
 where CASES.DELETED = 0

GO

Grant Select on dbo.vwCASES_PROJECTS to public;
GO


