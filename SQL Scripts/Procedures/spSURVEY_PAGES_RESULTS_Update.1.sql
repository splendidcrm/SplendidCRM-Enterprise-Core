if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSURVEY_PAGES_RESULTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSURVEY_PAGES_RESULTS_Update;
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
Create Procedure dbo.spSURVEY_PAGES_RESULTS_Update
	( @ID                  uniqueidentifier output
	, @MODIFIED_USER_ID    uniqueidentifier
	, @SURVEY_RESULT_ID    uniqueidentifier
	, @SURVEY_ID           uniqueidentifier
	, @SURVEY_PAGE_ID      uniqueidentifier
	, @RAW_CONTENT         nvarchar(max)
	)
as
  begin
	set nocount on
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		-- BEGIN Oracle Exception
			select @ID = ID
			  from SURVEY_PAGES_RESULTS
			 where SURVEY_RESULT_ID   = @SURVEY_RESULT_ID
			   and SURVEY_ID          = @SURVEY_ID
			   and SURVEY_PAGE_ID     = @SURVEY_PAGE_ID
			   and DELETED            = 0;
		-- END Oracle Exception
	end -- if;
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into SURVEY_PAGES_RESULTS
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, DATE_MODIFIED_UTC  
			, SURVEY_RESULT_ID   
			, SURVEY_ID          
			, SURVEY_PAGE_ID     
			, RAW_CONTENT        
			)
		values 	( @ID                 
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			,  getutcdate()       
			, @SURVEY_RESULT_ID   
			, @SURVEY_ID          
			, @SURVEY_PAGE_ID     
			, @RAW_CONTENT        
			);
	end else begin
		update SURVEY_PAGES_RESULTS
		   set MODIFIED_USER_ID    = @MODIFIED_USER_ID   
		     , DATE_MODIFIED       =  getdate()          
		     , DATE_MODIFIED_UTC   =  getutcdate()       
		     , RAW_CONTENT         = @RAW_CONTENT        
		 where ID                  = @ID                 ;
	end -- if;
  end
GO

Grant Execute on dbo.spSURVEY_PAGES_RESULTS_Update to public;
GO

