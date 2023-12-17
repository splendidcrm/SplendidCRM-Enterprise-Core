if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILS_Edit')
	Drop View dbo.vwEMAILS_Edit;
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
-- 04/17/2006 Paul.  Return DESCRIPTION_HTML.  This is the primary field now that we have and HTML editor. 
-- 11/08/2008 Paul.  Move description to base view. 
-- 06/05/2014 Paul.  Move _IDS and _EMAILS to base view so that they can be accessed via REST API. 
Create View dbo.vwEMAILS_Edit
as
select vwEMAILS.*
     , EMAILS.TO_ADDRS
     , EMAILS.CC_ADDRS
     , EMAILS.BCC_ADDRS
     , EMAILS.TO_ADDRS_NAMES
     , EMAILS.CC_ADDRS_NAMES
     , EMAILS.BCC_ADDRS_NAMES
  from            vwEMAILS
  left outer join EMAILS
               on EMAILS.ID = vwEMAILS.ID

GO

Grant Select on dbo.vwEMAILS_Edit to public;
GO

 
