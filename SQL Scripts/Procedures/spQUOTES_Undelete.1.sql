if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spQUOTES_Undelete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spQUOTES_Undelete;
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
Create Procedure dbo.spQUOTES_Undelete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @AUDIT_TOKEN      varchar(255)
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		update DOCUMENTS_QUOTES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where QUOTE_ID         = @ID
		   and DELETED          = 1
		   and ID in (select ID from DOCUMENTS_QUOTES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and QUOTE_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update QUOTES_LINE_ITEMS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from QUOTES_LINE_ITEMS
			 where QUOTE_ID         = @ID
			   and DELETED          = 1
			   and ID in (select ID from QUOTES_LINE_ITEMS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and QUOTE_ID = @ID)
			);
		update QUOTES_LINE_ITEMS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where QUOTE_ID         = @ID
		   and DELETED          = 1
		   and ID in (select ID from QUOTES_LINE_ITEMS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and QUOTE_ID = @ID);
	-- END Oracle Exception

	-- BEGIN Oracle Exception
		update QUOTES_OPPORTUNITIES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where QUOTE_ID         = @ID
		   and DELETED          = 1
		   and ID in (select ID from QUOTES_OPPORTUNITIES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and QUOTE_ID = @ID);
	-- END Oracle Exception

	-- BEGIN Oracle Exception
		update QUOTES_ACCOUNTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where QUOTE_ID         = @ID
		   and DELETED          = 1
		   and ID in (select ID from QUOTES_ACCOUNTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and QUOTE_ID = @ID);
	-- END Oracle Exception

	-- BEGIN Oracle Exception
		update QUOTES_CONTACTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where QUOTE_ID         = @ID
		   and DELETED          = 1
		   and ID in (select ID from QUOTES_CONTACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and QUOTE_ID = @ID);
	-- END Oracle Exception

	exec dbo.spPARENT_Undelete @ID, @MODIFIED_USER_ID, @AUDIT_TOKEN, N'Quotes';
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update QUOTES_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from QUOTES
			  where ID               = @ID
			    and DELETED          = 1
			    and ID in (select ID from QUOTES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID)
			);
		update QUOTES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID               = @ID
		   and DELETED          = 1
		   and ID in (select ID from QUOTES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID);
	-- END Oracle Exception
  end
GO
 
Grant Execute on dbo.spQUOTES_Undelete to public;
GO
 
 
