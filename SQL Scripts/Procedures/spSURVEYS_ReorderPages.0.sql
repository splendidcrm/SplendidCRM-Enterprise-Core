if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSURVEYS_ReorderPages' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSURVEYS_ReorderPages;
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
Create Procedure dbo.spSURVEYS_ReorderPages
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @SURVEY_PAGE_ID  uniqueidentifier;
	declare @PAGE_NUMBER_OLD int;
	declare @PAGE_NUMBER_NEW int;

-- #if SQL_Server /*
	declare PAGE_CURSOR cursor for
	select ID
	     , PAGE_NUMBER
	  from SURVEY_PAGES
	 where SURVEY_ID = @ID
	   and DELETED   = 0
	 order by PAGE_NUMBER, DATE_ENTERED;
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

	set @PAGE_NUMBER_NEW = 1;
	open PAGE_CURSOR;
	fetch next from PAGE_CURSOR into @SURVEY_PAGE_ID, @PAGE_NUMBER_OLD;
	while @@FETCH_STATUS = 0 begin -- do
		if @PAGE_NUMBER_OLD != @PAGE_NUMBER_NEW begin -- then
			print N'Correcting tab order of Survey ' + cast(@ID as char(36)) + N' (' + cast(@PAGE_NUMBER_NEW as varchar(10)) + N')';
			update SURVEY_PAGES
			   set PAGE_NUMBER       = @PAGE_NUMBER_NEW
			     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
			     , DATE_MODIFIED     = getdate()
			     , DATE_MODIFIED_UTC = getutcdate()
			 where ID                = @SURVEY_PAGE_ID;
		end -- if;
		set @PAGE_NUMBER_NEW = @PAGE_NUMBER_NEW + 1;
		fetch next from PAGE_CURSOR into @SURVEY_PAGE_ID, @PAGE_NUMBER_OLD;
/* -- #if Oracle
		IF PAGE_CURSOR%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close PAGE_CURSOR;

	deallocate PAGE_CURSOR;
  end
GO

Grant Execute on dbo.spSURVEYS_ReorderPages to public;
GO

