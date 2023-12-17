if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spRULES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spRULES_Update;
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
-- 05/25/2021 Paul.  Add Tags module. Must add after @ID is set. 
Create Procedure dbo.spRULES_Update
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @ASSIGNED_USER_ID   uniqueidentifier
	, @NAME               nvarchar(150)
	, @MODULE_NAME        nvarchar(25)
	, @RULE_TYPE          nvarchar(25)
	, @DESCRIPTION        nvarchar(max)
	, @FILTER_SQL         nvarchar(max)
	, @FILTER_XML         nvarchar(max)
	, @RULES_XML          nvarchar(max)
	, @XOML               nvarchar(max)
	, @TEAM_ID            uniqueidentifier
	, @TEAM_SET_LIST      varchar(8000)
	, @TAG_SET_NAME       nvarchar(4000) = null
	)
as
  begin
	set nocount on
	
	declare @TEAM_SET_ID         uniqueidentifier;
	
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	
	if not exists(select * from RULES where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into RULES
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
			, MODULE_NAME       
			, RULE_TYPE         
			, DESCRIPTION       
			, FILTER_SQL        
			, FILTER_XML        
			, RULES_XML         
			, XOML              
			)
		values 	( @ID                
			, @MODIFIED_USER_ID        
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @ASSIGNED_USER_ID  
			, @TEAM_ID           
			, @TEAM_SET_ID       
			, @NAME              
			, @MODULE_NAME       
			, @RULE_TYPE         
			, @DESCRIPTION       
			, @FILTER_SQL        
			, @FILTER_XML        
			, @RULES_XML         
			, @XOML              
			);
	end else begin
		update RULES
		   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
		     , DATE_MODIFIED      =  getdate()         
		     , DATE_MODIFIED_UTC  =  getutcdate()      
		     , ASSIGNED_USER_ID   = @ASSIGNED_USER_ID  
		     , TEAM_ID            = @TEAM_ID           
		     , TEAM_SET_ID        = @TEAM_SET_ID       
		     , NAME               = @NAME              
		     , MODULE_NAME        = @MODULE_NAME       
		     , RULE_TYPE          = @RULE_TYPE         
		     , DESCRIPTION        = @DESCRIPTION       
		     , FILTER_SQL         = @FILTER_SQL        
		     , FILTER_XML         = @FILTER_XML        
		     , RULES_XML          = @RULES_XML         
		     , XOML               = @XOML              
		 where ID                 = @ID                ;
	end -- if;
	-- 05/25/2021 Paul.  Add Tags module. Must add after @ID is set. 
	if @@ERROR = 0 begin -- then
		exec dbo.spTAG_SETS_NormalizeSet @MODIFIED_USER_ID, @ID, N'RulesWizard', @TAG_SET_NAME;
	end -- if;
  end
GO

Grant Execute on dbo.spRULES_Update to public;
GO

