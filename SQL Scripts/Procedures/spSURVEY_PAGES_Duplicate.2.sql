if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSURVEY_PAGES_Duplicate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSURVEY_PAGES_Duplicate;
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
Create Procedure dbo.spSURVEY_PAGES_Duplicate
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @DUPLICATE_ID      uniqueidentifier
	, @SURVEY_ID         uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @SURVEY_PAGES_QUESTION_ID uniqueidentifier;
	declare @SURVEY_QUESTION_ID       uniqueidentifier;
	declare @QUESTION_NUMBER          int;

	
-- #if SQL_Server /*
	declare SURVEY_QUESTION_CURSOR cursor for
	select SURVEY_QUESTION_ID
	     , QUESTION_NUMBER
	  from SURVEY_PAGES_QUESTIONS
	 where SURVEY_PAGE_ID = @DUPLICATE_ID
	   and DELETED        = 0
	 order by QUESTION_NUMBER;
-- #endif SQL_Server */

/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	set @ID = null;
	if not exists(select * from SURVEY_PAGES where ID = @DUPLICATE_ID and DELETED = 0) begin -- then
		raiserror(N'Cannot duplicate non-existent survey page.', 16, 1);
		return;
	end -- if;

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
	select	  @ID                    
		, @MODIFIED_USER_ID      
		,  getdate()             
		, @MODIFIED_USER_ID      
		,  getdate()             
		,  getutcdate()          
		, @SURVEY_ID             
		,  NAME                  
		,  PAGE_NUMBER           
		,  QUESTION_RANDOMIZATION
		,  DESCRIPTION           
	  from SURVEY_PAGES
	 where ID = @DUPLICATE_ID;

	open SURVEY_QUESTION_CURSOR;
	fetch next from SURVEY_QUESTION_CURSOR into @SURVEY_QUESTION_ID, @QUESTION_NUMBER;
	while @@FETCH_STATUS = 0 begin -- do
		set @SURVEY_PAGES_QUESTION_ID = null;
		exec dbo.spSURVEY_PAGES_QUESTIONS_Update @MODIFIED_USER_ID, @ID, @SURVEY_QUESTION_ID, @QUESTION_NUMBER;
		fetch next from SURVEY_QUESTION_CURSOR into @SURVEY_QUESTION_ID, @QUESTION_NUMBER;
/* -- #if Oracle
		IF SURVEY_QUESTION_CURSOR%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close SURVEY_QUESTION_CURSOR;
	deallocate SURVEY_QUESTION_CURSOR;

  end
GO
 
Grant Execute on dbo.spSURVEY_PAGES_Duplicate to public;
GO

