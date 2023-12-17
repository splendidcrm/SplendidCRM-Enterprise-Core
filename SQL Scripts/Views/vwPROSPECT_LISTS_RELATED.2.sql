if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROSPECT_LISTS_RELATED')
	Drop View dbo.vwPROSPECT_LISTS_RELATED;
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
-- 04/25/2016 Paul.  Must include EMAIL_OPT_OUT. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwPROSPECT_LISTS_RELATED
as
select PROSPECT_LISTS.ID                                         as PROSPECT_LIST_ID
     , PROSPECT_LISTS.NAME                                       as PROSPECT_LIST_NAME
     , PROSPECT_LISTS.ASSIGNED_USER_ID                           as PROSPECT_ASSIGNED_USER_ID
     , PROSPECT_LISTS.ASSIGNED_SET_ID                            as PROSPECT_ASSIGNED_SET_ID
     , PROSPECT_LISTS.DYNAMIC_LIST                               as PROSPECT_DYNAMIC_LIST
     , PROSPECT_LISTS_PROSPECTS.RELATED_TYPE                     as RELATED_TYPE
     , PROSPECT_LISTS_PROSPECTS.ID
     , dbo.fnFullName(PROSPECTS.FIRST_NAME, PROSPECTS.LAST_NAME) as NAME
     , dbo.fnFullName(PROSPECTS.FIRST_NAME, PROSPECTS.LAST_NAME) as RELATED_NAME
     , PROSPECTS.ID                                              as RELATED_ID
     , PROSPECTS.FIRST_NAME
     , PROSPECTS.LAST_NAME
     , PROSPECTS.EMAIL1
     , PROSPECTS.EMAIL_OPT_OUT
     , PROSPECTS.ASSIGNED_USER_ID
     , PROSPECTS.DATE_ENTERED
     , PROSPECTS.DATE_MODIFIED
     , PROSPECTS.DATE_MODIFIED_UTC
     , PROSPECTS.TEAM_ID
     , PROSPECTS.TEAM_SET_ID
  from            PROSPECT_LISTS
       inner join PROSPECT_LISTS_PROSPECTS
               on PROSPECT_LISTS_PROSPECTS.PROSPECT_LIST_ID = PROSPECT_LISTS.ID
              and PROSPECT_LISTS_PROSPECTS.RELATED_TYPE     = N'Prospects'
              and PROSPECT_LISTS_PROSPECTS.DELETED          = 0
       inner join PROSPECTS
               on PROSPECTS.ID             = PROSPECT_LISTS_PROSPECTS.RELATED_ID
              and PROSPECTS.DELETED        = 0
 where PROSPECT_LISTS.DELETED = 0
union all
select PROSPECT_LISTS.ID                                         as PROSPECT_LIST_ID
     , PROSPECT_LISTS.NAME                                       as PROSPECT_LIST_NAME
     , PROSPECT_LISTS.ASSIGNED_USER_ID                           as PROSPECT_ASSIGNED_USER_ID
     , PROSPECT_LISTS.ASSIGNED_SET_ID                            as PROSPECT_ASSIGNED_SET_ID
     , PROSPECT_LISTS.DYNAMIC_LIST                               as PROSPECT_DYNAMIC_LIST
     , PROSPECT_LISTS_PROSPECTS.RELATED_TYPE                     as RELATED_TYPE
     , PROSPECT_LISTS_PROSPECTS.ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME)   as NAME
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME)   as RELATED_NAME
     , CONTACTS.ID                                               as RELATED_ID
     , CONTACTS.FIRST_NAME
     , CONTACTS.LAST_NAME
     , CONTACTS.EMAIL1
     , CONTACTS.EMAIL_OPT_OUT
     , CONTACTS.ASSIGNED_USER_ID
     , CONTACTS.DATE_ENTERED
     , CONTACTS.DATE_MODIFIED
     , CONTACTS.DATE_MODIFIED_UTC
     , CONTACTS.TEAM_ID
     , CONTACTS.TEAM_SET_ID
  from            PROSPECT_LISTS
       inner join PROSPECT_LISTS_PROSPECTS
               on PROSPECT_LISTS_PROSPECTS.PROSPECT_LIST_ID = PROSPECT_LISTS.ID
              and PROSPECT_LISTS_PROSPECTS.RELATED_TYPE     = N'Contacts'
              and PROSPECT_LISTS_PROSPECTS.DELETED          = 0
       inner join CONTACTS
               on CONTACTS.ID              = PROSPECT_LISTS_PROSPECTS.RELATED_ID
              and CONTACTS.DELETED         = 0
 where PROSPECT_LISTS.DELETED = 0
union all
select PROSPECT_LISTS.ID                                         as PROSPECT_LIST_ID
     , PROSPECT_LISTS.NAME                                       as PROSPECT_LIST_NAME
     , PROSPECT_LISTS.ASSIGNED_USER_ID                           as PROSPECT_ASSIGNED_USER_ID
     , PROSPECT_LISTS.ASSIGNED_SET_ID                            as PROSPECT_ASSIGNED_SET_ID
     , PROSPECT_LISTS.DYNAMIC_LIST                               as PROSPECT_DYNAMIC_LIST
     , PROSPECT_LISTS_PROSPECTS.RELATED_TYPE                     as RELATED_TYPE
     , PROSPECT_LISTS_PROSPECTS.ID
     , dbo.fnFullName(LEADS.FIRST_NAME, LEADS.LAST_NAME)         as NAME
     , dbo.fnFullName(LEADS.FIRST_NAME, LEADS.LAST_NAME)         as RELATED_NAME
     , LEADS.ID                                                  as RELATED_ID
     , LEADS.FIRST_NAME
     , LEADS.LAST_NAME
     , LEADS.EMAIL1
     , LEADS.EMAIL_OPT_OUT
     , LEADS.ASSIGNED_USER_ID
     , LEADS.DATE_ENTERED
     , LEADS.DATE_MODIFIED
     , LEADS.DATE_MODIFIED_UTC
     , LEADS.TEAM_ID
     , LEADS.TEAM_SET_ID
  from            PROSPECT_LISTS
       inner join PROSPECT_LISTS_PROSPECTS
               on PROSPECT_LISTS_PROSPECTS.PROSPECT_LIST_ID = PROSPECT_LISTS.ID
              and PROSPECT_LISTS_PROSPECTS.RELATED_TYPE     = N'Leads'
              and PROSPECT_LISTS_PROSPECTS.DELETED          = 0
       inner join LEADS
               on LEADS.ID                 = PROSPECT_LISTS_PROSPECTS.RELATED_ID
              and LEADS.DELETED            = 0
 where PROSPECT_LISTS.DELETED = 0

GO

Grant Select on dbo.vwPROSPECT_LISTS_RELATED to public;
GO

