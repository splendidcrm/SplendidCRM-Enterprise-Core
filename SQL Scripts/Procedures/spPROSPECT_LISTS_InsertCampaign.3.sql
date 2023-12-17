if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROSPECT_LISTS_InsertCampaign' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROSPECT_LISTS_InsertCampaign;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spPROSPECT_LISTS_InsertCampaign
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @CAMPAIGN_ID       uniqueidentifier
	, @NAME              nvarchar(50)
	, @DYNAMIC_SQL       nvarchar(max)
	)
as
  begin
	set nocount on
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
	end -- if;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	insert into PROSPECT_LISTS
		( ID               
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, DATE_MODIFIED_UTC
		, ASSIGNED_USER_ID 
		, NAME             
		, DESCRIPTION      
		, LIST_TYPE        
		, DOMAIN_NAME      
		, DYNAMIC_LIST     
		, TEAM_ID          
		, TEAM_SET_ID      
		, ASSIGNED_SET_ID  
		)
	select
		  @ID                
		, @MODIFIED_USER_ID  
		,  getdate()         
		, @MODIFIED_USER_ID  
		,  getdate()         
		,  getutcdate()      
		, ASSIGNED_USER_ID   
		, @NAME              
		, null               
		, N'default'         
		, null               
		, 1                  
		, TEAM_ID            
		, TEAM_SET_ID        
		, ASSIGNED_SET_ID    
	  from vwCAMPAIGNS
	 where ID = @CAMPAIGN_ID;

	if @@ERROR = 0 begin -- then
		if not exists(select * from PROSPECT_LISTS_CSTM where ID_C = @ID) begin -- then
			insert into PROSPECT_LISTS_CSTM ( ID_C ) values ( @ID );
		end -- if;
		
		exec dbo.spPROSPECT_LISTS_SQL_Update @ID, @MODIFIED_USER_ID, @DYNAMIC_SQL, null;
		exec dbo.spPROSPECT_LISTS_UpdateDynamic @ID, @MODIFIED_USER_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spPROSPECT_LISTS_InsertCampaign to public;
GO

