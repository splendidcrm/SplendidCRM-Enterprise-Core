if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTIME_PERIODS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTIME_PERIODS_Update;
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
Create Procedure dbo.spTIME_PERIODS_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(25)
	, @PARENT_ID         uniqueidentifier
	, @START_DATE        datetime
	, @END_DATE          datetime
	, @IS_FISCAL_YEAR    bit
	)
as
  begin
	set nocount on
	
	if not exists(select * from TIME_PERIODS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into TIME_PERIODS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, NAME             
			, PARENT_ID        
			, START_DATE       
			, END_DATE         
			, IS_FISCAL_YEAR   
			)
		values 	( @ID               
			, @MODIFIED_USER_ID       
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @NAME             
			, @PARENT_ID        
			, @START_DATE       
			, @END_DATE         
			, @IS_FISCAL_YEAR   
			);
	end else begin
		update TIME_PERIODS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , NAME              = @NAME             
		     , PARENT_ID         = @PARENT_ID        
		     , START_DATE        = @START_DATE       
		     , END_DATE          = @END_DATE         
		     , IS_FISCAL_YEAR    = @IS_FISCAL_YEAR   
		 where ID                = @ID               ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spTIME_PERIODS_Update to public;
GO
 
