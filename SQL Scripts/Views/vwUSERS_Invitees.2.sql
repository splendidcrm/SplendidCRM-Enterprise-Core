if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwUSERS_Invitees')
	Drop View dbo.vwUSERS_Invitees;
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
-- 11/07/2005 Paul.  SQL Server needs the cast in order to compile vwACTIVITIES_Invitees.
-- 02/01/2006 Paul.  DB2 does not like comments in the middle of the Create View statement. 
-- 12/11/2009 Paul.  Only show active users and also exclude portal users. 
-- 12/12/2009 Paul.  We do not need to return the STATUS. 
-- If we include the status, then we would need a dummy STATUS field in the vwCONTACTS_Invitees view. 
Create View dbo.vwUSERS_Invitees
as
select ID          as ID
     , N'Users'    as INVITEE_TYPE
     , FULL_NAME   as NAME
     , FIRST_NAME  as FIRST_NAME
     , LAST_NAME   as LAST_NAME
     , EMAIL1      as EMAIL
     , PHONE_WORK  as PHONE
     , cast(null as uniqueidentifier) as ASSIGNED_USER_ID
  from vwUSERS
 where (STATUS      is null or STATUS      = N'Active')
   and (PORTAL_ONLY is null or PORTAL_ONLY = 0        )

GO

Grant Select on dbo.vwUSERS_Invitees to public;
GO


