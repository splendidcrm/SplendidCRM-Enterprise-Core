if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_CREDIT_CARDS_Processing')
	Drop View dbo.vwACCOUNTS_CREDIT_CARDS_Processing;
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
-- 11/15/2009 Paul.  We need a way to exclude old credit cards. 
-- Using the expiration date is a simply way, but a better way would be to add a status field to the table. 
-- 11/15/2009 Paul.  Allow 2 month old credit cards to be processed as there is a grace period. 
Create View dbo.vwACCOUNTS_CREDIT_CARDS_Processing
as
select *
  from vwACCOUNTS_CREDIT_CARDS
 where BANK_ROUTING_NUMBER is not null
    or dbo.fnDateAdd('month', 2, EXPIRATION_DATE) > getdate()

GO

Grant Select on dbo.vwACCOUNTS_CREDIT_CARDS_Processing to public;
GO

