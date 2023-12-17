if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwFORECASTS')
	Drop View dbo.vwFORECASTS;
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
-- 05/01/2009 Paul.  Add fields from SugarCRM 4.5.1.
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
Create View dbo.vwFORECASTS
as
select FORECASTS.ID
     , FORECASTS.FORECAST_TYPE
     , FORECASTS.OPP_COUNT
     , FORECASTS.OPP_WEIGH_VALUE
     , FORECASTS.BEST_CASE
     , FORECASTS.LIKELY_CASE
     , FORECASTS.WORST_CASE
     , FORECASTS.USER_ID
     , FORECASTS.DATE_ENTERED
     , FORECASTS.DATE_MODIFIED
     , FORECASTS.TIMEPERIOD_ID
     , TIME_PERIODS.NAME           as TIMEPERIOD_NAME
     , TIME_PERIODS.START_DATE     as TIMEPERIOD_START_DATE
     , TIME_PERIODS.END_DATE       as TIMEPERIOD_END_DATE
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
  from            FORECASTS
  left outer join TIME_PERIODS
               on TIME_PERIODS.ID      = FORECASTS.TIMEPERIOD_ID
              and TIME_PERIODS.DELETED = 0
  left outer join USERS USERS_CREATED_BY
               on USERS_CREATED_BY.ID  = FORECASTS.CREATED_BY
  left outer join USERS USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID = FORECASTS.MODIFIED_USER_ID
 where FORECASTS.DELETED = 0

GO

Grant Select on dbo.vwFORECASTS to public;
GO


