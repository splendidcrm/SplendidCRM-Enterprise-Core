if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCALL_MARKETING_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCALL_MARKETING_Update;
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
Create Procedure dbo.spCALL_MARKETING_Update
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @CAMPAIGN_ID        uniqueidentifier
	, @ASSIGNED_USER_ID   uniqueidentifier
	, @TEAM_ID            uniqueidentifier
	, @NAME               nvarchar(255)
	, @STATUS             nvarchar(25)
	, @DISTRIBUTION       nvarchar(25)
	, @ALL_PROSPECT_LISTS bit
	, @SUBJECT            nvarchar(50)
	, @DURATION_HOURS     int
	, @DURATION_MINUTES   int
	, @DATE_START         datetime
	, @DATE_END           datetime
	, @REMINDER_TIME      int
	, @DESCRIPTION        nvarchar(max)
	, @TEAM_SET_LIST      varchar(8000) = null
	, @ASSIGNED_SET_LIST  varchar(8000) = null
	)
as
  begin
	set nocount on

	declare @TEAM_SET_ID         uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;
	declare @TIME_START datetime;
	declare @TIME_END   datetime;
	set @TIME_START = dbo.fnStoreTimeOnly(@DATE_START);
	set @TIME_END   = dbo.fnStoreTimeOnly(@DATE_END  );
	
	-- 11/30/2017 Paul.  Add TEAM_SET_ID. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;


	if not exists(select * from CALL_MARKETING where ID = @ID) begin -- then
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
		values
			( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @CAMPAIGN_ID       
			, @ASSIGNED_USER_ID  
			, @TEAM_ID           
			, @NAME              
			, @STATUS            
			, @DISTRIBUTION      
			, @ALL_PROSPECT_LISTS
			, @SUBJECT           
			, @DURATION_HOURS    
			, @DURATION_MINUTES  
			, @DATE_START        
			, @TIME_START        
			, @DATE_END          
			, @TIME_END          
			, @REMINDER_TIME     
			, @DESCRIPTION       
			, @TEAM_SET_ID       
			, @ASSIGNED_SET_ID   
			);
	end else begin
		update CALL_MARKETING
		   set MODIFIED_USER_ID    = @MODIFIED_USER_ID  
		     , DATE_MODIFIED       =  getdate()         
		     , DATE_MODIFIED_UTC   =  getutcdate()      
		     , CAMPAIGN_ID         = @CAMPAIGN_ID       
		     , ASSIGNED_USER_ID    = @ASSIGNED_USER_ID  
		     , TEAM_ID             = @TEAM_ID           
		     , NAME                = @NAME              
		     , STATUS              = @STATUS            
		     , DISTRIBUTION        = @DISTRIBUTION      
		     , ALL_PROSPECT_LISTS  = @ALL_PROSPECT_LISTS
		     , SUBJECT             = @SUBJECT           
		     , DURATION_HOURS      = @DURATION_HOURS    
		     , DURATION_MINUTES    = @DURATION_MINUTES  
		     , DATE_START          = @DATE_START        
		     , TIME_START          = @TIME_START        
		     , DATE_END            = @DATE_END          
		     , TIME_END            = @TIME_END          
		     , REMINDER_TIME       = @REMINDER_TIME     
		     , DESCRIPTION         = @DESCRIPTION       
		     , TEAM_SET_ID         = @TEAM_SET_ID       
		     , ASSIGNED_SET_ID     = @ASSIGNED_SET_ID   
		 where ID                  = @ID                ;
		if @ALL_PROSPECT_LISTS = 1 begin -- then
			if exists(select * from CALL_MARKETING_PROSPECT_LISTS where CALL_MARKETING_ID = @ID and DELETED = 0) begin -- then
				update CALL_MARKETING_PROSPECT_LISTS
				   set DELETED            = 1
				     , MODIFIED_USER_ID   = @MODIFIED_USER_ID 
				     , DATE_MODIFIED      =  getdate()        
				     , DATE_MODIFIED_UTC  =  getutcdate()     
				 where CALL_MARKETING_ID = @ID
				   and DELETED            = 0;
			end -- if;
		end -- if;
	end -- if;

	if not exists(select * from CALL_MARKETING_CSTM where ID_C = @ID) begin -- then
		insert into CALL_MARKETING_CSTM ( ID_C ) values ( @ID );
	end -- if;

  end
GO

Grant Execute on dbo.spCALL_MARKETING_Update to public;
GO

