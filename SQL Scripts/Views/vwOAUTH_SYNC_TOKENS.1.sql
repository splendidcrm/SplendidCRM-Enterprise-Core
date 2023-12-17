if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwOAUTH_SYNC_TOKENS')
	Drop View dbo.vwOAUTH_SYNC_TOKENS;
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
-- 09/14/2015 Paul.  The Sync Token is used by Google Apps Calendar as a more efficient method than UpdatedMin. 
Create View dbo.vwOAUTH_SYNC_TOKENS
as
select ID
     , NAME
     , ASSIGNED_USER_ID
     , SYNC_TOKEN           
     , TOKEN_EXPIRES_AT
  from OAUTH_SYNC_TOKENS
 where DELETED = 0

GO

Grant Select on dbo.vwOAUTH_SYNC_TOKENS to public;
GO

