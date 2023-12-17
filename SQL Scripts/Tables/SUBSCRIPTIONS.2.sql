
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
-- 10/09/2015 Paul.  A SugarCRM will not have the ASSIGNED_USER_ID field, so add it. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'SUBSCRIPTIONS' and COLUMN_NAME = 'ASSIGNED_USER_ID') begin -- then
	print 'alter table SUBSCRIPTIONS add ASSIGNED_USER_ID uniqueidentifier null';
	alter table SUBSCRIPTIONS add ASSIGNED_USER_ID uniqueidentifier null;
	update SUBSCRIPTIONS
	   set ASSIGNED_USER_ID = CREATED_BY;

	create index IDX_SUBSCRIPTIONS_USER_RECORD on dbo.SUBSCRIPTIONS (ASSIGNED_USER_ID, DELETED, PARENT_ID  )
	create index IDX_SUBSCRIPTIONS_USER_MODULE on dbo.SUBSCRIPTIONS (ASSIGNED_USER_ID, DELETED, PARENT_TYPE)
end -- if;
GO

