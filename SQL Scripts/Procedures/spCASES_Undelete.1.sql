if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCASES_Undelete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCASES_Undelete;
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
Create Procedure dbo.spCASES_Undelete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @AUDIT_TOKEN      varchar(255)
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		update DOCUMENTS_CASES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CASE_ID          = @ID
		   and DELETED          = 1
		   and ID in (select ID from DOCUMENTS_CASES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CASE_ID = @ID);
	-- END Oracle Exception
	
	-- 04/24/2018 Paul.  ACCOUNTS_CASES use was ended back in 2005. The table needs to be removed as it causes problems with archiving. 
	/*
	-- BEGIN Oracle Exception
		update ACCOUNTS_CASES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CASE_ID          = @ID
		   and DELETED          = 1
		   and ID in (select ID from ACCOUNTS_CASES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CASE_ID = @ID);
	-- END Oracle Exception
	*/
	-- BEGIN Oracle Exception
		update CASES_BUGS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CASE_ID          = @ID
		   and DELETED          = 1
		   and ID in (select ID from CASES_BUGS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CASE_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update CONTACTS_CASES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CASE_ID          = @ID
		   and DELETED          = 1
		   and ID in (select ID from CONTACTS_CASES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CASE_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update EMAILS_CASES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CASE_ID          = @ID
		   and DELETED          = 1
		   and ID in (select ID from EMAILS_CASES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CASE_ID = @ID);
	-- END Oracle Exception
	
	exec dbo.spPARENT_Undelete @ID, @MODIFIED_USER_ID, @AUDIT_TOKEN, N'Cases';
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update CASES_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from CASES
			  where ID               = @ID
			    and DELETED          = 1
			    and ID in (select ID from CASES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID)
			);
		update CASES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID               = @ID
		   and DELETED          = 1
		   and ID in (select ID from CASES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID);
	-- END Oracle Exception
	
  end
GO

Grant Execute on dbo.spCASES_Undelete to public;
GO

