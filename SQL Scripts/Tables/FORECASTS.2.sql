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
-- 05/01/2009 Paul.  Add fields from SugarCRM 4.5.1.
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FORECASTS' and COLUMN_NAME = 'COMMIT_VALUE') begin -- then
	print 'alter table FORECASTS drop column COMMIT_VALUE';
	alter table FORECASTS drop column COMMIT_VALUE;
end -- if;
GO


if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FORECASTS' and COLUMN_NAME = 'BEST_CASE') begin -- then
	print 'alter table FORECASTS add BEST_CASE int null';
	alter table FORECASTS add BEST_CASE int null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FORECASTS' and COLUMN_NAME = 'LIKELY_CASE') begin -- then
	print 'alter table FORECASTS add LIKELY_CASE int null';
	alter table FORECASTS add LIKELY_CASE int null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FORECASTS' and COLUMN_NAME = 'WORST_CASE') begin -- then
	print 'alter table FORECASTS add WORST_CASE int null';
	alter table FORECASTS add WORST_CASE int null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'FORECASTS' and COLUMN_NAME = 'USER_ID') begin -- then
	print 'alter table FORECASTS add USER_ID uniqueidentifier null';
	alter table FORECASTS add USER_ID uniqueidentifier null;
end -- if;
GO

