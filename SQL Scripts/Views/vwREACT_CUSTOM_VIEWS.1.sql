if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwREACT_CUSTOM_VIEWS')
	Drop View dbo.vwREACT_CUSTOM_VIEWS;
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
Create View dbo.vwREACT_CUSTOM_VIEWS
as
select REACT_CUSTOM_VIEWS.ID
     , REACT_CUSTOM_VIEWS.NAME
     , REACT_CUSTOM_VIEWS.MODULE_NAME
     , REACT_CUSTOM_VIEWS.CATEGORY
     , MODULES.IS_ADMIN
     , REACT_CUSTOM_VIEWS.CONTENT
  from      REACT_CUSTOM_VIEWS
 inner join MODULES
         on MODULES.MODULE_NAME    = REACT_CUSTOM_VIEWS.MODULE_NAME
        and MODULES.DELETED        = 0
        and MODULES.MODULE_ENABLED = 1
 where REACT_CUSTOM_VIEWS.DELETED = 0

GO

Grant Select on dbo.vwREACT_CUSTOM_VIEWS to public;
GO

