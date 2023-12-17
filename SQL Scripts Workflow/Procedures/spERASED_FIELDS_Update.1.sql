if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spERASED_FIELDS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spERASED_FIELDS_Update;
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
Create Procedure dbo.spERASED_FIELDS_Update
	( @MODIFIED_USER_ID     uniqueidentifier
	, @BEAN_ID              uniqueidentifier
	, @TABLE_NAME           nvarchar(50)
	, @DATA                 nvarchar(max)
	)
as
  begin
	set nocount on

	declare @ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from ERASED_FIELDS
		 where BEAN_ID = @BEAN_ID
		   and DELETED = 0;
	-- END Oracle Exception

	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into ERASED_FIELDS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, BEAN_ID           
			, TABLE_NAME        
			, DATA              
			)
		values 	( @ID                
			, @MODIFIED_USER_ID        
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @BEAN_ID           
			, @TABLE_NAME        
			, @DATA              
			);
	end else begin
		if @DATA is null or len(@DATA) = 0 begin -- then
			update ERASED_FIELDS
			   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
			     , DATE_MODIFIED      =  getdate()         
			     , DATE_MODIFIED_UTC  =  getutcdate()      
			     , DELETED            = 1                  
			 where ID                 = @ID                ;
		end else begin
			update ERASED_FIELDS
			   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
			     , DATE_MODIFIED      =  getdate()         
			     , DATE_MODIFIED_UTC  =  getutcdate()      
			     , DATA               = @DATA              
			 where ID                 = @ID                ;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spERASED_FIELDS_Update to public;
GO

