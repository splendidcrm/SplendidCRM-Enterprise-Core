if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_ADDED_ACTIVITIES_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_ADDED_ACTIVITIES_Insert;
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
-- 06/28/2008 Paul.  Similar to InsertAddedActivity.
-- 06/28/2008 Paul.  The name ends in Insert because a record is always inserted. 
Create Procedure dbo.spWWF_ADDED_ACTIVITIES_Insert
	( @ID                             uniqueidentifier output
	, @MODIFIED_USER_ID               uniqueidentifier
	, @WORKFLOW_INSTANCE_INTERNAL_ID  uniqueidentifier
	, @WORKFLOW_INSTANCE_EVENT_ID     uniqueidentifier
	, @ACTIVITY_TYPE_FULL_NAME        nvarchar(128)
	, @ACTIVITY_ASSEMBLY_FULL_NAME    nvarchar(256)
	, @QUALIFIED_NAME                 nvarchar(128)
	, @PARENT_QUALIFIED_NAME          nvarchar(128)
	, @ADDED_ACTIVITY_ACTION          nvarchar(4000)
	, @ADDED_ACTIVITY_ORDER           int
	)
as
  begin
	set nocount on

	declare @ACTIVITY_TYPE_ID uniqueidentifier;

	set @ACTIVITY_TYPE_FULL_NAME     = nullif(ltrim(rtrim(@ACTIVITY_TYPE_FULL_NAME    )), N'');
	set @ACTIVITY_ASSEMBLY_FULL_NAME = nullif(ltrim(rtrim(@ACTIVITY_ASSEMBLY_FULL_NAME)), N'');
	exec dbo.spWWF_TYPES_InsertOnly @ACTIVITY_TYPE_ID out, @MODIFIED_USER_ID, @ACTIVITY_TYPE_FULL_NAME, @ACTIVITY_ASSEMBLY_FULL_NAME, 0;

	if dbo.fnIsEmptyGuid(@ACTIVITY_TYPE_ID) = 1 begin -- then
		raiserror(N'spWWF_ADDED_ACTIVITIES_Insert failed calling procedure spWWF_TYPES_InsertOnly', 16, 1);
		return;
	end -- if;

	set @ID = newid();
	insert into WWF_ADDED_ACTIVITIES
		( ID                            
		, CREATED_BY                    
		, DATE_ENTERED                  
		, WORKFLOW_INSTANCE_INTERNAL_ID 
		, WORKFLOW_INSTANCE_EVENT_ID    
		, QUALIFIED_NAME                
		, ACTIVITY_TYPE_ID              
		, PARENT_QUALIFIED_NAME         
		, ADDED_ACTIVITY_ACTION         
		, ADDED_ACTIVITY_ORDER          
		)
	values
	 	( @ID                            
		, @MODIFIED_USER_ID              
		,  getdate()                     
		, @WORKFLOW_INSTANCE_INTERNAL_ID 
		, @WORKFLOW_INSTANCE_EVENT_ID    
		, @QUALIFIED_NAME                
		, @ACTIVITY_TYPE_ID              
		, @PARENT_QUALIFIED_NAME         
		, @ADDED_ACTIVITY_ACTION         
		, @ADDED_ACTIVITY_ORDER          
		);
  end
GO
 
Grant Execute on dbo.spWWF_ADDED_ACTIVITIES_Insert to public;
GO

