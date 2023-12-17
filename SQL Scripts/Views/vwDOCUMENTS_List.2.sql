if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDOCUMENTS_List')
	Drop View dbo.vwDOCUMENTS_List;
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
-- 05/02/2006 Paul.  DB2 is particular about how * is used.  
-- 10/20/2010 Paul.  All modules should have a NAME field, so it was moved to the base view. 
-- 10/19/2016 Paul.  Include DOCUMENT_REVISIONS.CONTENT so that we can use Full-Text Search. 
-- 10/19/2016 Paul.  Instead of joining to actual table, just create placeholder for the layout manager. 
-- This is because the full-text query needs to be a sub-query or a schemabound indexed view. 
Create View dbo.vwDOCUMENTS_List
as
select vwDOCUMENTS.*
     , cast(null as varbinary(max)) as CONTENT
  from vwDOCUMENTS

GO

Grant Select on dbo.vwDOCUMENTS_List to public;
GO

 
