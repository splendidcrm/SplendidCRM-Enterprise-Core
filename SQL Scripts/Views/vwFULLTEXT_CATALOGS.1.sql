if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwFULLTEXT_CATALOGS')
	Drop View dbo.vwFULLTEXT_CATALOGS;
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
Create View dbo.vwFULLTEXT_CATALOGS
as
select FullTextCatalogProperty(name,'ItemCount'            ) as ITEM_COUNT
     , FullTextCatalogProperty(name,'MergeStatus'          ) as MERGE_STATUS
     , FullTextCatalogProperty(name,'PopulateCompletionAge') as POPULATE_COMPLETION_AGE
     , (case FullTextCatalogProperty(name,'PopulateStatus')
        when 0 then 'Idle'
        when 1 then 'Full population in progress'
        when 2 then 'Paused'
        when 3 then 'Throttled'
        when 4 then 'Recovering'
        when 5 then 'Shutdown'
        when 6 then 'Incremental population in progress'
        when 7 then 'Building index'
        when 8 then 'Disk is full. Paused.'
        when 9 then 'Change tracking'
        else cast(FullTextCatalogProperty(name,'PopulateStatus') as varchar(4))
        end) as POPULATE_STATUS
     , FullTextCatalogProperty(name,'ImportStatus'         ) as IMPORT_STATUS
     , FullTextCatalogProperty(name,'IndexSize'            ) as INDEX_SIZE
     , FullTextCatalogProperty(name,'UniqueKeyCount'       ) as UNIQUE_KEY_COUNT
     , dateadd(ss, FullTextCatalogProperty(name, 'PopulateCompletionAge'), '1/1/1990') as LAST_POPULATION_DATE
  from sys.fulltext_catalogs
 where name = db_name() + 'Catalog'
GO

Grant Select on dbo.vwFULLTEXT_CATALOGS to public;
GO

-- select * from vwFULLTEXT_CATALOGS

