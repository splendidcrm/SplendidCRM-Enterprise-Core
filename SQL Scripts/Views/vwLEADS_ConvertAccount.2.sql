if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwLEADS_ConvertAccount')
	Drop View dbo.vwLEADS_ConvertAccount;
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
Create View dbo.vwLEADS_ConvertAccount
as
select cast(null as nvarchar(30))     as ACCOUNT_NUMBER
     , ACCOUNT_NAME                   as NAME
     , PHONE_WORK                     as PHONE_OFFICE
     , PHONE_OTHER                    as PHONE_ALTERNATE
     , cast(null as nvarchar(25))     as ANNUAL_REVENUE
     , cast(null as nvarchar(10))     as EMPLOYEES
     , cast(null as nvarchar(25))     as INDUSTRY
     , cast(null as nvarchar(100))    as OWNERSHIP
     , cast(null as nvarchar(25))     as ACCOUNT_TYPE
     , cast(null as nvarchar(10))     as TICKER_SYMBOL
     , cast(null as nvarchar(25))     as RATING
     , cast(null as nvarchar(10))     as SIC_CODE
     , cast(null as uniqueidentifier) as PARENT_ID
     , cast(null as nvarchar(150))    as PARENT_NAME
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_USER_ID
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_SET_ID
     , vwLEADS_Convert.*
  from vwLEADS_Convert

GO

Grant Select on dbo.vwLEADS_ConvertAccount to public;
GO

