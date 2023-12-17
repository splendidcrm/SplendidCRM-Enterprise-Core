if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSURVEY_THEMES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSURVEY_THEMES_Update;
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
-- 11/12/2018 Paul.  Add custom styles field to allow any style change. 
-- 04/09/2019 Paul.  Add Survey Theme Page Background. 
Create Procedure dbo.spSURVEY_THEMES_Update
	( @ID                            uniqueidentifier output
	, @MODIFIED_USER_ID              uniqueidentifier
	, @NAME                          nvarchar(50)
	, @SURVEY_FONT_FAMILY            nvarchar(50)
	, @LOGO_BACKGROUND               nvarchar(25)
	, @SURVEY_BACKGROUND             nvarchar(25)
	, @SURVEY_TITLE_TEXT_COLOR       nvarchar(25)
	, @SURVEY_TITLE_FONT_SIZE        nvarchar(25)
	, @SURVEY_TITLE_FONT_STYLE       nvarchar(25)
	, @SURVEY_TITLE_FONT_WEIGHT      nvarchar(25)
	, @SURVEY_TITLE_DECORATION       nvarchar(25)
	, @SURVEY_TITLE_BACKGROUND       nvarchar(25)
	, @PAGE_TITLE_TEXT_COLOR         nvarchar(25)
	, @PAGE_TITLE_FONT_SIZE          nvarchar(25)
	, @PAGE_TITLE_FONT_STYLE         nvarchar(25)
	, @PAGE_TITLE_FONT_WEIGHT        nvarchar(25)
	, @PAGE_TITLE_DECORATION         nvarchar(25)
	, @PAGE_TITLE_BACKGROUND         nvarchar(25)
	, @PAGE_DESCRIPTION_TEXT_COLOR   nvarchar(25)
	, @PAGE_DESCRIPTION_FONT_SIZE    nvarchar(25)
	, @PAGE_DESCRIPTION_FONT_STYLE   nvarchar(25)
	, @PAGE_DESCRIPTION_FONT_WEIGHT  nvarchar(25)
	, @PAGE_DESCRIPTION_DECORATION   nvarchar(25)
	, @PAGE_DESCRIPTION_BACKGROUND   nvarchar(25)
	, @QUESTION_HEADING_TEXT_COLOR   nvarchar(25)
	, @QUESTION_HEADING_FONT_SIZE    nvarchar(25)
	, @QUESTION_HEADING_FONT_STYLE   nvarchar(25)
	, @QUESTION_HEADING_FONT_WEIGHT  nvarchar(25)
	, @QUESTION_HEADING_DECORATION   nvarchar(25)
	, @QUESTION_HEADING_BACKGROUND   nvarchar(25)
	, @QUESTION_CHOICE_TEXT_COLOR    nvarchar(25)
	, @QUESTION_CHOICE_FONT_SIZE     nvarchar(25)
	, @QUESTION_CHOICE_FONT_STYLE    nvarchar(25)
	, @QUESTION_CHOICE_FONT_WEIGHT   nvarchar(25)
	, @QUESTION_CHOICE_DECORATION    nvarchar(25)
	, @QUESTION_CHOICE_BACKGROUND    nvarchar(25)
	, @PROGRESS_BAR_PAGE_WIDTH       nvarchar(25)
	, @PROGRESS_BAR_COLOR            nvarchar(25)
	, @PROGRESS_BAR_BORDER_COLOR     nvarchar(25)
	, @PROGRESS_BAR_BORDER_WIDTH     nvarchar(25)
	, @PROGRESS_BAR_TEXT_COLOR       nvarchar(25)
	, @PROGRESS_BAR_FONT_SIZE        nvarchar(25)
	, @PROGRESS_BAR_FONT_STYLE       nvarchar(25)
	, @PROGRESS_BAR_FONT_WEIGHT      nvarchar(25)
	, @PROGRESS_BAR_DECORATION       nvarchar(25)
	, @PROGRESS_BAR_BACKGROUND       nvarchar(25)
	, @ERROR_TEXT_COLOR              nvarchar(25)
	, @ERROR_FONT_SIZE               nvarchar(25)
	, @ERROR_FONT_STYLE              nvarchar(25)
	, @ERROR_FONT_WEIGHT             nvarchar(25)
	, @ERROR_DECORATION              nvarchar(25)
	, @ERROR_BACKGROUND              nvarchar(25)
	, @EXIT_LINK_TEXT_COLOR          nvarchar(25)
	, @EXIT_LINK_FONT_SIZE           nvarchar(25)
	, @EXIT_LINK_FONT_STYLE          nvarchar(25)
	, @EXIT_LINK_FONT_WEIGHT         nvarchar(25)
	, @EXIT_LINK_DECORATION          nvarchar(25)
	, @EXIT_LINK_BACKGROUND          nvarchar(25)
	, @REQUIRED_TEXT_COLOR           nvarchar(25)
	, @DESCRIPTION                   nvarchar(max)
	, @CUSTOM_STYLES                 nvarchar(max) = null
	, @PAGE_BACKGROUND_IMAGE         nvarchar(255) = null
	, @PAGE_BACKGROUND_POSITION      nvarchar(25) = null
	, @PAGE_BACKGROUND_REPEAT        nvarchar(25) = null
	, @PAGE_BACKGROUND_SIZE          nvarchar(25) = null
	)
