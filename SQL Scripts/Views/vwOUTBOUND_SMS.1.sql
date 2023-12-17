if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwOUTBOUND_SMS')
	Drop View dbo.vwOUTBOUND_SMS;
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
Create View dbo.vwOUTBOUND_SMS
as
select OUTBOUND_SMS.ID
     , OUTBOUND_SMS.NAME
     , OUTBOUND_SMS.USER_ID
     , OUTBOUND_SMS.FROM_NUMBER
     , (case when USERS_ASSIGNED.ID is not null
             then dbo.fnEmailDisplayName(dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME, USERS_ASSIGNED.LAST_NAME), OUTBOUND_SMS.FROM_NUMBER)
             else dbo.fnEmailDisplayName(OUTBOUND_SMS.NAME, OUTBOUND_SMS.FROM_NUMBER)
        end) as DISPLAY_NAME
     , OUTBOUND_SMS.DATE_ENTERED
     , OUTBOUND_SMS.DATE_MODIFIED
     , OUTBOUND_SMS.USER_ID          as ASSIGNED_USER_ID
     , USERS_ASSIGNED.USER_NAME      as ASSIGNED_TO_NAME
     , USERS_CREATED_BY.USER_NAME    as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME   as MODIFIED_BY
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
  from            OUTBOUND_SMS
  left outer join USERS                      USERS_ASSIGNED
               on USERS_ASSIGNED.ID        = OUTBOUND_SMS.USER_ID
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = OUTBOUND_SMS.CREATED_BY
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = OUTBOUND_SMS.MODIFIED_USER_ID
 where OUTBOUND_SMS.DELETED = 0

GO

Grant Select on dbo.vwOUTBOUND_SMS to public;
GO

