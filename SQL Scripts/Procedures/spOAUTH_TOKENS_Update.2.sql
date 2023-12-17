if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spOAUTH_TOKENS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spOAUTH_TOKENS_Update;
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
-- 04/13/2012 Paul.  Facebook has a 111 character access token. 
-- 09/05/2015 Paul.  Google now uses OAuth 2.0. 
-- 01/19/2017 Paul.  The Microsoft OAuth token can be large, but less than 2000 bytes. 
-- 12/02/2020 Paul.  The Microsoft OAuth token is now about 2400, so increase to 4000 characters.
Create Procedure dbo.spOAUTH_TOKENS_Update
	( @MODIFIED_USER_ID   uniqueidentifier
	, @ASSIGNED_USER_ID   uniqueidentifier
	, @NAME               nvarchar(50)
	, @TOKEN              nvarchar(4000)
	, @SECRET             nvarchar(50)
	, @TOKEN_EXPIRES_AT   datetime = null
	, @REFRESH_TOKEN      nvarchar(4000) = null
	)
as
  begin
	set nocount on

	declare @ID uniqueidentifier;
	
	exec dbo.spOAUTH_TOKENS_Delete @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @NAME;
	
	set @ID = newid();
	insert into OAUTH_TOKENS
		( ID                
		, CREATED_BY        
		, DATE_ENTERED      
		, MODIFIED_USER_ID  
		, DATE_MODIFIED     
		, DATE_MODIFIED_UTC 
		, ASSIGNED_USER_ID  
		, NAME              
		, TOKEN             
		, SECRET            
		, TOKEN_EXPIRES_AT  
		, REFRESH_TOKEN     
		)
	values 	( @ID                
		, @MODIFIED_USER_ID  
		,  getdate()         
		, @MODIFIED_USER_ID  
		,  getdate()         
		,  getutcdate()      
		, @ASSIGNED_USER_ID  
		, @NAME              
		, @TOKEN             
		, @SECRET            
		, @TOKEN_EXPIRES_AT  
		, @REFRESH_TOKEN     
		);
  end
GO

Grant Execute on dbo.spOAUTH_TOKENS_Update to public;
GO

