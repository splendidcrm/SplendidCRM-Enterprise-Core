if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILMAN_Send')
	Drop View dbo.vwEMAILMAN_Send;
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
-- 12/20/2007 Paul.  When a send has failed, we try again after 24 hours. 
-- 06/02/2010 Paul.  The date check was reversed, so a second attempt was never made. 
-- 08/23/2011 Paul.  Campaign emails are being sent to invalid email addresses even after being marked as invalid. 
-- Filter invalid emails at runtime. 
-- 10/06/2011 Paul.  Invalid email had wrong condition. 
-- 03/30/2013 Paul.  All campaign emails should be created with the template Assigned User and Team ID. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwEMAILMAN_Send
as
select vwEMAILMAN_List.*
     , EMAIL_TEMPLATES.SUBJECT
     , EMAIL_TEMPLATES.BODY
     , EMAIL_TEMPLATES.BODY_HTML
     , EMAIL_TEMPLATES.ASSIGNED_USER_ID
     , EMAIL_TEMPLATES.TEAM_ID
     , EMAIL_TEMPLATES.TEAM_SET_ID
     , EMAIL_TEMPLATES.ASSIGNED_SET_ID
  from      vwEMAILMAN_List
 inner join EMAIL_TEMPLATES
         on EMAIL_TEMPLATES.ID = vwEMAILMAN_List.EMAIL_TEMPLATE_ID
 where vwEMAILMAN_List.SEND_ATTEMPTS < 5
   and (vwEMAILMAN_List.IN_QUEUE = 0 or dbo.fnDateAdd_Hours(24, getdate()) > vwEMAILMAN_List.IN_QUEUE_DATE)
   and INVALID_EMAIL = 0

GO

Grant Select on dbo.vwEMAILMAN_Send to public;
GO

