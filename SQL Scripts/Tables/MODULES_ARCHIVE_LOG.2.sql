
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
-- 02/17/2018 Paul.  Add ARCHIVE_RULE_ID. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'MODULES_ARCHIVE_LOG' and COLUMN_NAME = 'ARCHIVE_RULE_ID') begin -- then
	print 'alter table MODULES_ARCHIVE_LOG add ARCHIVE_RULE_ID uniqueidentifier null';
	alter table MODULES_ARCHIVE_LOG add ARCHIVE_RULE_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'MODULES_ARCHIVE_LOG' and COLUMN_NAME = 'ARCHIVE_RECORD_ID') begin -- then
	print 'alter table MODULES_ARCHIVE_LOG add ARCHIVE_RECORD_ID uniqueidentifier null';
	alter table MODULES_ARCHIVE_LOG add ARCHIVE_RECORD_ID uniqueidentifier null;

	-- drop index MODULES_ARCHIVE_LOG.IDX_MODULES_ARCHIVE_LOG_ACTION
	create index IDX_MODULES_ARCHIVE_LOG_ACTION on dbo.MODULES_ARCHIVE_LOG (ARCHIVE_ACTION, MODULE_NAME);
end -- if;
GO

