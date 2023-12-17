if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlBackupDatabase' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlBackupDatabase;
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
-- 02/09/2008 Paul.  Remove the SplendidCRM folder in the backup path.  
-- It is not automatically created and we don't want to create it manually at this time. 
-- 02/25/2008 Paul.  Increase size of DBNAME. 
-- 02/21/2017 Paul.  Allow both parameters to be optional. 
Create Procedure dbo.spSqlBackupDatabase
	( @FILENAME nvarchar(255) = null out
	, @TYPE nvarchar(20) = null
	)
as
  begin
	set nocount on

	-- 12/31/2007 Paul.  The backup is place relative to the default backup directory. 
	declare @TIMESTAMP varchar(30);
	-- 02/25/2008 Paul.  The database name can be large.
	declare @DBNAME    varchar(200);
	declare @NOW       datetime;
	set @NOW    = getdate();
	set @DBNAME = db_name();
	set @TYPE   = upper(@TYPE);
	set @TIMESTAMP = convert(varchar(30), @NOW, 112) + convert(varchar(30), @NOW, 108);
	set @TIMESTAMP = substring(replace(@TIMESTAMP, ':', ''), 1, 12);
	-- 02/21/2017 Paul.  Allow both parameters to be optional. 
	if @TYPE = 'FULL' or @TYPE is null begin -- then
		if @FILENAME is null or @FILENAME = '' begin -- then
			set @FILENAME = @DBNAME + '_db_' + @TIMESTAMP + '.bak';
		end -- if;
		backup database @DBNAME to disk = @FILENAME;
	end else if @TYPE = 'LOG' begin -- then
		if @FILENAME is null or @FILENAME = '' begin -- then
			set @FILENAME = @DBNAME + '_tlog_' + @TIMESTAMP + '.trn';
		end -- if;
		backup log @DBNAME to disk = @FILENAME;
	end else begin
		raiserror(N'Unknown backup type', 16, 1);
	end -- if;
  end
GO


Grant Execute on dbo.spSqlBackupDatabase to public;
GO

-- exec spSqlBackupDatabase null, 'FULL';
-- exec spSqlBackupDatabase null, 'LOG';

