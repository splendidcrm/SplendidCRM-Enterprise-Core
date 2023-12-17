if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPRODUCT_CATEGORIES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPRODUCT_CATEGORIES_Update;
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/03/2010 Paul.  We need to create the custom field record. 
-- 10/21/2010 Paul.  @LIST_ORDER of -1 means to use the max+1. 
Create Procedure dbo.spPRODUCT_CATEGORIES_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @PARENT_ID         uniqueidentifier
	, @NAME              nvarchar(50)
	, @DESCRIPTION       nvarchar(max)
	, @LIST_ORDER        int
	)
as
  begin
	set nocount on
	
	declare @TEMP_LIST_ORDER int;
	set @TEMP_LIST_ORDER = @LIST_ORDER;
	if @TEMP_LIST_ORDER is null or @TEMP_LIST_ORDER = -1 begin -- then
		-- BEGIN Oracle Exception
			select @TEMP_LIST_ORDER = isnull(max(LIST_ORDER), 0) + 1
			  from PRODUCT_CATEGORIES
			 where DELETED = 0;
		-- END Oracle Exception
	end -- if;
	if not exists(select * from PRODUCT_CATEGORIES where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into PRODUCT_CATEGORIES
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, PARENT_ID        
			, NAME             
			, DESCRIPTION      
			, LIST_ORDER       
			)
		values 	( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @PARENT_ID        
			, @NAME             
			, @DESCRIPTION      
			, @TEMP_LIST_ORDER  
			);
	end else begin
		update PRODUCT_CATEGORIES
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , PARENT_ID         = @PARENT_ID        
		     , NAME              = @NAME             
		     , DESCRIPTION       = @DESCRIPTION      
		     , LIST_ORDER        = @TEMP_LIST_ORDER  
		 where ID                = @ID               ;
	end -- if;

	if @@ERROR = 0 begin -- then
		if not exists(select * from PRODUCT_CATEGORIES_CSTM where ID_C = @ID) begin -- then
			insert into PRODUCT_CATEGORIES_CSTM ( ID_C ) values ( @ID );
		end -- if;
	end -- if;
  end
GO
 
Grant Execute on dbo.spPRODUCT_CATEGORIES_Update to public;
GO
 
