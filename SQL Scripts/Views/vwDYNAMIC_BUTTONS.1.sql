if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDYNAMIC_BUTTONS')
	Drop View dbo.vwDYNAMIC_BUTTONS;
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
-- 07/28/2010 Paul.  We need a flag to exclude a button from a mobile device. 
-- 03/14/2014 Paul.  Allow hidden buttons to be created. 
-- 08/16/2017 Paul.  Add ability to apply a business rule to a button. 
-- 04/02/2019 Paul.  All modules must have a name field. 
-- 04/02/2019 Paul.  DATE_MODIFIED and DATE_ENTERED for detail view. 
Create View dbo.vwDYNAMIC_BUTTONS
as
select ID
     , VIEW_NAME + isnull(' ' + CONTROL_TEXT, '')     as NAME
     , VIEW_NAME
     , CONTROL_INDEX
     , CONTROL_TYPE
     , DEFAULT_VIEW
     , MODULE_NAME
     , MODULE_ACCESS_TYPE
     , TARGET_NAME
     , TARGET_ACCESS_TYPE
     , MOBILE_ONLY
     , ADMIN_ONLY
     , EXCLUDE_MOBILE
     , CONTROL_TEXT
     , CONTROL_TOOLTIP
     , CONTROL_ACCESSKEY
     , CONTROL_CSSCLASS
     , TEXT_FIELD
     , ARGUMENT_FIELD
     , COMMAND_NAME
     , URL_FORMAT
     , URL_TARGET
     , ONCLICK_SCRIPT
     , HIDDEN
     , BUSINESS_RULE
     , BUSINESS_SCRIPT
     , DATE_ENTERED
     , DATE_MODIFIED
     , DATE_MODIFIED_UTC
  from DYNAMIC_BUTTONS
 where DELETED = 0

GO

Grant Select on dbo.vwDYNAMIC_BUTTONS to public;
GO

