if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCALL_DETAIL_RECORDS_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCALL_DETAIL_RECORDS_InsertOnly;
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
Create Procedure dbo.spCALL_DETAIL_RECORDS_InsertOnly
	( @MODIFIED_USER_ID     uniqueidentifier
	, @UNIQUEID             nvarchar(32)
	, @ACCOUNT_CODE_ID      uniqueidentifier
	, @SOURCE               nvarchar(80)
	, @DESTINATION          nvarchar(80)
	, @DESTINATION_CONTEXT  nvarchar(80)
	, @CALLERID             nvarchar(80)
	, @SOURCE_CHANNEL       nvarchar(80)
	, @DESTINATION_CHANNEL  nvarchar(80)
	, @START_TIME           datetime
	, @ANSWER_TIME          datetime
	, @END_TIME             datetime
	, @DURATION             int
	, @BILLABLE_SECONDS     int
	, @DISPOSITION          nvarchar(45)
	, @AMA_FLAGS            nvarchar(80)
	, @LAST_APPLICATION     nvarchar(80)
	, @LAST_DATA            nvarchar(80)
	, @USER_FIELD           nvarchar(255)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	set @ID = newid();
	insert into CALL_DETAIL_RECORDS
		( ID                  
		, CREATED_BY          
		, DATE_ENTERED        
		, MODIFIED_USER_ID    
		, DATE_MODIFIED       
		, DATE_MODIFIED_UTC   
		, UNIQUEID            
		, ACCOUNT_CODE_ID     
		, SOURCE              
		, DESTINATION         
		, DESTINATION_CONTEXT 
		, CALLERID            
		, SOURCE_CHANNEL      
		, DESTINATION_CHANNEL 
		, START_TIME          
		, ANSWER_TIME         
		, END_TIME            
		, DURATION            
		, BILLABLE_SECONDS    
		, DISPOSITION         
		, AMA_FLAGS           
		, LAST_APPLICATION    
		, LAST_DATA           
		, USER_FIELD          
		)
	values 	( @ID                  
		, @MODIFIED_USER_ID          
		,  getdate()           
		, @MODIFIED_USER_ID    
		,  getdate()           
		,  getutcdate()        
		, @UNIQUEID            
		, @ACCOUNT_CODE_ID     
		, @SOURCE              
		, @DESTINATION         
		, @DESTINATION_CONTEXT 
		, @CALLERID            
		, @SOURCE_CHANNEL      
		, @DESTINATION_CHANNEL 
		, @START_TIME          
		, @ANSWER_TIME         
		, @END_TIME            
		, @DURATION            
		, @BILLABLE_SECONDS    
		, @DISPOSITION         
		, @AMA_FLAGS           
		, @LAST_APPLICATION    
		, @LAST_DATA           
		, @USER_FIELD          
		);
  end
GO

Grant Execute on dbo.spCALL_DETAIL_RECORDS_InsertOnly to public;
GO

