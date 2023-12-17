if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROCESSES_HISTORY_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROCESSES_HISTORY_InsertOnly;
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
Create Procedure dbo.spPROCESSES_HISTORY_InsertOnly
	( @MODIFIED_USER_ID              uniqueidentifier
	, @PROCESS_ID                    uniqueidentifier
	, @BUSINESS_PROCESS_INSTANCE_ID  uniqueidentifier
	, @PROCESS_ACTION                nvarchar(50)
	, @PROCESS_USER_ID               uniqueidentifier
	, @ASSIGNED_USER_ID              uniqueidentifier
	, @APPROVAL_USER_ID              uniqueidentifier
	, @STATUS                        nvarchar(50)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	set @ID = newid();
	insert into PROCESSES_HISTORY
		( ID                           
		, CREATED_BY                   
		, DATE_ENTERED                 
		, MODIFIED_USER_ID             
		, DATE_MODIFIED                
		, DATE_MODIFIED_UTC            
		, PROCESS_ID                   
		, BUSINESS_PROCESS_INSTANCE_ID 
		, PROCESS_ACTION               
		, PROCESS_USER_ID              
		, ASSIGNED_USER_ID             
		, APPROVAL_USER_ID             
		, STATUS                       
		)
	values 	( @ID                           
		, @MODIFIED_USER_ID                   
		,  getdate()                    
		, @MODIFIED_USER_ID             
		,  getdate()                    
		,  getutcdate()                 
		, @PROCESS_ID                   
		, @BUSINESS_PROCESS_INSTANCE_ID 
		, @PROCESS_ACTION               
		, @PROCESS_USER_ID              
		, @ASSIGNED_USER_ID             
		, @APPROVAL_USER_ID             
		, @STATUS                       
		);
  end
GO

Grant Execute on dbo.spPROCESSES_HISTORY_InsertOnly to public;
GO

