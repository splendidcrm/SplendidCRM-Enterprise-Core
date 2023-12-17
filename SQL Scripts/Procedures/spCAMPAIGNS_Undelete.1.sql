if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCAMPAIGNS_Undelete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCAMPAIGNS_Undelete;
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
Create Procedure dbo.spCAMPAIGNS_Undelete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @AUDIT_TOKEN      varchar(255)
	)
as
  begin
	set nocount on
	
	/*
	-- BEGIN Oracle Exception
		-- 09/19/2005 Paul.  SugarCRM does not modify these. 
		update EMAIL_MARKETING
		   set CAMPAIGN_ID      = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CAMPAIGN_ID       is null
		   and ID in (select EMAIL_MARKETING_AUDIT.ID
		                from      EMAIL_MARKETING_AUDIT
		               inner join (select EMAIL_MARKETING_AUDIT_PREVIOUS.ID, max(EMAIL_MARKETING_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
		                             from      EMAIL_MARKETING_AUDIT                          EMAIL_MARKETING_AUDIT_CURRENT
		                            inner join EMAIL_MARKETING_AUDIT                          EMAIL_MARKETING_AUDIT_PREVIOUS
		                                    on EMAIL_MARKETING_AUDIT_PREVIOUS.ID            = EMAIL_MARKETING_AUDIT_CURRENT.ID
		                                   and EMAIL_MARKETING_AUDIT_PREVIOUS.AUDIT_VERSION < EMAIL_MARKETING_AUDIT_CURRENT.AUDIT_VERSION
		                                 where EMAIL_MARKETING_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
		                                 group by EMAIL_MARKETING_AUDIT_PREVIOUS.ID
		                          )                                        EMAIL_MARKETING_AUDIT_PREV_VERSION
		                       on EMAIL_MARKETING_AUDIT_PREV_VERSION.ID            = EMAIL_MARKETING_AUDIT.ID
		               inner join EMAIL_MARKETING_AUDIT                              EMAIL_MARKETING_AUDIT_PREV_ACCOUNT
		                       on EMAIL_MARKETING_AUDIT_PREV_ACCOUNT.ID            = EMAIL_MARKETING_AUDIT_PREV_VERSION.ID
		                      and EMAIL_MARKETING_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = EMAIL_MARKETING_AUDIT_PREV_VERSION.AUDIT_VERSION
		                      and EMAIL_MARKETING_AUDIT_PREV_ACCOUNT.CAMPAIGN_ID    = @ID
		                      and EMAIL_MARKETING_AUDIT_PREV_ACCOUNT.DELETED       = 0
		               where EMAIL_MARKETING_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
		             )
		;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update EMAILMAN
		   set CAMPAIGN_ID      = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CAMPAIGN_ID       is null
		   and ID in (select EMAILMAN_AUDIT.ID
		                from      EMAILMAN_AUDIT
		               inner join (select EMAILMAN_AUDIT_PREVIOUS.ID, max(EMAILMAN_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
		                             from      EMAILMAN_AUDIT                          EMAILMAN_AUDIT_CURRENT
		                            inner join EMAILMAN_AUDIT                          EMAILMAN_AUDIT_PREVIOUS
		                                    on EMAILMAN_AUDIT_PREVIOUS.ID            = EMAILMAN_AUDIT_CURRENT.ID
		                                   and EMAILMAN_AUDIT_PREVIOUS.AUDIT_VERSION < EMAILMAN_AUDIT_CURRENT.AUDIT_VERSION
		                                 where EMAILMAN_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
		                                 group by EMAILMAN_AUDIT_PREVIOUS.ID
		                          )                                        EMAILMAN_AUDIT_PREV_VERSION
		                       on EMAILMAN_AUDIT_PREV_VERSION.ID            = EMAILMAN_AUDIT.ID
		               inner join EMAILMAN_AUDIT                              EMAILMAN_AUDIT_PREV_ACCOUNT
		                       on EMAILMAN_AUDIT_PREV_ACCOUNT.ID            = EMAILMAN_AUDIT_PREV_VERSION.ID
		                      and EMAILMAN_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = EMAILMAN_AUDIT_PREV_VERSION.AUDIT_VERSION
		                      and EMAILMAN_AUDIT_PREV_ACCOUNT.CAMPAIGN_ID    = @ID
		                      and EMAILMAN_AUDIT_PREV_ACCOUNT.DELETED       = 0
		               where EMAILMAN_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
		             )
		;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update EMAILMAN_SENT
		   set CAMPAIGN_ID      = @ID
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CAMPAIGN_ID       is null
		   and ID in (select EMAILMAN_SENT_AUDIT.ID
		                from      EMAILMAN_SENT_AUDIT
		               inner join (select EMAILMAN_SENT_AUDIT_PREVIOUS.ID, max(EMAILMAN_SENT_AUDIT_PREVIOUS.AUDIT_VERSION) as AUDIT_VERSION
		                             from      EMAILMAN_SENT_AUDIT                          EMAILMAN_SENT_AUDIT_CURRENT
		                            inner join EMAILMAN_SENT_AUDIT                          EMAILMAN_SENT_AUDIT_PREVIOUS
		                                    on EMAILMAN_SENT_AUDIT_PREVIOUS.ID            = EMAILMAN_SENT_AUDIT_CURRENT.ID
		                                   and EMAILMAN_SENT_AUDIT_PREVIOUS.AUDIT_VERSION < EMAILMAN_SENT_AUDIT_CURRENT.AUDIT_VERSION
		                                 where EMAILMAN_SENT_AUDIT_CURRENT.AUDIT_TOKEN = @AUDIT_TOKEN
		                                 group by EMAILMAN_SENT_AUDIT_PREVIOUS.ID
		                          )                                        EMAILMAN_SENT_AUDIT_PREV_VERSION
		                       on EMAILMAN_SENT_AUDIT_PREV_VERSION.ID            = EMAILMAN_SENT_AUDIT.ID
		               inner join EMAILMAN_SENT_AUDIT                              EMAILMAN_SENT_AUDIT_PREV_ACCOUNT
		                       on EMAILMAN_SENT_AUDIT_PREV_ACCOUNT.ID            = EMAILMAN_SENT_AUDIT_PREV_VERSION.ID
		                      and EMAILMAN_SENT_AUDIT_PREV_ACCOUNT.AUDIT_VERSION = EMAILMAN_SENT_AUDIT_PREV_VERSION.AUDIT_VERSION
		                      and EMAILMAN_SENT_AUDIT_PREV_ACCOUNT.CAMPAIGN_ID    = @ID
		                      and EMAILMAN_SENT_AUDIT_PREV_ACCOUNT.DELETED       = 0
		               where EMAILMAN_SENT_AUDIT.AUDIT_TOKEN = @AUDIT_TOKEN
		             )
		;
	-- END Oracle Exception
	*/
	-- BEGIN Oracle Exception
		update PROSPECT_LIST_CAMPAIGNS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where CAMPAIGN_ID      = @ID
		   and DELETED          = 1
		   and ID in (select ID from PROSPECT_LIST_CAMPAIGNS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and CAMPAIGN_ID = @ID);
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
		update CAMPAIGNS_CSTM
		   set ID_C             = ID_C
		 where ID_C in 
			(select ID
			   from CAMPAIGNS
			  where ID               = @ID
			    and DELETED          = 1
			    and ID in (select ID from CAMPAIGNS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID)
			);
		update CAMPAIGNS
		   set DELETED          = 0
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ID               = @ID
		   and DELETED          = 1
		   and ID in (select ID from CAMPAIGNS_AUDIT where AUDIT_TOKEN = @AUDIT_TOKEN and ID = @ID);
	-- END Oracle Exception
	
  end
GO

Grant Execute on dbo.spCAMPAIGNS_Undelete to public;
GO

