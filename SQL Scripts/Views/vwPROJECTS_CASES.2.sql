if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROJECTS_CASES')
	Drop View dbo.vwPROJECTS_CASES;
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
-- 09/08/2012 Paul.  Project Relations data for Cases moved to PROJECTS_CASES. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwPROJECTS_CASES
as
select PROJECT.ID               as PROJECT_ID
     , PROJECT.NAME             as PROJECT_NAME
     , PROJECT.ASSIGNED_USER_ID as PROJECT_ASSIGNED_USER_ID
     , PROJECT.ASSIGNED_SET_ID  as PROJECT_ASSIGNED_SET_ID
     , vwCASES.ID               as CASE_ID
     , vwCASES.NAME             as CASE_NAME
     , vwCASES.*
  from           PROJECT
      inner join PROJECTS_CASES
              on PROJECTS_CASES.PROJECT_ID = PROJECT.ID
             and PROJECTS_CASES.DELETED    = 0
      inner join vwCASES
              on vwCASES.ID                = PROJECTS_CASES.CASE_ID
 where PROJECT.DELETED = 0

GO

Grant Select on dbo.vwPROJECTS_CASES to public;
GO


