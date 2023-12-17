if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMEETINGS_LEADS_Soap')
	Drop View dbo.vwMEETINGS_LEADS_Soap;
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
Create View dbo.vwMEETINGS_LEADS_Soap
as
select MEETINGS_LEADS.MEETING_ID as PRIMARY_ID
     , MEETINGS_LEADS.LEAD_ID    as RELATED_ID
     , MEETINGS_LEADS.DELETED
     , MEETINGS.DATE_MODIFIED
     , MEETINGS.DATE_MODIFIED_UTC
     , dbo.fnViewDateTime(MEETINGS.DATE_START, MEETINGS.TIME_START) as DATE_START
  from      MEETINGS_LEADS
 inner join MEETINGS
         on MEETINGS.ID      = MEETINGS_LEADS.MEETING_ID
        and MEETINGS.DELETED = MEETINGS_LEADS.DELETED
 inner join LEADS
         on LEADS.ID      = MEETINGS_LEADS.LEAD_ID
        and LEADS.DELETED = MEETINGS_LEADS.DELETED
 union
select MEETINGS.ID                  as PRIMARY_ID
     , LEADS.ID                     as RELATED_ID
     , MEETINGS.DELETED
     , MEETINGS.DATE_MODIFIED
     , MEETINGS.DATE_MODIFIED_UTC
     , dbo.fnViewDateTime(MEETINGS.DATE_START, MEETINGS.TIME_START) as DATE_START
  from      MEETINGS
 inner join LEADS
         on LEADS.ID      = MEETINGS.PARENT_ID
        and LEADS.DELETED = MEETINGS.DELETED
 where MEETINGS.PARENT_TYPE = N'Leads'

GO

Grant Select on dbo.vwMEETINGS_LEADS_Soap to public;
GO

