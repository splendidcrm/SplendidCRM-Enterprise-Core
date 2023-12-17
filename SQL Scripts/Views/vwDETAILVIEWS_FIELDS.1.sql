if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDETAILVIEWS_FIELDS')
	Drop View dbo.vwDETAILVIEWS_FIELDS;
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
-- 12/02/2007 Paul.  Add data columns. 
-- 05/22/2009 Paul.  Add MODULE_NAME to allow export. 
-- 06/12/2009 Paul.  Add TOOL_TIP for help hover.
-- 02/16/2010 Paul.  Add MODULE_TYPE so that we can lookup custom field IDs. 
-- 10/09/2010 Paul.  Add PARENT_FIELD so that we can establish dependent listboxes. 
-- 09/20/2012 Paul.  We need a SCRIPT field that is form specific. 
Create View dbo.vwDETAILVIEWS_FIELDS
as
select DETAILVIEWS_FIELDS.ID
     , DETAILVIEWS_FIELDS.DELETED
     , DETAILVIEWS_FIELDS.DETAIL_NAME
     , DETAILVIEWS_FIELDS.FIELD_INDEX
     , DETAILVIEWS_FIELDS.FIELD_TYPE
     , DETAILVIEWS_FIELDS.DEFAULT_VIEW
     , DETAILVIEWS_FIELDS.DATA_LABEL
     , DETAILVIEWS_FIELDS.DATA_FIELD
     , DETAILVIEWS_FIELDS.DATA_FORMAT
     , DETAILVIEWS_FIELDS.URL_FIELD
     , DETAILVIEWS_FIELDS.URL_FORMAT
     , DETAILVIEWS_FIELDS.URL_TARGET
     , DETAILVIEWS_FIELDS.LIST_NAME
     , DETAILVIEWS_FIELDS.COLSPAN
     , DETAILVIEWS.LABEL_WIDTH
     , DETAILVIEWS.FIELD_WIDTH
     , DETAILVIEWS.DATA_COLUMNS
     , DETAILVIEWS.VIEW_NAME
     , DETAILVIEWS.MODULE_NAME
     , DETAILVIEWS_FIELDS.TOOL_TIP
     , DETAILVIEWS_FIELDS.MODULE_TYPE
     , DETAILVIEWS_FIELDS.PARENT_FIELD
     , DETAILVIEWS.SCRIPT
  from      DETAILVIEWS_FIELDS
 inner join DETAILVIEWS
         on DETAILVIEWS.NAME    = DETAILVIEWS_FIELDS.DETAIL_NAME
        and DETAILVIEWS.DELETED = 0
 where DETAILVIEWS_FIELDS.DELETED = 0

GO

Grant Select on dbo.vwDETAILVIEWS_FIELDS to public;
GO

