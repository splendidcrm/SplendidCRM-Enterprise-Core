if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spFORECASTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spFORECASTS_Update;
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
-- 05/01/2009 Paul.  Add fields from SugarCRM 4.5.1.
Create Procedure dbo.spFORECASTS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @TIMEPERIOD_ID     uniqueidentifier
	, @FORECAST_TYPE     nvarchar(25)
	, @OPP_COUNT         int
	, @OPP_WEIGH_VALUE   int
	, @BEST_CASE         int
	, @LIKELY_CASE       int
	, @WORST_CASE        int
	, @USER_ID           uniqueidentifier
	)
as
  begin
	set nocount on
	
	if not exists(select * from FORECASTS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into FORECASTS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, TIMEPERIOD_ID    
			, FORECAST_TYPE    
			, OPP_COUNT        
			, OPP_WEIGH_VALUE  
			, BEST_CASE        
			, LIKELY_CASE      
			, WORST_CASE       
			, USER_ID          
			)
		values 	( @ID               
			, @MODIFIED_USER_ID       
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @TIMEPERIOD_ID    
			, @FORECAST_TYPE    
			, @OPP_COUNT        
			, @OPP_WEIGH_VALUE  
			, @BEST_CASE        
			, @LIKELY_CASE      
			, @WORST_CASE       
			, @USER_ID          
			);
	end else begin
		update FORECASTS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , TIMEPERIOD_ID     = @TIMEPERIOD_ID    
		     , FORECAST_TYPE     = @FORECAST_TYPE    
		     , OPP_COUNT         = @OPP_COUNT        
		     , OPP_WEIGH_VALUE   = @OPP_WEIGH_VALUE  
		     , BEST_CASE         = @BEST_CASE        
		     , LIKELY_CASE       = @LIKELY_CASE      
		     , WORST_CASE        = @WORST_CASE       
		     , USER_ID           = @USER_ID          
		 where ID                = @ID               ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spFORECASTS_Update to public;
GO
 
