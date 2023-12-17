if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spROLES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spROLES_Update;
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
Create Procedure dbo.spROLES_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(150)
	, @DESCRIPTION       nvarchar(max)
	, @ALLOW_LIST        varchar(8000)
	, @DENY_LIST         varchar(8000)
	)
as
  begin
	set nocount on
	
	declare @MODULE         varchar(30);
	declare @CurrentPosR    int;
	declare @NextPosR       int;
	declare @ROLE_MODULE_ID uniqueidentifier;

	if @NAME is null or @NAME = N'' begin -- then
		raiserror(N'Name is required', 16, 1);
	end else begin
			if not exists(select * from ROLES where ID = @ID) begin -- then
			if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
				set @ID = newid();
			end -- if;
			insert into ROLES
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, NAME             
				, DESCRIPTION      
				)
			values
				( @ID               
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @NAME             
				, @DESCRIPTION      
				);
		end else begin
			update ROLES
			   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
			     , DATE_MODIFIED     =  getdate()        
			     , DATE_MODIFIED_UTC =  getutcdate()     
			     , NAME              = @NAME             
			     , DESCRIPTION       = @DESCRIPTION      
			 where ID                = @ID               ;
		end -- if;

		if not exists(select * from ROLES_CSTM where ID_C = @ID) begin -- then
			insert into ROLES_CSTM ( ID_C ) values ( @ID );
		end -- if;

		if @@ERROR = 0 begin -- then
			set @CurrentPosR = 1;
			while @CurrentPosR <= len(@ALLOW_LIST) begin -- do
				-- 10/04/2006 Paul.  charindex should not use unicode parameters as it will limit all inputs to 4000 characters. 
				set @NextPosR = charindex(',', @ALLOW_LIST,  @CurrentPosR);
				if @NextPosR = 0 or @NextPosR is null begin -- then
					set @NextPosR = len(@ALLOW_LIST) + 1;
				end -- if;
				set @MODULE = rtrim(ltrim(substring(@ALLOW_LIST, @CurrentPosR, @NextPosR - @CurrentPosR)));
				set @CurrentPosR = @NextPosR+1;
				exec dbo.spROLES_MODULES_Update @ROLE_MODULE_ID out, @MODIFIED_USER_ID, @ID, @MODULE, 1;
			end -- while;
		
			set @CurrentPosR = 1;
			while @CurrentPosR <= len(@DENY_LIST) begin -- do
				-- 10/04/2006 Paul.  charindex should not use unicode parameters as it will limit all inputs to 4000 characters. 
				set @NextPosR = charindex(',', @DENY_LIST,  @CurrentPosR);
				if @NextPosR = 0 or @NextPosR is null begin -- then
					set @NextPosR = len(@DENY_LIST) + 1;
				end -- if;
				set @MODULE = rtrim(ltrim(substring(@DENY_LIST, @CurrentPosR, @NextPosR - @CurrentPosR)));
				set @CurrentPosR = @NextPosR+1;
				exec dbo.spROLES_MODULES_Update @ROLE_MODULE_ID out, @MODIFIED_USER_ID, @ID, @MODULE, 0;
			end -- while;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spROLES_Update to public;
GO

