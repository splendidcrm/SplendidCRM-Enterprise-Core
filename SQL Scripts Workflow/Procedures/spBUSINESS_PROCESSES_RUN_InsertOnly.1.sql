if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spBUSINESS_PROCESSES_RUN_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spBUSINESS_PROCESSES_RUN_InsertOnly;
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
Create Procedure dbo.spBUSINESS_PROCESSES_RUN_InsertOnly
	( @MODIFIED_USER_ID    uniqueidentifier
	, @BUSINESS_PROCESS_ID uniqueidentifier
	, @AUDIT_ID            uniqueidentifier
	, @AUDIT_TABLE         nvarchar(50)
	, @STATUS              nvarchar(25)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	set @ID = newid();
	insert into BUSINESS_PROCESSES_RUN
		( ID               
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, BUSINESS_PROCESS_ID      
		, AUDIT_ID         
		, AUDIT_TABLE      
		, STATUS           
		)
	values 	( @ID               
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @BUSINESS_PROCESS_ID      
		, @AUDIT_ID         
		, @AUDIT_TABLE      
		, @STATUS           
		);
  end
GO

Grant Execute on dbo.spBUSINESS_PROCESSES_RUN_InsertOnly to public;
GO

