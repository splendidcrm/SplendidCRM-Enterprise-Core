if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spKBTAGS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spKBTAGS_Update;
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
Create Procedure dbo.spKBTAGS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @PARENT_TAG_ID     uniqueidentifier
	, @TAG_NAME          nvarchar(100)
	)
as
  begin
	set nocount on

	declare @FULL_TAG_NAME     nvarchar(max);
	declare @PARENT_TAG_NAME   nvarchar(max);
	if @PARENT_TAG_ID is not null begin -- then
		select @PARENT_TAG_NAME = FULL_TAG_NAME
		  from KBTAGS
		 where ID      = @PARENT_TAG_ID
		   and DELETED = 0;
		if @PARENT_TAG_NAME is null begin -- then
			set @FULL_TAG_NAME = @TAG_NAME;
			set @PARENT_TAG_ID = null;
		end else begin
			set @FULL_TAG_NAME = @PARENT_TAG_NAME + N'\' + @TAG_NAME;
		end -- if;
	end else begin
		set @FULL_TAG_NAME = @TAG_NAME;
	end -- if;
	
	if not exists(select * from KBTAGS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into KBTAGS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, PARENT_TAG_ID    
			, TAG_NAME         
			, FULL_TAG_NAME    
			)
		values 	( @ID               
			, @MODIFIED_USER_ID       
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @PARENT_TAG_ID    
			, @TAG_NAME         
			, @FULL_TAG_NAME    
			);
	end else begin
		update KBTAGS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , PARENT_TAG_ID     = @PARENT_TAG_ID    
		     , TAG_NAME          = @TAG_NAME         
		     , FULL_TAG_NAME     = @FULL_TAG_NAME    
		 where ID                = @ID               ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spKBTAGS_Update to public;
GO
 
