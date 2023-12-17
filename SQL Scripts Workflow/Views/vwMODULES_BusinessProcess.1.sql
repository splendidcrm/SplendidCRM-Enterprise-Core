if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMODULES_BusinessProcess')
	Drop View dbo.vwMODULES_BusinessProcess;
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
-- 09/28/2016 Paul.  We want the ability to create a Call, Meeting, Note or Task. Also allow events for Survey Results and SMS Messages. 
-- 12/09/2017 Paul.  Allow Users. 
Create View dbo.vwMODULES_BusinessProcess
as
select MODULE_NAME
     , DISPLAY_NAME
     , TABLE_NAME
     , RELATIVE_PATH
  from vwMODULES
 where MODULE_ENABLED = 1
   and ((REPORT_ENABLED = 1 and IS_ADMIN = 0) or MODULE_NAME in (N'Users', N'Surveys', N'ProductTemplates', N'KBDocuments'))
   and MODULE_NAME not in (N'CampaignLog', N'InvoicesLineItems', N'OrdersLineItems', N'QuotesLineItems', N'RevenueLineItems', N'Products')
GO

-- select * from vwMODULES_BusinessProcess order by 1

Grant Select on dbo.vwMODULES_BusinessProcess to public;
GO


