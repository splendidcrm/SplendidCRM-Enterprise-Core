if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMODULES')
	Drop View dbo.vwMODULES;
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
-- 04/28/2006 Paul.  ACL needs access to new IS_ADMIN field. 
-- 05/02/2006 Paul.  Add TABLE_NAME as direct table queries are required by SOAP and we need a mapping. 
-- 07/20/2009 Paul.  Add SYNC_ENABLED flag to determine if module can be sync'd.
-- 09/03/2009 Paul.  Add IMPORT_ENABLED for module builder. 
-- 09/08/2009 Paul.  Custom Paging can be enabled /disabled per module. 
-- 12/02/2009 Paul.  Add the ability to disable Mass Updates. 
-- 01/13/2010 Paul.  Allow default search to be disabled. 
-- 04/01/2010 Paul.  Add Exchange Sync flag. 
-- 04/04/2010 Paul.  Add Exchange Folders flag. 
-- 04/05/2010 Paul.  Add Exchange Create Parent flag. Need to be able to disable Account creation. 
-- 06/18/2011 Paul.  REST_ENABLED provides a way to enable/disable a module in the REST API. 
-- 12/05/2012 Paul.  Surface RT requires a NAME field. 
-- 03/14/2014 Paul.  DUPLICATE_CHECHING_ENABLED enables duplicate checking. 
-- 11/01/2017 Paul.  Use a module-based flag so that Record Level Security is only enabled when needed. 
-- 05/01/2019 Paul.  We need a flag so that the React client can determine if the module is Process enabled. 
-- 07/31/2019 Paul.  DEFAULT_SORT is a new field for the React Client. 
Create View dbo.vwMODULES
as
select ID
     , MODULE_NAME as NAME
     , MODULE_NAME
     , DISPLAY_NAME
     , RELATIVE_PATH
     , MODULE_ENABLED
     , TAB_ENABLED
     , TAB_ORDER
     , PORTAL_ENABLED
     , CUSTOM_ENABLED
     , IS_ADMIN
     , TABLE_NAME
     , REPORT_ENABLED
     , IMPORT_ENABLED
     , SYNC_ENABLED
     , MOBILE_ENABLED
     , CUSTOM_PAGING
     , DATE_MODIFIED
     , DATE_MODIFIED_UTC
     , MASS_UPDATE_ENABLED
     , DEFAULT_SEARCH_ENABLED
     , EXCHANGE_SYNC
     , EXCHANGE_FOLDERS
     , EXCHANGE_CREATE_PARENT
     , REST_ENABLED
     , DUPLICATE_CHECHING_ENABLED
     , RECORD_LEVEL_SECURITY_ENABLED
     , DEFAULT_SORT
     , (case when exists(select * from vwSqlColumns where vwSqlColumns.ObjectName = 'vw' + MODULES.TABLE_NAME and vwSqlColumns.ColumnName = 'PENDING_PROCESS_ID') then 1 else 0 end) as PROCESS_ENABLED
  from MODULES
 where MODULE_ENABLED = 1
   and DELETED        = 0

GO

Grant Select on dbo.vwMODULES to public;
GO


