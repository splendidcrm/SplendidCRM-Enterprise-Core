if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPHONE_NUMBERS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPHONE_NUMBERS_Update;
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
Create Procedure dbo.spPHONE_NUMBERS_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @PARENT_ID         uniqueidentifier
	, @PARENT_TYPE       nvarchar(25)
	, @PHONE_TYPE        nvarchar(25)
	, @PHONE_NUMBER      nvarchar(25)
	)
as
  begin
	set nocount on
	
	declare @ID                uniqueidentifier;
	declare @NORMALIZED_NUMBER nvarchar(25);

	if @PHONE_NUMBER is not null begin -- then
		set @NORMALIZED_NUMBER = dbo.fnNormalizePhone(@PHONE_NUMBER);
	end -- if;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from PHONE_NUMBERS
		 where PARENT_ID   = @PARENT_ID
		   and PHONE_TYPE  = @PHONE_TYPE
		   and DELETED     = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		if @NORMALIZED_NUMBER is not null begin -- then
			set @ID = newid();
			insert into PHONE_NUMBERS
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, PARENT_ID        
				, PARENT_TYPE      
				, PHONE_TYPE       
				, NORMALIZED_NUMBER
				)
			values
				( @ID               
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @PARENT_ID        
				, @PARENT_TYPE      
				, @PHONE_TYPE       
				, @NORMALIZED_NUMBER
				);
		end -- if;
	end else begin
		if @NORMALIZED_NUMBER is not null begin -- then
			update PHONE_NUMBERS
			   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
			     , DATE_MODIFIED     =  getdate()        
			     , DATE_MODIFIED_UTC =  getutcdate()     
			     , NORMALIZED_NUMBER = @NORMALIZED_NUMBER
			 where ID                = @ID               ;
		end else begin
			update PHONE_NUMBERS
			   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
			     , DATE_MODIFIED     =  getdate()        
			     , DATE_MODIFIED_UTC =  getutcdate()     
			     , DELETED           = 1
			 where ID                = @ID               ;
		end -- if;
	end -- if;
  end
GO
 
Grant Execute on dbo.spPHONE_NUMBERS_Update to public;
GO
 
