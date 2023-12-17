if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROJECTS_BUGS')
	Drop View dbo.vwPROJECTS_BUGS;
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
Create View dbo.vwPROJECTS_BUGS
as
select PROJECT.ID               as PROJECT_ID
     , PROJECT.NAME             as PROJECT_NAME
     , PROJECT.ASSIGNED_USER_ID as PROJECT_ASSIGNED_USER_ID
     , PROJECT.ASSIGNED_SET_ID  as PROJECT_ASSIGNED_SET_ID
     , vwBUGS.ID                as BUG_ID
     , vwBUGS.NAME              as BUG_NAME
     , vwBUGS.*
  from           PROJECT
      inner join PROJECTS_BUGS
              on PROJECTS_BUGS.PROJECT_ID = PROJECT.ID
             and PROJECTS_BUGS.DELETED    = 0
      inner join vwBUGS
              on vwBUGS.ID                = PROJECTS_BUGS.BUG_ID
 where PROJECT.DELETED = 0

GO

Grant Select on dbo.vwPROJECTS_BUGS to public;
GO


