
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_RUN' and COLUMN_NAME = 'WORKFLOW_INSTANCE_ID') begin -- then
	print 'alter table WORKFLOW_RUN add WORKFLOW_INSTANCE_ID uniqueidentifier null';
	alter table WORKFLOW_RUN add WORKFLOW_INSTANCE_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_RUN' and COLUMN_NAME = 'DESCRIPTION') begin -- then
	print 'alter table WORKFLOW_RUN add DESCRIPTION nvarchar(max) null';
	alter table WORKFLOW_RUN add DESCRIPTION nvarchar(max) null;
end -- if;
GO

if not exists (select * from sys.indexes where name = 'IDX_WORKFLOW_RUN_AUDIT_ID') begin -- then
	-- drop index WORKFLOW_RUN.IDX_WORKFLOW_RUN_AUDIT_ID;
	print 'create index IDX_WORKFLOW_RUN_AUDIT_ID';
	create index IDX_WORKFLOW_RUN_AUDIT_ID on dbo.WORKFLOW_RUN (WORKFLOW_ID, AUDIT_ID, DATE_ENTERED);
end -- if;
GO

