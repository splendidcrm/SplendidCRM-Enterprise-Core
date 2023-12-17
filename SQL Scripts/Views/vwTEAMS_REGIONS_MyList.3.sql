if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTEAMS_REGIONS_MyList')
	Drop View dbo.vwTEAMS_REGIONS_MyList;
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
Create View dbo.vwTEAMS_REGIONS_MyList
as
select vwTEAMS_REGIONS_List.*
     , vwTEAM_MEMBERSHIPS.MEMBERSHIP_USER_ID
  from      vwTEAMS_REGIONS_List
 inner join vwTEAM_MEMBERSHIPS
         on vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID = vwTEAMS_REGIONS_List.ID

GO

Grant Select on dbo.vwTEAMS_REGIONS_MyList to public;
GO

