if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlTableDropColumnConstraint' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlTableDropColumnConstraint;
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
-- 09/15/2009 Paul.  Use alias to get working on Azure. 
-- Deprecated feature 'More than two-part column name' is not supported in this version of SQL Server.
-- 09/12/2010 Paul.  Add Oracle code to lookup the constraint name. 
Create Procedure dbo.spSqlTableDropColumnConstraint
	( @TABLE_NAME        varchar(255)
	, @COLUMN_NAME       varchar(255)
	)
as
  begin
	set nocount on
	
	declare @Command varchar(2000);
-- #if SQL_Server /*
	select @Command = 'alter table ' + objects.name + ' drop constraint ' + default_constraints.name + ';'
	  from      sys.default_constraints  default_constraints
	 inner join sys.objects              objects
	         on objects.object_id      = default_constraints.parent_object_id
	 inner join sys.columns              columns
	         on columns.object_id      = objects.object_id
	        and columns.column_id      = default_constraints.parent_column_id
	 where objects.type = 'U'
	   and default_constraints.type = 'D'
	   and objects.name = @TABLE_NAME
	   and columns.name = @COLUMN_NAME;
-- #endif SQL_Server */



	if @Command is not null begin -- then
		exec (@Command);
	end -- if;
  end
GO

Grant Execute on dbo.spSqlTableDropColumnConstraint to public;
GO

