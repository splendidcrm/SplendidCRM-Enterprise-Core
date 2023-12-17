if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEDITVIEWS_FIELDS_Searching')
	Drop View dbo.vwEDITVIEWS_FIELDS_Searching;
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
-- 04/17/2009 Paul.  Key off of the view name so that we don't have to change other areas of the code. 
Create View dbo.vwEDITVIEWS_FIELDS_Searching
as
select EDITVIEWS_FIELDS_Search.EDIT_NAME
     , EDITVIEWS_Search.VIEW_NAME
     , EDITVIEWS_Search.MODULE_NAME
     , EDITVIEWS_FIELDS_Module.DATA_FIELD
  from      EDITVIEWS_FIELDS                    EDITVIEWS_FIELDS_Search
 inner join EDITVIEWS                           EDITVIEWS_Search
         on EDITVIEWS_Search.NAME             = EDITVIEWS_FIELDS_Search.EDIT_NAME
        and EDITVIEWS_Search.DELETED          = 0
 inner join EDITVIEWS                           EDITVIEWS_Module
         on EDITVIEWS_Module.MODULE_NAME      = EDITVIEWS_Search.MODULE_NAME
        and EDITVIEWS_Module.DELETED          = 0
 inner join EDITVIEWS_FIELDS                    EDITVIEWS_FIELDS_Module
         on EDITVIEWS_FIELDS_Module.EDIT_NAME = EDITVIEWS_Module.NAME
        and EDITVIEWS_FIELDS_Module.DELETED   = 0
 where EDITVIEWS_FIELDS_Search.DELETED   = 0
   and (EDITVIEWS_FIELDS_Module.DEFAULT_VIEW = 0 or EDITVIEWS_FIELDS_Module.DEFAULT_VIEW is null)
   and EDITVIEWS_FIELDS_Module.DATA_FIELD is not null
union
select EDITVIEWS_FIELDS_Search.EDIT_NAME
     , EDITVIEWS_Search.VIEW_NAME
     , EDITVIEWS_Search.MODULE_NAME
     , EDITVIEWS_FIELDS_Module.DISPLAY_FIELD
  from      EDITVIEWS_FIELDS                    EDITVIEWS_FIELDS_Search
 inner join EDITVIEWS                           EDITVIEWS_Search
         on EDITVIEWS_Search.NAME             = EDITVIEWS_FIELDS_Search.EDIT_NAME
        and EDITVIEWS_Search.DELETED          = 0
 inner join EDITVIEWS                           EDITVIEWS_Module
         on EDITVIEWS_Module.MODULE_NAME      = EDITVIEWS_Search.MODULE_NAME
        and EDITVIEWS_Module.DELETED          = 0
 inner join EDITVIEWS_FIELDS                    EDITVIEWS_FIELDS_Module
         on EDITVIEWS_FIELDS_Module.EDIT_NAME = EDITVIEWS_Module.NAME
        and EDITVIEWS_FIELDS_Module.DELETED   = 0
 where EDITVIEWS_FIELDS_Search.DELETED   = 0
   and (EDITVIEWS_FIELDS_Module.DEFAULT_VIEW = 0 or EDITVIEWS_FIELDS_Module.DEFAULT_VIEW is null)
   and EDITVIEWS_FIELDS_Module.DISPLAY_FIELD is not null

GO

Grant Select on dbo.vwEDITVIEWS_FIELDS_Searching to public;
GO

