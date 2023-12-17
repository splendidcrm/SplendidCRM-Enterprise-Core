if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnSqlIndexColumns' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnSqlIndexColumns;
GO


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
-- 09/06/2010 Paul.  Help with migration with EffiProz. 
Create Function dbo.fnSqlIndexColumns(@TABLE_NAME sysname, @object_id int, @index_id tinyint)
returns varchar(4000)
as 
  begin
	declare @colnames    varchar(4000);
	declare @thisColID   int;
	declare @thisColName sysname;
	
	set @colnames = index_col(@table_name, @index_id, 1) + (case indexkey_property(@object_id, @index_id, 1, 'IsDescending') when 1 then ' DESC' else '' end);
	set @thisColID   = 2;
	set @thisColName = index_col(@table_name, @index_id, @thisColID) + (case indexkey_property(@object_id, @index_id, @thisColID, 'IsDescending') when 1 then ' DESC' else '' end);

	while @thisColName is not null begin -- do
		set @thisColID   = @thisColID + 1;
		set @colnames    = @colnames + ', ' + @thisColName;
		set @thisColName = index_col(@table_name, @index_id, @thisColID) + (case indexkey_property(@object_id, @index_id, @thisColID, 'IsDescending') when 1 then ' DESC' else '' end);
	end -- while;
	return upper(@colNames);
  end
GO

Grant Execute on dbo.fnSqlIndexColumns to public
GO

