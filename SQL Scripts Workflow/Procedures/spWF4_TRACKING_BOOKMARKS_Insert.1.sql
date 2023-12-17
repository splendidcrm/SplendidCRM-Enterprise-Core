if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWF4_TRACKING_BOOKMARKS_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWF4_TRACKING_BOOKMARKS_Insert;
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
Create Procedure dbo.spWF4_TRACKING_BOOKMARKS_Insert
	( @INSTANCE_ID                 uniqueidentifier
	, @EVENT_TIME                  datetime
	, @RECORD_NUMBER               bigint
	, @ANNOTATIONS                 nvarchar(max)
	, @BOOKMARK_NAME               nvarchar(256)
	, @BOOKMARK_SCOPE_ID           uniqueidentifier
	, @ACTIVITY_OWNER              nvarchar(100)
	, @ACTIVITY_OWNER_INSTANCE     nvarchar(100)
	, @ACTIVITY_OWNER_NAME         nvarchar(256)
	, @ACTIVITY_OWNER_TYPE_NAME    nvarchar(256)
	, @PAYLOAD                     varbinary(max)
	)
as
  begin
	set nocount on
	
	declare @ID         uniqueidentifier;
	declare @CREATED_BY uniqueidentifier;
	set @ID = newid();
	insert into WF4_TRACKING_BOOKMARKS
		( ID                         
		, CREATED_BY                 
		, DATE_ENTERED               
		, INSTANCE_ID                
		, EVENT_TIME                 
		, RECORD_NUMBER              
		, ANNOTATIONS                
		, BOOKMARK_NAME              
		, BOOKMARK_SCOPE_ID          
		, ACTIVITY_OWNER             
		, ACTIVITY_OWNER_INSTANCE    
		, ACTIVITY_OWNER_NAME        
		, ACTIVITY_OWNER_TYPE_NAME   
		, PAYLOAD                    
		)
	values 	( @ID                         
		, @CREATED_BY                 
		,  getdate()                  
		, @INSTANCE_ID                
		, @EVENT_TIME                 
		, @RECORD_NUMBER              
		, @ANNOTATIONS                
		, @BOOKMARK_NAME              
		, @BOOKMARK_SCOPE_ID          
		, @ACTIVITY_OWNER             
		, @ACTIVITY_OWNER_INSTANCE    
		, @ACTIVITY_OWNER_NAME        
		, @ACTIVITY_OWNER_TYPE_NAME   
		, @PAYLOAD                    
		);
  end
GO

Grant Execute on dbo.spWF4_TRACKING_BOOKMARKS_Insert to public;
GO

