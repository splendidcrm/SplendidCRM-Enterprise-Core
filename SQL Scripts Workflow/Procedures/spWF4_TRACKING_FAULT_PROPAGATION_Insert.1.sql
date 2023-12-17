if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWF4_TRACKING_FAULT_PROPAGATION_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWF4_TRACKING_FAULT_PROPAGATION_Insert;
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
-- 11/19/2023 Paul.  Not sure how to get record number inside activity, so get last from ACTIVITY_STATE record. 
Create Procedure dbo.spWF4_TRACKING_FAULT_PROPAGATION_Insert
	( @INSTANCE_ID                uniqueidentifier
	, @EVENT_TIME                 datetime
	, @RECORD_NUMBER              bigint
	, @ANNOTATIONS                nvarchar(max)
	, @FAULT                      nvarchar(max)
	, @STACK_TRACE                nvarchar(max)
	, @IS_FAULT_SOURCE            bit
	, @FAULT_HANDLER              nvarchar(100)
	, @FAULT_HANDLER_INSTANCE     nvarchar(100)
	, @FAULT_HANDLER_NAME         nvarchar(256)
	, @FAULT_HANDLER_TYPE_NAME    nvarchar(256)
	, @FAULT_SOURCE               nvarchar(100)
	, @FAULT_SOURCE_INSTANCE      nvarchar(100)
	, @FAULT_SOURCE_NAME          nvarchar(256)
	, @FAULT_SOURCE_TYPE_NAME     nvarchar(256)
	)
as
  begin
	set nocount on
	
	declare @ID         uniqueidentifier;
	declare @CREATED_BY uniqueidentifier;
	set @ID = newid();
	-- 11/19/2023 Paul.  Not sure how to get record number inside activity, so get last from ACTIVITY_STATE record. 
	if @RECORD_NUMBER = -1 begin -- then
		select @RECORD_NUMBER = max(RECORD_NUMBER) + 1
		  from WF4_TRACKING_ACTIVITY_STATE
		 where INSTANCE_ID = @INSTANCE_ID;
	end -- if;
	insert into WF4_TRACKING_FAULT_PROPAGATION
		( ID                        
		, CREATED_BY                
		, DATE_ENTERED              
		, INSTANCE_ID               
		, EVENT_TIME                
		, RECORD_NUMBER             
		, ANNOTATIONS               
		, FAULT                     
		, STACK_TRACE               
		, IS_FAULT_SOURCE           
		, FAULT_HANDLER             
		, FAULT_HANDLER_INSTANCE    
		, FAULT_HANDLER_NAME        
		, FAULT_HANDLER_TYPE_NAME   
		, FAULT_SOURCE              
		, FAULT_SOURCE_INSTANCE     
		, FAULT_SOURCE_NAME         
		, FAULT_SOURCE_TYPE_NAME    
		)
	values 	( @ID                        
		, @CREATED_BY                
		,  getdate()                 
		, @INSTANCE_ID               
		, @EVENT_TIME                
		, @RECORD_NUMBER             
		, @ANNOTATIONS               
		, @FAULT                     
		, @STACK_TRACE               
		, @IS_FAULT_SOURCE           
		, @FAULT_HANDLER             
		, @FAULT_HANDLER_INSTANCE    
		, @FAULT_HANDLER_NAME        
		, @FAULT_HANDLER_TYPE_NAME   
		, @FAULT_SOURCE              
		, @FAULT_SOURCE_INSTANCE     
		, @FAULT_SOURCE_NAME         
		, @FAULT_SOURCE_TYPE_NAME    
		);
  end
GO

Grant Execute on dbo.spWF4_TRACKING_FAULT_PROPAGATION_Insert to public;
GO

