if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTEAMS_InsertPrivate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTEAMS_InsertPrivate;
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
-- 11/18/2006 Paul.  Add the user to the Global team when the private team is created. 
-- 10/21/2008 Paul.  Increase USER_NAME to 60 to match table. 
-- 06/02/2009 Paul.  We need to allow the global team to be changed to help with SugarCRM migrations. 
-- 04/07/2016 Paul.  Provide a way to disable private teams.  
-- 04/28/2016 Paul.  Make sure that the custom field table exists. 
Create Procedure dbo.spTEAMS_InsertPrivate
	( @MODIFIED_USER_ID  uniqueidentifier
	, @USER_ID           uniqueidentifier
	, @USER_NAME         nvarchar(60)
	, @FULL_NAME         nvarchar(100)
	)
as
  begin
	set nocount on
	
	declare @TEAM_ID            uniqueidentifier;
	declare @TEAM_MEMBERSHIP_ID uniqueidentifier;
	declare @NAME               nvarchar(128);
	declare @DESCRIPTION        nvarchar(1024);
	declare @GLOBAL_TEAM_ID     uniqueidentifier;
	declare @DEFAULT_LANGUAGE   nvarchar(25);
	set @TEAM_ID = newid();
	set @NAME = N'(' + @USER_NAME + N')';
	-- 04/28/2016 Paul.  Use default language. 
	set @DEFAULT_LANGUAGE = dbo.fnCONFIG_String(N'default_language');
	if @DEFAULT_LANGUAGE is null or @DEFAULT_LANGUAGE = '' begin -- then
		set @DEFAULT_LANGUAGE = 'en-US';
	end -- if;
	set @DESCRIPTION = dbo.fnL10nTerm(@DEFAULT_LANGUAGE, 'Teams', 'LBL_PRIVATE_TEAM_DESC') + @FULL_NAME;
	-- 04/07/2016 Paul.  Provide a way to disable private teams.  
	if dbo.fnCONFIG_Boolean(N'disable_private_teams') = 0 begin -- then
		insert into TEAMS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, NAME             
			, DESCRIPTION      
			, PRIVATE          
			)
		values 	( @TEAM_ID          
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @NAME             
			, @DESCRIPTION      
			, 1
			);
		-- 04/28/2016 Paul.  Make sure that the custom field table exists. 
		if @@ERROR = 0 begin -- then
			if not exists(select * from TEAMS_CSTM where ID_C = @TEAM_ID) begin -- then
				insert into TEAMS_CSTM ( ID_C ) values ( @TEAM_ID );
			end -- if;
		end -- if;
		
		-- 11/18/2006 Paul.  We don't use spTEAM_MEMBERSHIPS_Update because we need to set the PRIVATE flag. 
		set @TEAM_MEMBERSHIP_ID = newid();
		insert into TEAM_MEMBERSHIPS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, TEAM_ID          
			, USER_ID          
			, EXPLICIT_ASSIGN  
			, IMPLICIT_ASSIGN  
			, PRIVATE  
			)
		values
			( @TEAM_MEMBERSHIP_ID
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @TEAM_ID          
			, @USER_ID          
			, 1  
			, 0  
			, 1  
			);
	
		-- 11/18/2006 Paul.  Refresh all the implicit members. 
		exec dbo.spTEAM_MEMBERSHIPS_UpdateImplicit @MODIFIED_USER_ID, @TEAM_ID;
	end -- if;

	-- 06/02/2009 Paul.  We need to allow the global team to be changed to help with SugarCRM migrations. 
	set @GLOBAL_TEAM_ID = dbo.fnCONFIG_Guid('global_team_id');
	if dbo.fnIsEmptyGuid(@GLOBAL_TEAM_ID) = 1 begin -- then
		set @GLOBAL_TEAM_ID = '17BB7135-2B95-42DC-85DE-842CAFF927A0';
	end -- if;
	if exists(select * from TEAMS where ID = @GLOBAL_TEAM_ID and DELETED = 0) begin -- then
		-- 11/18/2006 Paul.  Add the user to the Global team. 
		exec dbo.spTEAM_MEMBERSHIPS_Update @MODIFIED_USER_ID, @GLOBAL_TEAM_ID, @USER_ID, 1;
	end -- if;
  end
GO

Grant Execute on dbo.spTEAMS_InsertPrivate to public;
GO

