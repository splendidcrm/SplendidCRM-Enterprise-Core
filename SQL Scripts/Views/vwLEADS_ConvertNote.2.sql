if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwLEADS_ConvertNote')
	Drop View dbo.vwLEADS_ConvertNote;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwLEADS_ConvertNote
as
select cast(null as nvarchar(255))    as NAME
     , cast(null as nvarchar(25))     as PARENT_TYPE
     , cast(null as uniqueidentifier) as CONTACT_ID
     , cast(null as bit)              as PORTAL_FLAG
     , cast(null as uniqueidentifier) as PARENT_ID
     , cast(null as uniqueidentifier) as NOTE_ATTACHMENT_ID
     , cast(null as nvarchar(255))    as FILENAME
     , cast(null as nvarchar(100))    as FILE_MIME_TYPE
     , cast(null as bit)              as ATTACHMENT_READY
     , cast(null as nvarchar(150))    as PARENT_NAME
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_USER_ID
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_SET_ID
     , dbo.fnFullName(vwLEADS_Convert.FIRST_NAME, vwLEADS_Convert.LAST_NAME) as CONTACT_NAME
     , PHONE_WORK                     as CONTACT_PHONE
     , EMAIL1                         as CONTACT_EMAIL
     , ASSIGNED_USER_ID               as CONTACT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID                as CONTACT_ASSIGNED_SET_ID
     , vwLEADS_Convert.*
  from vwLEADS_Convert

GO

Grant Select on dbo.vwLEADS_ConvertNote to public;
GO

 
