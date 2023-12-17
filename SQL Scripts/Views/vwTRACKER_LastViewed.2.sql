if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTRACKER_LastViewed')
	Drop View dbo.vwTRACKER_LastViewed;
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
-- 04/06/2006 Paul.  The module name needs to be corrected as it will be used in the URL and the folder names are plural. 
-- 04/06/2006 Paul.  Add the IMAGE_NAME column as the filenames will not be changed. 
-- 07/26/2006 Paul.  Join to the modules table and return the relative path.  This will allow for nested modules. 
-- 07/26/2006 Paul.  Using the RELATIVE_PATH will also mean that the module name need not be corrected. 
-- 03/08/2012 Paul.  Add ACTION to the tracker table so that we can create quick user activity reports. 
-- 03/31/2012 Paul.  Increase name length to 25. 
Create View dbo.vwTRACKER_LastViewed
as
select vwTRACKER.USER_ID
     , vwTRACKER.MODULE_NAME
     , vwMODULES.RELATIVE_PATH
     , vwTRACKER.ITEM_ID
     , (case when len(vwTRACKER.ITEM_SUMMARY) > 25 then left(vwTRACKER.ITEM_SUMMARY, 25) + N'...'
        else ITEM_SUMMARY
        end) as ITEM_SUMMARY
     , vwTRACKER.DATE_ENTERED
     , vwTRACKER.MODULE_NAME as IMAGE_NAME
  from      vwTRACKER
 inner join vwMODULES
         on vwMODULES.MODULE_NAME = vwTRACKER.MODULE_NAME
 where vwTRACKER.ACTION = N'detailview'

GO

Grant Select on dbo.vwTRACKER_LastViewed to public;
GO

