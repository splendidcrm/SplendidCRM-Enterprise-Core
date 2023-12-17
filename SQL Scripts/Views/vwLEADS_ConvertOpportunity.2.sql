if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwLEADS_ConvertOpportunity')
	Drop View dbo.vwLEADS_ConvertOpportunity;
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
Create View dbo.vwLEADS_ConvertOpportunity
as
select cast(null as nvarchar(150))    as NAME
     , cast(null as nvarchar(255))    as OPPORTUNITY_TYPE
     , cast(null as money)            as AMOUNT
     , cast(null as nvarchar(25))     as AMOUNT_BACKUP
     , cast(null as money)            as AMOUNT_USDOLLAR
     , cast(null as uniqueidentifier) as CURRENCY_ID
     , cast(null as datetime)         as DATE_CLOSED
     , cast(null as nvarchar(100))    as NEXT_STEP
     , cast(null as nvarchar(25))     as SALES_STAGE
     , cast(null as float)            as PROBABILITY
     , cast(null as nvarchar(150))    as CAMPAIGN_NAME
     , cast(null as uniqueidentifier) as CAMPAIGN_ASSIGNED_USER_ID
     , cast(null as uniqueidentifier) as CAMPAIGN_ASSIGNED_SET_ID
     , cast(null as uniqueidentifier) as ACCOUNT_ID
     , cast(null as uniqueidentifier) as ACCOUNT_ASSIGNED_USER_ID
     , cast(null as uniqueidentifier) as ACCOUNT_ASSIGNED_SET_ID
     , cast(null as uniqueidentifier) as B2C_CONTACT_ID
     , cast(null as nvarchar(150))    as B2C_CONTACT_NAME
     , cast(null as uniqueidentifier) as B2C_CONTACT_ASSIGNED_USER_ID
     , cast(null as uniqueidentifier) as B2C_CONTACT_ASSIGNED_SET_ID
     , vwLEADS_Convert.*
  from vwLEADS_Convert

GO

Grant Select on dbo.vwLEADS_ConvertOpportunity to public;
GO


