if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPARENT_UpdateLastActivity' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPARENT_UpdateLastActivity;
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
-- 11/22/2012 Paul.  Activity moved to a separate table to prevent auditing. 
Create Procedure dbo.spPARENT_UpdateLastActivity
	( @MODIFIED_USER_ID  uniqueidentifier
	, @PARENT_ID         uniqueidentifier
	, @PARENT_TYPE       nvarchar(25)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	declare @TEMP_PARENT_TYPE nvarchar(25);
	if not exists(select * from LAST_ACTIVITY where ACTIVITY_ID = @PARENT_ID) begin -- then
		-- 12/15/2013 Paul.  PARENT_TYPE is a required field, so do a lookup if not provided. 
		set @TEMP_PARENT_TYPE = @PARENT_TYPE;
		if @TEMP_PARENT_TYPE is null begin -- then
			-- BEGIN Oracle Exception
				select top 1 @TEMP_PARENT_TYPE = PARENT_TYPE
				  from vwPARENTS
				 where PARENT_ID = @PARENT_ID
				 order by PARENT_TYPE;
			-- END Oracle Exception
		end -- if;

		set @ID = newid();
		insert into LAST_ACTIVITY
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, ACTIVITY_ID       
			, ACTIVITY_TYPE     
			, LAST_ACTIVITY_DATE
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @PARENT_ID        
			, @TEMP_PARENT_TYPE 
			,  getdate()        
			);
	end else begin
		update LAST_ACTIVITY
		   set LAST_ACTIVITY_DATE = getdate()
		     , DATE_MODIFIED      = getdate()
		     , DATE_MODIFIED_UTC  = getutcdate()
		     , MODIFIED_USER_ID   = @MODIFIED_USER_ID
		 where ACTIVITY_ID        = @PARENT_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spPARENT_UpdateLastActivity to public;
GO

