if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCURRENCIES')
	Drop View dbo.vwCURRENCIES;
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
-- 04/30/2016 Paul.  Add reference to log entry that modified the record. 
Create View dbo.vwCURRENCIES
as
select ID
     , NAME
     , SYMBOL
     , ISO4217
     , CONVERSION_RATE
     , STATUS
     , SYSTEM_CURRENCY_LOG_ID
     , DATE_MODIFIED
     , MODIFIED_USER_ID
     , CURRENCIES_CSTM.*
  from CURRENCIES
  left outer join CURRENCIES_CSTM
               on CURRENCIES_CSTM.ID_C = CURRENCIES.ID
 where DELETED = 0

GO

Grant Select on dbo.vwCURRENCIES to public;
GO

 
