if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILMAN_List')
	Drop View dbo.vwEMAILMAN_List;
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
-- 01/13/2008 Paul.  Use the email manager to generate AutoReplies. 
-- 08/23/2011 Paul.  Campaign emails are being sent to invalid email addresses even after being marked as invalid. 
-- Filter invalid emails at runtime. 
-- 10/27/2017 Paul.  Add Accounts as email source. 
Create View dbo.vwEMAILMAN_List
as
select vwUSERS.FULL_NAME      as RECIPIENT_NAME
     , vwUSERS.EMAIL1         as RECIPIENT_EMAIL
     , cast(0 as bit)         as INVALID_EMAIL
     , vwEMAILMAN.*
  from      vwEMAILMAN
 inner join vwUSERS
         on vwUSERS.ID = vwEMAILMAN.RELATED_ID
 where vwEMAILMAN.RELATED_TYPE = N'Users'
union all
select vwCONTACTS.NAME        as RECIPIENT_NAME
     , vwCONTACTS.EMAIL1      as RECIPIENT_EMAIL
     , isnull(vwCONTACTS.INVALID_EMAIL, 0) as INVALID_EMAIL
     , vwEMAILMAN.*
  from      vwEMAILMAN
 inner join vwCONTACTS
         on vwCONTACTS.ID = vwEMAILMAN.RELATED_ID
 where vwEMAILMAN.RELATED_TYPE = N'Contacts'
union all
select vwLEADS.NAME           as RECIPIENT_NAME
     , vwLEADS.EMAIL1         as RECIPIENT_EMAIL
     , isnull(vwLEADS.INVALID_EMAIL, 0) as INVALID_EMAIL
     , vwEMAILMAN.*
  from      vwEMAILMAN
 inner join vwLEADS
         on vwLEADS.ID = vwEMAILMAN.RELATED_ID
 where vwEMAILMAN.RELATED_TYPE = N'Leads'
union all
select vwPROSPECTS.NAME       as RECIPIENT_NAME
     , vwPROSPECTS.EMAIL1     as RECIPIENT_EMAIL
     , isnull(vwPROSPECTS.INVALID_EMAIL, 0) as INVALID_EMAIL
     , vwEMAILMAN.*
  from      vwEMAILMAN
 inner join vwPROSPECTS
         on vwPROSPECTS.ID = vwEMAILMAN.RELATED_ID
 where vwEMAILMAN.RELATED_TYPE = N'Prospects'
union all
select vwINBOUND_EMAIL_AUTOREPLY.AUTOREPLIED_NAME as RECIPIENT_NAME
     , vwINBOUND_EMAIL_AUTOREPLY.AUTOREPLIED_TO   as RECIPIENT_EMAIL
     , cast(0 as bit)                             as INVALID_EMAIL
     , vwEMAILMAN.*
  from      vwEMAILMAN
 inner join vwINBOUND_EMAIL_AUTOREPLY
         on vwINBOUND_EMAIL_AUTOREPLY.ID = vwEMAILMAN.RELATED_ID
 where vwEMAILMAN.RELATED_TYPE = N'AutoReply'
union all
select vwACCOUNTS.NAME        as RECIPIENT_NAME
     , vwACCOUNTS.EMAIL1      as RECIPIENT_EMAIL
     , isnull(vwACCOUNTS.INVALID_EMAIL, 0) as INVALID_EMAIL
     , vwEMAILMAN.*
  from      vwEMAILMAN
 inner join vwACCOUNTS
         on vwACCOUNTS.ID = vwEMAILMAN.RELATED_ID
 where vwEMAILMAN.RELATED_TYPE = N'Accounts'

GO

Grant Select on dbo.vwEMAILMAN_List to public;
GO

