if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSURVEY_QUESTIONS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSURVEY_QUESTIONS_Update;
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
-- 01/01/2016 Paul.  Add categories. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 09/30/2018 Paul.  Add survey record creation to survey. 
Create Procedure dbo.spSURVEY_QUESTIONS_Update
	( @ID                           uniqueidentifier output
	, @MODIFIED_USER_ID             uniqueidentifier
	, @ASSIGNED_USER_ID             uniqueidentifier
	, @TEAM_ID                      uniqueidentifier
	, @TEAM_SET_LIST                varchar(8000)
	, @NAME                         nvarchar(150)
	, @DESCRIPTION                  nvarchar(max)
	, @QUESTION_TYPE                nvarchar(25)
	, @DISPLAY_FORMAT               nvarchar(25)
	, @ANSWER_CHOICES               nvarchar(max)
	, @COLUMN_CHOICES               nvarchar(max)
	, @FORCED_RANKING               bit
	, @INVALID_DATE_MESSAGE         nvarchar(max)
	, @INVALID_NUMBER_MESSAGE       nvarchar(max)
	, @NA_ENABLED                   bit
	, @NA_LABEL                     nvarchar(max)
	, @OTHER_ENABLED                bit
	, @OTHER_LABEL                  nvarchar(200)
	, @OTHER_HEIGHT                 int
	, @OTHER_WIDTH                  int
	, @OTHER_AS_CHOICE              bit
	, @OTHER_ONE_PER_ROW            bit
	, @OTHER_REQUIRED_MESSAGE       nvarchar(max)
	, @OTHER_VALIDATION_TYPE        nvarchar(25)
	, @OTHER_VALIDATION_MIN         nvarchar(10)
	, @OTHER_VALIDATION_MAX         nvarchar(10)
	, @OTHER_VALIDATION_MESSAGE     nvarchar(max)
	, @REQUIRED                     bit
	, @REQUIRED_TYPE                nvarchar(25)
	, @REQUIRED_RESPONSES_MIN       int
	, @REQUIRED_RESPONSES_MAX       int
	, @REQUIRED_MESSAGE             nvarchar(max)
	, @VALIDATION_TYPE              nvarchar(25)
	, @VALIDATION_MIN               nvarchar(10)
	, @VALIDATION_MAX               nvarchar(10)
	, @VALIDATION_MESSAGE           nvarchar(max)
	, @VALIDATION_SUM_ENABLED       bit
	, @VALIDATION_NUMERIC_SUM       int
	, @VALIDATION_SUM_MESSAGE       nvarchar(max)
	, @RANDOMIZE_TYPE               nvarchar(25)
	, @RANDOMIZE_NOT_LAST           bit
	, @SIZE_WIDTH                   nvarchar(10)
	, @SIZE_HEIGHT                  nvarchar(10)
	, @BOX_WIDTH                    nvarchar(10)
	, @BOX_HEIGHT                   nvarchar(10)
	, @COLUMN_WIDTH                 nvarchar(25)
	, @PLACEMENT                    nvarchar(25)
	, @SPACING_LEFT                 int
	, @SPACING_TOP                  int
	, @SPACING_RIGHT                int
	, @SPACING_BOTTOM               int
	, @IMAGE_URL                    nvarchar(1000)
	, @CATEGORIES                   nvarchar(max) = null
	, @ASSIGNED_SET_LIST            varchar(8000) = null
	, @SURVEY_TARGET_MODULE         nvarchar(25) = null
	, @TARGET_FIELD_NAME            nvarchar(50) = null
	)
