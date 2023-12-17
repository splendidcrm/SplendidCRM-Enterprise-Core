if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_ARCHIVE_RULES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_ARCHIVE_RULES_Update;
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
Create Procedure dbo.spMODULES_ARCHIVE_RULES_Update
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @NAME               nvarchar(150)
	, @MODULE_NAME        nvarchar(25)
	, @STATUS             bit
	, @DESCRIPTION        nvarchar(max)
	, @FILTER_SQL         nvarchar(max)
	, @FILTER_XML         nvarchar(max)
	)
as
  begin
	set nocount on
	
	declare @LIST_ORDER_Y int;
	if not exists(select * from MODULES_ARCHIVE_RULES where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;

		select @LIST_ORDER_Y =  max(LIST_ORDER_Y) + 1
		  from vwMODULES_ARCHIVE_RULES
		 where MODULE_NAME = @MODULE_NAME;
		if @LIST_ORDER_Y is null begin -- then
			set @LIST_ORDER_Y = 1;
		end -- if;

		insert into MODULES_ARCHIVE_RULES
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, NAME              
			, MODULE_NAME       
			, STATUS            
			, LIST_ORDER_Y      
			, DESCRIPTION       
			, FILTER_SQL        
			, FILTER_XML        
			)
		values 	( @ID                
			, @MODIFIED_USER_ID        
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @NAME              
			, @MODULE_NAME       
			, @STATUS            
			, @LIST_ORDER_Y      
			, @DESCRIPTION       
			, @FILTER_SQL        
			, @FILTER_XML        
			);
	end else begin
		update MODULES_ARCHIVE_RULES
		   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
		     , DATE_MODIFIED      =  getdate()         
		     , DATE_MODIFIED_UTC  =  getutcdate()      
		     , NAME               = @NAME              
		     , MODULE_NAME        = @MODULE_NAME       
		     , STATUS             = @STATUS            
		     , LIST_ORDER_Y       = @LIST_ORDER_Y      
		     , DESCRIPTION        = @DESCRIPTION       
		     , FILTER_SQL         = @FILTER_SQL        
		     , FILTER_XML         = @FILTER_XML        
		 where ID                 = @ID                ;
		
		exec dbo.spSUGARFAVORITES_UpdateName @MODIFIED_USER_ID, @ID, @NAME;
	end -- if;
  end
GO

Grant Execute on dbo.spMODULES_ARCHIVE_RULES_Update to public;
GO

