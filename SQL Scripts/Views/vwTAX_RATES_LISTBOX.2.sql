if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTAX_RATES_LISTBOX')
	Drop View dbo.vwTAX_RATES_LISTBOX;
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
-- 03/31/2007 Paul.   We need the tax rate value to be cached. 
-- 04/07/2016 Paul.  Tax rates per team. 
Create View dbo.vwTAX_RATES_LISTBOX
as
select ID
     , NAME
     , LIST_ORDER
     , VALUE
     , TEAM_ID
     , TEAM_NAME
     , TEAM_SET_ID
     , TEAM_SET_NAME
     , TEAM_SET_LIST
  from vwTAX_RATES
 where STATUS = N'Active'

GO

Grant Select on dbo.vwTAX_RATES_LISTBOX to public;
GO


