if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSYSTEM_LOG')
	Drop View dbo.vwSYSTEM_LOG;
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
-- 03/18/2019 Paul.  All views should have a NAME field. 
Create View dbo.vwSYSTEM_LOG
as
select ID
     , DATE_ENTERED
     , USER_ID
     , USER_NAME
     , MACHINE
     , ASPNET_SESSIONID
     , REMOTE_HOST
     , SERVER_HOST
     , TARGET
     , RELATIVE_PATH
     , PARAMETERS
     , ERROR_TYPE
     , FILE_NAME
     , METHOD
     , LINE_NUMBER
     , MESSAGE
     , MESSAGE as NAME
  from SYSTEM_LOG

GO

Grant Select on dbo.vwSYSTEM_LOG to public;
GO

