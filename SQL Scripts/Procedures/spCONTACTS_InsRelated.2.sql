if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCONTACTS_InsRelated' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCONTACTS_InsRelated;
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
Create Procedure dbo.spCONTACTS_InsRelated
	( @MODIFIED_USER_ID  uniqueidentifier
	, @CONTACT_ID        uniqueidentifier
	, @PARENT_TYPE       nvarchar(25)
	, @PARENT_ID         uniqueidentifier
	)
as
  begin
	set nocount on
	
	if dbo.fnIsEmptyGuid(@PARENT_ID) = 0 begin -- then
		if @PARENT_TYPE = N'Accounts' begin -- then
			exec dbo.spACCOUNTS_CONTACTS_Update       @MODIFIED_USER_ID, @PARENT_ID , @CONTACT_ID;
		end else if @PARENT_TYPE = N'Calls' begin -- then
			exec dbo.spCALLS_CONTACTS_Update          @MODIFIED_USER_ID, @PARENT_ID , @CONTACT_ID, null, null;
		end else if @PARENT_TYPE = N'Bugs' begin -- then
			exec dbo.spCONTACTS_BUGS_Update           @MODIFIED_USER_ID, @CONTACT_ID, @PARENT_ID, null;
		end else if @PARENT_TYPE = N'Cases' begin -- then
			exec dbo.spCONTACTS_CASES_Update          @MODIFIED_USER_ID, @CONTACT_ID, @PARENT_ID, null;
		end else if @PARENT_TYPE = N'Contacts' begin -- then
			exec dbo.spCONTACTS_REPORTS_TO_Update     @MODIFIED_USER_ID, @CONTACT_ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Contracts' begin -- then
			exec dbo.spCONTRACTS_CONTACTS_Update      @MODIFIED_USER_ID, @PARENT_ID , @CONTACT_ID;
		end else if @PARENT_TYPE = N'Emails' begin -- then
			exec dbo.spEMAILS_CONTACTS_Update         @MODIFIED_USER_ID, @PARENT_ID , @CONTACT_ID;
		end else if @PARENT_TYPE = N'Invoices' begin -- then
			exec dbo.spINVOICES_CONTACTS_Update       @MODIFIED_USER_ID, @PARENT_ID , @CONTACT_ID, N'Bill To';
		end else if @PARENT_TYPE = N'Meetings' begin -- then
			exec dbo.spMEETINGS_CONTACTS_Update       @MODIFIED_USER_ID, @PARENT_ID , @CONTACT_ID, null, null;
		end else if @PARENT_TYPE = N'Opportunities' begin -- then
			exec dbo.spOPPORTUNITIES_CONTACTS_Update  @MODIFIED_USER_ID, @PARENT_ID , @CONTACT_ID, null;
		end else if @PARENT_TYPE = N'Orders' begin -- then
			exec dbo.spORDERS_CONTACTS_Update         @MODIFIED_USER_ID, @PARENT_ID , @CONTACT_ID, null;
		end else if @PARENT_TYPE = N'ProspectLists' begin -- then
			exec dbo.spPROSPECT_LISTS_CONTACTS_Update @MODIFIED_USER_ID, @PARENT_ID , @CONTACT_ID;
		end else if @PARENT_TYPE = N'Quotes' begin -- then
			exec dbo.spQUOTES_CONTACTS_Update         @MODIFIED_USER_ID, @PARENT_ID , @CONTACT_ID, null;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spCONTACTS_InsRelated to public;
GO

