
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
-- 04/21/2008 Paul.  SugarCRM uses the field name CONTENTS and we use CONTENT. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'USER_PREFERENCES' and COLUMN_NAME = 'CONTENT') begin -- then
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'USER_PREFERENCES' and COLUMN_NAME = 'CONTENTS') begin -- then
		print 'alter table USER_PREFERENCES rename CONTENTS to CONTENT';
		exec sp_rename 'USER_PREFERENCES.CONTENTS', 'CONTENT', 'COLUMN';
	end -- if;
end -- if;
GO

-- 11/17/2009 Paul.  We have added DATE_MODIFIED_UTC to tables that are sync'd. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'USER_PREFERENCES' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table USER_PREFERENCES add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table USER_PREFERENCES add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO

