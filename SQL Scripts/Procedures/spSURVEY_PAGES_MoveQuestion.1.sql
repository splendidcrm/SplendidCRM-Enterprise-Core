if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSURVEY_PAGES_MoveQuestion' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSURVEY_PAGES_MoveQuestion;
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
Create Procedure dbo.spSURVEY_PAGES_MoveQuestion
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @OLD_NUMBER       int
	, @NEW_NUMBER       int
	)
as
  begin
	set nocount on
	
	declare @SWAP_ID    uniqueidentifier;
	-- BEGIN Oracle Exception
		select @SWAP_ID = ID
		  from SURVEY_PAGES_QUESTIONS
		 where SURVEY_PAGE_ID  = @ID
		   and QUESTION_NUMBER = @OLD_NUMBER
		   and DELETED         = 0;
	-- END Oracle Exception

	if dbo.fnIsEmptyGuid(@SWAP_ID) = 0 and (@OLD_NUMBER > @NEW_NUMBER or @OLD_NUMBER < @NEW_NUMBER) begin -- then
		if @OLD_NUMBER < @NEW_NUMBER begin -- then
			update SURVEY_PAGES_QUESTIONS
			   set QUESTION_NUMBER   = QUESTION_NUMBER - 1
			     , DATE_MODIFIED     = getdate()
			     , DATE_MODIFIED_UTC = getutcdate()
			     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
			 where SURVEY_PAGE_ID    = @ID
			   and QUESTION_NUMBER  >= @OLD_NUMBER
			   and QUESTION_NUMBER  <= @NEW_NUMBER
			   and DELETED           = 0;
		end else if @OLD_NUMBER > @NEW_NUMBER begin -- then
			update SURVEY_PAGES_QUESTIONS
			   set QUESTION_NUMBER   = QUESTION_NUMBER + 1
			     , DATE_MODIFIED     = getdate()
			     , DATE_MODIFIED_UTC = getutcdate()
			     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
			 where SURVEY_PAGE_ID    = @ID
			   and QUESTION_NUMBER  >= @NEW_NUMBER
			   and QUESTION_NUMBER  <= @OLD_NUMBER
			   and DELETED           = 0;
		end -- if;
		update SURVEY_PAGES_QUESTIONS
		   set QUESTION_NUMBER   = @NEW_NUMBER
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where ID                = @SWAP_ID
		   and DELETED           = 0;
		
		exec dbo.spSURVEY_PAGES_ReorderQuestions @ID, @MODIFIED_USER_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spSURVEY_PAGES_MoveQuestion to public;
GO

