if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwAPPOINTMENTS_USERS')
	Drop View dbo.vwAPPOINTMENTS_USERS;
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
Create View dbo.vwAPPOINTMENTS_USERS
as
select MEETING_ID            as APPOINTMENT_ID
     , MEETING_NAME          as APPOINTMENT_NAME
     , USER_ID
  from vwMEETINGS_USERS
 union all
select CALL_ID               as APPOINTMENT_ID
     , CALL_NAME             as APPOINTMENT_NAME
     , USER_ID
  from vwCALLS_USERS

GO

Grant Select on dbo.vwAPPOINTMENTS_USERS to public;
GO


