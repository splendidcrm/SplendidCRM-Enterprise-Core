
if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwREPORT_RULES_Edit')
	Drop View dbo.vwREPORT_RULES_Edit;
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
-- 05/19/2021 Paul.  ReportRules is based off of RULES table, but does not apply team filter, nor is it assigned. 
Create View dbo.vwREPORT_RULES_Edit
as
select vwREPORT_RULES.*
     , RULES.FILTER_SQL
     , RULES.FILTER_XML
     , RULES.RULES_XML
     , RULES.XOML
  from            vwREPORT_RULES
  left outer join RULES
               on RULES.ID = vwREPORT_RULES.ID

GO

Grant Select on dbo.vwREPORT_RULES_Edit to public;
GO

