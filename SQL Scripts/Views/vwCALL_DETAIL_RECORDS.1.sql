if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCALL_DETAIL_RECORDS')
	Drop View dbo.vwCALL_DETAIL_RECORDS;
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
Create View dbo.vwCALL_DETAIL_RECORDS
as
select CALL_DETAIL_RECORDS.ID
     , CALL_DETAIL_RECORDS.UNIQUEID           as NAME
     , CALL_DETAIL_RECORDS.UNIQUEID
     , CALL_DETAIL_RECORDS.ACCOUNT_CODE_ID
     , CALL_DETAIL_RECORDS.START_TIME
     , CALL_DETAIL_RECORDS.ANSWER_TIME
     , CALL_DETAIL_RECORDS.END_TIME
     , CALL_DETAIL_RECORDS.DURATION
     , CALL_DETAIL_RECORDS.BILLABLE_SECONDS
     , CALL_DETAIL_RECORDS.SOURCE
     , CALL_DETAIL_RECORDS.DESTINATION
     , CALL_DETAIL_RECORDS.DESTINATION_CONTEXT
     , CALL_DETAIL_RECORDS.CALLERID
     , CALL_DETAIL_RECORDS.SOURCE_CHANNEL
     , CALL_DETAIL_RECORDS.DESTINATION_CHANNEL
     , CALL_DETAIL_RECORDS.DISPOSITION
     , CALL_DETAIL_RECORDS.AMA_FLAGS
     , CALL_DETAIL_RECORDS.LAST_APPLICATION
     , CALL_DETAIL_RECORDS.LAST_DATA
     , CALL_DETAIL_RECORDS.USER_FIELD
     , N'Calls'                               as PARENT_TYPE
     , CALLS.ID                               as PARENT_ID
     , CALLS.NAME                             as PARENT_NAME
  from            CALL_DETAIL_RECORDS
  left outer join CALLS
               on CALLS.ID      = CALL_DETAIL_RECORDS.ACCOUNT_CODE_ID
              and CALLS.DELETED = 0
 where CALL_DETAIL_RECORDS.DELETED = 0

GO

Grant Select on dbo.vwCALL_DETAIL_RECORDS to public;
GO

