if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCURRENCIES_LISTBOX')
	Drop View dbo.vwCURRENCIES_LISTBOX;
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
-- 05/29/2008 Paul.  ISO4217 is needed to process PayPal transactions. 
-- 05/01/2016 Paul.  We are going to prepopulate the list and the ISO4217 is required and unique. 
Create View dbo.vwCURRENCIES_LISTBOX
as
select ID
     , NAME
     , SYMBOL
     , NAME + N': ' + SYMBOL as NAME_SYMBOL
     , CONVERSION_RATE
     , ISO4217
  from CURRENCIES
 where DELETED = 0
   and (STATUS is null or STATUS = N'Active')

GO

Grant Select on dbo.vwCURRENCIES_LISTBOX to public;
GO

 
