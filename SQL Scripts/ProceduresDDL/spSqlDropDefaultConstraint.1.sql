if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlDropDefaultConstraint' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlDropDefaultConstraint;
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
Create Procedure dbo.spSqlDropDefaultConstraint(@TABLE_NAME nvarchar(50) out, @COLUMN_NAME nvarchar(50))
as
  begin
	set nocount on

	declare @COMMAND varchar(1000);
	select @COMMAND = 'alter table ' + sys.tables.name + ' drop constraint ' + sys.default_constraints.name
	  from      sys.all_columns
	 inner join sys.tables
	         on sys.tables.object_id              = sys.all_columns.object_id
	 inner join sys.default_constraints
	         on sys.default_constraints.object_id = sys.all_columns.default_object_id
	 where sys.tables.name      = @TABLE_NAME
	   and sys.all_columns.name = @COLUMN_NAME;

	if @COMMAND is not null begin -- then
		print @COMMAND;
		exec(@COMMAND);
	end -- if;
  end
GO


Grant Execute on dbo.spSqlDropDefaultConstraint to public;
GO

