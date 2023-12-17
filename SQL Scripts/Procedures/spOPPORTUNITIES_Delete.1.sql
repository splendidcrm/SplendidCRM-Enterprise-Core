if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spOPPORTUNITIES_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spOPPORTUNITIES_Delete;
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
-- 08/08/2013 Paul.  Delete documents and threads. 
-- 01/30/2019 Paul.  Delete revenue line items when the opportunity is deleted. 
-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
Create Procedure dbo.spOPPORTUNITIES_Delete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	-- 01/30/2019 Paul.  Delete revenue line items when the opportunity is deleted. 
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update REVENUE_LINE_ITEMS_CSTM
		   set ID_C             = ID_C
		 where ID_C IN
			(select ID
			   from REVENUE_LINE_ITEMS
			  where OPPORTUNITY_ID   = @ID
			    and DELETED          = 0
			);
		update REVENUE_LINE_ITEMS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 0;
	-- END Oracle Exception

	-- 08/10/2013 Paul.  Delete Documents relationship. 
	-- BEGIN Oracle Exception
		update OPPORTUNITIES_DOCUMENTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- 04/02/2006 Paul.  Catch the Oracle NO_DATA_FOUND exception. 
	-- BEGIN Oracle Exception
		update ACCOUNTS_OPPORTUNITIES
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update EMAILS_OPPORTUNITIES
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update OPPORTUNITIES_CONTACTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update OPPORTUNITIES_DOCUMENTS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update OPPORTUNITIES_THREADS
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update LEADS_CSTM
		   set ID_C             = ID_C
		 where ID_C in
			(select ID
			   from LEADS
			  where OPPORTUNITY_ID   = @ID
			    and DELETED          = 0
			);
		update LEADS
		   set OPPORTUNITY_ID   = null
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		delete from TRACKER
		 where ITEM_ID          = @ID
		   and USER_ID          = @MODIFIED_USER_ID;
	-- END Oracle Exception
	
	exec dbo.spPARENT_Delete @ID, @MODIFIED_USER_ID;
	
	-- BEGIN Oracle Exception
		update OPPORTUNITIES
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID               = @ID
		   and DELETED          = 0;

		-- 01/30/2019 Paul.  Trigger audit record so delete workflow will have access to custom fields. 
		update OPPORTUNITIES_CSTM
		   set ID_C             = ID_C
		 where ID_C             = @ID;
	-- END Oracle Exception
	
	-- 10/13/2015 Paul.  We need to delete all favorite records. 
	-- BEGIN Oracle Exception
		update SUGARFAVORITES
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where RECORD_ID         = @ID
		   and DELETED           = 0;
	-- END Oracle Exception

  end
GO

Grant Execute on dbo.spOPPORTUNITIES_Delete to public;
GO

