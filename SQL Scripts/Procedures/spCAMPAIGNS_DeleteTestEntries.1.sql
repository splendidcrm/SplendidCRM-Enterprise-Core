if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCAMPAIGNS_DeleteTestEntries' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCAMPAIGNS_DeleteTestEntries;
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
Create Procedure dbo.spCAMPAIGNS_DeleteTestEntries
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	-- 01/26/2008 Paul.  Oracle does not allow the join syntax in a delete statement. 
	update EMAILS
	   set DELETED          = 1
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = @MODIFIED_USER_ID
	 where DELETED          = 0
	   and ID in (select CAMPAIGN_LOG.RELATED_ID
	                from      CAMPAIGN_LOG
	               inner join PROSPECT_LIST_CAMPAIGNS
	                       on PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID      = CAMPAIGN_LOG.CAMPAIGN_ID
	                      and PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID = CAMPAIGN_LOG.LIST_ID
	                      and PROSPECT_LIST_CAMPAIGNS.DELETED          = 0
	               inner join PROSPECT_LISTS
	                       on PROSPECT_LISTS.ID                        = PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
	                      and PROSPECT_LISTS.LIST_TYPE                 = N'test'
	                      and PROSPECT_LISTS.DELETED                   = 0
	               where CAMPAIGN_LOG.CAMPAIGN_ID  = @ID
	                 and CAMPAIGN_LOG.DELETED      = 0
	                 and CAMPAIGN_LOG.RELATED_TYPE = N'Emails');
	
	delete from EMAILMAN
	 where ID in (select EMAILMAN.ID
	                from      EMAILMAN
	               inner join PROSPECT_LIST_CAMPAIGNS
	                       on PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID      = EMAILMAN.CAMPAIGN_ID
	                      and PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID = EMAILMAN.LIST_ID
	                      and PROSPECT_LIST_CAMPAIGNS.DELETED          = 0
	               inner join PROSPECT_LISTS
	                       on PROSPECT_LISTS.ID                        = PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
	                      and PROSPECT_LISTS.LIST_TYPE                 = N'test'
	                      and PROSPECT_LISTS.DELETED                   = 0
	               where EMAILMAN.CAMPAIGN_ID  = @ID);

	update CAMPAIGN_LOG
	   set DELETED          = 1
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = @MODIFIED_USER_ID
	 where DELETED          = 0
	   and ID in (select CAMPAIGN_LOG.ID
	                from      CAMPAIGN_LOG
	               inner join PROSPECT_LIST_CAMPAIGNS
	                       on PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID      = CAMPAIGN_LOG.CAMPAIGN_ID
	                      and PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID = CAMPAIGN_LOG.LIST_ID
	                      and PROSPECT_LIST_CAMPAIGNS.DELETED          = 0
	               inner join PROSPECT_LISTS
	                       on PROSPECT_LISTS.ID                        = PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
	                      and PROSPECT_LISTS.LIST_TYPE                 = N'test'
	                      and PROSPECT_LISTS.DELETED                   = 0
	               where CAMPAIGN_LOG.CAMPAIGN_ID  = @ID
	                 and CAMPAIGN_LOG.DELETED      = 0);
  end
GO

Grant Execute on dbo.spCAMPAIGNS_DeleteTestEntries to public;
GO

