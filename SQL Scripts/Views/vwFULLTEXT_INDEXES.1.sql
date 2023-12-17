if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwFULLTEXT_INDEXES')
	Drop View dbo.vwFULLTEXT_INDEXES;
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
-- https://msdn.microsoft.com/en-us/library/ms190370(v=sql.90).aspx
Create View dbo.vwFULLTEXT_INDEXES
as
select object_name(fulltext_indexes.object_id) as TABLE_NAME
  from      sys.fulltext_indexes                    fulltext_indexes
 inner join sys.fulltext_catalogs                   fulltext_catalogs
         on fulltext_catalogs.fulltext_catalog_id = fulltext_indexes.fulltext_catalog_id
 where fulltext_catalogs.name = db_name() + 'Catalog'
GO

Grant Select on dbo.vwFULLTEXT_INDEXES to public;
GO

-- select * from vwFULLTEXT_INDEXES

