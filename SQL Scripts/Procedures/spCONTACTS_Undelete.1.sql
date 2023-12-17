if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCONTACTS_Undelete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCONTACTS_Undelete;
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
Create Procedure dbo.spCONTACTS_Undelete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @AUDIT_TOKEN      varchar(255)
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		update CONTACTS_DOCUMENTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from CONTACTS_DOCUMENTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CONTACT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update ACCOUNTS_CONTACTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from ACCOUNTS_CONTACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CONTACT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update CALLS_CONTACTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from CALLS_CONTACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CONTACT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update CONTACTS_BUGS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from CONTACTS_BUGS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CONTACT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update CONTACTS_CASES
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from CONTACTS_CASES_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CONTACT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update CONTACTS_USERS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from CONTACTS_USERS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CONTACT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update EMAILS_CONTACTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from EMAILS_CONTACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CONTACT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update MEETINGS_CONTACTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from MEETINGS_CONTACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CONTACT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update OPPORTUNITIES_CONTACTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from OPPORTUNITIES_CONTACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CONTACT_ID = @ID);
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
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update LEADS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from LEADS
			 where CONTACT_ID       is null
			   and ID in (select LEADS_AUDIT.ID
			                from      LEADS_AUDIT
			               inner join (select LEADS_AUDIT_PREVIOUS.ID, max(LEADS_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
			                             from      LEADS_AUDIT                          LEADS_AUDIT_CURRENT
			                            inner join LEADS_AUDIT                          LEADS_AUDIT_PREVIOUS
			                                    on LEADS_AUDIT_PREVIOUS.ID            = LEADS_AUDIT_CURRENT.ID
			                                   and LEADS_AUDIT_PREVIOUS.AUDIT_VERSION < LEADS_AUDIT_CURRENT.AUDIT_VERSION
			                                 where LEADS_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
			                                 group by LEADS_AUDIT_PREVIOUS.ID
			                          )                                        LEADS_AUDIT_PREV_VERSION
			                       on LEADS_AUDIT_PREV_VERSION.ID            = LEADS_AUDIT.ID
			               inner join LEADS_AUDIT                              LEADS_AUDIT_PREV_ACCOUNT
			                       on LEADS_AUDIT_PREV_ACCOUNT.ID            = LEADS_AUDIT_PREV_VERSION.ID
			                      and LEADS_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = LEADS_AUDIT_PREV_VERSION.AUDIT_VERSION
			                      and LEADS_AUDIT_PREV_ACCOUNT.CONTACT_ID    = @ID 
			                      and LEADS_AUDIT_PREV_ACCOUNT.DELETED       = 0
			               where LEADS_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
			             )
			);
		update LEADS
		   set CONTACT_ID       = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       is null
		   and ID in (select LEADS_AUDIT.ID
		                from      LEADS_AUDIT
		               inner join (select LEADS_AUDIT_PREVIOUS.ID, max(LEADS_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
		                             from      LEADS_AUDIT                          LEADS_AUDIT_CURRENT
		                            inner join LEADS_AUDIT                          LEADS_AUDIT_PREVIOUS
		                                    on LEADS_AUDIT_PREVIOUS.ID            = LEADS_AUDIT_CURRENT.ID
		                                   and LEADS_AUDIT_PREVIOUS.AUDIT_VERSION < LEADS_AUDIT_CURRENT.AUDIT_VERSION
		                                 where LEADS_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
		                                 group by LEADS_AUDIT_PREVIOUS.ID
		                          )                                        LEADS_AUDIT_PREV_VERSION
		                       on LEADS_AUDIT_PREV_VERSION.ID            = LEADS_AUDIT.ID
		               inner join LEADS_AUDIT                              LEADS_AUDIT_PREV_ACCOUNT
		                       on LEADS_AUDIT_PREV_ACCOUNT.ID            = LEADS_AUDIT_PREV_VERSION.ID
		                      and LEADS_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = LEADS_AUDIT_PREV_VERSION.AUDIT_VERSION
		                      and LEADS_AUDIT_PREV_ACCOUNT.CONTACT_ID    = @ID 
		                      and LEADS_AUDIT_PREV_ACCOUNT.DELETED       = 0
		               where LEADS_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
		             )
		;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update NOTES_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from NOTES
			 where CONTACT_ID       is null
			   and ID in (select NOTES_AUDIT.ID
			                from      NOTES_AUDIT
			               inner join (select NOTES_AUDIT_PREVIOUS.ID, max(NOTES_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
			                             from      NOTES_AUDIT                          NOTES_AUDIT_CURRENT
			                            inner join NOTES_AUDIT                          NOTES_AUDIT_PREVIOUS
			                                    on NOTES_AUDIT_PREVIOUS.ID            = NOTES_AUDIT_CURRENT.ID
			                                   and NOTES_AUDIT_PREVIOUS.AUDIT_VERSION < NOTES_AUDIT_CURRENT.AUDIT_VERSION
			                                 where NOTES_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
			                                 group by NOTES_AUDIT_PREVIOUS.ID
			                          )                                        NOTES_AUDIT_PREV_VERSION
			                       on NOTES_AUDIT_PREV_VERSION.ID            = NOTES_AUDIT.ID
			               inner join NOTES_AUDIT                              NOTES_AUDIT_PREV_ACCOUNT
			                       on NOTES_AUDIT_PREV_ACCOUNT.ID            = NOTES_AUDIT_PREV_VERSION.ID
			                      and NOTES_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = NOTES_AUDIT_PREV_VERSION.AUDIT_VERSION
			                      and NOTES_AUDIT_PREV_ACCOUNT.CONTACT_ID    = @ID 
			                      and NOTES_AUDIT_PREV_ACCOUNT.DELETED       = 0
			               where NOTES_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
			             )
			);
		update NOTES
		   set CONTACT_ID       = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       is null
		   and ID in (select NOTES_AUDIT.ID
		                from      NOTES_AUDIT
		               inner join (select NOTES_AUDIT_PREVIOUS.ID, max(NOTES_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
		                             from      NOTES_AUDIT                          NOTES_AUDIT_CURRENT
		                            inner join NOTES_AUDIT                          NOTES_AUDIT_PREVIOUS
		                                    on NOTES_AUDIT_PREVIOUS.ID            = NOTES_AUDIT_CURRENT.ID
		                                   and NOTES_AUDIT_PREVIOUS.AUDIT_VERSION < NOTES_AUDIT_CURRENT.AUDIT_VERSION
		                                 where NOTES_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
		                                 group by NOTES_AUDIT_PREVIOUS.ID
		                          )                                        NOTES_AUDIT_PREV_VERSION
		                       on NOTES_AUDIT_PREV_VERSION.ID            = NOTES_AUDIT.ID
		               inner join NOTES_AUDIT                              NOTES_AUDIT_PREV_ACCOUNT
		                       on NOTES_AUDIT_PREV_ACCOUNT.ID            = NOTES_AUDIT_PREV_VERSION.ID
		                      and NOTES_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = NOTES_AUDIT_PREV_VERSION.AUDIT_VERSION
		                      and NOTES_AUDIT_PREV_ACCOUNT.CONTACT_ID    = @ID 
		                      and NOTES_AUDIT_PREV_ACCOUNT.DELETED       = 0
		               where NOTES_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
		             )
		;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update TASKS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from TASKS
			 where CONTACT_ID       is null
			   and ID in (select TASKS_AUDIT.ID
			                from      TASKS_AUDIT
			               inner join (select TASKS_AUDIT_PREVIOUS.ID, max(TASKS_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
			                             from      TASKS_AUDIT                          TASKS_AUDIT_CURRENT
			                            inner join TASKS_AUDIT                          TASKS_AUDIT_PREVIOUS
			                                    on TASKS_AUDIT_PREVIOUS.ID            = TASKS_AUDIT_CURRENT.ID
			                                   and TASKS_AUDIT_PREVIOUS.AUDIT_VERSION < TASKS_AUDIT_CURRENT.AUDIT_VERSION
			                                 where TASKS_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
			                                 group by TASKS_AUDIT_PREVIOUS.ID
			                          )                                        TASKS_AUDIT_PREV_VERSION
			                       on TASKS_AUDIT_PREV_VERSION.ID            = TASKS_AUDIT.ID
			               inner join TASKS_AUDIT                              TASKS_AUDIT_PREV_ACCOUNT
			                       on TASKS_AUDIT_PREV_ACCOUNT.ID            = TASKS_AUDIT_PREV_VERSION.ID
			                      and TASKS_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = TASKS_AUDIT_PREV_VERSION.AUDIT_VERSION
			                      and TASKS_AUDIT_PREV_ACCOUNT.CONTACT_ID    = @ID 
			                      and TASKS_AUDIT_PREV_ACCOUNT.DELETED       = 0
			               where TASKS_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
			             )
			);
		update TASKS
		   set CONTACT_ID       = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       is null
		   and ID in (select TASKS_AUDIT.ID
		                from      TASKS_AUDIT
		               inner join (select TASKS_AUDIT_PREVIOUS.ID, max(TASKS_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
		                             from      TASKS_AUDIT                          TASKS_AUDIT_CURRENT
		                            inner join TASKS_AUDIT                          TASKS_AUDIT_PREVIOUS
		                                    on TASKS_AUDIT_PREVIOUS.ID            = TASKS_AUDIT_CURRENT.ID
		                                   and TASKS_AUDIT_PREVIOUS.AUDIT_VERSION < TASKS_AUDIT_CURRENT.AUDIT_VERSION
		                                 where TASKS_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
		                                 group by TASKS_AUDIT_PREVIOUS.ID
		                          )                                        TASKS_AUDIT_PREV_VERSION
		                       on TASKS_AUDIT_PREV_VERSION.ID            = TASKS_AUDIT.ID
		               inner join TASKS_AUDIT                              TASKS_AUDIT_PREV_ACCOUNT
		                       on TASKS_AUDIT_PREV_ACCOUNT.ID            = TASKS_AUDIT_PREV_VERSION.ID
		                      and TASKS_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = TASKS_AUDIT_PREV_VERSION.AUDIT_VERSION
		                      and TASKS_AUDIT_PREV_ACCOUNT.CONTACT_ID    = @ID 
		                      and TASKS_AUDIT_PREV_ACCOUNT.DELETED       = 0
		               where TASKS_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
		             )
		;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update INVOICES_CONTACTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from INVOICES_CONTACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CONTACT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update ORDERS_CONTACTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from ORDERS_CONTACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CONTACT_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update QUOTES_CONTACTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CONTACT_ID       = @ID
		   and DELETED          = 1
		   and ID in (select ID from QUOTES_CONTACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CONTACT_ID = @ID);
	-- END Oracle Exception
	
	exec dbo.spPARENT_Undelete @ID, @MODIFIED_USER_ID, @AUDIT_TOKEN, N'Contacts';
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update CONTACTS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from CONTACTS
			  where ID               = @ID
			    and DELETED          = 1
			    and ID in (select ID from CONTACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID)
			);
		update CONTACTS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID               = @ID
		   and DELETED          = 1
		   and ID in (select ID from CONTACTS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID);
	-- END Oracle Exception
	
  end
GO

Grant Execute on dbo.spCONTACTS_Undelete to public;
GO

