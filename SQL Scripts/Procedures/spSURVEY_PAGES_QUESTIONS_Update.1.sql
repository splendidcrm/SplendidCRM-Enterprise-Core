if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSURVEY_PAGES_QUESTIONS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSURVEY_PAGES_QUESTIONS_Update;
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
Create Procedure dbo.spSURVEY_PAGES_QUESTIONS_Update
	( @MODIFIED_USER_ID   uniqueidentifier
	, @SURVEY_PAGE_ID     uniqueidentifier
	, @SURVEY_QUESTION_ID uniqueidentifier
	, @QUESTION_NUMBER    int
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	declare @TEMP_QUESTION_NUMBER int;
	set @TEMP_QUESTION_NUMBER = @QUESTION_NUMBER;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from SURVEY_PAGES_QUESTIONS
		 where SURVEY_PAGE_ID     = @SURVEY_PAGE_ID
		   and SURVEY_QUESTION_ID = @SURVEY_QUESTION_ID
		   and DELETED            = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		if @QUESTION_NUMBER = 0 begin -- then
			-- BEGIN Oracle Exception
				select @TEMP_QUESTION_NUMBER = isnull(max(QUESTION_NUMBER), 0) + 1
				  from SURVEY_PAGES_QUESTIONS
				 where SURVEY_PAGE_ID   = @SURVEY_PAGE_ID
				   and DELETED          = 0              ;
			-- END Oracle Exception
		end -- if;
		set @ID = newid();
		insert into SURVEY_PAGES_QUESTIONS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, SURVEY_PAGE_ID    
			, SURVEY_QUESTION_ID
			, QUESTION_NUMBER   
			)
		values
			( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @SURVEY_PAGE_ID    
			, @SURVEY_QUESTION_ID
			, @TEMP_QUESTION_NUMBER
			);
		
		exec dbo.spSURVEY_PAGES_ReorderQuestions @SURVEY_PAGE_ID, @MODIFIED_USER_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spSURVEY_PAGES_QUESTIONS_Update to public;
GO

