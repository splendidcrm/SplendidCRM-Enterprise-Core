if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROSPECTS_DATA_PRIVACY')
	Drop View dbo.vwPROSPECTS_DATA_PRIVACY;
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
Create View dbo.vwPROSPECTS_DATA_PRIVACY
as
select PROSPECTS.ID               as PROSPECT_ID
     , dbo.fnFullName(PROSPECTS.FIRST_NAME, PROSPECTS.LAST_NAME) as PROSPECT_NAME
     , PROSPECTS.ASSIGNED_USER_ID as PROSPECT_ASSIGNED_USER_ID
     , PROSPECTS.ASSIGNED_SET_ID  as PROSPECT_ASSIGNED_SET_ID
     , vwDATA_PRIVACY.ID         as DATA_PRIVACY_ID
     , vwDATA_PRIVACY.NAME       as DATA_PRIVACY_NAME
     , vwDATA_PRIVACY.*
  from           PROSPECTS
      inner join PROSPECTS_DATA_PRIVACY
              on PROSPECTS_DATA_PRIVACY.PROSPECT_ID = PROSPECTS.ID
             and PROSPECTS_DATA_PRIVACY.DELETED    = 0
      inner join vwDATA_PRIVACY
              on vwDATA_PRIVACY.ID                = PROSPECTS_DATA_PRIVACY.DATA_PRIVACY_ID
 where PROSPECTS.DELETED = 0

GO

Grant Select on dbo.vwPROSPECTS_DATA_PRIVACY to public;
GO

