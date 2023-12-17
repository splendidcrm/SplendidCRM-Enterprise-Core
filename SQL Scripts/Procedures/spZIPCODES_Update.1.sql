if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spZIPCODES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spZIPCODES_Update;
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
Create Procedure dbo.spZIPCODES_Update
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @NAME               nvarchar(20)
	, @CITY               nvarchar(100)
	, @STATE              nvarchar(100)
	, @COUNTRY            nvarchar(100)
	, @LONGITUDE          decimal(10, 6)
	, @LATITUDE           decimal(10, 6)
	, @TIMEZONE_ID        uniqueidentifier
	)
as
  begin
	set nocount on
	
	if not exists(select * from ZIPCODES where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
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
			, TIMEZONE_ID       
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
			, @COUNTRY           
			, @LONGITUDE         
			, @LATITUDE          
			, @TIMEZONE_ID       
			);
	end else begin
		update ZIPCODES
		   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
		     , DATE_MODIFIED      =  getdate()         
		     , DATE_MODIFIED_UTC  =  getutcdate()      
		     , NAME               = @NAME              
		     , CITY               = @CITY              
		     , STATE              = @STATE             
		     , COUNTRY            = @COUNTRY           
		     , LONGITUDE          = @LONGITUDE         
		     , LATITUDE           = @LATITUDE          
		     , TIMEZONE_ID        = @TIMEZONE_ID       
		 where ID                 = @ID                ;
	end -- if;
  end
GO

Grant Execute on dbo.spZIPCODES_Update to public;
GO

