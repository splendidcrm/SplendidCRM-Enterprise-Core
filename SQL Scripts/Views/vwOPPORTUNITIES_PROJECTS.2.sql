if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwOPPORTUNITIES_PROJECTS')
	Drop View dbo.vwOPPORTUNITIES_PROJECTS;
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
-- 10/27/2012 Paul.  Project Relations data for Opportunities moved to PROJECTS_OPPORTUNITIES. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwOPPORTUNITIES_PROJECTS
as
select OPPORTUNITIES.ID               as OPPORTUNITY_ID
     , OPPORTUNITIES.NAME             as OPPORTUNITY_NAME
     , OPPORTUNITIES.ASSIGNED_USER_ID as OPPORTUNITY_ASSIGNED_USER_ID
     , OPPORTUNITIES.ASSIGNED_SET_ID  as OPPORTUNITY_ASSIGNED_SET_ID
     , vwPROJECTS.ID                  as PROJECT_ID
     , vwPROJECTS.NAME                as PROJECT_NAME
     , vwPROJECTS.*
  from           OPPORTUNITIES
      inner join PROJECTS_OPPORTUNITIES
              on PROJECTS_OPPORTUNITIES.OPPORTUNITY_ID = OPPORTUNITIES.ID
             and PROJECTS_OPPORTUNITIES.DELETED        = 0
      inner join vwPROJECTS
              on vwPROJECTS.ID                         = PROJECTS_OPPORTUNITIES.PROJECT_ID
 where OPPORTUNITIES.DELETED = 0

GO

Grant Select on dbo.vwOPPORTUNITIES_PROJECTS to public;
GO


