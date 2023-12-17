if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwNOTES_List')
	Drop View dbo.vwNOTES_List;
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
-- 10/19/2016 Paul.  Include NOTE_ATTACHMENTS.ATTACHMENT so that we can use Full-Text Search. 
-- 10/19/2016 Paul.  Instead of joining to actual table, just create placeholder for the layout manager. 
-- This is because the full-text query needs to be a sub-query or a schemabound indexed view. 
Create View dbo.vwNOTES_List
as
select vwNOTES.*
     , cast(null as varbinary(max)) as ATTACHMENT
  from vwNOTES

GO

Grant Select on dbo.vwNOTES_List to public;
GO


