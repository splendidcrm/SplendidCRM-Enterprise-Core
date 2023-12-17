if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSCHEDULERS_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSCHEDULERS_InsertOnly;
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
-- 12/31/2007 Paul.  Don't need to insert LAST_RUN. 
Create Procedure dbo.spSCHEDULERS_InsertOnly
	( @MODIFIED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(255)
	, @JOB               nvarchar(255)
	, @DATE_TIME_START   datetime
	, @DATE_TIME_END     datetime
	, @JOB_INTERVAL      nvarchar(100)
	, @TIME_FROM         datetime
	, @TIME_TO           datetime
	, @STATUS            nvarchar(25)
	, @CATCH_UP          bit
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	

	-- BEGIN Oracle Exception
		select @ID = ID
		  from SCHEDULERS
		 where NAME    = @NAME
		   and DELETED = 0    ;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into SCHEDULERS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, NAME             
			, JOB              
			, DATE_TIME_START  
			, DATE_TIME_END    
			, JOB_INTERVAL     
			, TIME_FROM        
			, TIME_TO          
			, STATUS           
			, CATCH_UP         
			)
		values 	( @ID               
			, @MODIFIED_USER_ID       
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @NAME             
			, @JOB              
			, @DATE_TIME_START  
			, @DATE_TIME_END    
			, @JOB_INTERVAL     
			, @TIME_FROM        
			, @TIME_TO          
			, @STATUS           
			, @CATCH_UP         
			);
	end -- if;
  end
GO
 
Grant Execute on dbo.spSCHEDULERS_InsertOnly to public;
GO

