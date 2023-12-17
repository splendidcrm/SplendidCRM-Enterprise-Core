if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAIL_IMAGES')
	Drop View dbo.vwEMAIL_IMAGES;
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
-- 06/19/2010 Paul.  View was pointing to IMAGES table and not EMAIL_IMAGES table. 
-- 05/17/2017 Paul.  Need to optimize for Azure. CONTENT is null filter is not indexable, so index length field. 
Create View dbo.vwEMAIL_IMAGES
as
select ID
     , PARENT_ID
     , FILENAME
     , FILE_MIME_TYPE
     , DATE_ENTERED 
     , CONTENT_LENGTH  as FILE_SIZE
  from EMAIL_IMAGES
 where DELETED = 0

GO

Grant Select on dbo.vwEMAIL_IMAGES to public;
GO

