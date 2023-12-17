if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSURVEY_RESULTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSURVEY_RESULTS_Update;
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
Create Procedure dbo.spSURVEY_RESULTS_Update
	( @ID                 uniqueidentifier output
	, @MODIFIED_USER_ID   uniqueidentifier
	, @SURVEY_ID          uniqueidentifier
	, @PARENT_ID          uniqueidentifier
	, @START_DATE         datetime
	, @SUBMIT_DATE        datetime
	, @IS_COMPLETE        bit
	, @IP_ADDRESS         nvarchar(100)
	, @USER_AGENT         nvarchar(255)
	)
as
  begin
	set nocount on
	
	if not exists(select * from SURVEY_RESULTS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into SURVEY_RESULTS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, SURVEY_ID         
			, PARENT_ID         
			, START_DATE        
			, SUBMIT_DATE       
			, IS_COMPLETE       
			, IP_ADDRESS        
			, USER_AGENT        
			)
		values 	( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @SURVEY_ID         
			, @PARENT_ID         
			, @START_DATE        
			, @SUBMIT_DATE       
			, @IS_COMPLETE       
			, @IP_ADDRESS        
			, @USER_AGENT        
			);
	end else begin
		-- 06/15/2013 Paul.  Do not mark a survey as uncomplete if already complete. 
		-- Do not change submit date if survey is complete. 
		update SURVEY_RESULTS
		   set MODIFIED_USER_ID   = @MODIFIED_USER_ID  
		     , DATE_MODIFIED      =  getdate()         
		     , DATE_MODIFIED_UTC  =  getutcdate()      
		     , SUBMIT_DATE        = (case when IS_COMPLETE = 1 then SUBMIT_DATE else @SUBMIT_DATE end)
		     , IS_COMPLETE        = (case when IS_COMPLETE = 1 then IS_COMPLETE else @IS_COMPLETE end)
		 where ID                 = @ID                ;
	end -- if;
  end
GO

Grant Execute on dbo.spSURVEY_RESULTS_Update to public;
GO

