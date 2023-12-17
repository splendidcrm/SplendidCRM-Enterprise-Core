if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spFIELD_VALIDATORS_InsertRegEx' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spFIELD_VALIDATORS_InsertRegEx;
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
Create Procedure dbo.spFIELD_VALIDATORS_InsertRegEx
	( @MODIFIED_USER_ID   uniqueidentifier
	, @NAME               nvarchar(50)
	, @REGULAR_EXPRESSION nvarchar(2000)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	if not exists(select * from FIELD_VALIDATORS where NAME = @NAME) begin -- then
		set @ID = newid();
		insert into FIELD_VALIDATORS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, NAME              
			, VALIDATION_TYPE   
			, REGULAR_EXPRESSION
			)
		values
			( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @NAME              
			, N'RegularExpressionValidator'
			, @REGULAR_EXPRESSION
			);
	end -- if;
  end
GO

Grant Execute on dbo.spFIELD_VALIDATORS_InsertRegEx to public;
GO

