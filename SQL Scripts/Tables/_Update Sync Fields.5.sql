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

-- 05/11/2014 Paul.  Disabling triggers is not working. We are still getting events from the audit tables. Instead, remove all CRM triggers. 
if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSqlTables') begin -- then
	exec dbo.spSqlDropAllAuditTriggers;
end -- if;
GO

-- 11/16/2009 Paul.  The DATE_MODIFIED_UTC field must be created before the views are created. 
exec dbo.spSqlUpdateSyncdTables;

-- 04/27/2014 Paul.  We do not need to add the triggers here.  They will be added after the procedures. 
GO


