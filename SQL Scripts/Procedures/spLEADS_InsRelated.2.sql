if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spLEADS_InsRelated' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spLEADS_InsRelated;
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
-- 05/11/2010 Paul.  The Opportunity is a member of the LEADS table. 
-- 04/01/2012 Paul.  Add Calls/Leads relationship. 
Create Procedure dbo.spLEADS_InsRelated
	( @MODIFIED_USER_ID  uniqueidentifier
	, @LEAD_ID           uniqueidentifier
	, @PARENT_TYPE       nvarchar(25)
	, @PARENT_ID         uniqueidentifier
	)
as
  begin
	set nocount on
	
	if dbo.fnIsEmptyGuid(@PARENT_ID) = 0 begin -- then
		if @PARENT_TYPE = N'Emails' begin -- then
			exec dbo.spEMAILS_LEADS_Update         @MODIFIED_USER_ID, @PARENT_ID, @LEAD_ID;
		end else if @PARENT_TYPE = N'ProspectLists' begin -- then
			exec dbo.spPROSPECT_LISTS_LEADS_Update @MODIFIED_USER_ID, @PARENT_ID, @LEAD_ID;
		end else if @PARENT_TYPE = N'Opportunities' begin -- then
			-- 05/11/2010 Paul.  The Opportunity is a member of the LEADS table. 
			update LEADS
			   set MODIFIED_USER_ID  = @MODIFIED_USER_ID
			     , DATE_MODIFIED     =  getdate()       
			     , DATE_MODIFIED_UTC =  getutcdate()    
			     , OPPORTUNITY_ID    = @PARENT_ID       
			 where ID                = @LEAD_ID         ;
		-- 04/01/2012 Paul.  Add Calls/Leads relationship. 
		end else if @PARENT_TYPE = N'Calls' begin -- then
			exec dbo.spCALLS_LEADS_Update          @MODIFIED_USER_ID, @PARENT_ID , @LEAD_ID, null, null;
		-- 04/01/2012 Paul.  Add Meetings/Leads relationship. 
		end else if @PARENT_TYPE = N'Meetings' begin -- then
			exec dbo.spMEETINGS_LEADS_Update       @MODIFIED_USER_ID, @PARENT_ID , @LEAD_ID, null, null;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spLEADS_InsRelated to public;
GO

