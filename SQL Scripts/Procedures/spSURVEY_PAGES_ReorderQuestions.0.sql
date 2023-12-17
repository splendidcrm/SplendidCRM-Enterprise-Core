if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSURVEY_PAGES_ReorderQuestions' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSURVEY_PAGES_ReorderQuestions;
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
Create Procedure dbo.spSURVEY_PAGES_ReorderQuestions
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on

	declare @SURVEY_PAGES_QUESTION_ID uniqueidentifier;
	declare @QUESTION_NUMBER_OLD      int;
	declare @QUESTION_NUMBER_NEW      int;

-- #if SQL_Server /*
	declare QUESTION_CURSOR cursor for
	select ID
	     , QUESTION_NUMBER
	  from SURVEY_PAGES_QUESTIONS
	 where SURVEY_PAGE_ID = @ID
	   and DELETED        = 0
	 order by QUESTION_NUMBER, DATE_ENTERED;
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

	set @QUESTION_NUMBER_NEW = 1;
	open QUESTION_CURSOR;
	fetch next from QUESTION_CURSOR into @SURVEY_PAGES_QUESTION_ID, @QUESTION_NUMBER_OLD;
	while @@FETCH_STATUS = 0 begin -- do
		if @QUESTION_NUMBER_OLD != @QUESTION_NUMBER_NEW begin -- then
			print N'Correcting tab order of Survey Page ' + cast(@ID as char(36)) + N' (' + cast(@QUESTION_NUMBER_NEW as varchar(10)) + N')';
			update SURVEY_PAGES_QUESTIONS
			   set QUESTION_NUMBER   = @QUESTION_NUMBER_NEW
			     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
			     , DATE_MODIFIED     = getdate()
			     , DATE_MODIFIED_UTC = getutcdate()
			 where ID                = @SURVEY_PAGES_QUESTION_ID;
		end -- if;
		set @QUESTION_NUMBER_NEW = @QUESTION_NUMBER_NEW + 1;
		fetch next from QUESTION_CURSOR into @SURVEY_PAGES_QUESTION_ID, @QUESTION_NUMBER_OLD;
/* -- #if Oracle
		IF QUESTION_CURSOR%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close QUESTION_CURSOR;

	deallocate QUESTION_CURSOR;
  end
GO

Grant Execute on dbo.spSURVEY_PAGES_ReorderQuestions to public;
GO

