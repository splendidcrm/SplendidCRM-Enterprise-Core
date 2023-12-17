if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDOCUMENTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDOCUMENTS_Update;
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
-- 04/21/2006 Paul.  MAIL_MERGE_DOCUMENT was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  RELATED_DOC_ID was added in SugarCRM 4.2.
-- 04/21/2006 Paul.  RELATED_DOC_REV_ID was added in SugarCRM 4.2.
-- 04/21/2006 Paul.  IS_TEMPLATE was added in SugarCRM 4.2.
-- 04/21/2006 Paul.  TEMPLATE_TYPE was added in SugarCRM 4.2.
-- 12/29/2007 Paul.  Add TEAM_ID so that it is not updated separately. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 08/23/2009 Paul.  Decrease set list so that index plus ID will be less than 900 bytes. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 05/15/2011 Paul.  We need to include the Master and Secondary so that the user selects the correct template. 
-- 04/02/2012 Paul.  Add ASSIGNED_USER_ID. 
-- 04/03/2012 Paul.  When the name changes, update the favorites table. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spDOCUMENTS_Update
	( @ID                    uniqueidentifier output
	, @MODIFIED_USER_ID      uniqueidentifier
	, @DOCUMENT_NAME         nvarchar(255)
	, @ACTIVE_DATE           datetime
	, @EXP_DATE              datetime
	, @CATEGORY_ID           nvarchar(25)
	, @SUBCATEGORY_ID        nvarchar(25)
	, @STATUS_ID             nvarchar(25)
	, @DESCRIPTION           nvarchar(max)
	, @MAIL_MERGE_DOCUMENT   bit
	, @RELATED_DOC_ID        uniqueidentifier
	, @RELATED_DOC_REV_ID    uniqueidentifier
	, @IS_TEMPLATE           bit
	, @TEMPLATE_TYPE         nvarchar(25)
	, @TEAM_ID               uniqueidentifier = null
	, @TEAM_SET_LIST         varchar(8000) = null
	, @PRIMARY_MODULE        nvarchar(25) = null
	, @SECONDARY_MODULE      nvarchar(25) = null
	, @ASSIGNED_USER_ID      uniqueidentifier = null
	, @TAG_SET_NAME          nvarchar(4000) = null
	, @ASSIGNED_SET_LIST     varchar(8000) = null
	)
as
  begin
	set nocount on
	
	declare @TEAM_SET_ID         uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;

	-- 08/22/2009 Paul.  Normalize the team set by placing the primary ID first, then order list by ID and the name by team names. 
	-- 08/23/2009 Paul.  Use a team set so that team name changes can propagate. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;

	if not exists(select * from DOCUMENTS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into DOCUMENTS
			( ID                   
			, CREATED_BY           
			, DATE_ENTERED         
			, MODIFIED_USER_ID     
			, DATE_MODIFIED        
			, DATE_MODIFIED_UTC    
			, DOCUMENT_NAME        
			, ACTIVE_DATE          
			, EXP_DATE             
			, DESCRIPTION          
			, CATEGORY_ID          
			, SUBCATEGORY_ID       
			, STATUS_ID            
			, MAIL_MERGE_DOCUMENT  
			, RELATED_DOC_ID       
			, RELATED_DOC_REV_ID   
			, IS_TEMPLATE          
			, TEMPLATE_TYPE        
			, PRIMARY_MODULE       
			, SECONDARY_MODULE     
			, TEAM_ID              
			, TEAM_SET_ID          
			, ASSIGNED_USER_ID     
			, ASSIGNED_SET_ID      
			)
		values
			( @ID                   
			, @MODIFIED_USER_ID     
			,  getdate()            
			, @MODIFIED_USER_ID     
			,  getdate()            
			,  getutcdate()         
			, @DOCUMENT_NAME        
			, @ACTIVE_DATE          
			, @EXP_DATE             
			, @DESCRIPTION          
			, @CATEGORY_ID          
			, @SUBCATEGORY_ID       
			, @STATUS_ID            
			, @MAIL_MERGE_DOCUMENT  
			, @RELATED_DOC_ID       
			, @RELATED_DOC_REV_ID   
			, @IS_TEMPLATE          
			, @TEMPLATE_TYPE        
			, @PRIMARY_MODULE       
			, @SECONDARY_MODULE     
			, @TEAM_ID              
			, @TEAM_SET_ID          
			, @ASSIGNED_USER_ID     
			, @ASSIGNED_SET_ID      
			);
	end else begin
		update DOCUMENTS
		   set MODIFIED_USER_ID      = @MODIFIED_USER_ID     
		     , DATE_MODIFIED         =  getdate()            
		     , DATE_MODIFIED_UTC     =  getutcdate()         
		     , DOCUMENT_NAME         = @DOCUMENT_NAME        
		     , ACTIVE_DATE           = @ACTIVE_DATE          
		     , EXP_DATE              = @EXP_DATE             
		     , DESCRIPTION           = @DESCRIPTION          
		     , CATEGORY_ID           = @CATEGORY_ID          
		     , SUBCATEGORY_ID        = @SUBCATEGORY_ID       
		     , STATUS_ID             = @STATUS_ID            
		     , MAIL_MERGE_DOCUMENT   = @MAIL_MERGE_DOCUMENT  
		     , RELATED_DOC_ID        = @RELATED_DOC_ID       
		     , RELATED_DOC_REV_ID    = @RELATED_DOC_REV_ID   
		     , IS_TEMPLATE           = @IS_TEMPLATE          
		     , TEMPLATE_TYPE         = @TEMPLATE_TYPE        
		     , PRIMARY_MODULE        = @PRIMARY_MODULE       
		     , SECONDARY_MODULE      = @SECONDARY_MODULE     
		     , TEAM_ID               = @TEAM_ID              
		     , TEAM_SET_ID           = @TEAM_SET_ID          
		     , ASSIGNED_USER_ID      = @ASSIGNED_USER_ID     
		     , ASSIGNED_SET_ID       = @ASSIGNED_SET_ID      
		 where ID                    = @ID                   ;
		
		-- 04/03/2012 Paul.  When the name changes, update the favorites table. 
		exec dbo.spSUGARFAVORITES_UpdateName @MODIFIED_USER_ID, @ID, @DOCUMENT_NAME;
	end -- if;

	-- 08/22/2009 Paul.  If insert fails, then the rest will as well. Just display the one error. 
	if @@ERROR = 0 begin -- then
		if not exists(select * from DOCUMENTS_CSTM where ID_C = @ID) begin -- then
			insert into DOCUMENTS_CSTM ( ID_C ) values ( @ID );
		end -- if;
		
		-- 08/21/2009 Paul.  Add or remove the team relationship records. 
		-- 08/30/2009 Paul.  Instead of using @TEAM_SET_LIST, use the @TEAM_SET_ID to build the module-specific team relationships. 
		-- 08/31/2009 Paul.  Instead of managing a separate teams relationship, we will leverage TEAM_SETS_TEAMS. 
		-- exec dbo.spDOCUMENTS_TEAMS_Update @ID, @MODIFIED_USER_ID, @TEAM_SET_ID;
	end -- if;
	-- 05/12/2016 Paul.  Add Tags module. Must add after @ID is set. 
	if @@ERROR = 0 begin -- then
		exec dbo.spTAG_SETS_NormalizeSet @MODIFIED_USER_ID, @ID, N'Documents', @TAG_SET_NAME;
	end -- if;
  end
GO

Grant Execute on dbo.spDOCUMENTS_Update to public;
GO

