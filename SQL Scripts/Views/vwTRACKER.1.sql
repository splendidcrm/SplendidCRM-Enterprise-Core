if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTRACKER')
	Drop View dbo.vwTRACKER;
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
-- 08/17/2005 Paul.  Oracle is having a problem returning 0 as an integer. 
-- Just add the column in code. 
-- 02/01/2006 Paul.  DB2 does not like comments in the middle of the Create View statement. 
-- 03/08/2012 Paul.  Add ACTION to the tracker table so that we can create quick user activity reports. 
Create View dbo.vwTRACKER
as
select USER_ID
     , MODULE_NAME
     , ITEM_ID
     , ITEM_SUMMARY
     , DATE_ENTERED
     , DATE_MODIFIED
     , ACTION
  from TRACKER

GO

Grant Select on dbo.vwTRACKER to public;
GO


