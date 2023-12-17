if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCALLS_USERS_Soap')
	Drop View dbo.vwCALLS_USERS_Soap;
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
-- 02/21/2006 Paul.  A valid relationship is one where all three records are valid. 
-- A deleted record is one where the user is valid but the contact and the relationship are deleted. 
-- 06/13/2007 Paul.  The date to return is that of the related object. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
Create View dbo.vwCALLS_USERS_Soap
as
select CALLS_USERS.CALL_ID    as PRIMARY_ID
     , CALLS_USERS.USER_ID    as RELATED_ID
     , CALLS_USERS.DELETED
     , CALLS.DATE_MODIFIED
     , CALLS.DATE_MODIFIED_UTC
     , dbo.fnViewDateTime(CALLS.DATE_START, CALLS.TIME_START) as DATE_START
  from      CALLS_USERS
 inner join CALLS
         on CALLS.ID      = CALLS_USERS.CALL_ID
        and CALLS.DELETED = CALLS_USERS.DELETED
 inner join USERS
         on USERS.ID      = CALLS_USERS.USER_ID
        and USERS.DELETED = 0

GO

Grant Select on dbo.vwCALLS_USERS_Soap to public;
GO

