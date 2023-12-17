if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_TRACKING_DATA_ITEMS_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_TRACKING_DATA_ITEMS_Insert;
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
-- 06/28/2008 Paul.  Similar to InsertTrackingDataItem. 
-- 06/28/2008 Paul.  The name ends in Insert because a record is always inserted. 
-- 09/15/2009 Paul.  Convert data type to varbinary(max) to support Azure. 
Create Procedure dbo.spWWF_TRACKING_DATA_ITEMS_Insert
	( @ID                             uniqueidentifier output
	, @MODIFIED_USER_ID               uniqueidentifier
	, @WORKFLOW_INSTANCE_INTERNAL_ID  uniqueidentifier
	, @EVENT_ID                       uniqueidentifier
	, @EVENT_TYPE                     nvarchar( 25)
	, @FIELD_NAME                     nvarchar(256)
	, @FIELD_TYPE_FULL_NAME           nvarchar(128)
	, @FIELD_ASSEMBLY_FULL_NAME       nvarchar(256)
	, @DATA_STR                       nvarchar(512)
	, @DATA_BLOB                      varbinary(max)
	, @DATA_NON_SERIALIZABLE          bit
	)
as
  begin
	set nocount on

	declare @FIELD_TYPE_ID uniqueidentifier;

	if @DATA_BLOB is not null or @DATA_NON_SERIALIZABLE = 1 begin -- then
		set @FIELD_TYPE_FULL_NAME     = nullif(ltrim(rtrim(@FIELD_TYPE_FULL_NAME    )), N'');
		set @FIELD_ASSEMBLY_FULL_NAME = nullif(ltrim(rtrim(@FIELD_ASSEMBLY_FULL_NAME)), N'');
		if @FIELD_TYPE_FULL_NAME is null or @FIELD_ASSEMBLY_FULL_NAME is null begin -- then
			raiserror(N'@FIELD_TYPE_FULL_NAME and @FIELD_ASSEMBLY_FULL_NAME must be non null if @DATA_BLOB is non null', 16, 1);
			return;
		end else begin
			exec dbo.spWWF_TYPES_InsertOnly @FIELD_TYPE_ID out, @MODIFIED_USER_ID, @FIELD_TYPE_FULL_NAME, @FIELD_ASSEMBLY_FULL_NAME, 0;
		end -- if;
	end -- if;
	
	set @ID = newid();
	insert into WWF_TRACKING_DATA_ITEMS
		( ID                           
		, CREATED_BY                   
		, DATE_ENTERED                 
		, WORKFLOW_INSTANCE_INTERNAL_ID
		, EVENT_ID                     
		, EVENT_TYPE                   
		, FIELD_NAME                   
		, FIELD_TYPE_ID                
		, DATA_STR                     
		, DATA_BLOB                    
		, DATA_NON_SERIALIZABLE        
		)
	values
	 	( @ID                           
		, @MODIFIED_USER_ID             
		,  getdate()                    
		, @WORKFLOW_INSTANCE_INTERNAL_ID
		, @EVENT_ID                     
		, @EVENT_TYPE                   
		, @FIELD_NAME                   
		, @FIELD_TYPE_ID                
		, @DATA_STR                     
		, @DATA_BLOB                    
		, @DATA_NON_SERIALIZABLE        
		);
  end
GO
 
Grant Execute on dbo.spWWF_TRACKING_DATA_ITEMS_Insert to public;
GO

