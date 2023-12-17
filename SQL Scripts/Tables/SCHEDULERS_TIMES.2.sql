
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
-- 04/21/2008 Paul.  SugarCRM uses the field name SCHEDULER_ID and we use SCHEDULE_ID. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SCHEDULERS_TIMES' and COLUMN_NAME = 'SCHEDULE_ID') begin -- then
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SCHEDULERS_TIMES' and COLUMN_NAME = 'SCHEDULER_ID') begin -- then
		print 'alter table SCHEDULERS_TIMES rename SCHEDULER_ID to SCHEDULE_ID';
		exec sp_rename 'SCHEDULERS_TIMES.SCHEDULER_ID', 'SCHEDULE_ID', 'COLUMN';
	end -- if;
end -- if;
GO

