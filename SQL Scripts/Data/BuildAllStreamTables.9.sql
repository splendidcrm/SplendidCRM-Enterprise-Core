

print 'SqlBuildAllStreamTables';

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
-- 09/27/2015 Paul.  Don't create the audit tables on an Offline Client database. 
-- 06/04/2021 Paul.  Do not create the stream tables if they system has been disabled. 
if dbo.fnCONFIG_Boolean('enable_activity_streams') = 1 begin -- then
	if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SYSTEM_SYNC_CONFIG' and TABLE_TYPE = 'BASE TABLE') begin -- then
		exec dbo.spSqlBuildAllStreamTables ;
	end -- if;
end -- if;
GO

-- 10/10/2015 Paul.  Provide a way to disable streams.  When disabled, just remove the triggers and keep the data. 
if dbo.fnCONFIG_Boolean('enable_activity_streams') = 0 begin -- then
	print 'spSqlDropAllStreamTriggers';
	exec dbo.spSqlDropAllStreamTriggers ;
end -- if;
GO

-- exec dbo.spSqlBuildAllStreamTriggers ;
-- select name from sys.triggers where name like 'tr%_Ins_STREAM' order by name;


/* -- #if Oracle
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			StoO_selcnt := 0;
		WHEN OTHERS THEN
			RAISE;
	END;
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spSqlBuildAllStreamTables_Data()
/

call dbo.spSqlDropProcedure('spSqlBuildAllStreamTables_Data')
/

-- #endif IBM_DB2 */

