if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSqlTablesCachedSystem')
	Drop View dbo.vwSqlTablesCachedSystem;
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
-- 09/24/2009 Paul.  Add the DASHLETS tables so that they are not audited. 
-- 01/17/2010 Paul.  Add ACL Fields. 
-- 12/04/2010 Paul.  Add PAYMENT_GATEWAYS, DISCOUNTS and RULES. 
-- 05/30/2014 Paul.  Add EDITVIEWS_RELATIONSHIPS. 
-- 12/17/2017 Paul.  Add MODULES_ARCHIVE_RELATED. 
-- 07/25/2019 Paul.  Add REACT_CUSTOM_VIEWS. 
Create View dbo.vwSqlTablesCachedSystem
as
select TABLE_NAME
  from vwSqlTables
 where TABLE_NAME in
( N'ACL_ACTIONS'
, N'ACL_FIELDS'
, N'ACL_FIELDS_ALIASES'
, N'ACL_ROLES'
, N'ACL_ROLES_ACTIONS'
, N'ACL_ROLES_USERS'
, N'CONFIG'
, N'CUSTOM_FIELDS'
, N'DASHLETS'
, N'DASHLETS_USERS'
, N'DETAILVIEWS'
, N'DETAILVIEWS_FIELDS'
, N'DETAILVIEWS_RELATIONSHIPS'
, N'DISCOUNTS'
, N'DYNAMIC_BUTTONS'
, N'EDITVIEWS'
, N'EDITVIEWS_FIELDS'
, N'EDITVIEWS_RELATIONSHIPS'
, N'FIELDS_META_DATA'
, N'GRIDVIEWS'
, N'GRIDVIEWS_COLUMNS'
, N'LANGUAGES'
, N'MODULES'
, N'MODULES_ARCHIVE_RELATED'
, N'PAYMENT_GATEWAYS'
, N'REACT_CUSTOM_VIEWS'
, N'RELATIONSHIPS'
, N'RULES'
, N'SHORTCUTS'
, N'TERMINOLOGY'
, N'TERMINOLOGY_ALIASES'
, N'TIMEZONES'
)
GO


Grant Select on dbo.vwSqlTablesCachedSystem to public;
GO

