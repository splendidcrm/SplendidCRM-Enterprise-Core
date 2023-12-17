if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_REMOVED_ACTIVITIES_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_REMOVED_ACTIVITIES_Insert;
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
-- 06/30/2008 Paul.  Similar to InsertRemovedActivity. 
-- 06/30/2008 Paul.  The name ends in Insert because a record is always inserted. 
Create Procedure dbo.spWWF_REMOVED_ACTIVITIES_Insert
	( @ID                             uniqueidentifier output
	, @MODIFIED_USER_ID               uniqueidentifier
	, @WORKFLOW_INSTANCE_INTERNAL_ID  uniqueidentifier
	, @WORKFLOW_INSTANCE_EVENT_ID     uniqueidentifier
	, @QUALIFIED_NAME                 nvarchar(128)
	, @PARENT_QUALIFIED_NAME          nvarchar(128)
	, @REMOVED_ACTIVITY_ACTION        nvarchar(4000)
	, @REMOVED_ACTIVITY_ORDER         int
	)
as
  begin
	set nocount on

	set @ID = newid();
	insert into WWF_REMOVED_ACTIVITIES
		( ID                            
		, CREATED_BY                    
		, DATE_ENTERED                  
		, WORKFLOW_INSTANCE_INTERNAL_ID 
		, WORKFLOW_INSTANCE_EVENT_ID    
		, QUALIFIED_NAME                
		, PARENT_QUALIFIED_NAME         
		, REMOVED_ACTIVITY_ACTION       
		, REMOVED_ACTIVITY_ORDER        
		)
	values
	 	( @ID                            
		, @MODIFIED_USER_ID              
		,  getdate()                     
		, @WORKFLOW_INSTANCE_INTERNAL_ID 
		, @WORKFLOW_INSTANCE_EVENT_ID    
		, @QUALIFIED_NAME                
		, @PARENT_QUALIFIED_NAME         
		, @REMOVED_ACTIVITY_ACTION       
		, @REMOVED_ACTIVITY_ORDER        
		);
  end
GO
 
Grant Execute on dbo.spWWF_REMOVED_ACTIVITIES_Insert to public;
GO

