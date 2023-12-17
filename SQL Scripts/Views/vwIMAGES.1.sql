if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwIMAGES')
	Drop View dbo.vwIMAGES;
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
-- 11/23/2010 Paul.  Every module should have a NAME field. 
-- 05/27/2016 Paul.  REST API requires DATE_MODIFIED_UTC. 
Create View dbo.vwIMAGES
as
select IMAGES.ID
     , IMAGES.PARENT_ID
     , IMAGES.FILENAME
     , IMAGES.FILENAME                  as NAME
     , IMAGES.FILE_MIME_TYPE
     , IMAGES.DATE_ENTERED 
     , IMAGES.DATE_MODIFIED_UTC
     , USERS_CREATED_BY.USER_NAME       as CREATED_BY
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
  from            IMAGES
  left outer join USERS USERS_CREATED_BY
               on USERS_CREATED_BY.ID = IMAGES.CREATED_BY
 where IMAGES.DELETED = 0

GO

Grant Select on dbo.vwIMAGES to public;
GO

