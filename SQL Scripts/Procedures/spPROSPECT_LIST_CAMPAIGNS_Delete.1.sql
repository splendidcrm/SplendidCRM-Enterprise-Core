if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROSPECT_LIST_CAMPAIGNS_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROSPECT_LIST_CAMPAIGNS_Delete;
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
-- 12/15/2007 Paul.  When a prospect list is removed, also removed it from the email marketing lists. 
Create Procedure dbo.spPROSPECT_LIST_CAMPAIGNS_Delete
	( @MODIFIED_USER_ID uniqueidentifier
	, @PROSPECT_LIST_ID uniqueidentifier
	, @CAMPAIGN_ID      uniqueidentifier
	)
as
  begin
	set nocount on
	
	update PROSPECT_LIST_CAMPAIGNS
	   set DELETED          = 1
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = @MODIFIED_USER_ID
	 where PROSPECT_LIST_ID = @PROSPECT_LIST_ID
	   and CAMPAIGN_ID      = @CAMPAIGN_ID
	   and DELETED          = 0;

	-- 12/15/2007 Paul.  Although SQL Server supports the join syntax in an update statement, MySQL and Oracle do not. 
	-- 05/22/2008 Paul.  We need to use the in clause when using a sub query as more than one value may be returned. 
	update EMAIL_MARKETING_PROSPECT_LISTS
	   set DELETED            = 1
	     , DATE_MODIFIED      = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID   = @MODIFIED_USER_ID
	 where EMAIL_MARKETING_ID in (select ID from EMAIL_MARKETING where CAMPAIGN_ID = @CAMPAIGN_ID and DELETED = 0)
	   and PROSPECT_LIST_ID   = @PROSPECT_LIST_ID
	   and DELETED            = 0;
  end
GO

Grant Execute on dbo.spPROSPECT_LIST_CAMPAIGNS_Delete to public;
GO


