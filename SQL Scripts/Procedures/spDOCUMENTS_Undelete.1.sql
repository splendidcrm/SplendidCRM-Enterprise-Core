if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDOCUMENTS_Undelete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDOCUMENTS_Undelete;
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
-- 01/24/2015 Paul.  Select was pulling from CONTACTS_AUDIT not DOCUMENTS_AUDIT. 
Create Procedure dbo.spDOCUMENTS_Undelete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @AUDIT_TOKEN      varchar(255)
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		update ACCOUNTS_DOCUMENTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where DOCUMENT_ID      = @ID
		   and DELETED          = 1
		   and ID in (select ID from ACCOUNTS_DOCUMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and DOCUMENT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update CONTACTS_DOCUMENTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where DOCUMENT_ID      = @ID
		   and DELETED          = 1
		   and ID in (select ID from CONTACTS_DOCUMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and DOCUMENT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update DOCUMENTS_BUGS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where DOCUMENT_ID      = @ID
		   and DELETED          = 1
		   and ID in (select ID from DOCUMENTS_BUGS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and DOCUMENT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update DOCUMENTS_CASES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where DOCUMENT_ID      = @ID
		   and DELETED          = 1
		   and ID in (select ID from DOCUMENTS_CASES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and DOCUMENT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update LEADS_DOCUMENTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where DOCUMENT_ID      = @ID
		   and DELETED          = 1
		   and ID in (select ID from LEADS_DOCUMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and DOCUMENT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update OPPORTUNITIES_DOCUMENTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where DOCUMENT_ID      = @ID
		   and DELETED          = 1
		   and ID in (select ID from OPPORTUNITIES_DOCUMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and DOCUMENT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update CONTRACTS_DOCUMENTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where DOCUMENT_ID      = @ID
		   and DELETED          = 1
		   and ID in (select ID from CONTRACTS_DOCUMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and DOCUMENT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update CONTRACT_TYPES_DOCUMENTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where DOCUMENT_ID      = @ID
		   and DELETED          = 1
		   and ID in (select ID from CONTRACT_TYPES_DOCUMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and DOCUMENT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update DOCUMENTS_QUOTES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where DOCUMENT_ID      = @ID
		   and DELETED          = 1
		   and ID in (select ID from DOCUMENTS_QUOTES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and DOCUMENT_ID = @ID);
	-- END Oracle Exception
	
	-- 08/07/2013 Paul.  Document Revisions are not tracked, so we cannot rely upon the audit token. 
	-- Just undelete all revisions as it is unlikely to have very many incorrect undeleted revisions. 
	-- BEGIN Oracle Exception
		update DOCUMENT_REVISIONS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where DOCUMENT_ID      = @ID
		   and DELETED          = 1;
	-- END Oracle Exception

	-- 01/24/2015 Paul.  Select was pulling from CONTACTS_AUDIT not DOCUMENTS_AUDIT. 
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update DOCUMENTS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from DOCUMENTS
			  where ID               = @ID
			    and DELETED          = 1
			    and ID in (select ID from DOCUMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID)
			);
		update DOCUMENTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID               = @ID
		   and DELETED          = 1
		   and ID in (select ID from DOCUMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID);
	-- END Oracle Exception
  end
GO

Grant Execute on dbo.spDOCUMENTS_Undelete to public;
GO

