if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spFORUMS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spFORUMS_Update;
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
-- 12/29/2007 Paul.  Add TEAM_ID so that it is not updated separately. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 08/23/2009 Paul.  Decrease set list so that index plus ID will be less than 900 bytes. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
Create Procedure dbo.spFORUMS_Update
	( @ID                  uniqueidentifier output
	, @MODIFIED_USER_ID    uniqueidentifier
	, @TITLE               nvarchar(150)
	, @CATEGORY            nvarchar(150)
	, @DESCRIPTION         nvarchar(max)
	, @TEAM_ID             uniqueidentifier = null
	, @TEAM_SET_LIST       varchar(8000) = null
	)
as
  begin
	set nocount on
	
	declare @TEAM_SET_ID         uniqueidentifier;

	-- 08/22/2009 Paul.  Normalize the team set by placing the primary ID first, then order list by ID and the name by team names. 
	-- 08/23/2009 Paul.  Use a team set so that team name changes can propagate. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;

	if not exists(select * from FORUMS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into FORUMS
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, DATE_MODIFIED_UTC  
			, TITLE              
			, CATEGORY           
			, THREADCOUNT        
			, THREADANDPOSTCOUNT 
			, DESCRIPTION        
			, TEAM_ID            
			, TEAM_SET_ID        
			)
		values 
			( @ID                 
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			,  getutcdate()       
			, @TITLE              
			, @CATEGORY           
			, 0                   
			, 0                   
			, @DESCRIPTION        
			, @TEAM_ID            
			, @TEAM_SET_ID        
			);
	end else begin
		update FORUMS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID  
		     , DATE_MODIFIED     =  getdate()         
		     , DATE_MODIFIED_UTC =  getutcdate()      
		     , TITLE             = @TITLE             
		     , CATEGORY          = @CATEGORY          
		     , DESCRIPTION       = @DESCRIPTION       
		     , TEAM_ID           = @TEAM_ID           
		     , TEAM_SET_ID       = @TEAM_SET_ID       
		 where ID                = @ID                ;
	end -- if;

	-- 08/21/2009 Paul.  Add or remove the team relationship records. 
	-- 08/30/2009 Paul.  Instead of using @TEAM_SET_LIST, use the @TEAM_SET_ID to build the module-specific team relationships. 
	-- 08/31/2009 Paul.  Instead of managing a separate teams relationship, we will leverage TEAM_SETS_TEAMS. 
	-- exec dbo.spFORUMS_TEAMS_Update @ID, @MODIFIED_USER_ID, @TEAM_SET_ID;

  end
GO

Grant Execute on dbo.spFORUMS_Update to public;
GO

