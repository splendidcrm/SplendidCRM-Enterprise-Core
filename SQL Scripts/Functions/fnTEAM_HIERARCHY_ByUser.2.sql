if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnTEAM_HIERARCHY_ByUser' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnTEAM_HIERARCHY_ByUser;
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
Create Function dbo.fnTEAM_HIERARCHY_ByUser(@USER_ID uniqueidentifier)
returns @TEAMS table (ID uniqueidentifier, NAME nvarchar(128), PARENT_ID uniqueidentifier)
as
  begin
	with TEAMS_AllAssigned(ID, NAME, PARENT_ID) as
	(select TEAMS.ID
	      , TEAMS.NAME
	      , TEAMS.PARENT_ID
	   from      TEAMS
	  inner join TEAM_MEMBERSHIPS
	          on TEAM_MEMBERSHIPS.TEAM_ID         = TEAMS.ID
	--         and TEAM_MEMBERSHIPS.EXPLICIT_ASSIGN = 1
	         and TEAM_MEMBERSHIPS.DELETED         = 0
	         and TEAM_MEMBERSHIPS.USER_ID         = @USER_ID
	  where TEAMS.DELETED = 0
	--    and TEAMS.PRIVATE = 0
	  union all
	 select CHILD.ID
	      , CHILD.NAME
	      , CHILD.PARENT_ID
	   from      TEAMS CHILD
	  inner join TEAMS_AllAssigned
	          on TEAMS_AllAssigned.ID = CHILD.PARENT_ID
	  where CHILD.DELETED = 0
	--    and CHILD.PRIVATE = 0
	)
	insert into @TEAMS
	select ID
	     , NAME
	     , PARENT_ID
	  from TEAMS_AllAssigned;
	return;
  end
GO

Grant Select on dbo.fnTEAM_HIERARCHY_ByUser to public;
GO

