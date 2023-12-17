
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
-- 09/01/2010 Paul.  Store a copy of the DEFAULT_SEARCH_ID in the table so that we don't need to read the XML in order to get the value. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SAVED_SEARCH' and COLUMN_NAME = 'DEFAULT_SEARCH_ID') begin -- then
	print 'alter table SAVED_SEARCH add DEFAULT_SEARCH_ID uniqueidentifier null';
	alter table SAVED_SEARCH add DEFAULT_SEARCH_ID uniqueidentifier null;
end -- if;
GO

-- 09/01/2010 Paul.  We also need a separate module-only field so that the query will get all records for the module. 
/*
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SAVED_SEARCH' and COLUMN_NAME = 'MODULE') begin -- then
	print 'alter table SAVED_SEARCH add MODULE nvarchar(50) null';
	alter table SAVED_SEARCH add MODULE nvarchar(50) null;
	exec('update SAVED_SEARCH set MODULE = SEARCH_MODULE where MODULE is null and SEARCH_MODULE not like ''%.%''');
	exec('update SAVED_SEARCH set MODULE = substring(SEARCH_MODULE, 1, charindex(''.'', SEARCH_MODULE, 1) - 1) where MODULE is null and SEARCH_MODULE like ''%.%''');
	
	-- 09/01/2010 Paul.  The index has changed from including SEARCH_MODULE to including MODULE. 
	-- exec dbo.spSqlUpdateIndex 'IDX_SAVED_SEARCH', 'SAVED_SEARCH', 'ASSIGNED_USER_ID', 'MODULE', 'DELETED', 'ID';
end -- if;
*/

-- 09/02/1010 Paul.  Adding the default search caused lots of problems, so we are going to ignore the fields for now. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SAVED_SEARCH' and COLUMN_NAME = 'MODULE') begin -- then
	print 'alter table SAVED_SEARCH drop column MODULE';
	exec dbo.spSqlUpdateIndex 'IDX_SAVED_SEARCH', 'SAVED_SEARCH', 'ASSIGNED_USER_ID', 'SEARCH_MODULE', 'NAME', 'DELETED', 'ID';

	alter table SAVED_SEARCH drop column MODULE;
end -- if;
GO

