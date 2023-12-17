if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILMAN_Preview')
	Drop View dbo.vwEMAILMAN_Preview;
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
-- 01/12/2008 Paul.  Preview is different in that it does not filter on queue date. 
-- 08/23/2011 Paul.  Campaign emails are being sent to invalid email addresses even after being marked as invalid. 
-- Filter invalid emails at runtime. 
-- 10/06/2011 Paul.  Invalid email had wrong condition. 
-- 03/30/2013 Paul.  All campaign emails should be created with the template Assigned User and Team ID. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwEMAILMAN_Preview
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
 where INVALID_EMAIL = 0

GO

Grant Select on dbo.vwEMAILMAN_Preview to public;
GO

