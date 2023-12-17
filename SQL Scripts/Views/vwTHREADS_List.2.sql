if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTHREADS_List')
	Drop View dbo.vwTHREADS_List;
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
Create View dbo.vwTHREADS_List
as
select vwTHREADS.*
     , vwPOSTS.ID                     as LAST_POST_ID
     , vwPOSTS.TITLE                  as LAST_POST_TITLE
     , vwPOSTS.CREATED_BY_ID          as LAST_POST_CREATED_BY_ID
     , vwPOSTS.CREATED_BY             as LAST_POST_CREATED_BY
     , vwPOSTS.DATE_MODIFIED          as LAST_POST_DATE_MODIFIED
     , vwPOSTS.CREATED_BY_NAME        as LAST_POST_CREATED_BY_NAME
  from            vwTHREADS
  left outer join vwPOSTS
               on vwPOSTS.THREAD_ID = vwTHREADS.ID
              and vwPOSTS.ID        = dbo.fnPOSTS_Last(vwTHREADS.ID)

GO

Grant Select on dbo.vwTHREADS_List to public;
GO


