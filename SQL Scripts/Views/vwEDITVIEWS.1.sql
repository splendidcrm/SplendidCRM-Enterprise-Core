if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEDITVIEWS')
	Drop View dbo.vwEDITVIEWS;
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
-- 10/30/2010 Paul.  Add support for Business Rules Framework. 
-- 11/11/2010 Paul.  Change to Pre Load and Post Load. 
-- 09/20/2012 Paul.  We need a SCRIPT field that is form specific. 
-- 02/14/2013 Paul.  Add DATA_COLUMNS. 
Create View dbo.vwEDITVIEWS
as
select EDITVIEWS.ID
     , EDITVIEWS.NAME
     , EDITVIEWS.MODULE_NAME
     , EDITVIEWS.VIEW_NAME
     , EDITVIEWS.LABEL_WIDTH
     , EDITVIEWS.FIELD_WIDTH
     , EDITVIEWS.SCRIPT
     , EDITVIEWS.DATA_COLUMNS
     , NEW_EVENT_RULES.ID           as NEW_EVENT_ID
     , NEW_EVENT_RULES.NAME         as NEW_EVENT_NAME
     , PRE_LOAD_EVENT_RULES.ID      as PRE_LOAD_EVENT_ID
     , PRE_LOAD_EVENT_RULES.NAME    as PRE_LOAD_EVENT_NAME
     , POST_LOAD_EVENT_RULES.ID     as POST_LOAD_EVENT_ID
     , POST_LOAD_EVENT_RULES.NAME   as POST_LOAD_EVENT_NAME
     , VALIDATION_EVENT_RULES.ID    as VALIDATION_EVENT_ID
     , VALIDATION_EVENT_RULES.NAME  as VALIDATION_EVENT_NAME
     , PRE_SAVE_EVENT_RULES.ID      as PRE_SAVE_EVENT_ID
     , PRE_SAVE_EVENT_RULES.NAME    as PRE_SAVE_EVENT_NAME
     , POST_SAVE_EVENT_RULES.ID     as POST_SAVE_EVENT_ID
     , POST_SAVE_EVENT_RULES.NAME   as POST_SAVE_EVENT_NAME
  from            EDITVIEWS
  left outer join RULES                            NEW_EVENT_RULES
               on NEW_EVENT_RULES.ID             = EDITVIEWS.NEW_EVENT_ID
              and NEW_EVENT_RULES.DELETED        = 0
  left outer join RULES                            PRE_LOAD_EVENT_RULES
               on PRE_LOAD_EVENT_RULES.ID        = EDITVIEWS.PRE_LOAD_EVENT_ID
              and PRE_LOAD_EVENT_RULES.DELETED   = 0
  left outer join RULES                            POST_LOAD_EVENT_RULES
               on POST_LOAD_EVENT_RULES.ID       = EDITVIEWS.POST_LOAD_EVENT_ID
              and POST_LOAD_EVENT_RULES.DELETED  = 0
  left outer join RULES                            VALIDATION_EVENT_RULES
               on VALIDATION_EVENT_RULES.ID      = EDITVIEWS.VALIDATION_EVENT_ID
              and VALIDATION_EVENT_RULES.DELETED = 0
  left outer join RULES                            PRE_SAVE_EVENT_RULES
               on PRE_SAVE_EVENT_RULES.ID        = EDITVIEWS.PRE_SAVE_EVENT_ID
              and PRE_SAVE_EVENT_RULES.DELETED   = 0
  left outer join RULES                            POST_SAVE_EVENT_RULES
               on POST_SAVE_EVENT_RULES.ID       = EDITVIEWS.POST_SAVE_EVENT_ID
              and POST_SAVE_EVENT_RULES.DELETED  = 0
 where EDITVIEWS.DELETED = 0

GO

Grant Select on dbo.vwEDITVIEWS to public;
GO

