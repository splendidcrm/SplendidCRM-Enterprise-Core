if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spFIELD_VALIDATORS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spFIELD_VALIDATORS_Update;
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
Create Procedure dbo.spFIELD_VALIDATORS_Update
	( @ID                  uniqueidentifier output
	, @MODIFIED_USER_ID    uniqueidentifier
	, @NAME                nvarchar(50)
	, @VALIDATION_TYPE     nvarchar(50)
	, @REGULAR_EXPRESSION  nvarchar(2000)
	, @DATA_TYPE           nvarchar(25)
	, @MININUM_VALUE       nvarchar(255)
	, @MAXIMUM_VALUE       nvarchar(255)
	, @COMPARE_OPERATOR    nvarchar(25)
	)
as
  begin
	set nocount on
	
	if not exists(select * from FIELD_VALIDATORS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into FIELD_VALIDATORS
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, NAME               
			, VALIDATION_TYPE    
			, REGULAR_EXPRESSION 
			, DATA_TYPE          
			, MININUM_VALUE      
			, MAXIMUM_VALUE      
			, COMPARE_OPERATOR   
			)
		values 	( @ID                 
			, @MODIFIED_USER_ID         
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @NAME               
			, @VALIDATION_TYPE    
			, @REGULAR_EXPRESSION 
			, @DATA_TYPE          
			, @MININUM_VALUE      
			, @MAXIMUM_VALUE      
			, @COMPARE_OPERATOR   
			);
	end else begin
		update FIELD_VALIDATORS
		   set MODIFIED_USER_ID    = @MODIFIED_USER_ID   
		     , DATE_MODIFIED       =  getdate()          
		     , DATE_MODIFIED_UTC   =  getutcdate()       
		     , NAME                = @NAME               
		     , VALIDATION_TYPE     = @VALIDATION_TYPE    
		     , REGULAR_EXPRESSION  = @REGULAR_EXPRESSION 
		     , DATA_TYPE           = @DATA_TYPE          
		     , MININUM_VALUE       = @MININUM_VALUE      
		     , MAXIMUM_VALUE       = @MAXIMUM_VALUE      
		     , COMPARE_OPERATOR    = @COMPARE_OPERATOR   
		 where ID                  = @ID                 ;
	end -- if;
  end
GO

Grant Execute on dbo.spFIELD_VALIDATORS_Update to public;
GO

