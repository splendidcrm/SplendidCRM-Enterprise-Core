if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWF4_TRACKING_ACTIVITY_SCHEDULE_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWF4_TRACKING_ACTIVITY_SCHEDULE_Insert;
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
Create Procedure dbo.spWF4_TRACKING_ACTIVITY_SCHEDULE_Insert
	( @INSTANCE_ID                 uniqueidentifier
	, @EVENT_TIME                  datetime
	, @RECORD_NUMBER               bigint
	, @ANNOTATIONS                 nvarchar(max)
	, @ACTIVITY                    nvarchar(100)
	, @ACTIVITY_INSTANCE           nvarchar(100)
	, @ACTIVITY_NAME               nvarchar(256)
	, @ACTIVITY_TYPE_NAME          nvarchar(256)
	, @CHILD_ACTIVITY              nvarchar(100)
	, @CHILD_ACTIVITY_INSTANCE     nvarchar(100)
	, @CHILD_ACTIVITY_NAME         nvarchar(256)
	, @CHILD_ACTIVITY_TYPE_NAME    nvarchar(256)
	)
as
  begin
	set nocount on
	
	declare @ID         uniqueidentifier;
	declare @CREATED_BY uniqueidentifier;
	set @ID = newid();
	insert into WF4_TRACKING_ACTIVITY_SCHEDULE
		( ID                         
		, CREATED_BY                 
		, DATE_ENTERED               
		, INSTANCE_ID                
		, EVENT_TIME                 
		, RECORD_NUMBER              
		, ANNOTATIONS                
		, ACTIVITY                   
		, ACTIVITY_INSTANCE          
		, ACTIVITY_NAME              
		, ACTIVITY_TYPE_NAME         
		, CHILD_ACTIVITY             
		, CHILD_ACTIVITY_INSTANCE    
		, CHILD_ACTIVITY_NAME        
		, CHILD_ACTIVITY_TYPE_NAME   
		)
	values 	( @ID                         
		, @CREATED_BY                 
		,  getdate()                  
		, @INSTANCE_ID                
		, @EVENT_TIME                 
		, @RECORD_NUMBER              
		, @ANNOTATIONS                
		, @ACTIVITY                   
		, @ACTIVITY_INSTANCE          
		, @ACTIVITY_NAME              
		, @ACTIVITY_TYPE_NAME         
		, @CHILD_ACTIVITY             
		, @CHILD_ACTIVITY_INSTANCE    
		, @CHILD_ACTIVITY_NAME        
		, @CHILD_ACTIVITY_TYPE_NAME   
		);
  end
GO

Grant Execute on dbo.spWF4_TRACKING_ACTIVITY_SCHEDULE_Insert to public;
GO

