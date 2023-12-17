if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnTEAM_HIERARCHY_USERS' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnTEAM_HIERARCHY_USERS;
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
-- 08/17/2016 Paul.  Would like to use USERS, but functions are created before views. 
Create Function dbo.fnTEAM_HIERARCHY_USERS(@TEAM_ID uniqueidentifier)
returns @USERS table (MEMBERSHIP_USER_ID uniqueidentifier, DATE_ENTERED datetime)
as
  begin
	with USERS_AllAssigned(USER_ID, TEAM_ID, PARENT_ID, DATE_ENTERED) as
	(select TEAM_MEMBERSHIPS.USER_ID
	      , TEAM_MEMBERSHIPS.TEAM_ID
	      , TEAMS.PARENT_ID
	      , USERS.DATE_ENTERED
	   from      TEAMS
	  inner join TEAM_MEMBERSHIPS
	          on TEAM_MEMBERSHIPS.TEAM_ID = TEAMS.ID
	         and TEAM_MEMBERSHIPS.DELETED = 0
	  inner join USERS
	          on USERS.ID   = TEAM_MEMBERSHIPS.USER_ID
	         and USERS.USER_NAME is not null
	         and len(USERS.USER_NAME) > 0
	         and (USERS.STATUS is null or USERS.STATUS = N'Active')
	         and (USERS.PORTAL_ONLY is null or USERS.PORTAL_ONLY = 0)
	         and USERS.DELETED = 0
	  where TEAMS.DELETED = 0
	    and TEAMS.ID      = @TEAM_ID
	  union all
	 select TEAM_MEMBERSHIPS.USER_ID
	      , TEAM_MEMBERSHIPS.TEAM_ID
	      , CHILD.PARENT_ID
	      , USERS.DATE_ENTERED
	   from      TEAMS                      CHILD
	  inner join TEAM_MEMBERSHIPS
	          on TEAM_MEMBERSHIPS.TEAM_ID = CHILD.ID
	         and TEAM_MEMBERSHIPS.DELETED = 0
	  inner join USERS
	          on USERS.ID   = TEAM_MEMBERSHIPS.USER_ID
	         and USERS.USER_NAME is not null
	         and len(USERS.USER_NAME) > 0
	         and (USERS.STATUS is null or USERS.STATUS = N'Active')
	         and (USERS.PORTAL_ONLY is null or USERS.PORTAL_ONLY = 0)
	         and USERS.DELETED = 0
	  inner join USERS_AllAssigned
	          on USERS_AllAssigned.TEAM_ID = CHILD.PARENT_ID
	  where CHILD.DELETED = 0
	)
	insert into @USERS
	select distinct USER_ID, DATE_ENTERED
	  from USERS_AllAssigned
	 order by DATE_ENTERED;
	return;
  end
GO

Grant Select on dbo.fnTEAM_HIERARCHY_USERS to public;
GO

