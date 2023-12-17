if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCHAT_CHANNELS_ATTACHMENTS')
	Drop View dbo.vwCHAT_CHANNELS_ATTACHMENTS;
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
Create View dbo.vwCHAT_CHANNELS_ATTACHMENTS
as
select CHAT_CHANNELS.ID               as CHAT_CHANNEL_ID
     , CHAT_CHANNELS.NAME             as CHAT_CHANNEL_NAME
     , CHAT_CHANNELS.ASSIGNED_USER_ID
     , TEAMS.ID                       as TEAM_ID
     , TEAMS.NAME                     as TEAM_NAME
     , TEAM_SETS.ID                   as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME        as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST        as TEAM_SET_LIST
     , NOTE_ATTACHMENTS.FILENAME      as NAME
     , NOTE_ATTACHMENTS.ID
     , NOTE_ATTACHMENTS.DESCRIPTION
     , NOTE_ATTACHMENTS.NOTE_ID
     , NOTE_ATTACHMENTS.FILENAME
     , NOTE_ATTACHMENTS.FILE_MIME_TYPE
     , NOTE_ATTACHMENTS.DATE_ENTERED 
     , NOTE_ATTACHMENTS.CREATED_BY    as CREATED_USER_ID
     , USERS_CREATED_BY.USER_NAME     as CREATED_BY
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , ASSIGNED_SETS.ID                as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST as ASSIGNED_SET_LIST
  from            CHAT_CHANNELS
       inner join CHAT_MESSAGES
               on CHAT_MESSAGES.CHAT_CHANNEL_ID = CHAT_CHANNELS.ID
              and CHAT_MESSAGES.DELETED         = 0
       inner join NOTE_ATTACHMENTS
               on NOTE_ATTACHMENTS.ID           = CHAT_MESSAGES.NOTE_ATTACHMENT_ID
              and NOTE_ATTACHMENTS.DELETED      = 0
  left outer join TEAMS
               on TEAMS.ID                      = CHAT_CHANNELS.TEAM_ID
              and TEAMS.DELETED                 = 0
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID              = CHAT_CHANNELS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED         = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID                  = CHAT_CHANNELS.TEAM_SET_ID
              and TEAM_SETS.DELETED             = 0
  left outer join USERS USERS_CREATED_BY
               on USERS_CREATED_BY.ID           = NOTE_ATTACHMENTS.CREATED_BY
 where NOTE_ATTACHMENTS.DELETED = 0

GO

Grant Select on dbo.vwCHAT_CHANNELS_ATTACHMENTS to public;
GO

