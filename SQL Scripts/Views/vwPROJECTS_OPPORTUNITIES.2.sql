if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROJECTS_OPPORTUNITIES')
	Drop View dbo.vwPROJECTS_OPPORTUNITIES;
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
-- 12/05/2006 Paul.  Literals should be in unicode to reduce conversions at runtime. 
-- 09/08/2012 Paul.  Project Relations data for Opportunities moved to PROJECTS_OPPORTUNITIES. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwPROJECTS_OPPORTUNITIES
as
select PROJECT.ID               as PROJECT_ID
     , PROJECT.NAME             as PROJECT_NAME
     , PROJECT.ASSIGNED_USER_ID as PROJECT_ASSIGNED_USER_ID
     , PROJECT.ASSIGNED_SET_ID  as PROJECT_ASSIGNED_SET_ID
     , vwOPPORTUNITIES.ID       as OPPORTUNITY_ID
     , vwOPPORTUNITIES.NAME     as OPPORTUNITY_NAME
     , vwOPPORTUNITIES.*
  from            PROJECT
       inner join PROJECTS_OPPORTUNITIES
               on PROJECTS_OPPORTUNITIES.PROJECT_ID     = PROJECT.ID
              and PROJECTS_OPPORTUNITIES.DELETED        = 0
       inner join vwOPPORTUNITIES
               on vwOPPORTUNITIES.ID                    = PROJECTS_OPPORTUNITIES.OPPORTUNITY_ID
 where PROJECT.DELETED = 0

GO

Grant Select on dbo.vwPROJECTS_OPPORTUNITIES to public;
GO


