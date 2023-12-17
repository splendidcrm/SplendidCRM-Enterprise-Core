if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_ArchiveBuildByName' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_ArchiveBuildByName;
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
Create Procedure dbo.spMODULES_ArchiveBuildByName
	( @MODIFIED_USER_ID  uniqueidentifier
	, @MODULE_NAME       nvarchar(25)
	)
as
  begin
	set nocount on

	declare @ID uniqueidentifier;
	select @ID = ID
	  from MODULES
	 where MODULE_NAME = @MODULE_NAME
	   and DELETED     = 0;
	if @ID is not null begin -- then
		exec dbo.spMODULES_ArchiveBuild @ID, @MODIFIED_USER_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spMODULES_ArchiveBuildByName to public;
GO

/*
-- 12/14/2017 Paul.  Took 4 minutes. 
begin try
	begin tran;
	--exec dbo.spSqlDropAllArchiveTables;
	exec dbo.spMODULES_ArchiveBuildByName null, 'Accounts';
	commit tran;
end try
begin catch
	rollback tran;
	print ERROR_MESSAGE();
end catch
*/

