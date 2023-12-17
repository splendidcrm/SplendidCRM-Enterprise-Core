if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spLEADS_Undelete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spLEADS_Undelete;
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
Create Procedure dbo.spLEADS_Undelete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @AUDIT_TOKEN      varchar(255)
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		update LEADS_DOCUMENTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where LEAD_ID          = @ID
		   and DELETED          = 1
		   and ID in (select ID from LEADS_DOCUMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and LEAD_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update PROSPECT_LISTS_PROSPECTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where RELATED_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from PROSPECT_LISTS_PROSPECTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and RELATED_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update CALLS_LEADS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where LEAD_ID          = @ID
		   and DELETED          = 1
		   and ID in (select ID from CALLS_LEADS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and LEAD_ID = @ID);
	-- END Oracle Exception

	-- BEGIN Oracle Exception
		update MEETINGS_LEADS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where LEAD_ID          = @ID
		   and DELETED          = 1
		   and ID in (select ID from MEETINGS_LEADS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and LEAD_ID = @ID);
	-- END Oracle Exception

	-- BEGIN Oracle Exception
		update LEADS_USERS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where LEAD_ID          = @ID
		   and DELETED          = 1
		   and ID in (select ID from LEADS_USERS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and LEAD_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update EMAILS_LEADS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where LEAD_ID          = @ID
		   and DELETED          = 1
		   and ID in (select ID from EMAILS_LEADS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and LEAD_ID = @ID);
	-- END Oracle Exception
	
	exec dbo.spPARENT_Undelete @ID, @MODIFIED_USER_ID, @AUDIT_TOKEN, N'Leads';
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update LEADS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from LEADS
			  where ID               = @ID
			    and DELETED          = 1
			    and ID in (select ID from LEADS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID)
			);
		update LEADS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID               = @ID
		   and DELETED          = 1
		   and ID in (select ID from LEADS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID);
	-- END Oracle Exception
	
  end
GO

Grant Execute on dbo.spLEADS_Undelete to public;
GO

