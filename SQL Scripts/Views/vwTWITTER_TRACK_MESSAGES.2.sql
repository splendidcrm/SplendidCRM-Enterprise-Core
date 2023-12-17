if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTWITTER_TRACK_MESSAGES')
	Drop View dbo.vwTWITTER_TRACK_MESSAGES;
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
Create View dbo.vwTWITTER_TRACK_MESSAGES
as
select TWITTER_TRACKS.ID               as TWITTER_TRACK_ID
     , TWITTER_TRACKS.NAME             as TWITTER_TRACK_NAME
     , TWITTER_TRACKS.ASSIGNED_USER_ID as TWITTER_TRACK_ASSIGNED_USER_ID
     , TWITTER_TRACKS.ASSIGNED_SET_ID  as TWITTER_TRACK_ASSIGNED_SET_ID
     , vwTWITTER_MESSAGES.ID           as TWITTER_MESSAGE_ID
     , vwTWITTER_MESSAGES.NAME         as TWITTER_MESSAGE_NAME
     , vwTWITTER_MESSAGES.*
  from           TWITTER_TRACKS
      inner join TWITTER_TRACK_MESSAGES
              on TWITTER_TRACK_MESSAGES.TWITTER_TRACK_ID = TWITTER_TRACKS.ID
             and TWITTER_TRACK_MESSAGES.DELETED = 0
      inner join vwTWITTER_MESSAGES
              on vwTWITTER_MESSAGES.ID          = TWITTER_TRACK_MESSAGES.TWITTER_MESSAGE_ID
 where TWITTER_TRACKS.DELETED = 0

GO

Grant Select on dbo.vwTWITTER_TRACK_MESSAGES to public;
GO


