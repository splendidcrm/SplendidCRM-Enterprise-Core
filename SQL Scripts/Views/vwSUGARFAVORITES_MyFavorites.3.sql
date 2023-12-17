if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSUGARFAVORITES_MyFavorites')
	Drop View dbo.vwSUGARFAVORITES_MyFavorites;
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
-- 12/15/2012 Paul.  vwMODULES now includes a name field, so we must qualify the NAME field. 
Create View dbo.vwSUGARFAVORITES_MyFavorites
as
select ASSIGNED_USER_ID         as USER_ID
     , vwMODULES.MODULE_NAME    as MODULE_NAME
     , vwMODULES.RELATIVE_PATH  as RELATIVE_PATH
     , RECORD_ID                as ITEM_ID
     , (case when len(SUGARFAVORITES.NAME) > 25 then left(SUGARFAVORITES.NAME, 25) + N'...'
        else SUGARFAVORITES.NAME
        end) as ITEM_SUMMARY
  from      SUGARFAVORITES
 inner join vwMODULES
         on vwMODULES.MODULE_NAME = SUGARFAVORITES.MODULE
 where DELETED = 0

GO

Grant Select on dbo.vwSUGARFAVORITES_MyFavorites to public;
GO

