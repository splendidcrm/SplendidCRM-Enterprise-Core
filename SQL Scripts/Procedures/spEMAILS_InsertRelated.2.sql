if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEMAILS_InsertRelated' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEMAILS_InsertRelated;
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
-- 03/23/2016 Paul.  Relationship used with OfficeAddin. 
Create Procedure dbo.spEMAILS_InsertRelated
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @PARENT_TYPE       nvarchar(25)
	, @PARENT_ID         uniqueidentifier
	)
as
  begin
	set nocount on

	if dbo.fnIsEmptyGuid(@PARENT_ID) = 0 begin -- then
		if          @PARENT_TYPE = N'Accounts' begin -- then
			exec dbo.spEMAILS_ACCOUNTS_Update      @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Bugs' begin -- then
			exec dbo.spEMAILS_BUGS_Update          @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Cases' begin -- then
			exec dbo.spEMAILS_CASES_Update         @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Contacts' begin -- then
			exec dbo.spEMAILS_CONTACTS_Update      @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Leads' begin -- then
			exec dbo.spEMAILS_LEADS_Update         @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Opportunities' begin -- then
			exec dbo.spEMAILS_OPPORTUNITIES_Update @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Project' begin -- then
			exec dbo.spEMAILS_PROJECTS_Update      @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'ProjectTask' begin -- then
			exec dbo.spEMAILS_PROJECT_TASKS_Update @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Prospects' begin -- then
			exec dbo.spEMAILS_PROSPECTS_Update     @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Quotes' begin -- then
			exec dbo.spEMAILS_QUOTES_Update        @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Tasks' begin -- then
			exec dbo.spEMAILS_TASKS_Update         @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Users' begin -- then
			exec dbo.spEMAILS_USERS_Update         @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Contracts' begin -- then
			exec dbo.spEMAILS_CONTRACTS_Update     @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Orders' begin -- then
			exec dbo.spEMAILS_ORDERS_Update        @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Invoices' begin -- then
			exec dbo.spEMAILS_INVOICES_Update      @MODIFIED_USER_ID, @ID, @PARENT_ID;
		end -- if;
		-- 03/23/2016 Paul.  Archiving an email is not necessarily the last activity. 
		-- exec dbo.spPARENT_UpdateLastActivity @MODIFIED_USER_ID, @PARENT_ID, @PARENT_TYPE;
	end -- if;
  end
GO

Grant Execute on dbo.spEMAILS_InsertRelated to public;
GO

