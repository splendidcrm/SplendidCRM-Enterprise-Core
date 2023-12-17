if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCALL_MKTG_PRSPT_LST_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCALL_MKTG_PRSPT_LST_Delete;
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
Create Procedure dbo.spCALL_MKTG_PRSPT_LST_Delete
	( @MODIFIED_USER_ID   uniqueidentifier
	, @CALL_MARKETING_ID uniqueidentifier
	, @PROSPECT_LIST_ID   uniqueidentifier
	)
as
  begin
	set nocount on

	-- 12/15/2007 Paul.  When removing the first item, we may need to add all the others. 
	-- Lets add them all, then mark the removed as deleted.  This will give us a record of the remove.
	-- 01/20/2008 Paul.  Only add the existing lists if currently marked as ALL_PROSPECT_LISTS. 
	if exists(select * from CALL_MARKETING where ID = @CALL_MARKETING_ID and ALL_PROSPECT_LISTS = 1 and DELETED = 0) begin -- then
		insert into CALL_MARKETING_PROSPECT_LISTS(CREATED_BY, MODIFIED_USER_ID, CALL_MARKETING_ID, PROSPECT_LIST_ID)
		select @MODIFIED_USER_ID
		     , @MODIFIED_USER_ID
		     , CALL_MARKETING.ID
		     , PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
		  from            CALL_MARKETING
		       inner join CAMPAIGNS
		               on CAMPAIGNS.ID                        = CALL_MARKETING.CAMPAIGN_ID
		              and CAMPAIGNS.DELETED                   = 0
		       inner join PROSPECT_LIST_CAMPAIGNS
		               on PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID = CAMPAIGNS.ID
		              and PROSPECT_LIST_CAMPAIGNS.DELETED     = 0
		 where CALL_MARKETING.ID      = @CALL_MARKETING_ID
		   and CALL_MARKETING.DELETED = 0;

		-- 12/15/2007 Paul.  Disable the ALL flag when the first item is removed. 
		update CALL_MARKETING
		   set ALL_PROSPECT_LISTS = 0
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = @MODIFIED_USER_ID
		 where ID                 = @CALL_MARKETING_ID
		   and ALL_PROSPECT_LISTS = 1;
	end -- if;
	
	update CALL_MARKETING_PROSPECT_LISTS
	   set DELETED            = 1
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC  = getutcdate()
	     , MODIFIED_USER_ID   = @MODIFIED_USER_ID
	 where CALL_MARKETING_ID = @CALL_MARKETING_ID
	   and PROSPECT_LIST_ID   = @PROSPECT_LIST_ID
	   and DELETED            = 0;
  end
GO

Grant Execute on dbo.spCALL_MKTG_PRSPT_LST_Delete to public;
GO

