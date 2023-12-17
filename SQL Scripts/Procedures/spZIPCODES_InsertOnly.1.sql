if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spZIPCODES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spZIPCODES_InsertOnly;
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
Create Procedure dbo.spZIPCODES_InsertOnly
	( @NAME               nvarchar(20)
	, @CITY               nvarchar(100)
	, @STATE              nvarchar(100)
	, @COUNTRY            nvarchar(100)
	, @LONGITUDE          decimal(10, 6)
	, @LATITUDE           decimal(10, 6)
	)
as
  begin
	set nocount on
	
	declare @ID                uniqueidentifier;
	declare @MODIFIED_USER_ID  uniqueidentifier;
	declare @TEMP_COUNTRY      nvarchar(100);
	set @TEMP_COUNTRY = @COUNTRY;
	if @TEMP_COUNTRY is null begin -- then
		set @TEMP_COUNTRY = N'US';
	end -- if;
	if not exists(select * from ZIPCODES where NAME = @NAME and DELETED = 0) begin -- then
		set @ID = newid();
		insert into ZIPCODES
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, NAME              
			, CITY              
			, STATE             
			, COUNTRY           
			, LONGITUDE         
			, LATITUDE          
			)
		values 	( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @NAME              
			, @CITY              
			, @STATE             
			, @TEMP_COUNTRY      
			, @LONGITUDE         
			, @LATITUDE          
			);
	end -- if;
  end
GO

Grant Execute on dbo.spZIPCODES_InsertOnly to public;
GO

