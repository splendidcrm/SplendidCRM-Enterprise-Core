if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEMAILS_CampaignRef' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEMAILS_CampaignRef;
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 03/30/2013 Paul.  All campaign emails should be created with the template Assigned User and Team ID. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spEMAILS_CampaignRef
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(255)
	, @PARENT_TYPE       nvarchar(25)
	, @PARENT_ID         uniqueidentifier
	, @DESCRIPTION       nvarchar(max)
	, @DESCRIPTION_HTML  nvarchar(max)
	, @FROM_ADDR         nvarchar(100)
	, @FROM_NAME         nvarchar(100)
	, @TO_ADDRS          nvarchar(max)
	, @TO_ADDRS_IDS      varchar(8000)
	, @TO_ADDRS_NAMES    nvarchar(max)
	, @TO_ADDRS_EMAILS   nvarchar(max)
	, @TYPE              nvarchar(25)
	, @STATUS            nvarchar(25)
	, @RELATED_TYPE      nvarchar(25)
	, @RELATED_ID        uniqueidentifier
	, @ASSIGNED_USER_ID  uniqueidentifier = null
	, @TEAM_ID           uniqueidentifier = null
	, @TEAM_SET_ID       uniqueidentifier = null
	, @ASSIGNED_SET_ID   uniqueidentifier = null
	)
as
  begin
	set nocount on

	declare @DATE_TIME    datetime;
	declare @DATE_START   datetime;
	declare @TIME_START   datetime;
	set @DATE_TIME  = getdate();
	set @DATE_START = dbo.fnStoreDateOnly(@DATE_TIME);
	set @TIME_START = dbo.fnStoreTimeOnly(@DATE_TIME);

	if not exists(select * from EMAILS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
		insert into EMAILS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, NAME             
			, DATE_START       
			, TIME_START       
			, PARENT_TYPE      
			, PARENT_ID        
			, DESCRIPTION      
			, DESCRIPTION_HTML 
			, FROM_ADDR        
			, FROM_NAME        
			, TO_ADDRS         
			, CC_ADDRS         
			, BCC_ADDRS        
			, TO_ADDRS_IDS     
			, TO_ADDRS_NAMES   
			, TO_ADDRS_EMAILS  
			, CC_ADDRS_IDS     
			, CC_ADDRS_NAMES   
			, CC_ADDRS_EMAILS  
			, BCC_ADDRS_IDS    
			, BCC_ADDRS_NAMES  
			, BCC_ADDRS_EMAILS 
			, TYPE             
			, STATUS           
			, MESSAGE_ID       
			, REPLY_TO_NAME    
			, REPLY_TO_ADDR    
			, ASSIGNED_USER_ID 
			, TEAM_ID          
			, TEAM_SET_ID      
			, ASSIGNED_SET_ID  
			)
		values
			( @ID                       
			, @MODIFIED_USER_ID         
			,  getdate()                
			, @MODIFIED_USER_ID         
			,  getdate()                
			, @NAME                     
			, @DATE_START               
			, @TIME_START               
			, @PARENT_TYPE              
			, @PARENT_ID                
			, @DESCRIPTION              
			, @DESCRIPTION_HTML         
			, @FROM_ADDR                
			, @FROM_NAME                
			, @TO_ADDRS                 
			, null -- @CC_ADDRS         
			, null -- @BCC_ADDRS        
			, @TO_ADDRS_IDS             
			, @TO_ADDRS_NAMES           
			, @TO_ADDRS_EMAILS          
			, null -- @CC_ADDRS_IDS     
			, null -- @CC_ADDRS_NAMES   
			, null -- @CC_ADDRS_EMAILS  
			, null -- @BCC_ADDRS_IDS    
			, null -- @BCC_ADDRS_NAMES  
			, null -- @BCC_ADDRS_EMAILS 
			, @TYPE                     
			, @STATUS                   
			, null -- @MESSAGE_ID       
			, null -- @REPLY_TO_NAME    
			, null -- @REPLY_TO_ADDR    
			, @ASSIGNED_USER_ID         
			, @TEAM_ID                  
			, @TEAM_SET_ID              
			, @ASSIGNED_SET_ID          
			);
	end -- if;

	if not exists(select * from EMAILS_CSTM where ID_C = @ID) begin -- then
		insert into EMAILS_CSTM ( ID_C ) values ( @ID );
	end -- if;

	if @RELATED_TYPE = N'Contacts' begin -- then
		exec dbo.spEMAILS_CONTACTS_Update @MODIFIED_USER_ID, @ID, @RELATED_ID;
	end else if @RELATED_TYPE = N'Leads' begin -- then
		exec dbo.spEMAILS_LEADS_Update @MODIFIED_USER_ID, @ID, @RELATED_ID;
	end else if @RELATED_TYPE = N'Prospects' begin -- then
		exec dbo.spEMAILS_PROSPECTS_Update @MODIFIED_USER_ID, @ID, @RELATED_ID;
	end else if @RELATED_TYPE = N'Users' begin -- then
		exec dbo.spEMAILS_USERS_Update @MODIFIED_USER_ID, @ID, @RELATED_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spEMAILS_CampaignRef to public;
GO

