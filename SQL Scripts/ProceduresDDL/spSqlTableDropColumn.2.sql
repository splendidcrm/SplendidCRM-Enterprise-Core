if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlTableDropColumn' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlTableDropColumn;
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
Create Procedure dbo.spSqlTableDropColumn
	( @TABLE_NAME        varchar(255)
	, @COLUMN_NAME       varchar(255)
	)
as
  begin
	set nocount on

	declare @Command   varchar(2000);
	declare @OldColumn varchar(100);
	declare @NewColumn varchar(100);

	exec dbo.spSqlTableDropColumnConstraint @TABLE_NAME, @COLUMN_NAME;

	set @Command = 'alter table ' + @TABLE_NAME + ' drop column ' + @COLUMN_NAME;
	exec (@Command);

	-- 07/15/2009 Jamie.  When dropping a column, we also need to drop it from the audit table. 
	-- However, since we want to retain the audit, just rename the filed and include the drop date. 
	if exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TABLE_NAME + '_AUDIT' and COLUMN_NAME = @COLUMN_NAME) begin -- then
-- #if SQL_Server /*
		set @OldColumn = @TABLE_NAME + '_AUDIT' + '.' + @COLUMN_NAME;
		set @NewColumn = upper(@COLUMN_NAME) + '_' + convert(varchar(8), getdate(), 112) + '_' + replace(convert(varchar(8), getdate(), 108), ':', '');
		exec sp_rename @OldColumn, @NewColumn, 'COLUMN';
-- #endif SQL_Server */
	end -- if;
  end
GO

Grant Execute on dbo.spSqlTableDropColumn to public;
GO


