if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwINBOUND_EMAILS_Sync')
	Drop View dbo.vwINBOUND_EMAILS_Sync;
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
Create View dbo.vwINBOUND_EMAILS_Sync
as
select INBOUND_EMAILS.ID
     , INBOUND_EMAILS.DELETED
     , INBOUND_EMAILS.CREATED_BY       
     , INBOUND_EMAILS.DATE_ENTERED     
     , INBOUND_EMAILS.MODIFIED_USER_ID 
     , INBOUND_EMAILS.DATE_MODIFIED    
     , INBOUND_EMAILS.DATE_MODIFIED_UTC
     , INBOUND_EMAILS.NAME             
     , INBOUND_EMAILS.STATUS           
     , INBOUND_EMAILS.MAILBOX_SSL      
     , INBOUND_EMAILS.SERVICE          
     , INBOUND_EMAILS.MAILBOX          
     , INBOUND_EMAILS.DELETE_SEEN      
     , INBOUND_EMAILS.ONLY_SINCE       
     , INBOUND_EMAILS.MAILBOX_TYPE     
     , INBOUND_EMAILS.TEMPLATE_ID      
     , INBOUND_EMAILS.STORED_OPTIONS   
     , INBOUND_EMAILS.GROUP_ID         
     , INBOUND_EMAILS.FROM_NAME        
     , INBOUND_EMAILS.FROM_ADDR        
     , INBOUND_EMAILS.FILTER_DOMAIN    
     , INBOUND_EMAILS.IS_PERSONAL      
     , INBOUND_EMAILS.REPLY_TO_NAME    
     , INBOUND_EMAILS.REPLY_TO_ADDR    
     , INBOUND_EMAILS.LAST_EMAIL_UID   
     , INBOUND_EMAILS_CSTM.*
  from            INBOUND_EMAILS
  left outer join INBOUND_EMAILS_CSTM
               on INBOUND_EMAILS_CSTM.ID_C = INBOUND_EMAILS.ID
 where INBOUND_EMAILS.DELETED = 0

GO

Grant Select on dbo.vwINBOUND_EMAILS_Sync to public;
GO


