if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOW_TRANS_LOG_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOW_TRANS_LOG_InsertOnly;
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
Create Procedure dbo.spWORKFLOW_TRANS_LOG_InsertOnly
	( @MODIFIED_USER_ID     uniqueidentifier
	, @MODULE_TABLE         nvarchar(30)
	, @WORKFLOW_ID          uniqueidentifier
	, @WORKFLOW_INSTANCE_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID          uniqueidentifier;
	declare @BIND_TOKEN  varchar(255);
	declare @AUDIT_TABLE nvarchar(50);
	set @ID          = newid();
	set @AUDIT_TABLE = @MODULE_TABLE + N'_AUDIT';
	exec dbo.spSqlGetTransactionToken @BIND_TOKEN out;

	insert into WORKFLOW_TRANSACTION_LOG
		( ID                  
		, CREATED_BY          
		, DATE_ENTERED        
		, MODIFIED_USER_ID    
		, DATE_MODIFIED       
		, AUDIT_TABLE         
		, AUDIT_TOKEN         
		, WORKFLOW_ID         
		, WORKFLOW_INSTANCE_ID
		)
	values 	( @ID                  
		, @MODIFIED_USER_ID 
		,  getdate()           
		, @MODIFIED_USER_ID    
		,  getdate()           
		, @AUDIT_TABLE         
		, @BIND_TOKEN          
		, @WORKFLOW_ID         
		, @WORKFLOW_INSTANCE_ID
		);
  end
GO

Grant Execute on dbo.spWORKFLOW_TRANS_LOG_InsertOnly to public;
GO

