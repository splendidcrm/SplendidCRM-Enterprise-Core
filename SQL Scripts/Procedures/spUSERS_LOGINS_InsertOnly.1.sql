if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spUSERS_LOGINS_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spUSERS_LOGINS_InsertOnly;
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
-- 08/27/2008 Paul.  PostgreSQL does not allow modifying input parameters.  Use a local temp variable. 
Create Procedure dbo.spUSERS_LOGINS_InsertOnly
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @USER_ID           uniqueidentifier
	, @USER_NAME         nvarchar(60)
	, @LOGIN_TYPE        nvarchar(25)
	, @LOGIN_STATUS      nvarchar(25)
	, @ASPNET_SESSIONID  nvarchar(50)
	, @REMOTE_HOST       nvarchar(100)
	, @SERVER_HOST       nvarchar(100)
	, @TARGET            nvarchar(255)
	, @RELATIVE_PATH     nvarchar(255)
	, @USER_AGENT        nvarchar(255)
	)
as
  begin
	set nocount on
	
	declare @TEMP_USER_ID uniqueidentifier;
	set @TEMP_USER_ID = @USER_ID;
	-- 03/02/2008 Paul.  Even though the login has failed, 
	-- try and find the user that attempted the login. 
	if dbo.fnIsEmptyGuid(@TEMP_USER_ID) = 1 begin -- then
		-- BEGIN Oracle Exception
			select @TEMP_USER_ID = ID
			  from vwUSERS_Login
			 where lower(USER_NAME) = lower(@USER_NAME);
		-- END Oracle Exception
	end -- if;

	set @ID = newid();
	insert into USERS_LOGINS
		( ID               
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, USER_ID          
		, USER_NAME        
		, LOGIN_TYPE       
		, LOGIN_DATE       
		, LOGIN_STATUS     
		, ASPNET_SESSIONID 
		, REMOTE_HOST      
		, SERVER_HOST      
		, TARGET           
		, RELATIVE_PATH    
		, USER_AGENT       
		)
	values 	( @ID               
		, @MODIFIED_USER_ID       
		,  getdate()        
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @TEMP_USER_ID     
		, @USER_NAME        
		, @LOGIN_TYPE       
		,  getdate()        
		, @LOGIN_STATUS     
		, @ASPNET_SESSIONID 
		, @REMOTE_HOST      
		, @SERVER_HOST      
		, @TARGET           
		, @RELATIVE_PATH    
		, @USER_AGENT       
		);
  end
GO

Grant Execute on dbo.spUSERS_LOGINS_InsertOnly to public;
GO

