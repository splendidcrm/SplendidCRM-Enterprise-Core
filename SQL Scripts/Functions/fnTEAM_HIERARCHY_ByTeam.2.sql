if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnTEAM_HIERARCHY_ByTeam' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnTEAM_HIERARCHY_ByTeam;
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
-- 02/25/2017 Paul.  We need to use a unique column name to prevent colisions with joins in Sql.Filter(). 
Create Function dbo.fnTEAM_HIERARCHY_ByTeam(@TEAM_ID uniqueidentifier)
returns @TEAMS table (MEMBERSHIP_TEAM_ID uniqueidentifier)
as
  begin
	with TEAMS_AllAssigned(ID, NAME, PARENT_ID) as
	(select TEAMS.ID
	      , TEAMS.NAME
	      , TEAMS.PARENT_ID
	   from      TEAMS
	  where TEAMS.DELETED = 0
	    and TEAMS.ID      = @TEAM_ID
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
	select distinct ID
	  from TEAMS_AllAssigned;
	return;
  end
GO

Grant Select on dbo.fnTEAM_HIERARCHY_ByTeam to public;
GO

