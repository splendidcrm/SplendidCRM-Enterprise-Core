if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCHAT_MESSAGES_NOTES')
	Drop View dbo.vwCHAT_MESSAGES_NOTES;
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
Create View dbo.vwCHAT_MESSAGES_NOTES
as
select CHAT_MESSAGES.ID               as CHAT_MESSAGE_ID
     , CHAT_MESSAGES.NAME             as CHAT_MESSAGE_NAME
     , CHAT_MESSAGES.CREATED_BY       as CREATED_USER_ID
     , CHAT_MESSAGES.CHAT_CHANNEL_ID  as CHAT_CHANNEL_ID
     , vwNOTES.ID                     as NOTE_ID
     , vwNOTES.NAME                   as NOTE_NAME
     , vwNOTES.*
  from           CHAT_MESSAGES
      inner join vwNOTES
              on vwNOTES.PARENT_ID   = CHAT_MESSAGES.ID
             and vwNOTES.PARENT_TYPE = N'ChatMessages'
 where CHAT_MESSAGES.DELETED = 0

GO

Grant Select on dbo.vwCHAT_MESSAGES_NOTES to public;
GO


