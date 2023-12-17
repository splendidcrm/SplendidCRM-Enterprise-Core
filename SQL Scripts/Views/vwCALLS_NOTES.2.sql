if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCALLS_NOTES')
	Drop View dbo.vwCALLS_NOTES;
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
-- 02/01/2006 Paul.  DB2 does not like to return NULL.  So cast NULL to the correct data type. 
-- 04/21/2006 Paul.  Email does have a status, make sure to return it.
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwCALLS_NOTES
as
select CALLS.ID                  as CALL_ID
     , CALLS.NAME                as CALL_NAME
     , CALLS.ASSIGNED_USER_ID    as CALL_ASSIGNED_USER_ID
     , CALLS.ASSIGNED_SET_ID     as CALL_ASSIGNED_SET_ID
     , vwNOTES.ID                as NOTE_ID
     , vwNOTES.NAME              as NOTE_NAME
     , vwNOTES.*
  from           CALLS
      inner join vwNOTES
              on vwNOTES.PARENT_ID   = CALLS.ID
             and vwNOTES.PARENT_TYPE = N'Calls'
 where CALLS.DELETED = 0

GO

Grant Select on dbo.vwCALLS_NOTES to public;
GO

