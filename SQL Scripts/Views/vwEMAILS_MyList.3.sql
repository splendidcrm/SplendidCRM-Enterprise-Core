if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILS_MyList')
	Drop View dbo.vwEMAILS_MyList;
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
Create View dbo.vwEMAILS_MyList
as
select vwEMAILS.*
     , EMAILS.TO_ADDRS
     , EMAILS.CC_ADDRS
     , EMAILS.TO_ADDRS_NAMES
     , EMAILS.CC_ADDRS_NAMES
     , (select count(*)
          from NOTES
         where NOTES.PARENT_ID    = vwEMAILS.ID
           and PARENT_TYPE        = N'Emails'
           and FILENAME           is not null
           and NOTE_ATTACHMENT_ID is not null
       ) as ATTACHMENT_COUNT
  from            vwEMAILS
  left outer join EMAILS
               on EMAILS.ID                = vwEMAILS.ID
 where (vwEMAILS.STATUS = N'Unread' or vwEMAILS.ASSIGNED_USER_ID is null)
   and vwEMAILS.TYPE in ('archived', 'inbound')

GO

Grant Select on dbo.vwEMAILS_MyList to public;
GO

 
