if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSURVEY_PAGES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSURVEY_PAGES_Update;
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
Create Procedure dbo.spSURVEY_PAGES_Update
	( @ID                      uniqueidentifier output
	, @MODIFIED_USER_ID        uniqueidentifier
	, @SURVEY_ID               uniqueidentifier
	, @NAME                    nvarchar(1000)
	, @QUESTION_RANDOMIZATION  nvarchar(25)
	, @DESCRIPTION             nvarchar(max)
	)
as
  begin
	set nocount on
	
	declare @PAGE_NUMBER int;
	if not exists(select * from SURVEY_PAGES where ID = @ID) begin -- then
		-- BEGIN Oracle Exception
			select @PAGE_NUMBER = isnull(max(PAGE_NUMBER), 0) + 1
			  from SURVEY_PAGES
			 where SURVEY_ID    = @SURVEY_ID
			   and DELETED      = 0         ;
		-- END Oracle Exception
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into SURVEY_PAGES
			( ID                     
			, CREATED_BY             
			, DATE_ENTERED           
			, MODIFIED_USER_ID       
			, DATE_MODIFIED          
			, DATE_MODIFIED_UTC      
			, SURVEY_ID              
			, NAME                   
			, PAGE_NUMBER            
			, QUESTION_RANDOMIZATION 
			, DESCRIPTION            
			)
		values 	( @ID                     
			, @MODIFIED_USER_ID             
			,  getdate()              
			, @MODIFIED_USER_ID       
			,  getdate()              
			,  getutcdate()           
			, @SURVEY_ID              
			, @NAME                   
			, @PAGE_NUMBER            
			, @QUESTION_RANDOMIZATION 
			, @DESCRIPTION            
			);
	end else begin
		update SURVEY_PAGES
		   set MODIFIED_USER_ID        = @MODIFIED_USER_ID       
		     , DATE_MODIFIED           =  getdate()              
		     , DATE_MODIFIED_UTC       =  getutcdate()           
		     , NAME                    = @NAME                   
		     , QUESTION_RANDOMIZATION  = @QUESTION_RANDOMIZATION 
		     , DESCRIPTION             = @DESCRIPTION            
		 where ID                      = @ID                     ;
	end -- if;

	exec dbo.spSURVEYS_ReorderPages @SURVEY_ID, @MODIFIED_USER_ID;
  end
GO

Grant Execute on dbo.spSURVEY_PAGES_Update to public;
GO

