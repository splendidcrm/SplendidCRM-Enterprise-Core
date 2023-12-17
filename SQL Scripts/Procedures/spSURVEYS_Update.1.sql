if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSURVEYS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSURVEYS_Update;
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
-- 05/12/2016 Paul.  Add Tags module. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 07/28/2018 Paul.  Add Kiosk mode fields. 
-- 09/30/2018 Paul.  Add survey record creation to survey. 
-- 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
Create Procedure dbo.spSURVEYS_Update
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @ASSIGNED_USER_ID   uniqueidentifier
	, @NAME               nvarchar(50)
	, @STATUS             nvarchar(25)
	, @SURVEY_STYLE       nvarchar(25)
	, @PAGE_RANDOMIZATION nvarchar(25)
	, @SURVEY_THEME_ID    uniqueidentifier
	, @DESCRIPTION        nvarchar(max)
	, @TEAM_ID            uniqueidentifier
	, @TEAM_SET_LIST      varchar(8000)
	, @TAG_SET_NAME       nvarchar(4000) = null
	, @ASSIGNED_SET_LIST  varchar(8000) = null
	, @LOOP_SURVEY        bit = null
	, @EXIT_CODE          nvarchar(25) = null
	, @TIMEOUT            int = null
	, @SURVEY_TARGET_MODULE nvarchar(25) = null
	, @SURVEY_TARGET_ASSIGNMENT nvarchar(50) = null
	)
as
  begin
	set nocount on
	
	declare @TEAM_SET_ID         uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;

	if not exists(select * from SURVEYS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into SURVEYS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, ASSIGNED_USER_ID  
			, TEAM_ID           
			, TEAM_SET_ID       
			, NAME              
			, STATUS            
			, SURVEY_TARGET_MODULE
			, SURVEY_TARGET_ASSIGNMENT
			, SURVEY_STYLE      
			, PAGE_RANDOMIZATION
			, SURVEY_THEME_ID   
			, DESCRIPTION       
			, ASSIGNED_SET_ID   
			, LOOP_SURVEY       
			, EXIT_CODE         
			, TIMEOUT           
			)
		values
			( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @ASSIGNED_USER_ID  
			, @TEAM_ID           
			, @TEAM_SET_ID       
			, @NAME              
			, @STATUS            
			, @SURVEY_TARGET_MODULE
			, @SURVEY_TARGET_ASSIGNMENT
			, @SURVEY_STYLE      
			, @PAGE_RANDOMIZATION
			, @SURVEY_THEME_ID   
			, @DESCRIPTION       
			, @ASSIGNED_SET_ID   
			, @LOOP_SURVEY       
			, @EXIT_CODE         
			, @TIMEOUT           
			);
	end else begin
		update SURVEYS
		   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
		     , DATE_MODIFIED        =  getdate()           
		     , DATE_MODIFIED_UTC    =  getutcdate()        
		     , ASSIGNED_USER_ID     = @ASSIGNED_USER_ID    
		     , TEAM_ID              = @TEAM_ID             
		     , TEAM_SET_ID          = @TEAM_SET_ID         
		     , NAME                 = @NAME                
		     , STATUS               = @STATUS              
		     , SURVEY_TARGET_MODULE = @SURVEY_TARGET_MODULE
		     , SURVEY_TARGET_ASSIGNMENT = @SURVEY_TARGET_ASSIGNMENT
		     , SURVEY_STYLE         = @SURVEY_STYLE        
		     , PAGE_RANDOMIZATION   = @PAGE_RANDOMIZATION  
		     , SURVEY_THEME_ID      = @SURVEY_THEME_ID     
		     , DESCRIPTION          = @DESCRIPTION         
		     , ASSIGNED_SET_ID      = @ASSIGNED_SET_ID     
		     , LOOP_SURVEY          = @LOOP_SURVEY         
		     , EXIT_CODE            = @EXIT_CODE           
		     , TIMEOUT              = @TIMEOUT             
		 where ID                   = @ID                  ;
		
		exec dbo.spSUGARFAVORITES_UpdateName @MODIFIED_USER_ID, @ID, @NAME;
	end -- if;

	if @@ERROR = 0 begin -- then
		if not exists(select * from SURVEYS_CSTM where ID_C = @ID) begin -- then
			insert into SURVEYS_CSTM ( ID_C ) values ( @ID );
		end -- if;
	end -- if;
	-- 05/12/2016 Paul.  Add Tags module. Must add after @ID is set. 
	if @@ERROR = 0 begin -- then
		exec dbo.spTAG_SETS_NormalizeSet @MODIFIED_USER_ID, @ID, N'Surveys', @TAG_SET_NAME;
	end -- if;
  end
GO

Grant Execute on dbo.spSURVEYS_Update to public;
GO

