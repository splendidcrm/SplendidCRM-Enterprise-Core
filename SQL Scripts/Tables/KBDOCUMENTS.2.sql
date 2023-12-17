
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
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'KBDOCUMENTS' and COLUMN_NAME = 'KBTAG_SET_LIST') begin -- then
	print 'alter table KBDOCUMENTS add KBTAG_SET_LIST nvarchar(max) null';
	alter table KBDOCUMENTS add KBTAG_SET_LIST nvarchar(max) null;
end -- if;
GO

-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'KBDOCUMENTS' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
	print 'alter table KBDOCUMENTS add ASSIGNED_SET_ID uniqueidentifier null';
	alter table KBDOCUMENTS add ASSIGNED_SET_ID uniqueidentifier null;

	create index IDX_KBDOCUMENTS_ASSIGNED_SET_ID on dbo.KBDOCUMENTS (ASSIGNED_SET_ID, DELETED, ID)
end -- if;
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'KBDOCUMENTS_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'KBDOCUMENTS_AUDIT' and COLUMN_NAME = 'ASSIGNED_SET_ID') begin -- then
		print 'alter table KBDOCUMENTS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null';
		alter table KBDOCUMENTS_AUDIT add ASSIGNED_SET_ID uniqueidentifier null;
	end -- if;
end -- if;
GO

