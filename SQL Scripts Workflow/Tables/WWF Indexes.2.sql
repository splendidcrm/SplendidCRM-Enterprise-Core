
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
-- 06/21/2017 Paul.  Index DATE_ENTERED for Cleanup. 
if not exists (select * from sys.indexes where name = 'IDX_WWF_TYPES_DATE') begin -- then
	create index IDX_WWF_TYPES_DATE on dbo.WWF_TYPES (DATE_ENTERED);
end -- if;
GO

if not exists (select * from sys.indexes where name = 'IDX_WWF_DEFINITIONS_DATE') begin -- then
	create index IDX_WWF_DEFINITIONS_DATE on dbo.WWF_DEFINITIONS (DATE_ENTERED);
end -- if;
GO

if not exists (select * from sys.indexes where name = 'IDX_WWF_INSTANCE_EVENTS_DATE') begin -- then
	create index IDX_WWF_INSTANCE_EVENTS_DATE on dbo.WWF_INSTANCE_EVENTS (DATE_ENTERED);
end -- if;
GO

if not exists (select * from sys.indexes where name = 'IDX_WWF_ACTIVITIES_DATE') begin -- then
	create index IDX_WWF_ACTIVITIES_DATE on dbo.WWF_ACTIVITIES (DATE_ENTERED);
end -- if;
GO

if not exists (select * from sys.indexes where name = 'IDX_WWF_ACTIVITY_INST_DATE') begin -- then
	create index IDX_WWF_ACTIVITY_INST_DATE on dbo.WWF_ACTIVITY_INSTANCES (DATE_ENTERED);
end -- if;
GO

if not exists (select * from sys.indexes where name = 'IDX_WWF_ACTIVITY_STATUS_DATE') begin -- then
	create index IDX_WWF_ACTIVITY_STATUS_DATE on dbo.WWF_ACTIVITY_STATUS_EVENTS (DATE_ENTERED);
end -- if;
GO

