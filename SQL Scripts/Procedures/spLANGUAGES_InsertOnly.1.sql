if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spLANGUAGES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spLANGUAGES_InsertOnly;
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
Create Procedure dbo.spLANGUAGES_InsertOnly
	( @NAME              nvarchar(10)
	, @LCID              int
	, @ACTIVE            bit
	, @NATIVE_NAME       nvarchar(80)
	, @DISPLAY_NAME      nvarchar(80)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	declare @MODIFIED_USER_ID  uniqueidentifier;
	if not exists(select * from LANGUAGES where NAME = @NAME and DELETED = 0) begin -- then
		set @ID = newid();
		insert into LANGUAGES
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, NAME             
			, LCID             
			, ACTIVE           
			, NATIVE_NAME      
			, DISPLAY_NAME     
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @NAME             
			, @LCID             
			, @ACTIVE           
			, @NATIVE_NAME      
			, @DISPLAY_NAME     
			);
	end -- if;
	-- 01/13/2006 Paul.  InsertOnly is used when importing a Language Pack. Enable the language if necessary. 
	-- 05/21/2008 Paul.  Language is no longer automatically enabled. Now that we add all supported languages, only support the minimum. 
  end
GO
 
Grant Execute on dbo.spLANGUAGES_InsertOnly to public;
GO
 
