if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMODULES_TablesSyncd')
	Drop View dbo.vwMODULES_TablesSyncd;
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
-- 10/27/2009 Paul.  We also need the module name. 
Create View dbo.vwMODULES_TablesSyncd
as
select vwMODULES.MODULE_NAME
     , vwSqlTables.TABLE_NAME
     , cast(0 as bit)         as RELATIONSHIP
  from            vwMODULES
       inner join vwSqlTables
               on vwSqlTables.TABLE_NAME = vwMODULES.TABLE_NAME
 where vwMODULES.SYNC_ENABLED = 1
union
select vwMODULES.MODULE_NAME
     , vwSqlTables.TABLE_NAME
     , cast(1 as bit)         as RELATIONSHIP
  from            vwMODULES
       inner join vwSqlTables
               on vwSqlTables.TABLE_NAME           like vwMODULES.TABLE_NAME + N'_%'
  left outer join vwMODULES                             vwMODULES_NotSyncd
               on vwSqlTables.TABLE_NAME           like N'%_' + vwMODULES_NotSyncd.TABLE_NAME
              and (vwMODULES_NotSyncd.SYNC_ENABLED is null or vwMODULES_NotSyncd.SYNC_ENABLED = 0)
 where vwMODULES.SYNC_ENABLED = 1
   and vwMODULES_NotSyncd.ID is null
   and vwSqlTables.TABLE_NAME not in ('USERS_LAST_IMPORT', 'USERS_LOGINS', 'USERS_SIGNATURES')
   and vwSqlTables.TABLE_NAME not like N'%_AUDIT'
   and vwSqlTables.TABLE_NAME not like N'%_REMOTE'
   and vwSqlTables.TABLE_NAME not like N'%_CSTM'
   and vwSqlTables.TABLE_NAME not like N'%_SYNC'

GO

-- select * from vwMODULES_TablesSyncd order by TABLE_NAME

Grant Select on dbo.vwMODULES_TablesSyncd to public;
GO

