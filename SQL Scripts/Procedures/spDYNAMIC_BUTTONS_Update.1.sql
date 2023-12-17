if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDYNAMIC_BUTTONS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDYNAMIC_BUTTONS_Update;
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
-- 04/25/2008 Paul.  Don't update CONTROL_INDEX.  Only use it during insert. 
-- 07/28/2010 Paul.  We need a flag to exclude a button from a mobile device. 
-- 11/10/2010 Paul.  Control index of -1 means to put at the end. 
-- 03/14/2014 Paul.  Allow hidden buttons to be created. 
-- 08/16/2017 Paul.  Increase the size of the ONCLICK_SCRIPT so that we can add a javascript info column. 
-- 08/16/2017 Paul.  Add ability to apply a business rule to a button. 
Create Procedure dbo.spDYNAMIC_BUTTONS_Update
	( @ID                  uniqueidentifier output
	, @MODIFIED_USER_ID    uniqueidentifier
	, @VIEW_NAME           nvarchar(50)
	, @CONTROL_INDEX       int
	, @CONTROL_TYPE        nvarchar(25)
	, @MODULE_NAME         nvarchar(25)
	, @MODULE_ACCESS_TYPE  nvarchar(100)
	, @TARGET_NAME         nvarchar(25)
	, @TARGET_ACCESS_TYPE  nvarchar(100)
	, @CONTROL_TEXT        nvarchar(150)
	, @CONTROL_TOOLTIP     nvarchar(150)
	, @CONTROL_ACCESSKEY   nvarchar(150)
	, @CONTROL_CSSCLASS    nvarchar(50)
	, @TEXT_FIELD          nvarchar(200)
	, @ARGUMENT_FIELD      nvarchar(200)
	, @COMMAND_NAME        nvarchar(50)
	, @URL_FORMAT          nvarchar(255)
	, @URL_TARGET          nvarchar(20)
	, @ONCLICK_SCRIPT      nvarchar(max)
	, @MOBILE_ONLY         bit
	, @ADMIN_ONLY          bit
	, @EXCLUDE_MOBILE      bit = null
	, @HIDDEN              bit = null
	, @BUSINESS_RULE       nvarchar(max) = null
	, @BUSINESS_SCRIPT     nvarchar(max) = null
	)
as
  begin
	set nocount on
	
	declare @TEMP_CONTROL_INDEX int;	
	set @TEMP_CONTROL_INDEX = @CONTROL_INDEX;
	if @TEMP_CONTROL_INDEX is null or @TEMP_CONTROL_INDEX = -1 begin -- then
		-- BEGIN Oracle Exception
			select @TEMP_CONTROL_INDEX = isnull(max(CONTROL_INDEX), -1) + 1
			  from DYNAMIC_BUTTONS
			 where VIEW_NAME    = @VIEW_NAME
			   and DELETED      = 0         
			   and DEFAULT_VIEW = 0         ;
		-- END Oracle Exception
	end -- if;
	if not exists(select * from DYNAMIC_BUTTONS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		-- 03/18/2008 Paul.  Prevent index from overlapping. 
		if exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = @VIEW_NAME and CONTROL_INDEX = @TEMP_CONTROL_INDEX and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			update DYNAMIC_BUTTONS
			   set CONTROL_INDEX  = CONTROL_INDEX + 1
			 where VIEW_NAME      = @VIEW_NAME
			   and CONTROL_INDEX >= @TEMP_CONTROL_INDEX
			   and DEFAULT_VIEW   = 0
			   and DELETED        = 0;
		end -- if;
		insert into DYNAMIC_BUTTONS
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, VIEW_NAME          
			, CONTROL_INDEX      
			, CONTROL_TYPE       
			, MODULE_NAME        
			, MODULE_ACCESS_TYPE 
			, TARGET_NAME        
			, TARGET_ACCESS_TYPE 
			, MOBILE_ONLY        
			, ADMIN_ONLY         
			, EXCLUDE_MOBILE     
			, HIDDEN             
			, CONTROL_TEXT       
			, CONTROL_TOOLTIP    
			, CONTROL_ACCESSKEY  
			, CONTROL_CSSCLASS   
			, TEXT_FIELD         
			, ARGUMENT_FIELD     
			, COMMAND_NAME       
			, URL_FORMAT         
			, URL_TARGET         
			, ONCLICK_SCRIPT     
			, BUSINESS_RULE      
			, BUSINESS_SCRIPT    
			)
		values 	( @ID                 
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @VIEW_NAME          
			, @TEMP_CONTROL_INDEX 
			, @CONTROL_TYPE       
			, @MODULE_NAME        
			, @MODULE_ACCESS_TYPE 
			, @TARGET_NAME        
			, @TARGET_ACCESS_TYPE 
			, @MOBILE_ONLY        
			, @ADMIN_ONLY         
			, @EXCLUDE_MOBILE     
			, @HIDDEN             
			, @CONTROL_TEXT       
			, @CONTROL_TOOLTIP    
			, @CONTROL_ACCESSKEY  
			, @CONTROL_CSSCLASS   
			, @TEXT_FIELD         
			, @ARGUMENT_FIELD     
			, @COMMAND_NAME       
			, @URL_FORMAT         
			, @URL_TARGET         
			, @ONCLICK_SCRIPT     
			, @BUSINESS_RULE      
			, @BUSINESS_SCRIPT    
			);
	end else begin
		update DYNAMIC_BUTTONS
		   set MODIFIED_USER_ID    = @MODIFIED_USER_ID   
		     , DATE_MODIFIED       =  getdate()          
		     , DATE_MODIFIED_UTC   =  getutcdate()       
		     , VIEW_NAME           = @VIEW_NAME          
		     , CONTROL_TYPE        = @CONTROL_TYPE       
		     , MODULE_NAME         = @MODULE_NAME        
		     , MODULE_ACCESS_TYPE  = @MODULE_ACCESS_TYPE 
		     , TARGET_NAME         = @TARGET_NAME        
		     , TARGET_ACCESS_TYPE  = @TARGET_ACCESS_TYPE 
		     , MOBILE_ONLY         = @MOBILE_ONLY        
		     , ADMIN_ONLY          = @ADMIN_ONLY         
		     , EXCLUDE_MOBILE      = @EXCLUDE_MOBILE     
		     , HIDDEN              = @HIDDEN             
		     , CONTROL_TEXT        = @CONTROL_TEXT       
		     , CONTROL_TOOLTIP     = @CONTROL_TOOLTIP    
		     , CONTROL_ACCESSKEY   = @CONTROL_ACCESSKEY  
		     , CONTROL_CSSCLASS    = @CONTROL_CSSCLASS   
		     , TEXT_FIELD          = @TEXT_FIELD         
		     , ARGUMENT_FIELD      = @ARGUMENT_FIELD     
		     , COMMAND_NAME        = @COMMAND_NAME       
		     , URL_FORMAT          = @URL_FORMAT         
		     , URL_TARGET          = @URL_TARGET         
		     , ONCLICK_SCRIPT      = @ONCLICK_SCRIPT     
		     , BUSINESS_RULE       = @BUSINESS_RULE      
		     , BUSINESS_SCRIPT     = @BUSINESS_SCRIPT    
		 where ID                  = @ID                 ;
	end -- if;
  end
GO

Grant Execute on dbo.spDYNAMIC_BUTTONS_Update to public;
GO

