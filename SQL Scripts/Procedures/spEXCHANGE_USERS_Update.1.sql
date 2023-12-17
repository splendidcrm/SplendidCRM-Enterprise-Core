if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEXCHANGE_USERS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEXCHANGE_USERS_Update;
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
Create Procedure dbo.spEXCHANGE_USERS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @EXCHANGE_ALIAS    nvarchar(60)
	, @EXCHANGE_EMAIL    nvarchar(100)
	, @IMPERSONATED_TYPE nvarchar(25)
	, @ASSIGNED_USER_ID  uniqueidentifier
	)
as
  begin
	set nocount on

	declare @EXCHANGE_ID uniqueidentifier;
	declare @TEMP_ASSIGNED_USER_ID uniqueidentifier;
	
	set @TEMP_ASSIGNED_USER_ID = @ASSIGNED_USER_ID;
	if @IMPERSONATED_TYPE = 'SmtpAddress' begin -- then
		-- BEGIN Oracle Exception
			select @EXCHANGE_ID = ID
			  from EXCHANGE_USERS
			 where EXCHANGE_EMAIL = @EXCHANGE_EMAIL
			   and DELETED        = 0;
		-- END Oracle Exception
		if dbo.fnIsEmptyGuid(@TEMP_ASSIGNED_USER_ID) = 1 begin -- then
			-- BEGIN Oracle Exception
				select @TEMP_ASSIGNED_USER_ID = ID
				  from vwUSERS
				 where EMAIL1 = @EXCHANGE_EMAIL;
			-- END Oracle Exception
		end -- if;
	end else begin
		-- BEGIN Oracle Exception
			select @EXCHANGE_ID = ID
			  from EXCHANGE_USERS
			 where EXCHANGE_ALIAS = @EXCHANGE_ALIAS
			   and DELETED        = 0;
		-- END Oracle Exception
		if dbo.fnIsEmptyGuid(@TEMP_ASSIGNED_USER_ID) = 1 begin -- then
			-- BEGIN Oracle Exception
				select @TEMP_ASSIGNED_USER_ID = ID
				  from vwUSERS
				 where USER_NAME = @EXCHANGE_ALIAS;
			-- END Oracle Exception
		end -- if;
	end -- if;
	
	if dbo.fnIsEmptyGuid(@TEMP_ASSIGNED_USER_ID) = 0 begin -- then
		if dbo.fnIsEmptyGuid(@EXCHANGE_ID) = 1 begin -- then
			if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
				set @ID = newid();
			end else begin
				-- BEGIN Oracle Exception
					select @EXCHANGE_ID = ID
					  from EXCHANGE_USERS
					 where ID           = @ID
					   and DELETED      = 0;
				-- END Oracle Exception
			end -- if;
			if dbo.fnIsEmptyGuid(@EXCHANGE_ID) = 1 begin -- then
				insert into EXCHANGE_USERS
					( ID               
					, CREATED_BY       
					, DATE_ENTERED     
					, MODIFIED_USER_ID 
					, DATE_MODIFIED    
					, ASSIGNED_USER_ID 
					, EXCHANGE_ALIAS   
					, EXCHANGE_EMAIL   
					)
				values
					( @ID               
					, @MODIFIED_USER_ID 
					,  getdate()        
					, @MODIFIED_USER_ID 
					,  getdate()        
					, @TEMP_ASSIGNED_USER_ID 
					, @EXCHANGE_ALIAS   
					, @EXCHANGE_EMAIL   
					);
			end else begin
				update EXCHANGE_USERS
				   set ASSIGNED_USER_ID  = @TEMP_ASSIGNED_USER_ID
				     , EXCHANGE_ALIAS    = @EXCHANGE_ALIAS
				     , EXCHANGE_EMAIL    = @EXCHANGE_EMAIL
				     , DATE_MODIFIED     = getdate()
				     , DATE_MODIFIED_UTC = getutcdate()
				     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
				 where ID                = @EXCHANGE_ID
				   and DELETED           = 0;
			end -- if;
		end -- if;
	end -- if;
  end
GO
 
Grant Execute on dbo.spEXCHANGE_USERS_Update to public;
GO
 
