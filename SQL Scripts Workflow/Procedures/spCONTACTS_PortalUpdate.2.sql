if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCONTACTS_PortalUpdate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCONTACTS_PortalUpdate;
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
-- 03/05/2009 Paul.  When creating a portal user, also create a USERS record for proper auditing. 
Create Procedure dbo.spCONTACTS_PortalUpdate
	( @ID                          uniqueidentifier
	, @MODIFIED_USER_ID            uniqueidentifier
	, @PORTAL_ACTIVE               bit
	, @PORTAL_NAME                 nvarchar(255)
	, @PORTAL_PASSWORD             nvarchar(32)
	)
as
  begin
	set nocount on
	
	declare @FIRST_NAME nvarchar(30);
	declare @LAST_NAME  nvarchar(30);
	declare @USER_NAME  nvarchar(60);
	declare @USER_HASH  nvarchar(32);
	declare @THEME      nvarchar(25);

	update CONTACTS
	   set MODIFIED_USER_ID = @MODIFIED_USER_ID
	     , DATE_MODIFIED    =  getdate()       
	     , DATE_MODIFIED_UTC=  getutcdate()    
	     , PORTAL_ACTIVE    = @PORTAL_ACTIVE   
	     , PORTAL_NAME      = @PORTAL_NAME     
	     , PORTAL_PASSWORD  = @PORTAL_PASSWORD 
	 where ID               = @ID              ;
	if @PORTAL_ACTIVE = 1 and @PORTAL_NAME is not null begin -- then
		if exists(select * from vwCONTACTS where PORTAL_NAME = @PORTAL_NAME and ID <> @ID) begin -- then
			raiserror(N'A contact with the Portal Name [%s] already exists.', 16, 1, @PORTAL_NAME);
		end -- if;
		
		if @@ERROR = 0 begin -- then
			set @THEME     = dbo.fnCONFIG_String(N'default_theme');
			set @USER_NAME = substring(N'portal: ' +  @PORTAL_NAME, 1, 60);
			set @USER_HASH = replace(cast(newid() as nchar(36)), N'-', N'');
			select @FIRST_NAME = substring(FIRST_NAME, 1, 30)
			     , @LAST_NAME  = substring(LAST_NAME , 1, 30)
			  from vwCONTACTS
			 where ID = @ID;

			-- 03/05/2009 Paul.  A portal user with have a user record with the same ID as the Contact. 
			-- 11/19/2015 Paul.  Default to Active status so that record will appear in users list. 
			-- 11/19/2015 Paul.  We need to set the default theme. 
			if not exists(select * from USERS where ID = @ID) begin -- then
				insert into USERS
					( ID              
					, CREATED_BY      
					, MODIFIED_USER_ID
					, USER_NAME       
					, FIRST_NAME      
					, LAST_NAME       
					, USER_HASH       
					, PORTAL_ONLY     
					, STATUS          
					, THEME           
					)
				values	( @ID              
					, @MODIFIED_USER_ID
					, @MODIFIED_USER_ID
					, @USER_NAME       
					, @FIRST_NAME      
					, @LAST_NAME       
					, @USER_HASH       
					, 1                
					, N'Active'        
					, @THEME           
					);
			end else begin
				update USERS
				   set MODIFIED_USER_ID = @MODIFIED_USER_ID
				     , DATE_MODIFIED    =  getdate()       
				     , DATE_MODIFIED_UTC=  getutcdate()    
				     , USER_NAME        = @USER_NAME       
				     , FIRST_NAME       = @FIRST_NAME      
				     , LAST_NAME        = @LAST_NAME       
				     , PORTAL_ONLY      = 1                
				 where ID               = @ID              ;
			end -- if;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spCONTACTS_PortalUpdate to public;
GO

