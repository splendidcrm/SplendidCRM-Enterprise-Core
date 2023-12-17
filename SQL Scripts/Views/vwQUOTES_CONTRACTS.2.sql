if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwQUOTES_CONTRACTS')
	Drop View dbo.vwQUOTES_CONTRACTS;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwQUOTES_CONTRACTS
as
select QUOTES.ID                   as QUOTE_ID
     , QUOTES.NAME                 as QUOTE_NAME
     , QUOTES.ASSIGNED_USER_ID     as QUOTE_ASSIGNED_USER_ID
     , QUOTES.ASSIGNED_SET_ID      as QUOTE_ASSIGNED_SET_ID
     , vwCONTRACTS.ID              as CONTRACT_ID
     , vwCONTRACTS.NAME            as CONTRACT_NAME
     , vwCONTRACTS.*
  from           QUOTES
      inner join CONTRACTS_QUOTES
              on CONTRACTS_QUOTES.QUOTE_ID      = QUOTES.ID
             and CONTRACTS_QUOTES.DELETED       = 0
      inner join vwCONTRACTS
              on vwCONTRACTS.ID                 = CONTRACTS_QUOTES.CONTRACT_ID
 where QUOTES.DELETED = 0

GO

Grant Select on dbo.vwQUOTES_CONTRACTS to public;
GO


