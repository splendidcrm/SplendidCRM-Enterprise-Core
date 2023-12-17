if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwRELEASES')
	Drop View dbo.vwRELEASES;
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
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 04/07/2019 Paul.  DATE_MODIFIED and DATE_ENTERED for detail view. 
Create View dbo.vwRELEASES
as
select RELEASES.ID
     , RELEASES.NAME
     , RELEASES.LIST_ORDER
     , RELEASES.STATUS
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , RELEASES.CREATED_BY         as CREATED_BY_ID
     , RELEASES.MODIFIED_USER_ID
     , RELEASES.DATE_ENTERED
     , RELEASES.DATE_MODIFIED
     , RELEASES.DATE_MODIFIED_UTC
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , RELEASES_CSTM.*
  from            RELEASES
  left outer join USERS USERS_CREATED_BY
               on USERS_CREATED_BY.ID  = RELEASES.CREATED_BY
  left outer join USERS USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID = RELEASES.MODIFIED_USER_ID
  left outer join RELEASES_CSTM
               on RELEASES_CSTM.ID_C   = RELEASES.ID
 where RELEASES.DELETED = 0

GO

Grant Select on dbo.vwRELEASES to public;
GO


