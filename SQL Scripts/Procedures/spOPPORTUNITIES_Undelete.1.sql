if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spOPPORTUNITIES_Undelete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spOPPORTUNITIES_Undelete;
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
Create Procedure dbo.spOPPORTUNITIES_Undelete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @AUDIT_TOKEN      varchar(255)
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		update OPPORTUNITIES_DOCUMENTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 1
		   and ID in (select ID from OPPORTUNITIES_DOCUMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and OPPORTUNITY_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update ACCOUNTS_OPPORTUNITIES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 1
		   and ID in (select ID from ACCOUNTS_OPPORTUNITIES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and OPPORTUNITY_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update EMAILS_OPPORTUNITIES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 1
		   and ID in (select ID from EMAILS_OPPORTUNITIES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and OPPORTUNITY_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update OPPORTUNITIES_CONTACTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 1
		   and ID in (select ID from OPPORTUNITIES_CONTACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and OPPORTUNITY_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update OPPORTUNITIES_DOCUMENTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 1
		   and ID in (select ID from OPPORTUNITIES_DOCUMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and OPPORTUNITY_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update OPPORTUNITIES_THREADS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID   = @ID
		   and DELETED          = 1
		   and ID in (select ID from OPPORTUNITIES_THREADS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and OPPORTUNITY_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update LEADS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from LEADS
			 where OPPORTUNITY_ID       is null
			   and ID in (select LEADS_AUDIT.ID
			                from      LEADS_AUDIT
			               inner join (select LEADS_AUDIT_PREVIOUS.ID, max(LEADS_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
			                             from      LEADS_AUDIT                          LEADS_AUDIT_CURRENT
			                            inner join LEADS_AUDIT                          LEADS_AUDIT_PREVIOUS
			                                    on LEADS_AUDIT_PREVIOUS.ID            = LEADS_AUDIT_CURRENT.ID
			                                   and LEADS_AUDIT_PREVIOUS.AUDIT_VERSION < LEADS_AUDIT_CURRENT.AUDIT_VERSION
			                                 where LEADS_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
			                                 group by LEADS_AUDIT_PREVIOUS.ID
			                          )                                         LEADS_AUDIT_PREV_VERSION
			                       on LEADS_AUDIT_PREV_VERSION.ID             = LEADS_AUDIT.ID
			               inner join LEADS_AUDIT                               LEADS_AUDIT_PREV_ACCOUNT
			                       on LEADS_AUDIT_PREV_ACCOUNT.ID             = LEADS_AUDIT_PREV_VERSION.ID
			                      and LEADS_AUDIT_PREV_ACCOUNT.AUDIT_VERSION  = LEADS_AUDIT_PREV_VERSION.AUDIT_VERSION
			                      and LEADS_AUDIT_PREV_ACCOUNT.OPPORTUNITY_ID = @ID
			                      and LEADS_AUDIT_PREV_ACCOUNT.DELETED        = 0
			               where LEADS_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
			             )
			);
		update LEADS
		   set OPPORTUNITY_ID   = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where OPPORTUNITY_ID       is null
		   and ID in (select LEADS_AUDIT.ID
		                from      LEADS_AUDIT
		               inner join (select LEADS_AUDIT_PREVIOUS.ID, max(LEADS_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
		                             from      LEADS_AUDIT                          LEADS_AUDIT_CURRENT
		                            inner join LEADS_AUDIT                          LEADS_AUDIT_PREVIOUS
		                                    on LEADS_AUDIT_PREVIOUS.ID            = LEADS_AUDIT_CURRENT.ID
		                                   and LEADS_AUDIT_PREVIOUS.AUDIT_VERSION < LEADS_AUDIT_CURRENT.AUDIT_VERSION
		                                 where LEADS_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
		                                 group by LEADS_AUDIT_PREVIOUS.ID
		                          )                                         LEADS_AUDIT_PREV_VERSION
		                       on LEADS_AUDIT_PREV_VERSION.ID             = LEADS_AUDIT.ID
		               inner join LEADS_AUDIT                               LEADS_AUDIT_PREV_ACCOUNT
		                       on LEADS_AUDIT_PREV_ACCOUNT.ID             = LEADS_AUDIT_PREV_VERSION.ID
		                      and LEADS_AUDIT_PREV_ACCOUNT.AUDIT_VERSION  = LEADS_AUDIT_PREV_VERSION.AUDIT_VERSION
		                      and LEADS_AUDIT_PREV_ACCOUNT.OPPORTUNITY_ID = @ID
		                      and LEADS_AUDIT_PREV_ACCOUNT.DELETED        = 0
		               where LEADS_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
		             )
		;
	-- END Oracle Exception
	
	exec dbo.spPARENT_Undelete @ID, @MODIFIED_USER_ID, @AUDIT_TOKEN, N'Opportunities';
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update OPPORTUNITIES_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from OPPORTUNITIES
			  where ID               = @ID
			    and DELETED          = 1
			    and ID in (select ID from OPPORTUNITIES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID)
			);
		update OPPORTUNITIES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID               = @ID
		   and DELETED          = 1
		   and ID in (select ID from OPPORTUNITIES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID);
	-- END Oracle Exception
	
  end
GO

Grant Execute on dbo.spOPPORTUNITIES_Undelete to public;
GO

