if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSYSTEM_REST_TABLES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSYSTEM_REST_TABLES_Update;
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
-- 06/18/2011 Paul.  SYSTEM_REST_TABLES are nearly identical to SYSTEM_SYNC_TABLES,
-- but the Module tables typically refer to the base view instead of the raw table. 
-- 08/02/2019 Paul.  The React Client will need access to views that require a filter, like CAMPAIGN_ID. 
Create Procedure dbo.spSYSTEM_REST_TABLES_Update
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @TABLE_NAME           nvarchar(50)
	, @VIEW_NAME            nvarchar(60)
	, @MODULE_NAME          nvarchar(25)
	, @MODULE_NAME_RELATED  nvarchar(25)
	, @MODULE_SPECIFIC      int
	, @MODULE_FIELD_NAME    nvarchar(50)
	, @IS_SYSTEM            bit
	, @IS_ASSIGNED          bit
	, @ASSIGNED_FIELD_NAME  nvarchar(50)
	, @IS_RELATIONSHIP      bit
	, @REQUIRED_FIELDS      nvarchar(150) = null
	)
as
  begin
	set nocount on
	
	declare @DEPENDENT_LEVEL int;
	declare @HAS_CUSTOM      bit;
	set @DEPENDENT_LEVEL = dbo.fnSqlDependentLevel(@TABLE_NAME, 'U');
	set @HAS_CUSTOM      = 0;
	-- 01/11/2010 Paul.  Use vwSqlTables as it is portable to oracle. 
	if exists(select * from vwSqlTables where TABLE_NAME = @VIEW_NAME + '_CSTM') begin -- then
		set @HAS_CUSTOM = 1;
	end -- if;
	if not exists(select * from SYSTEM_REST_TABLES where TABLE_NAME = @TABLE_NAME and DELETED = 0) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into SYSTEM_REST_TABLES
			( ID                  
			, CREATED_BY          
			, DATE_ENTERED        
			, MODIFIED_USER_ID    
			, DATE_MODIFIED       
			, DATE_MODIFIED_UTC   
			, TABLE_NAME          
			, VIEW_NAME           
			, MODULE_NAME         
			, MODULE_NAME_RELATED 
			, MODULE_SPECIFIC     
			, MODULE_FIELD_NAME   
			, IS_SYSTEM           
			, IS_ASSIGNED         
			, ASSIGNED_FIELD_NAME 
			, IS_RELATIONSHIP     
			, HAS_CUSTOM          
			, DEPENDENT_LEVEL     
			, REQUIRED_FIELDS     
			)
		values 	( @ID                  
			, @MODIFIED_USER_ID    
			,  getdate()           
			, @MODIFIED_USER_ID    
			,  getdate()           
			,  getutcdate()        
			, @TABLE_NAME          
			, @VIEW_NAME           
			, @MODULE_NAME         
			, @MODULE_NAME_RELATED 
			, @MODULE_SPECIFIC     
			, @MODULE_FIELD_NAME   
			, @IS_SYSTEM           
			, @IS_ASSIGNED         
			, @ASSIGNED_FIELD_NAME 
			, @IS_RELATIONSHIP     
			, @HAS_CUSTOM          
			, @DEPENDENT_LEVEL     
			, @REQUIRED_FIELDS     
			);
		-- 11/26/2009 Paul.  Modules are not REST enabled by default, so we will enable modules as necessary. 
		if @MODULE_NAME is not null begin -- then
			if exists(select * from vwMODULES where MODULE_NAME = @MODULE_NAME and (REST_ENABLED = 0 or REST_ENABLED is null)) begin -- then
				update MODULES
				   set REST_ENABLED         = 1
				     , MODIFIED_USER_ID     = @MODIFIED_USER_ID    
				     , DATE_MODIFIED        =  getdate()           
				     , DATE_MODIFIED_UTC    =  getutcdate()        
				 where MODULE_NAME          = @MODULE_NAME
				   and DELETED              = 0;
			end -- if;
		end -- if;
		if @MODULE_NAME_RELATED is not null begin -- then
			if exists(select * from vwMODULES where MODULE_NAME = @MODULE_NAME_RELATED and (REST_ENABLED = 0 or REST_ENABLED is null)) begin -- then
				update MODULES
				   set REST_ENABLED         = 1
				     , MODIFIED_USER_ID     = @MODIFIED_USER_ID    
				     , DATE_MODIFIED        =  getdate()           
				     , DATE_MODIFIED_UTC    =  getutcdate()        
				 where MODULE_NAME          = @MODULE_NAME_RELATED
				   and DELETED              = 0;
			end -- if;
		end -- if;
	end else begin
		update SYSTEM_REST_TABLES
		   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
		     , DATE_MODIFIED        =  getdate()           
		     , DATE_MODIFIED_UTC    =  getutcdate()        
		     , TABLE_NAME           = @TABLE_NAME          
		     , VIEW_NAME            = @VIEW_NAME           
		     , MODULE_NAME          = @MODULE_NAME         
		     , MODULE_NAME_RELATED  = @MODULE_NAME_RELATED 
		     , MODULE_SPECIFIC      = @MODULE_SPECIFIC     
		     , MODULE_FIELD_NAME    = @MODULE_FIELD_NAME   
		     , IS_SYSTEM            = @IS_SYSTEM           
		     , IS_ASSIGNED          = @IS_ASSIGNED         
		     , ASSIGNED_FIELD_NAME  = @ASSIGNED_FIELD_NAME 
		     , IS_RELATIONSHIP      = @IS_RELATIONSHIP     
		     , HAS_CUSTOM           = @HAS_CUSTOM          
		     , DEPENDENT_LEVEL      = @DEPENDENT_LEVEL     
		     , REQUIRED_FIELDS      = @REQUIRED_FIELDS     
		 where ID                   = @ID                  ;
	end -- if;
  end
GO

Grant Execute on dbo.spSYSTEM_REST_TABLES_Update to public;
GO

