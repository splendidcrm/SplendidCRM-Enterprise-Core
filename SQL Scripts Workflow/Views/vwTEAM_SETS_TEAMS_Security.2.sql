if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTEAM_SETS_TEAMS_Security')
	Drop View dbo.vwTEAM_SETS_TEAMS_Security;
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
-- 06/30/2010 Paul.  We need a new view to prevent field name collisions. 
Create View dbo.vwTEAM_SETS_TEAMS_Security
as
select ID       as MEMBERSHIP_TEAM_SET_ID
     , TEAM_ID  as MEMBERSHIP_TEAM_ID
  from vwTEAM_SETS_TEAMS

GO

Grant Select on dbo.vwTEAM_SETS_TEAMS_Security to public;
GO

