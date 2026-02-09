if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spREPLICATION_TABLES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spREPLICATION_TABLES_Update;
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
Create Procedure dbo.spREPLICATION_TABLES_Update
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @TABLE_NAME           nvarchar(50)
	, @LOCAL_COUNT          int
	, @LOCAL_LAST_MODIFIED  datetime
	, @REMOTE_COUNT         int
	, @REMOTE_LAST_MODIFIED datetime
	)
as
  begin
	set nocount on
	
	if not exists(select * from REPLICATION_TABLES where TABLE_NAME = @TABLE_NAME) begin -- then
		set @ID = newid();

		insert into REPLICATION_TABLES
			( ID                  
			, CREATED_BY          
			, DATE_ENTERED        
			, MODIFIED_USER_ID    
			, DATE_MODIFIED       
			, DATE_MODIFIED_UTC   
			, TABLE_NAME          
			, LOCAL_COUNT         
			, LOCAL_LAST_MODIFIED 
			, REMOTE_COUNT        
			, REMOTE_LAST_MODIFIED
			)
		values 	( @ID                  
			, @MODIFIED_USER_ID    
			,  getdate()           
			, @MODIFIED_USER_ID    
			,  getdate()           
			,  getutcdate()        
			, @TABLE_NAME          
			, @LOCAL_COUNT         
			, @LOCAL_LAST_MODIFIED 
			, @REMOTE_COUNT        
			, @REMOTE_LAST_MODIFIED
			);
	end else begin
		update REPLICATION_TABLES
		   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
		     , DATE_MODIFIED        =  getdate()           
		     , DATE_MODIFIED_UTC    =  getutcdate()        
		     , LOCAL_COUNT          = @LOCAL_COUNT         
		     , LOCAL_LAST_MODIFIED  = @LOCAL_LAST_MODIFIED 
		     , REMOTE_COUNT         = @REMOTE_COUNT        
		     , REMOTE_LAST_MODIFIED = @REMOTE_LAST_MODIFIED
		 where TABLE_NAME           = @TABLE_NAME                ;
	end -- if;
  end
GO

Grant Execute on dbo.spREPLICATION_TABLES_Update to public;
GO

