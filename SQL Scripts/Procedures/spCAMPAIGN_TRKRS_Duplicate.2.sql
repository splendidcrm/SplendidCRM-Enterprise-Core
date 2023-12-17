if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCAMPAIGN_TRKRS_Duplicate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCAMPAIGN_TRKRS_Duplicate;
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
Create Procedure dbo.spCAMPAIGN_TRKRS_Duplicate
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @DUPLICATE_ID      uniqueidentifier
	, @CAMPAIGN_ID       uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @TEMP_TRACKER_KEY nvarchar(30);
	set @ID = null;
	if not exists(select * from vwCAMPAIGN_TRKRS where ID = @DUPLICATE_ID) begin -- then
		raiserror(N'Cannot duplicate non-existent campaign tracker.', 16, 1);
		return;
	end -- if;

	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
	end -- if;
	exec dbo.spNUMBER_SEQUENCES_Formatted 'CAMPAIGN_TRKRS.TRACKER_KEY', 1, @TEMP_TRACKER_KEY out;
	insert into CAMPAIGN_TRKRS
		( ID               
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, TRACKER_NAME     
		, TRACKER_URL      
		, TRACKER_KEY      
		, CAMPAIGN_ID      
		, IS_OPTOUT        
		)
	select	  @ID               
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @MODIFIED_USER_ID 
		,  getdate()        
		,  TRACKER_NAME     
		,  TRACKER_URL      
		, @TEMP_TRACKER_KEY 
		, @CAMPAIGN_ID      
		,  IS_OPTOUT        
	  from CAMPAIGN_TRKRS
	 where ID = @DUPLICATE_ID;

	insert into CAMPAIGN_TRKRS_CSTM ( ID_C ) values ( @ID );
  end
GO
 
Grant Execute on dbo.spCAMPAIGN_TRKRS_Duplicate to public;
GO

