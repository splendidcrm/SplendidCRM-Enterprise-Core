if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMODULES_Workflow')
	Drop View dbo.vwMODULES_Workflow;
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
-- 06/23/2010 Paul.  Add Reports module. 
-- 08/13/2014 Paul.  Add relative path for generation of CampaignLog. 
-- 01/29/2019 Paul.  Include Teams in workflow. 
Create View dbo.vwMODULES_Workflow
as
select MODULE_NAME
     , DISPLAY_NAME
     , TABLE_NAME
     , RELATIVE_PATH
  from vwMODULES
 where MODULE_ENABLED = 1
   and ((REPORT_ENABLED = 1 and IS_ADMIN = 0) or MODULE_NAME in (N'CreditCards', N'Notes', N'Users', N'Reports', 'Teams'))
GO

-- select * from vwMODULES_Workflow order by 1

Grant Select on dbo.vwMODULES_Workflow to public;
GO


