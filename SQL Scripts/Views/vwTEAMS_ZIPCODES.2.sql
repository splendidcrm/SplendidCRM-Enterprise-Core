if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTEAMS_ZIPCODES')
	Drop View dbo.vwTEAMS_ZIPCODES;
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
Create View dbo.vwTEAMS_ZIPCODES
as
select vwZIPCODES.ID   as ZIPCODE_ID
     , vwZIPCODES.NAME as ZIPCODE_NAME
     , vwZIPCODES.NAME as ZIPCODE
     , TEAMS.ID        as TEAM_ID
     , TEAMS.NAME      as TEAM_NAME
     , vwZIPCODES.*
  from      TEAMS
 inner join TEAMS_ZIPCODES
         on TEAMS_ZIPCODES.TEAM_ID = TEAMS.ID
        and TEAMS_ZIPCODES.DELETED = 0
 inner join vwZIPCODES
         on vwZIPCODES.ID          = TEAMS_ZIPCODES.ZIPCODE_ID
 where TEAMS.DELETED = 0

GO

Grant Select on dbo.vwTEAMS_ZIPCODES to public;
GO