as
  begin
	set nocount on
	
	declare @TEAM_SET_ID         uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;
	
	if not exists(select * from SURVEY_QUESTIONS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into SURVEY_QUESTIONS
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
			, DESCRIPTION                 
			, SURVEY_TARGET_MODULE        
			, TARGET_FIELD_NAME           
			, QUESTION_TYPE               
			, DISPLAY_FORMAT              
			, ANSWER_CHOICES              
			, COLUMN_CHOICES              
			, FORCED_RANKING              
			, INVALID_DATE_MESSAGE        
			, INVALID_NUMBER_MESSAGE      
			, NA_ENABLED                  
			, NA_LABEL                    
			, OTHER_ENABLED               
			, OTHER_LABEL                 
			, OTHER_HEIGHT                
			, OTHER_WIDTH                 
			, OTHER_AS_CHOICE             
			, OTHER_ONE_PER_ROW           
			, OTHER_REQUIRED_MESSAGE      
			, OTHER_VALIDATION_TYPE       
			, OTHER_VALIDATION_MIN        
			, OTHER_VALIDATION_MAX        
			, OTHER_VALIDATION_MESSAGE    
			, REQUIRED                    
			, REQUIRED_TYPE               
			, REQUIRED_RESPONSES_MIN      
			, REQUIRED_RESPONSES_MAX      
			, REQUIRED_MESSAGE            
			, VALIDATION_TYPE             
			, VALIDATION_MIN              
			, VALIDATION_MAX              
			, VALIDATION_MESSAGE          
			, VALIDATION_SUM_ENABLED      
			, VALIDATION_NUMERIC_SUM      
			, VALIDATION_SUM_MESSAGE      
			, RANDOMIZE_TYPE              
			, RANDOMIZE_NOT_LAST          
			, SIZE_WIDTH                  
			, SIZE_HEIGHT                 
			, BOX_WIDTH                   
			, BOX_HEIGHT                  
			, COLUMN_WIDTH                
			, PLACEMENT                   
			, SPACING_LEFT                
			, SPACING_TOP                 
			, SPACING_RIGHT               
			, SPACING_BOTTOM              
			, IMAGE_URL                   
			, CATEGORIES                  
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
			, @TEAM_ID                     
			, @TEAM_SET_ID                 
			, @NAME                        
			, @DESCRIPTION                 
			, @SURVEY_TARGET_MODULE        
			, @TARGET_FIELD_NAME           
			, @QUESTION_TYPE               
			, @DISPLAY_FORMAT              
			, @ANSWER_CHOICES              
			, @COLUMN_CHOICES              
			, @FORCED_RANKING              
			, @INVALID_DATE_MESSAGE        
			, @INVALID_NUMBER_MESSAGE      
			, @NA_ENABLED                  
			, @NA_LABEL                    
			, @OTHER_ENABLED               
			, @OTHER_LABEL                 
			, @OTHER_HEIGHT                
			, @OTHER_WIDTH                 
			, @OTHER_AS_CHOICE             
			, @OTHER_ONE_PER_ROW           
			, @OTHER_REQUIRED_MESSAGE      
			, @OTHER_VALIDATION_TYPE       
			, @OTHER_VALIDATION_MIN        
			, @OTHER_VALIDATION_MAX        
			, @OTHER_VALIDATION_MESSAGE    
			, @REQUIRED                    
			, @REQUIRED_TYPE               
			, @REQUIRED_RESPONSES_MIN      
			, @REQUIRED_RESPONSES_MAX      
			, @REQUIRED_MESSAGE            
			, @VALIDATION_TYPE             
			, @VALIDATION_MIN              
			, @VALIDATION_MAX              
			, @VALIDATION_MESSAGE          
			, @VALIDATION_SUM_ENABLED      
			, @VALIDATION_NUMERIC_SUM      
			, @VALIDATION_SUM_MESSAGE      
			, @RANDOMIZE_TYPE              
			, @RANDOMIZE_NOT_LAST          
			, @SIZE_WIDTH                  
			, @SIZE_HEIGHT                 
			, @BOX_WIDTH                   
			, @BOX_HEIGHT                  
			, @COLUMN_WIDTH                
			, @PLACEMENT                   
			, @SPACING_LEFT                
			, @SPACING_TOP                 
			, @SPACING_RIGHT               
			, @SPACING_BOTTOM              
			, @IMAGE_URL                   
			, @CATEGORIES                  
			, @ASSIGNED_SET_ID             
			);
	end else begin
		update SURVEY_QUESTIONS
		   set MODIFIED_USER_ID             = @MODIFIED_USER_ID            
		     , DATE_MODIFIED                =  getdate()                   
		     , DATE_MODIFIED_UTC            =  getutcdate()                
		     , ASSIGNED_USER_ID             = @ASSIGNED_USER_ID            
		     , TEAM_ID                      = @TEAM_ID                     
		     , TEAM_SET_ID                  = @TEAM_SET_ID                 
		     , NAME                         = @NAME                        
		     , DESCRIPTION                  = @DESCRIPTION                 
		     , SURVEY_TARGET_MODULE         = @SURVEY_TARGET_MODULE        
		     , TARGET_FIELD_NAME            = @TARGET_FIELD_NAME           
		     , QUESTION_TYPE                = @QUESTION_TYPE               
		     , DISPLAY_FORMAT               = @DISPLAY_FORMAT              
		     , ANSWER_CHOICES               = @ANSWER_CHOICES              
		     , COLUMN_CHOICES               = @COLUMN_CHOICES              
		     , FORCED_RANKING               = @FORCED_RANKING              
		     , INVALID_DATE_MESSAGE         = @INVALID_DATE_MESSAGE        
		     , INVALID_NUMBER_MESSAGE       = @INVALID_NUMBER_MESSAGE      
		     , NA_ENABLED                   = @NA_ENABLED                  
		     , NA_LABEL                     = @NA_LABEL                    
		     , OTHER_ENABLED                = @OTHER_ENABLED               
		     , OTHER_LABEL                  = @OTHER_LABEL                 
		     , OTHER_HEIGHT                 = @OTHER_HEIGHT                
		     , OTHER_WIDTH                  = @OTHER_WIDTH                 
		     , OTHER_AS_CHOICE              = @OTHER_AS_CHOICE             
		     , OTHER_ONE_PER_ROW            = @OTHER_ONE_PER_ROW           
		     , OTHER_REQUIRED_MESSAGE       = @OTHER_REQUIRED_MESSAGE      
		     , OTHER_VALIDATION_TYPE        = @OTHER_VALIDATION_TYPE       
		     , OTHER_VALIDATION_MIN         = @OTHER_VALIDATION_MIN        
		     , OTHER_VALIDATION_MAX         = @OTHER_VALIDATION_MAX        
		     , OTHER_VALIDATION_MESSAGE     = @OTHER_VALIDATION_MESSAGE    
		     , REQUIRED                     = @REQUIRED                    
		     , REQUIRED_TYPE                = @REQUIRED_TYPE               
		     , REQUIRED_RESPONSES_MIN       = @REQUIRED_RESPONSES_MIN      
		     , REQUIRED_RESPONSES_MAX       = @REQUIRED_RESPONSES_MAX      
		     , REQUIRED_MESSAGE             = @REQUIRED_MESSAGE            
		     , VALIDATION_TYPE              = @VALIDATION_TYPE             
		     , VALIDATION_MIN               = @VALIDATION_MIN              
		     , VALIDATION_MAX               = @VALIDATION_MAX              
		     , VALIDATION_MESSAGE           = @VALIDATION_MESSAGE          
		     , VALIDATION_SUM_ENABLED       = @VALIDATION_SUM_ENABLED      
		     , VALIDATION_NUMERIC_SUM       = @VALIDATION_NUMERIC_SUM      
		     , VALIDATION_SUM_MESSAGE       = @VALIDATION_SUM_MESSAGE      
		     , RANDOMIZE_TYPE               = @RANDOMIZE_TYPE              
		     , RANDOMIZE_NOT_LAST           = @RANDOMIZE_NOT_LAST          
		     , SIZE_WIDTH                   = @SIZE_WIDTH                  
		     , SIZE_HEIGHT                  = @SIZE_HEIGHT                 
		     , BOX_WIDTH                    = @BOX_WIDTH                   
		     , BOX_HEIGHT                   = @BOX_HEIGHT                  
		     , COLUMN_WIDTH                 = @COLUMN_WIDTH                
		     , PLACEMENT                    = @PLACEMENT                   
		     , SPACING_LEFT                 = @SPACING_LEFT                
		     , SPACING_TOP                  = @SPACING_TOP                 
		     , SPACING_RIGHT                = @SPACING_RIGHT               
		     , SPACING_BOTTOM               = @SPACING_BOTTOM              
		     , IMAGE_URL                    = @IMAGE_URL                   
		     , CATEGORIES                   = @CATEGORIES                  
		     , ASSIGNED_SET_ID              = @ASSIGNED_SET_ID             
		 where ID                           = @ID                          ;
		
		exec dbo.spSUGARFAVORITES_UpdateName @MODIFIED_USER_ID, @ID, @NAME;
	end -- if;

	if @@ERROR = 0 begin -- then
		if not exists(select * from SURVEY_QUESTIONS_CSTM where ID_C = @ID) begin -- then
			insert into SURVEY_QUESTIONS_CSTM ( ID_C ) values ( @ID );
		end -- if;
	end -- if;

  end
GO

Grant Execute on dbo.spSURVEY_QUESTIONS_Update to public;
GO

