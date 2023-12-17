if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwGRIDVIEWS_COLUMNS')
	Drop View dbo.vwGRIDVIEWS_COLUMNS;
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
-- 05/02/2006 Paul.  Add URL_ASSIGNED_FIELD to support ACL. 
-- 05/22/2009 Paul.  Add MODULE_NAME to allow export. 
-- 02/16/2010 Paul.  Add MODULE_TYPE so that we can lookup custom field IDs. 
-- 10/09/2010 Paul.  Add PARENT_FIELD so that we can establish dependent listboxes. 
-- 09/20/2012 Paul.  We need a SCRIPT field that is form specific. 
Create View dbo.vwGRIDVIEWS_COLUMNS
as
select GRIDVIEWS_COLUMNS.ID
     , GRIDVIEWS_COLUMNS.DELETED
     , GRIDVIEWS_COLUMNS.GRID_NAME
     , GRIDVIEWS_COLUMNS.COLUMN_INDEX
     , GRIDVIEWS_COLUMNS.COLUMN_TYPE
     , GRIDVIEWS_COLUMNS.DEFAULT_VIEW
     , GRIDVIEWS_COLUMNS.HEADER_TEXT
     , GRIDVIEWS_COLUMNS.SORT_EXPRESSION
     , GRIDVIEWS_COLUMNS.ITEMSTYLE_WIDTH
     , GRIDVIEWS_COLUMNS.ITEMSTYLE_CSSCLASS
     , GRIDVIEWS_COLUMNS.ITEMSTYLE_HORIZONTAL_ALIGN
     , GRIDVIEWS_COLUMNS.ITEMSTYLE_VERTICAL_ALIGN
     , GRIDVIEWS_COLUMNS.ITEMSTYLE_WRAP
     , GRIDVIEWS_COLUMNS.DATA_FIELD
     , GRIDVIEWS_COLUMNS.DATA_FORMAT
     , GRIDVIEWS_COLUMNS.URL_FIELD
     , GRIDVIEWS_COLUMNS.URL_FORMAT
     , GRIDVIEWS_COLUMNS.URL_TARGET
     , GRIDVIEWS_COLUMNS.LIST_NAME
     , GRIDVIEWS_COLUMNS.URL_MODULE
     , GRIDVIEWS_COLUMNS.URL_ASSIGNED_FIELD
     , GRIDVIEWS.VIEW_NAME
     , GRIDVIEWS.MODULE_NAME
     , GRIDVIEWS_COLUMNS.MODULE_TYPE
     , GRIDVIEWS_COLUMNS.PARENT_FIELD
     , GRIDVIEWS.SCRIPT
  from      GRIDVIEWS_COLUMNS
 inner join GRIDVIEWS
         on GRIDVIEWS.NAME    = GRIDVIEWS_COLUMNS.GRID_NAME
        and GRIDVIEWS.DELETED = 0
 where GRIDVIEWS_COLUMNS.DELETED = 0

GO

Grant Select on dbo.vwGRIDVIEWS_COLUMNS to public;
GO

