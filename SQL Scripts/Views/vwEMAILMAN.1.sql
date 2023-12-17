if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILMAN')
	Drop View dbo.vwEMAILMAN;
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
-- 12/21/2007 Paul.  We need to use the inbound email to specify the RETURN_PATH. 
-- 01/08/2008 Paul.  The inbound email is also used as the FROM_ADDR. 
-- 01/21/2008 Paul.  CAMPAIGN_ID will be NULL for an auto-reply. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 01/23/2013 Paul.  Add REPLY_TO_NAME and REPLY_TO_ADDR. 
-- 11/01/2015 Paul.  Include COMPUTED_EMAIL1 in table to increase performance of dup removal. 
Create View dbo.vwEMAILMAN
as
select EMAILMAN.ID
     , EMAILMAN.EMAILMAN_NUMBER
     , EMAILMAN.CAMPAIGN_ID    
     , EMAILMAN.MARKETING_ID   
     , EMAILMAN.LIST_ID        
     , EMAILMAN.SEND_DATE_TIME 
     , EMAILMAN.IN_QUEUE       
     , EMAILMAN.IN_QUEUE_DATE  
     , EMAILMAN.SEND_ATTEMPTS  
     , EMAILMAN.RELATED_ID     
     , EMAILMAN.RELATED_TYPE   
     , CAMPAIGNS.NAME              as CAMPAIGN_NAME
     , EMAIL_MARKETING.ID          as EMAIL_MARKETING_ID
     , EMAIL_MARKETING.NAME        as EMAIL_MARKETING_NAME
     , INBOUND_EMAILS.FROM_ADDR    as EMAIL_MARKETING_FROM_ADDR
     , EMAIL_MARKETING.FROM_NAME   as EMAIL_MARKETING_FROM_NAME
     , INBOUND_EMAILS.FROM_NAME    as EMAIL_MARKETING_RETURN_NAME
     , INBOUND_EMAILS.FROM_ADDR    as EMAIL_MARKETING_RETURN_PATH
     , isnull(EMAIL_MARKETING.REPLY_TO_ADDR, INBOUND_EMAILS.REPLY_TO_ADDR) as EMAIL_MARKETING_REPLY_TO_ADDR
     , isnull(EMAIL_MARKETING.REPLY_TO_NAME, INBOUND_EMAILS.REPLY_TO_NAME) as EMAIL_MARKETING_REPLY_TO_NAME
     , EMAIL_MARKETING.TEMPLATE_ID as EMAIL_TEMPLATE_ID
     , PROSPECT_LISTS.ID           as PROSPECT_LIST_ID
     , PROSPECT_LISTS.NAME         as PROSPECT_LIST_NAME
     , EMAILMAN.DATE_ENTERED
     , EMAILMAN.DATE_MODIFIED
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , EMAILMAN.CREATED_BY         as CREATED_BY_ID
     , EMAILMAN.MODIFIED_USER_ID
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , EMAILMAN.COMPUTED_EMAIL1
--     , EMAILMAN_CSTM.*
  from            EMAILMAN
  left outer join CAMPAIGNS
               on CAMPAIGNS.ID             = EMAILMAN.CAMPAIGN_ID
  left outer join EMAIL_MARKETING
               on EMAIL_MARKETING.ID       = EMAILMAN.MARKETING_ID
  left outer join PROSPECT_LISTS
               on PROSPECT_LISTS.ID        = EMAILMAN.LIST_ID
  left outer join INBOUND_EMAILS
               on INBOUND_EMAILS.ID        = EMAIL_MARKETING.INBOUND_EMAIL_ID
              and INBOUND_EMAILS.DELETED   = 0
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = CAMPAIGNS.CREATED_BY
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = CAMPAIGNS.MODIFIED_USER_ID
--  left outer join EMAILMAN_CSTM
--               on EMAILMAN_CSTM.ID_C       = EMAILMAN.ID
 where EMAILMAN.DELETED = 0
   and EMAILMAN.CAMPAIGN_ID is not null
union all
select EMAILMAN.ID
     , EMAILMAN.EMAILMAN_NUMBER
     , EMAILMAN.CAMPAIGN_ID    
     , EMAILMAN.MARKETING_ID   
     , EMAILMAN.LIST_ID        
     , EMAILMAN.SEND_DATE_TIME 
     , EMAILMAN.IN_QUEUE       
     , EMAILMAN.IN_QUEUE_DATE  
     , EMAILMAN.SEND_ATTEMPTS  
     , EMAILMAN.RELATED_ID     
     , EMAILMAN.RELATED_TYPE   
     , cast(null as nvarchar(50))     as CAMPAIGN_NAME
     , cast(null as uniqueidentifier) as EMAIL_MARKETING_ID
     , cast(null as nvarchar(255))    as EMAIL_MARKETING_NAME
     , INBOUND_EMAILS.FROM_ADDR       as EMAIL_MARKETING_FROM_ADDR
     , INBOUND_EMAILS.FROM_NAME       as EMAIL_MARKETING_FROM_NAME
     , INBOUND_EMAILS.FROM_NAME       as EMAIL_MARKETING_RETURN_NAME
     , INBOUND_EMAILS.FROM_ADDR       as EMAIL_MARKETING_RETURN_PATH
     , INBOUND_EMAILS.REPLY_TO_ADDR   as EMAIL_MARKETING_REPLY_TO_ADDR
     , INBOUND_EMAILS.REPLY_TO_NAME   as EMAIL_MARKETING_REPLY_TO_NAME
     , INBOUND_EMAILS.TEMPLATE_ID     as EMAIL_TEMPLATE_ID
     , cast(null as uniqueidentifier) as PROSPECT_LIST_ID
     , cast(null as nvarchar(50))     as PROSPECT_LIST_NAME
     , EMAILMAN.DATE_ENTERED
     , EMAILMAN.DATE_MODIFIED
     , cast(null as nvarchar(20))     as CREATED_BY
     , cast(null as nvarchar(20))     as MODIFIED_BY
     , EMAILMAN.CREATED_BY            as CREATED_BY_ID
     , EMAILMAN.MODIFIED_USER_ID
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , EMAILMAN.COMPUTED_EMAIL1
--     , EMAILMAN_CSTM.*
  from            EMAILMAN
  left outer join INBOUND_EMAILS
               on INBOUND_EMAILS.ID        = EMAILMAN.INBOUND_EMAIL_ID
              and INBOUND_EMAILS.DELETED   = 0
--  left outer join EMAILMAN_CSTM
--               on EMAILMAN_CSTM.ID_C       = EMAILMAN.ID
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = EMAILMAN.CREATED_BY
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = EMAILMAN.MODIFIED_USER_ID
 where EMAILMAN.DELETED = 0
   and EMAILMAN.CAMPAIGN_ID is null

GO

Grant Select on dbo.vwEMAILMAN to public;
GO

