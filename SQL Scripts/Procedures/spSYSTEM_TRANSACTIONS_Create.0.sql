if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSYSTEM_TRANSACTIONS_Create' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSYSTEM_TRANSACTIONS_Create;
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
-- 10/07/2009 Paul.  The goal will be to use the SQL Server 2008 MERGE statement. 
-- http://weblogs.sqlteam.com/mladenp/archive/2007/08/03/60277.aspx
-- 10/07/2009 Paul.  On SQL Server 2005 and 2008, this function should do nothing. 
-- 05/11/2013 Paul.  Dynamically create the procedure so that the same code would work on SQL Server and SQL Azure. 
declare @Command varchar(max);
if charindex('Microsoft SQL Azure', @@VERSION) > 0 begin -- then
	set @Command = 'Create Procedure dbo.spSYSTEM_TRANSACTIONS_Create
	( @ID               uniqueidentifier output
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on

	declare @TEMP_SESSION_SPID     int;
	declare @TEMP_MODIFIED_USER_ID uniqueidentifier;

	set @TEMP_SESSION_SPID     = @@SPID;
	set @TEMP_MODIFIED_USER_ID = @MODIFIED_USER_ID;
	if @ID is null begin -- then
		set @ID = newid();
	end -- if;
	if @TEMP_MODIFIED_USER_ID is null begin -- then
		set @TEMP_MODIFIED_USER_ID = ''00000000-0000-0000-0000-000000000000'';
	end -- if;

	merge dbo.SYSTEM_TRANSACTIONS as TARGET
	using (select @ID
	            , @TEMP_MODIFIED_USER_ID
	            , getdate()
	            , @TEMP_SESSION_SPID
	            )
	   as SOURCE( ID
	            , MODIFIED_USER_ID
	            , DATE_MODIFIED
	            , SESSION_SPID
	            )
	   on (TARGET.SESSION_SPID = SOURCE.SESSION_SPID)
	 when matched then
		update set TARGET.ID               = SOURCE.ID              
		         , TARGET.MODIFIED_USER_ID = SOURCE.MODIFIED_USER_ID
		         , TARGET.DATE_MODIFIED    = SOURCE.DATE_MODIFIED   
	 when not matched then
		insert
			( ID              
			, MODIFIED_USER_ID
			, DATE_MODIFIED   
			, SESSION_SPID    
			)
		values
			( SOURCE.ID              
			, SOURCE.MODIFIED_USER_ID
			, SOURCE.DATE_MODIFIED   
			, SOURCE.SESSION_SPID    
			);
  end
';
	exec(@Command);
end else begin
	set @Command = 'Create Procedure dbo.spSYSTEM_TRANSACTIONS_Create
	( @ID               uniqueidentifier output
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on

  end
';
	exec(@Command);
end -- if;
GO

Grant Execute on dbo.spSYSTEM_TRANSACTIONS_Create to public;
GO

