if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spKBDOCUMENTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spKBDOCUMENTS_Update;
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
-- 10/21/2009 Paul.  KBTAG_SET_LIST so that we can generate workflow events on tag changes. 
-- 04/03/2012 Paul.  When the name changes, update the favorites table. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spKBDOCUMENTS_Update
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @ASSIGNED_USER_ID     uniqueidentifier
	, @NAME                 nvarchar(255)
	, @KBDOC_APPROVER_ID    uniqueidentifier
	, @IS_EXTERNAL_ARTICLE  bit
	, @ACTIVE_DATE          datetime
	, @EXP_DATE             datetime
	, @STATUS               nvarchar(25)
	, @REVISION             nvarchar(25)
	, @DESCRIPTION          nvarchar(max)
	, @TEAM_ID              uniqueidentifier
	, @TEAM_SET_LIST        varchar(8000)
	, @KBTAG_SET_LIST       nvarchar(max)
	, @TAG_SET_NAME         nvarchar(4000) = null
	, @ASSIGNED_SET_LIST    varchar(8000) = null
	)
as
  begin
	set nocount on
	
	declare @TEAM_SET_ID           uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;
	declare @NORMAL_KBTAG_SET_LIST nvarchar(max);
	
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;
	
	if not exists(select * from KBDOCUMENTS where ID = @ID) begin -- then
		-- 10/21/2009 Paul.  When inserting an article, we normalize the set twice. 
		-- The first pass is to get the normalized list, the second pass is to insert the records. 
		-- We need the two passes because of the foreign keys in the relationship table. 
		exec dbo.spKBDOCUMENTS_KBTAGS_NormalizeSet @MODIFIED_USER_ID, null, @KBTAG_SET_LIST, @NORMAL_KBTAG_SET_LIST out;

		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into KBDOCUMENTS
			( ID                  
			, CREATED_BY          
			, DATE_ENTERED        
			, MODIFIED_USER_ID    
			, DATE_MODIFIED       
			, DATE_MODIFIED_UTC   
			, ASSIGNED_USER_ID    
			, NAME                
			, KBDOC_APPROVER_ID   
			, IS_EXTERNAL_ARTICLE 
			, ACTIVE_DATE         
			, EXP_DATE            
			, STATUS              
			, REVISION            
			, DESCRIPTION         
			, TEAM_ID             
			, TEAM_SET_ID         
			, KBTAG_SET_LIST      
			, ASSIGNED_SET_ID     
			)
		values
		 	( @ID                  
			, @MODIFIED_USER_ID    
			,  getdate()           
			, @MODIFIED_USER_ID    
			,  getdate()           
			,  getutcdate()        
			, @ASSIGNED_USER_ID    
			, @NAME                
			, @KBDOC_APPROVER_ID   
			, @IS_EXTERNAL_ARTICLE 
			, @ACTIVE_DATE         
			, @EXP_DATE            
			, @STATUS              
			, @REVISION            
			, @DESCRIPTION         
			, @TEAM_ID             
			, @TEAM_SET_ID         
			, @NORMAL_KBTAG_SET_LIST
			, @ASSIGNED_SET_ID     
			);

		exec dbo.spKBDOCUMENTS_KBTAGS_NormalizeSet @MODIFIED_USER_ID, @ID, @KBTAG_SET_LIST, @NORMAL_KBTAG_SET_LIST out;
	end else begin
		-- 10/21/2009 Paul.  We have to normalize the set before performing the main updated. 
		exec dbo.spKBDOCUMENTS_KBTAGS_NormalizeSet @MODIFIED_USER_ID, @ID, @KBTAG_SET_LIST, @NORMAL_KBTAG_SET_LIST out;

		update KBDOCUMENTS
		   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
		     , DATE_MODIFIED        =  getdate()           
		     , DATE_MODIFIED_UTC    =  getutcdate()        
		     , ASSIGNED_USER_ID     = @ASSIGNED_USER_ID    
		     , NAME                 = @NAME                
		     , KBDOC_APPROVER_ID    = @KBDOC_APPROVER_ID   
		     , IS_EXTERNAL_ARTICLE  = @IS_EXTERNAL_ARTICLE 
		     , ACTIVE_DATE          = @ACTIVE_DATE         
		     , EXP_DATE             = @EXP_DATE            
		     , STATUS               = @STATUS              
		     , REVISION             = @REVISION            
		     , DESCRIPTION          = @DESCRIPTION         
		     , TEAM_ID              = @TEAM_ID             
		     , TEAM_SET_ID          = @TEAM_SET_ID         
		     , KBTAG_SET_LIST       = @NORMAL_KBTAG_SET_LIST
		     , ASSIGNED_SET_ID      = @ASSIGNED_SET_ID     
		 where ID                   = @ID                  ;
		
		-- 04/03/2012 Paul.  When the name changes, update the favorites table. 
		exec dbo.spSUGARFAVORITES_UpdateName @MODIFIED_USER_ID, @ID, @NAME;
	end -- if;

	-- 04/08/2014 Paul.  We were missing the custom table insert.  This prevented any custom fields from getting updated. 
	if @@ERROR = 0 begin -- then
		if not exists(select * from KBDOCUMENTS_CSTM where ID_C = @ID) begin -- then
			insert into KBDOCUMENTS_CSTM ( ID_C ) values ( @ID );
		end -- if;
	end -- if;
	-- 05/12/2016 Paul.  Add Tags module. Must add after @ID is set. 
	if @@ERROR = 0 begin -- then
		exec dbo.spTAG_SETS_NormalizeSet @MODIFIED_USER_ID, @ID, N'KBDocuments', @TAG_SET_NAME;
	end -- if;
  end
GO

Grant Execute on dbo.spKBDOCUMENTS_Update to public;
GO

