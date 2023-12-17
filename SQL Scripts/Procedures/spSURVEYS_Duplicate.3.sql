if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSURVEYS_Duplicate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSURVEYS_Duplicate;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spSURVEYS_Duplicate
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @DUPLICATE_ID      uniqueidentifier
	, @COPY_OF           nvarchar(50)
	)
as
  begin
	set nocount on

	declare @TEMP_NAME          nvarchar(150);
	declare @SURVEY_PAGE_ID     uniqueidentifier;
	declare @NEW_SURVEY_PAGE_ID uniqueidentifier;

	
-- #if SQL_Server /*
	declare SURVEY_PAGE_CURSOR cursor for
	select ID
	  from SURVEY_PAGES
	 where SURVEY_ID = @DUPLICATE_ID
	   and DELETED   = 0
	 order by PAGE_NUMBER;
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

	if not exists(select * from SURVEYS where ID = @DUPLICATE_ID and DELETED = 0) begin -- then
		raiserror(N'Cannot duplicate non-existent survey.  ', 16, 1);
		return;
	end -- if;

	select @TEMP_NAME = replace(isnull(@COPY_OF, N'{0}'), N'{0}', NAME)
	  from SURVEYS
	 where ID      = @DUPLICATE_ID
	   and DELETED = 0;

	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
	end -- if;
	insert into SURVEYS
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
		, STATUS            
		, SURVEY_STYLE      
		, PAGE_RANDOMIZATION
		, SURVEY_THEME_ID   
		, DESCRIPTION       
		, ASSIGNED_SET_ID   
		)
	select
		  @ID               
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @MODIFIED_USER_ID 
		,  getdate()        
		,  getutcdate()     
		, ASSIGNED_USER_ID  
		, TEAM_ID           
		, TEAM_SET_ID       
		, @TEMP_NAME        
		, STATUS            
		, SURVEY_STYLE      
		, PAGE_RANDOMIZATION
		, SURVEY_THEME_ID   
		, DESCRIPTION       
		, ASSIGNED_SET_ID   
	  from SURVEYS
	 where ID = @DUPLICATE_ID;

	insert into SURVEYS_CSTM ( ID_C ) values ( @ID );

	open SURVEY_PAGE_CURSOR;
	fetch next from SURVEY_PAGE_CURSOR into @SURVEY_PAGE_ID;
	while @@FETCH_STATUS = 0 begin -- do
		set @NEW_SURVEY_PAGE_ID = null;
		exec dbo.spSURVEY_PAGES_Duplicate @NEW_SURVEY_PAGE_ID out, @MODIFIED_USER_ID, @SURVEY_PAGE_ID, @ID;
		fetch next from SURVEY_PAGE_CURSOR into @SURVEY_PAGE_ID;
/* -- #if Oracle
		IF SURVEY_PAGE_CURSOR%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close SURVEY_PAGE_CURSOR;
	deallocate SURVEY_PAGE_CURSOR;

  end
GO

Grant Execute on dbo.spSURVEYS_Duplicate to public;
GO

