if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwKBTAGS')
	Drop View dbo.vwKBTAGS;
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
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
Create View dbo.vwKBTAGS
as
select KBTAGS.ID
     , KBTAGS.TAG_NAME       as NAME
     , KBTAGS.TAG_NAME
     , KBTAGS.FULL_TAG_NAME
     , KBTAGS.DATE_ENTERED
     , KBTAGS.DATE_MODIFIED
     , KBTAGS.DATE_MODIFIED_UTC
     , KBTAGS.PARENT_TAG_ID
     , PARENT.TAG_NAME       as PARENT_TAG_NAME
     , PARENT.FULL_TAG_NAME  as PARENT_FULL_TAG_NAME
  from            KBTAGS
  left outer join KBTAGS           PARENT
               on PARENT.ID      = KBTAGS.PARENT_TAG_ID
              and PARENT.DELETED = 0
 where KBTAGS.DELETED = 0

GO

Grant Select on dbo.vwKBTAGS to public;
GO

 
