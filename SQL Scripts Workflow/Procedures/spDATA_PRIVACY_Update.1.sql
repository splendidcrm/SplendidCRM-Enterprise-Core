if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDATA_PRIVACY_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDATA_PRIVACY_Update;
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
Create Procedure dbo.spDATA_PRIVACY_Update
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @ASSIGNED_USER_ID     uniqueidentifier
	, @ASSIGNED_SET_LIST    varchar(8000)
	, @TEAM_ID              uniqueidentifier
	, @TEAM_SET_LIST        varchar(8000)
	, @NAME                 nvarchar(255)
	, @DATA_PRIVACY_NUMBER  nvarchar(30)
	, @TYPE                 nvarchar(100)
	, @PRIORITY             nvarchar(100)
	, @DATE_DUE             datetime
	, @SOURCE               nvarchar(255)
	, @REQUESTED_BY         nvarchar(255)
	, @BUSINESS_PURPOSE     nvarchar(max)
	, @DESCRIPTION          nvarchar(max)
	, @RESOLUTION           nvarchar(max)
	, @WORK_LOG             nvarchar(max)
	, @FIELDS_TO_ERASE      nvarchar(max)
	, @TAG_SET_NAME         nvarchar(4000)
	)
as
  begin
	set nocount on
	
	declare @STATUS                   nvarchar(100);
	declare @DATE_OPENED              datetime;
	declare @DATE_CLOSED              datetime;
	declare @TEMP_DATA_PRIVACY_NUMBER nvarchar(30);
	declare @TEAM_SET_ID              uniqueidentifier;
	declare @ASSIGNED_SET_ID          uniqueidentifier;
	declare @TEMP_FIELDS_TO_ERASE     nvarchar(max);
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;
	set @TEMP_DATA_PRIVACY_NUMBER  = @DATA_PRIVACY_NUMBER;
	set @TEMP_FIELDS_TO_ERASE      = @FIELDS_TO_ERASE;

	if @TEMP_FIELDS_TO_ERASE is null begin -- then
		set @TEMP_FIELDS_TO_ERASE = '';
		select @TEMP_FIELDS_TO_ERASE = @TEMP_FIELDS_TO_ERASE + (case when len(@TEMP_FIELDS_TO_ERASE) > 0 then  ',' else  '' end) + MODULE_NAME + '.' + FIELD_NAME
		  from DATA_PRIVACY_FIELDS
		 where DELETED = 0
		 order by MODULE_NAME, FIELD_NAME;
	end -- if;
	
	if not exists(select * from DATA_PRIVACY where ID = @ID) begin -- then
		set @STATUS      = N'Open';
		set @DATE_OPENED = getdate();

		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		if @TEMP_DATA_PRIVACY_NUMBER is null begin -- then
			exec dbo.spNUMBER_SEQUENCES_Formatted 'DATA_PRIVACY.DATA_PRIVACY_NUMBER', 1, @TEMP_DATA_PRIVACY_NUMBER out;
		end -- if;
		insert into DATA_PRIVACY
			( ID                  
			, CREATED_BY          
			, DATE_ENTERED        
			, MODIFIED_USER_ID    
			, DATE_MODIFIED       
			, DATE_MODIFIED_UTC   
			, ASSIGNED_USER_ID    
			, ASSIGNED_SET_ID     
			, TEAM_ID             
			, TEAM_SET_ID         
			, NAME                
			, DATA_PRIVACY_NUMBER 
			, TYPE                
			, STATUS              
			, PRIORITY            
			, DATE_OPENED         
			, DATE_DUE            
			, DATE_CLOSED         
			, SOURCE              
			, REQUESTED_BY        
			, BUSINESS_PURPOSE    
			, DESCRIPTION         
			, RESOLUTION          
			, WORK_LOG            
			, FIELDS_TO_ERASE     
			)
		values 	( @ID                  
			, @MODIFIED_USER_ID    
			,  getdate()           
			, @MODIFIED_USER_ID    
			,  getdate()           
			,  getutcdate()        
			, @ASSIGNED_USER_ID    
			, @ASSIGNED_SET_ID     
			, @TEAM_ID             
			, @TEAM_SET_ID         
			, @NAME                
			, @TEMP_DATA_PRIVACY_NUMBER
			, @TYPE                
			, @STATUS              
			, @PRIORITY            
			, @DATE_OPENED         
			, @DATE_DUE            
			, @DATE_CLOSED         
			, @SOURCE              
			, @REQUESTED_BY        
			, @BUSINESS_PURPOSE    
			, @DESCRIPTION         
			, @RESOLUTION          
			, @WORK_LOG            
			, @TEMP_FIELDS_TO_ERASE
			);
	end else begin
		update DATA_PRIVACY
		   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
		     , DATE_MODIFIED        =  getdate()           
		     , DATE_MODIFIED_UTC    =  getutcdate()        
		     , ASSIGNED_USER_ID     = @ASSIGNED_USER_ID    
		     , ASSIGNED_SET_ID      = @ASSIGNED_SET_ID     
		     , TEAM_ID              = @TEAM_ID             
		     , TEAM_SET_ID          = @TEAM_SET_ID         
		     , NAME                 = @NAME                
		     , DATA_PRIVACY_NUMBER  = isnull(@TEMP_DATA_PRIVACY_NUMBER, DATA_PRIVACY_NUMBER)
		     , TYPE                 = @TYPE                
--		     , STATUS               = @STATUS              
		     , PRIORITY             = @PRIORITY            
--		     , DATE_OPENED          = @DATE_OPENED         
		     , DATE_DUE             = @DATE_DUE            
--		     , DATE_CLOSED          = @DATE_CLOSED         
		     , SOURCE               = @SOURCE              
		     , REQUESTED_BY         = @REQUESTED_BY        
		     , BUSINESS_PURPOSE     = @BUSINESS_PURPOSE    
		     , DESCRIPTION          = @DESCRIPTION         
		     , RESOLUTION           = @RESOLUTION          
		     , WORK_LOG             = @WORK_LOG            
		     , FIELDS_TO_ERASE      = @TEMP_FIELDS_TO_ERASE
		 where ID                   = @ID                  ;
	end -- if;
	if @@ERROR = 0 begin -- then
		exec dbo.spTAG_SETS_NormalizeSet @MODIFIED_USER_ID, @ID, N'DataPrivacy', @TAG_SET_NAME;
	end -- if;
  end
GO

Grant Execute on dbo.spDATA_PRIVACY_Update to public;
GO

