if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWF4_DEFINITION_IDENTITY_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWF4_DEFINITION_IDENTITY_Insert;
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
Create Procedure dbo.spWF4_DEFINITION_IDENTITY_Insert
	( @ID                        uniqueidentifier output
	, @SURROGATE_IDENTITY_ID     uniqueidentifier
	, @DEFINITION_IDENTITY_HASH  uniqueidentifier
	, @NAME                      nvarchar(256)
	, @PACKAGE                   nvarchar(256)
	, @VERSION                   nvarchar(25)
	, @XAML                      nvarchar(max)
	)
as
  begin
	set nocount on
	
	declare @CREATED_BY uniqueidentifier;
	select @ID = ID
	  from WF4_DEFINITION_IDENTITY
	 where SURROGATE_IDENTITY_ID    = @SURROGATE_IDENTITY_ID
	   and DEFINITION_IDENTITY_HASH = @DEFINITION_IDENTITY_HASH;
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into WF4_DEFINITION_IDENTITY
			( ID                       
			, CREATED_BY               
			, DATE_ENTERED             
			, SURROGATE_IDENTITY_ID    
			, DEFINITION_IDENTITY_HASH 
			, NAME                     
			, PACKAGE                  
			, VERSION                  
			, XAML                     
			)
		values 	( @ID                       
			, @CREATED_BY               
			,  getdate()                
			, @SURROGATE_IDENTITY_ID    
			, @DEFINITION_IDENTITY_HASH 
			, @NAME                     
			, @PACKAGE                  
			, @VERSION                  
			, @XAML                     
			);
	end -- if;
  end
GO

Grant Execute on dbo.spWF4_DEFINITION_IDENTITY_Insert to public;
GO


