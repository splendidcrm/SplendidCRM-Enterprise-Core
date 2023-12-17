if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_USER_EVENTS_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_USER_EVENTS_Insert;
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
-- 06/28/2008 Paul.  Similar to InsertUserEvent. 
-- 06/28/2008 Paul.  The name ends in Insert because a record is always inserted. 
-- 09/15/2009 Paul.  Convert data type to varbinary(max) to support Azure. 
Create Procedure dbo.spWWF_USER_EVENTS_Insert
	( @ID                             uniqueidentifier output
	, @MODIFIED_USER_ID               uniqueidentifier
	, @WORKFLOW_INSTANCE_INTERNAL_ID  uniqueidentifier
	, @ACTIVITY_INSTANCE_ID           uniqueidentifier output
	, @QUALIFIED_NAME                 nvarchar(128)
	, @CONTEXT_ID                     uniqueidentifier
	, @PARENT_CONTEXT_ID              uniqueidentifier
	, @EVENT_ORDER                    int
	, @EVENT_DATE_TIME                datetime
	, @USER_DATA_KEY                  nvarchar(512)
	, @USER_DATA_TYPE_FULL_NAME       nvarchar(128)
	, @USER_DATA_ASSEMBLY_FULL_NAME   nvarchar(256)
	, @USER_DATA_STR                  nvarchar(512)
	, @USER_DATA_BLOB                 varbinary(max)
	, @USER_DATA_NON_SERIALIZABLE     bit
	, @DESCRIPTION                    nvarchar(max)
	)
as
  begin
	set nocount on

	declare @WORKFLOW_INSTANCE_EVENT_ID uniqueidentifier;
	declare @USER_DATA_TYPE_ID          uniqueidentifier;

	exec dbo.spWWF_ACTIVITY_INSTANCES_InsertOnly @ACTIVITY_INSTANCE_ID out, @MODIFIED_USER_ID, @WORKFLOW_INSTANCE_INTERNAL_ID, @QUALIFIED_NAME, @CONTEXT_ID, @PARENT_CONTEXT_ID;
	if @ACTIVITY_INSTANCE_ID is null or @@ERROR <> 0 begin -- then
		return;
	end -- if;

	if @USER_DATA_BLOB is not null or @USER_DATA_NON_SERIALIZABLE = 1 begin -- then
		set @USER_DATA_TYPE_FULL_NAME     = nullif(ltrim(rtrim(@USER_DATA_TYPE_FULL_NAME    )), N'');
		set @USER_DATA_ASSEMBLY_FULL_NAME = nullif(ltrim(rtrim(@USER_DATA_ASSEMBLY_FULL_NAME)), N'');
		if @USER_DATA_TYPE_FULL_NAME is null or @USER_DATA_ASSEMBLY_FULL_NAME is null begin -- then
			raiserror(N'@USER_DATA_TYPE_FULL_NAME and @USER_DATA_ASSEMBLY_FULL_NAME must be non null if @USER_DATA_BLOB is non null', 16, 1);
			return;
		end else begin
			exec dbo.spWWF_TYPES_InsertOnly @USER_DATA_TYPE_ID out, @MODIFIED_USER_ID, @USER_DATA_TYPE_FULL_NAME, @USER_DATA_ASSEMBLY_FULL_NAME, 0;
		end -- if;
	end -- if;
	
	set @ID = newid();
	insert into WWF_USER_EVENTS
		( ID                            
		, CREATED_BY                    
		, DATE_ENTERED                  
		, WORKFLOW_INSTANCE_INTERNAL_ID 
		, ACTIVITY_INSTANCE_ID          
		, EVENT_ORDER                   
		, EVENT_DATE_TIME               
		, DB_EVENT_DATE_TIME            
		, USER_DATA_KEY                 
		, USER_DATA_TYPE_ID             
		, USER_DATA_STR                 
		, USER_DATA_BLOB                
		, USER_DATA_NON_SERIALIZABLE    
		, DESCRIPTION                   
		)
	values
	 	( @ID                            
		, @MODIFIED_USER_ID              
		,  getdate()                     
		, @WORKFLOW_INSTANCE_INTERNAL_ID 
		, @ACTIVITY_INSTANCE_ID          
		, @EVENT_ORDER                   
		, @EVENT_DATE_TIME               
		, getdate()                      
		, @USER_DATA_KEY                 
		, @USER_DATA_TYPE_ID             
		, @USER_DATA_STR                 
		, @USER_DATA_BLOB                
		, @USER_DATA_NON_SERIALIZABLE    
		, @DESCRIPTION                   
		);
  end
GO
 
Grant Execute on dbo.spWWF_USER_EVENTS_Insert to public;
GO

