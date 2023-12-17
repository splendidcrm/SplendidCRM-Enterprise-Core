if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwOUTBOUND_EMAILS_Sync')
	Drop View dbo.vwOUTBOUND_EMAILS_Sync;
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
-- 06/27/2014 Paul.  Exclude SMTP values for security reasons. 
-- 08/30/2014 Paul.  The DELETED field is required. 
-- 04/20/2016 Paul.  Add team management to Outbound Emails. 
Create View dbo.vwOUTBOUND_EMAILS_Sync
as
select ID
     , DELETED
     , CREATED_BY       
     , DATE_ENTERED     
     , MODIFIED_USER_ID 
     , DATE_MODIFIED    
     , DATE_MODIFIED_UTC
     , NAME             
     , TYPE             
     , USER_ID          
     , FROM_NAME        
     , FROM_ADDR        
     , TEAM_ID          
     , TEAM_SET_ID      
  from OUTBOUND_EMAILS
 where DELETED = 0

GO

Grant Select on dbo.vwOUTBOUND_EMAILS_Sync to public;
GO


