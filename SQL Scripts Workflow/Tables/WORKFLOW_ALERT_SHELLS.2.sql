
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
-- 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ALERT_SHELLS' and COLUMN_NAME = 'ASSIGNED_USER_ID') begin -- then
	print 'alter table WORKFLOW_ALERT_SHELLS alter column ASSIGNED_USER_ID uniqueidentifier null';
	alter table WORKFLOW_ALERT_SHELLS add ASSIGNED_USER_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ALERT_SHELLS' and COLUMN_NAME = 'TEAM_ID') begin -- then
	print 'alter table WORKFLOW_ALERT_SHELLS alter column TEAM_ID uniqueidentifier null';
	alter table WORKFLOW_ALERT_SHELLS add TEAM_ID uniqueidentifier null;
end -- if;
GO

if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_ALERT_SHELLS' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table WORKFLOW_ALERT_SHELLS alter column TEAM_SET_ID uniqueidentifier null';
	alter table WORKFLOW_ALERT_SHELLS add TEAM_SET_ID uniqueidentifier null;
end -- if;
GO

