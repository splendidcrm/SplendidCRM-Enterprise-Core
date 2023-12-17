if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSMS_MESSAGES_ReadyToSend')
	Drop View dbo.vwSMS_MESSAGES_ReadyToSend;
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
Create View dbo.vwSMS_MESSAGES_ReadyToSend
as
select SMS_MESSAGES.ID
     , SMS_MESSAGES.FROM_NUMBER
     , SMS_MESSAGES.TO_NUMBER
     , SMS_MESSAGES.NAME
     , SMS_MESSAGES.TYPE
     , SMS_MESSAGES.STATUS
     , SMS_MESSAGES.PARENT_TYPE
     , SMS_MESSAGES.PARENT_ID
     , SMS_MESSAGES.DATE_MODIFIED
     , SMS_MESSAGES.MODIFIED_USER_ID
     , SMS_MESSAGES.MAILBOX_ID
  from            SMS_MESSAGES
  left outer join OUTBOUND_SMS
               on OUTBOUND_SMS.ID      = SMS_MESSAGES.MAILBOX_ID
              and OUTBOUND_SMS.DELETED = 0
 where SMS_MESSAGES.DELETED = 0
   and SMS_MESSAGES.TYPE    = N'out'
   and (SMS_MESSAGES.STATUS = N'draft' or SMS_MESSAGES.STATUS is null)

GO

Grant Select on dbo.vwSMS_MESSAGES_ReadyToSend to public;
GO

 
