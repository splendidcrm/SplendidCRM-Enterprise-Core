if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCALL_MARKETING_Duplicate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCALL_MARKETING_Duplicate;
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
-- 11/30/2017 Paul.  Add TEAM_SET_ID. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spCALL_MARKETING_Duplicate
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @DUPLICATE_ID      uniqueidentifier
	, @CAMPAIGN_ID       uniqueidentifier
	)
as
  begin
	set nocount on
	
	set @ID = null;
	if not exists(select * from vwCALL_MARKETING where ID = @DUPLICATE_ID) begin -- then
		raiserror(N'Cannot duplicate non-existent call marketing.', 16, 1);
		return;
	end -- if;

	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
	end -- if;
	insert into CALL_MARKETING
		( ID                 
		, CREATED_BY         
		, DATE_ENTERED       
		, MODIFIED_USER_ID   
		, DATE_MODIFIED      
		, CAMPAIGN_ID        
		, ASSIGNED_USER_ID   
		, TEAM_ID            
		, NAME               
		, STATUS             
		, DISTRIBUTION       
		, ALL_PROSPECT_LISTS 
		, SUBJECT            
		, DURATION_HOURS     
		, DURATION_MINUTES   
		, DATE_START         
		, TIME_START         
		, DATE_END           
		, TIME_END           
		, REMINDER_TIME      
		, DESCRIPTION        
		, TEAM_SET_ID        
		, ASSIGNED_SET_ID    
		)
	select @ID                 
		, @MODIFIED_USER_ID   
		,  getdate()          
		, @MODIFIED_USER_ID   
		,  getdate()          
		, @CAMPAIGN_ID        
		,  ASSIGNED_USER_ID   
		,  TEAM_ID            
		,  NAME               
		,  STATUS             
		,  DISTRIBUTION       
		,  ALL_PROSPECT_LISTS 
		,  SUBJECT            
		,  DURATION_HOURS     
		,  DURATION_MINUTES   
		,  DATE_START         
		,  TIME_START         
		,  DATE_END           
		,  TIME_END           
		,  REMINDER_TIME      
		,  DESCRIPTION        
		,  TEAM_SET_ID        
		,  ASSIGNED_SET_ID    
	  from CALL_MARKETING
	 where ID = @DUPLICATE_ID;

	insert into CALL_MARKETING_CSTM ( ID_C ) values ( @ID );
  end
GO
 
Grant Execute on dbo.spCALL_MARKETING_Duplicate to public;
GO

