if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOW_ALERT_SHELLS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOW_ALERT_SHELLS_Update;
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
-- 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
Create Procedure dbo.spWORKFLOW_ALERT_SHELLS_Update
	( @ID                  uniqueidentifier output
	, @MODIFIED_USER_ID    uniqueidentifier
	, @PARENT_ID           uniqueidentifier
	, @NAME                nvarchar(100)
	, @ALERT_TYPE          nvarchar(25)
	, @SOURCE_TYPE         nvarchar(25)
	, @CUSTOM_TEMPLATE_ID  uniqueidentifier
	, @ALERT_TEXT          nvarchar(max)
	, @RDL                 nvarchar(max)
	, @XOML                nvarchar(max)
	, @ASSIGNED_USER_ID    uniqueidentifier = null
	, @TEAM_ID             uniqueidentifier = null
	, @TEAM_SET_LIST       varchar(8000) = null
	)
as
  begin
	set nocount on
	
	declare @TEAM_SET_ID uniqueidentifier;
	-- 03/15/2013 Paul.  Normalize the team set by placing the primary ID first, then order list by ID and the name by team names. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;

	if not exists(select * from WORKFLOW_ALERT_SHELLS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into WORKFLOW_ALERT_SHELLS
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, PARENT_ID          
			, NAME               
			, ALERT_TYPE         
			, SOURCE_TYPE        
			, CUSTOM_TEMPLATE_ID 
			, ALERT_TEXT         
			, RDL                
			, XOML               
			, ASSIGNED_USER_ID   
			, TEAM_ID            
			, TEAM_SET_ID        
			)
		values 	( @ID                 
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @PARENT_ID          
			, @NAME               
			, @ALERT_TYPE         
			, @SOURCE_TYPE        
			, @CUSTOM_TEMPLATE_ID 
			, @ALERT_TEXT         
			, @RDL                
			, @XOML               
			, @ASSIGNED_USER_ID   
			, @TEAM_ID            
			, @TEAM_SET_ID        
			);
	end else begin
		update WORKFLOW_ALERT_SHELLS
		   set MODIFIED_USER_ID    = @MODIFIED_USER_ID   
		     , DATE_MODIFIED       =  getdate()          
		     , DATE_MODIFIED_UTC   =  getutcdate()       
		     , NAME                = @NAME               
		     , ALERT_TYPE          = @ALERT_TYPE         
		     , SOURCE_TYPE         = @SOURCE_TYPE        
		     , CUSTOM_TEMPLATE_ID  = @CUSTOM_TEMPLATE_ID 
		     , ALERT_TEXT          = @ALERT_TEXT         
		     , RDL                 = @RDL                
		     , XOML                = @XOML               
		     , ASSIGNED_USER_ID    = @ASSIGNED_USER_ID   
		     , TEAM_ID             = @TEAM_ID            
		     , TEAM_SET_ID         = @TEAM_SET_ID        
		 where ID                  = @ID                 ;
	end -- if;
  end
GO

Grant Execute on dbo.spWORKFLOW_ALERT_SHELLS_Update to public;
GO