as
  begin
	set nocount on
	
	if not exists(select * from SURVEY_THEMES where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into SURVEY_THEMES
			( ID                           
			, CREATED_BY                   
			, DATE_ENTERED                 
			, MODIFIED_USER_ID             
			, DATE_MODIFIED                
			, DATE_MODIFIED_UTC            
			, NAME                         
			, SURVEY_FONT_FAMILY           
			, LOGO_BACKGROUND              
			, SURVEY_BACKGROUND            
			, SURVEY_TITLE_TEXT_COLOR      
			, SURVEY_TITLE_FONT_SIZE       
			, SURVEY_TITLE_FONT_STYLE      
			, SURVEY_TITLE_FONT_WEIGHT     
			, SURVEY_TITLE_DECORATION      
			, SURVEY_TITLE_BACKGROUND      
			, PAGE_TITLE_TEXT_COLOR        
			, PAGE_TITLE_FONT_SIZE         
			, PAGE_TITLE_FONT_STYLE        
			, PAGE_TITLE_FONT_WEIGHT       
			, PAGE_TITLE_DECORATION        
			, PAGE_TITLE_BACKGROUND        
			, PAGE_DESCRIPTION_TEXT_COLOR  
			, PAGE_DESCRIPTION_FONT_SIZE   
			, PAGE_DESCRIPTION_FONT_STYLE  
			, PAGE_DESCRIPTION_FONT_WEIGHT 
			, PAGE_DESCRIPTION_DECORATION  
			, PAGE_DESCRIPTION_BACKGROUND  
			, QUESTION_HEADING_TEXT_COLOR  
			, QUESTION_HEADING_FONT_SIZE   
			, QUESTION_HEADING_FONT_STYLE  
			, QUESTION_HEADING_FONT_WEIGHT 
			, QUESTION_HEADING_DECORATION  
			, QUESTION_HEADING_BACKGROUND  
			, QUESTION_CHOICE_TEXT_COLOR   
			, QUESTION_CHOICE_FONT_SIZE    
			, QUESTION_CHOICE_FONT_STYLE   
			, QUESTION_CHOICE_FONT_WEIGHT  
			, QUESTION_CHOICE_DECORATION   
			, QUESTION_CHOICE_BACKGROUND   
			, PROGRESS_BAR_PAGE_WIDTH      
			, PROGRESS_BAR_COLOR           
			, PROGRESS_BAR_BORDER_COLOR    
			, PROGRESS_BAR_BORDER_WIDTH    
			, PROGRESS_BAR_TEXT_COLOR      
			, PROGRESS_BAR_FONT_SIZE       
			, PROGRESS_BAR_FONT_STYLE      
			, PROGRESS_BAR_FONT_WEIGHT     
			, PROGRESS_BAR_DECORATION      
			, PROGRESS_BAR_BACKGROUND      
			, ERROR_TEXT_COLOR             
			, ERROR_FONT_SIZE              
			, ERROR_FONT_STYLE             
			, ERROR_FONT_WEIGHT            
			, ERROR_DECORATION             
			, ERROR_BACKGROUND             
			, EXIT_LINK_TEXT_COLOR         
			, EXIT_LINK_FONT_SIZE          
			, EXIT_LINK_FONT_STYLE         
			, EXIT_LINK_FONT_WEIGHT        
			, EXIT_LINK_DECORATION         
			, EXIT_LINK_BACKGROUND         
			, REQUIRED_TEXT_COLOR          
			, CUSTOM_STYLES                
			, DESCRIPTION                  
			, PAGE_BACKGROUND_IMAGE        
			, PAGE_BACKGROUND_POSITION     
			, PAGE_BACKGROUND_REPEAT       
			, PAGE_BACKGROUND_SIZE         
			)
		values 	( @ID                           
			, @MODIFIED_USER_ID                   
			,  getdate()                    
			, @MODIFIED_USER_ID             
			,  getdate()                    
			,  getutcdate()                 
			, @NAME                         
			, @SURVEY_FONT_FAMILY           
			, @LOGO_BACKGROUND              
			, @SURVEY_BACKGROUND            
			, @SURVEY_TITLE_TEXT_COLOR      
			, @SURVEY_TITLE_FONT_SIZE       
			, @SURVEY_TITLE_FONT_STYLE      
			, @SURVEY_TITLE_FONT_WEIGHT     
			, @SURVEY_TITLE_DECORATION      
			, @SURVEY_TITLE_BACKGROUND      
			, @PAGE_TITLE_TEXT_COLOR        
			, @PAGE_TITLE_FONT_SIZE         
			, @PAGE_TITLE_FONT_STYLE        
			, @PAGE_TITLE_FONT_WEIGHT       
			, @PAGE_TITLE_DECORATION        
			, @PAGE_TITLE_BACKGROUND        
			, @PAGE_DESCRIPTION_TEXT_COLOR  
			, @PAGE_DESCRIPTION_FONT_SIZE   
			, @PAGE_DESCRIPTION_FONT_STYLE  
			, @PAGE_DESCRIPTION_FONT_WEIGHT 
			, @PAGE_DESCRIPTION_DECORATION  
			, @PAGE_DESCRIPTION_BACKGROUND  
			, @QUESTION_HEADING_TEXT_COLOR  
			, @QUESTION_HEADING_FONT_SIZE   
			, @QUESTION_HEADING_FONT_STYLE  
			, @QUESTION_HEADING_FONT_WEIGHT 
			, @QUESTION_HEADING_DECORATION  
			, @QUESTION_HEADING_BACKGROUND  
			, @QUESTION_CHOICE_TEXT_COLOR   
			, @QUESTION_CHOICE_FONT_SIZE    
			, @QUESTION_CHOICE_FONT_STYLE   
			, @QUESTION_CHOICE_FONT_WEIGHT  
			, @QUESTION_CHOICE_DECORATION   
			, @QUESTION_CHOICE_BACKGROUND   
			, @PROGRESS_BAR_PAGE_WIDTH      
			, @PROGRESS_BAR_COLOR           
			, @PROGRESS_BAR_BORDER_COLOR    
			, @PROGRESS_BAR_BORDER_WIDTH    
			, @PROGRESS_BAR_TEXT_COLOR      
			, @PROGRESS_BAR_FONT_SIZE       
			, @PROGRESS_BAR_FONT_STYLE      
			, @PROGRESS_BAR_FONT_WEIGHT     
			, @PROGRESS_BAR_DECORATION      
			, @PROGRESS_BAR_BACKGROUND      
			, @ERROR_TEXT_COLOR             
			, @ERROR_FONT_SIZE              
			, @ERROR_FONT_STYLE             
			, @ERROR_FONT_WEIGHT            
			, @ERROR_DECORATION             
			, @ERROR_BACKGROUND             
			, @EXIT_LINK_TEXT_COLOR         
			, @EXIT_LINK_FONT_SIZE          
			, @EXIT_LINK_FONT_STYLE         
			, @EXIT_LINK_FONT_WEIGHT        
			, @EXIT_LINK_DECORATION         
			, @EXIT_LINK_BACKGROUND         
			, @REQUIRED_TEXT_COLOR          
			, @CUSTOM_STYLES                
			, @DESCRIPTION                  
			, @PAGE_BACKGROUND_IMAGE        
			, @PAGE_BACKGROUND_POSITION     
			, @PAGE_BACKGROUND_REPEAT       
			, @PAGE_BACKGROUND_SIZE         
			);
	end else begin
		update SURVEY_THEMES
		   set MODIFIED_USER_ID              = @MODIFIED_USER_ID             
		     , DATE_MODIFIED                 =  getdate()                    
		     , DATE_MODIFIED_UTC             =  getutcdate()                 
		     , NAME                          = @NAME                         
		     , SURVEY_FONT_FAMILY            = @SURVEY_FONT_FAMILY           
		     , LOGO_BACKGROUND               = @LOGO_BACKGROUND              
		     , SURVEY_BACKGROUND             = @SURVEY_BACKGROUND            
		     , SURVEY_TITLE_TEXT_COLOR       = @SURVEY_TITLE_TEXT_COLOR      
		     , SURVEY_TITLE_FONT_SIZE        = @SURVEY_TITLE_FONT_SIZE       
		     , SURVEY_TITLE_FONT_STYLE       = @SURVEY_TITLE_FONT_STYLE      
		     , SURVEY_TITLE_FONT_WEIGHT      = @SURVEY_TITLE_FONT_WEIGHT     
		     , SURVEY_TITLE_DECORATION       = @SURVEY_TITLE_DECORATION      
		     , SURVEY_TITLE_BACKGROUND       = @SURVEY_TITLE_BACKGROUND      
		     , PAGE_TITLE_TEXT_COLOR         = @PAGE_TITLE_TEXT_COLOR        
		     , PAGE_TITLE_FONT_SIZE          = @PAGE_TITLE_FONT_SIZE         
		     , PAGE_TITLE_FONT_STYLE         = @PAGE_TITLE_FONT_STYLE        
		     , PAGE_TITLE_FONT_WEIGHT        = @PAGE_TITLE_FONT_WEIGHT       
		     , PAGE_TITLE_DECORATION         = @PAGE_TITLE_DECORATION        
		     , PAGE_TITLE_BACKGROUND         = @PAGE_TITLE_BACKGROUND        
		     , PAGE_DESCRIPTION_TEXT_COLOR   = @PAGE_DESCRIPTION_TEXT_COLOR  
		     , PAGE_DESCRIPTION_FONT_SIZE    = @PAGE_DESCRIPTION_FONT_SIZE   
		     , PAGE_DESCRIPTION_FONT_STYLE   = @PAGE_DESCRIPTION_FONT_STYLE  
		     , PAGE_DESCRIPTION_FONT_WEIGHT  = @PAGE_DESCRIPTION_FONT_WEIGHT 
		     , PAGE_DESCRIPTION_DECORATION   = @PAGE_DESCRIPTION_DECORATION  
		     , PAGE_DESCRIPTION_BACKGROUND   = @PAGE_DESCRIPTION_BACKGROUND  
		     , QUESTION_HEADING_TEXT_COLOR   = @QUESTION_HEADING_TEXT_COLOR  
		     , QUESTION_HEADING_FONT_SIZE    = @QUESTION_HEADING_FONT_SIZE   
		     , QUESTION_HEADING_FONT_STYLE   = @QUESTION_HEADING_FONT_STYLE  
		     , QUESTION_HEADING_FONT_WEIGHT  = @QUESTION_HEADING_FONT_WEIGHT 
		     , QUESTION_HEADING_DECORATION   = @QUESTION_HEADING_DECORATION  
		     , QUESTION_HEADING_BACKGROUND   = @QUESTION_HEADING_BACKGROUND  
		     , QUESTION_CHOICE_TEXT_COLOR    = @QUESTION_CHOICE_TEXT_COLOR   
		     , QUESTION_CHOICE_FONT_SIZE     = @QUESTION_CHOICE_FONT_SIZE    
		     , QUESTION_CHOICE_FONT_STYLE    = @QUESTION_CHOICE_FONT_STYLE   
		     , QUESTION_CHOICE_FONT_WEIGHT   = @QUESTION_CHOICE_FONT_WEIGHT  
		     , QUESTION_CHOICE_DECORATION    = @QUESTION_CHOICE_DECORATION   
		     , QUESTION_CHOICE_BACKGROUND    = @QUESTION_CHOICE_BACKGROUND   
		     , PROGRESS_BAR_PAGE_WIDTH       = @PROGRESS_BAR_PAGE_WIDTH      
		     , PROGRESS_BAR_COLOR            = @PROGRESS_BAR_COLOR           
		     , PROGRESS_BAR_BORDER_COLOR     = @PROGRESS_BAR_BORDER_COLOR    
		     , PROGRESS_BAR_BORDER_WIDTH     = @PROGRESS_BAR_BORDER_WIDTH    
		     , PROGRESS_BAR_TEXT_COLOR       = @PROGRESS_BAR_TEXT_COLOR      
		     , PROGRESS_BAR_FONT_SIZE        = @PROGRESS_BAR_FONT_SIZE       
		     , PROGRESS_BAR_FONT_STYLE       = @PROGRESS_BAR_FONT_STYLE      
		     , PROGRESS_BAR_FONT_WEIGHT      = @PROGRESS_BAR_FONT_WEIGHT     
		     , PROGRESS_BAR_DECORATION       = @PROGRESS_BAR_DECORATION      
		     , PROGRESS_BAR_BACKGROUND       = @PROGRESS_BAR_BACKGROUND      
		     , ERROR_TEXT_COLOR              = @ERROR_TEXT_COLOR             
		     , ERROR_FONT_SIZE               = @ERROR_FONT_SIZE              
		     , ERROR_FONT_STYLE              = @ERROR_FONT_STYLE             
		     , ERROR_FONT_WEIGHT             = @ERROR_FONT_WEIGHT            
		     , ERROR_DECORATION              = @ERROR_DECORATION             
		     , ERROR_BACKGROUND              = @ERROR_BACKGROUND             
		     , EXIT_LINK_TEXT_COLOR          = @EXIT_LINK_TEXT_COLOR         
		     , EXIT_LINK_FONT_SIZE           = @EXIT_LINK_FONT_SIZE          
		     , EXIT_LINK_FONT_STYLE          = @EXIT_LINK_FONT_STYLE         
		     , EXIT_LINK_FONT_WEIGHT         = @EXIT_LINK_FONT_WEIGHT        
		     , EXIT_LINK_DECORATION          = @EXIT_LINK_DECORATION         
		     , EXIT_LINK_BACKGROUND          = @EXIT_LINK_BACKGROUND         
		     , REQUIRED_TEXT_COLOR           = @REQUIRED_TEXT_COLOR          
		     , CUSTOM_STYLES                 = @CUSTOM_STYLES                
		     , DESCRIPTION                   = @DESCRIPTION                  
		     , PAGE_BACKGROUND_IMAGE         = @PAGE_BACKGROUND_IMAGE        
		     , PAGE_BACKGROUND_POSITION      = @PAGE_BACKGROUND_POSITION     
		     , PAGE_BACKGROUND_REPEAT        = @PAGE_BACKGROUND_REPEAT       
		     , PAGE_BACKGROUND_SIZE          = @PAGE_BACKGROUND_SIZE         
		 where ID                            = @ID                           ;
	end -- if;
  end
GO

Grant Execute on dbo.spSURVEY_THEMES_Update to public;
GO

