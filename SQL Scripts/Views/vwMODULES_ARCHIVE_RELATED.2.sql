if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMODULES_ARCHIVE_RELATED')
	Drop View dbo.vwMODULES_ARCHIVE_RELATED;
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
-- 01/08/2018 Paul.  ACTIVITIES should never be returned as a related table. 
-- Protect against bad TABLE_NAME in MODULES table. 
-- 01/30/2019 Paul.  Ease conversion to Oracle. 
Create View dbo.vwMODULES_ARCHIVE_RELATED
as
select MODULES_ARCHIVE_RELATED.MODULE_NAME
     , MODULES_ARCHIVE_RELATED.RELATED_NAME
     , MODULES_ARCHIVE_RELATED.RELATED_ORDER
     , MODULES.TABLE_NAME
     , nullif(RELATED.TABLE_NAME, N'ACTIVITIES')   as RELATED_TABLE
  from      MODULES_ARCHIVE_RELATED
 inner join MODULES
         on MODULES.MODULE_NAME    = MODULES_ARCHIVE_RELATED.MODULE_NAME
        and MODULES.DELETED        = 0
 inner join MODULES                  RELATED
         on RELATED.MODULE_NAME    = MODULES_ARCHIVE_RELATED.RELATED_NAME
        and RELATED.MODULE_ENABLED = 1
        and RELATED.DELETED        = 0
 where MODULES_ARCHIVE_RELATED.DELETED = 0

GO

Grant Select on dbo.vwMODULES_ARCHIVE_RELATED to public;
GO

