if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEDITVIEWS_RELATIONSHIPS_Layout')
	Drop View dbo.vwEDITVIEWS_RELATIONSHIPS_Layout;
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
-- 10/29/2015 Paul.  CONTROL_NAME is need to allow copying of the layout. 
Create View dbo.vwEDITVIEWS_RELATIONSHIPS_Layout
as
select EDITVIEWS_RELATIONSHIPS.ID
     , EDITVIEWS_RELATIONSHIPS.EDIT_NAME
     , EDITVIEWS_RELATIONSHIPS.MODULE_NAME
     , EDITVIEWS_RELATIONSHIPS.TITLE
     , EDITVIEWS_RELATIONSHIPS.CONTROL_NAME
     , EDITVIEWS_RELATIONSHIPS.RELATIONSHIP_ORDER
     , EDITVIEWS_RELATIONSHIPS.RELATIONSHIP_ENABLED
     , EDITVIEWS_RELATIONSHIPS.NEW_RECORD_ENABLED
     , EDITVIEWS_RELATIONSHIPS.EXISTING_RECORD_ENABLED
     , EDITVIEWS_RELATIONSHIPS.ALTERNATE_VIEW
  from      EDITVIEWS_RELATIONSHIPS
 inner join MODULES
         on MODULES.MODULE_NAME    = EDITVIEWS_RELATIONSHIPS.MODULE_NAME
        and MODULES.DELETED        = 0
        and MODULES.MODULE_ENABLED = 1
 where EDITVIEWS_RELATIONSHIPS.DELETED = 0

GO

Grant Select on dbo.vwEDITVIEWS_RELATIONSHIPS_Layout to public;
GO

