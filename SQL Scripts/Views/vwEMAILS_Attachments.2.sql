if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILS_Attachments')
	Drop View dbo.vwEMAILS_Attachments;
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
-- 07/30/2006 Paul.  System.Net.Mail in .NET 2.0 requires the mime type for the attachments. 
-- 12/05/2006 Paul.  Literals should be in unicode to reduce conversions at runtime. 
-- 05/12/2017 Paul.  Need to optimize for Azure. 
Create View dbo.vwEMAILS_Attachments
as
select NOTES.ID
     , NOTES.NAME
     , NOTES.FILENAME
     , NOTES.FILE_MIME_TYPE
     , NOTES.NOTE_ATTACHMENT_ID
     , NOTES.PARENT_ID          as EMAIL_ID
  from      NOTES
 inner join NOTE_ATTACHMENTS
         on NOTE_ATTACHMENTS.ID      = NOTES.NOTE_ATTACHMENT_ID
        and NOTE_ATTACHMENTS.DELETED = 0
        and NOTE_ATTACHMENTS.ATTACHMENT_LENGTH > 0
 where NOTES.DELETED            = 0
   and NOTES.PARENT_TYPE        = N'Emails'
   and NOTES.FILENAME           is not null

GO

Grant Select on dbo.vwEMAILS_Attachments to public;
GO


