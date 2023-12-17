if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCAMPAIGN_LOG_List')
	Drop View dbo.vwCAMPAIGN_LOG_List;
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
Create View dbo.vwCAMPAIGN_LOG_List
as
select vwUSERS.FULL_NAME      as RECIPIENT_NAME
     , vwUSERS.EMAIL1         as RECIPIENT_EMAIL
     , vwCAMPAIGN_LOG.*
  from      vwCAMPAIGN_LOG
 inner join vwUSERS
         on vwUSERS.ID = vwCAMPAIGN_LOG.TARGET_ID
 where vwCAMPAIGN_LOG.TARGET_TYPE = N'Users'
union all
select vwCONTACTS.NAME        as RECIPIENT_NAME
     , vwCONTACTS.EMAIL1      as RECIPIENT_EMAIL
     , vwCAMPAIGN_LOG.*
  from      vwCAMPAIGN_LOG
 inner join vwCONTACTS
         on vwCONTACTS.ID = vwCAMPAIGN_LOG.TARGET_ID
 where vwCAMPAIGN_LOG.TARGET_TYPE = N'Contacts'
union all
select vwLEADS.NAME           as RECIPIENT_NAME
     , vwLEADS.EMAIL1         as RECIPIENT_EMAIL
     , vwCAMPAIGN_LOG.*
  from      vwCAMPAIGN_LOG
 inner join vwLEADS
         on vwLEADS.ID = vwCAMPAIGN_LOG.TARGET_ID
 where vwCAMPAIGN_LOG.TARGET_TYPE = N'Leads'
union all
select vwPROSPECTS.NAME       as RECIPIENT_NAME
     , vwPROSPECTS.EMAIL1     as RECIPIENT_EMAIL
     , vwCAMPAIGN_LOG.*
  from      vwCAMPAIGN_LOG
 inner join vwPROSPECTS
         on vwPROSPECTS.ID = vwCAMPAIGN_LOG.TARGET_ID
 where vwCAMPAIGN_LOG.TARGET_TYPE = N'Prospects'

GO

Grant Select on dbo.vwCAMPAIGN_LOG_List to public;
GO

