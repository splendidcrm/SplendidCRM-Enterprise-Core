
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
-- 09/02/2009 Paul.  Add support for dynamic teams. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TEAM_NOTICES' and COLUMN_NAME = 'TEAM_SET_ID') begin -- then
	print 'alter table TEAM_NOTICES add TEAM_SET_ID uniqueidentifier null';
	alter table TEAM_NOTICES add TEAM_SET_ID uniqueidentifier null;

	-- 09/02/2009 Paul.  Add indexes for team filtering.
	create index IDX_TEAM_NOTICES_TEAM_ID     on dbo.TEAM_NOTICES (TEAM_ID    , DELETED, DATE_START, DATE_END)
	create index IDX_TEAM_NOTICES_TEAM_SET_ID on dbo.TEAM_NOTICES (TEAM_SET_ID, DELETED, DATE_START, DATE_END)
end -- if;
GO

-- 09/02/2009 Paul.  Add UTC date so that this module can be sync'd. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TEAM_NOTICES' and COLUMN_NAME = 'DATE_MODIFIED_UTC') begin -- then
	print 'alter table TEAM_NOTICES add DATE_MODIFIED_UTC datetime null default(getutcdate())';
	alter table TEAM_NOTICES add DATE_MODIFIED_UTC datetime null default(getutcdate());
end -- if;
GO

