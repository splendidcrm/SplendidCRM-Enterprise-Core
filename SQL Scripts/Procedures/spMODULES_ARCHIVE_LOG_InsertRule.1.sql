if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_ARCHIVE_LOG_InsertRule' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_ARCHIVE_LOG_InsertRule;
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
Create Procedure dbo.spMODULES_ARCHIVE_LOG_InsertRule
	( @MODIFIED_USER_ID  uniqueidentifier
	, @ARCHIVE_RULE_ID   uniqueidentifier
	, @MODULE_NAME       nvarchar(25)
	, @TABLE_NAME        nvarchar(50)
	)
as
  begin
	declare @ARCHIVE_ACTION nvarchar(25);
	declare @ARCHIVE_TOKEN  varchar(255);

	set @ARCHIVE_ACTION = N'Archive Rule';
	exec dbo.spSqlGetTransactionToken @ARCHIVE_TOKEN out;

	insert into MODULES_ARCHIVE_LOG
		( ID               
		, CREATED_BY       
		, DATE_ENTERED     

		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, MODULE_NAME      
		, TABLE_NAME       
		, ARCHIVE_RULE_ID  
		, ARCHIVE_ACTION   
		, ARCHIVE_TOKEN    
		)
	values 
		(  newid()          
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @MODULE_NAME      
		, @TABLE_NAME       
		, @ARCHIVE_RULE_ID  
		, @ARCHIVE_ACTION   
		, @ARCHIVE_TOKEN    
		);
  end
GO

Grant Execute on dbo.spMODULES_ARCHIVE_LOG_InsertRule to public;
GO

