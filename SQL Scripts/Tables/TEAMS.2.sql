
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
-- 04/12/2016 Paul.  Add parent team and custom fields. 
-- 04/28/2016 Paul.  Rename parent to PARENT_ID. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TEAMS' and COLUMN_NAME = 'PARENT_TEAM_ID') begin -- then
	print 'alter table TEAMS add PARENT_TEAM_ID uniqueidentifier null';
	print 'rename TEAMS.PARENT_TEAM_ID to TEAMS.PARENT_ID';
	exec sp_rename 'TEAMS.PARENT_TEAM_ID', 'PARENT_ID', 'COLUMN';
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TEAMS' and COLUMN_NAME = 'PARENT_ID') begin -- then
	print 'alter table TEAMS add PARENT_ID uniqueidentifier null';
	alter table TEAMS add PARENT_ID uniqueidentifier null;
end -- if;
GO

