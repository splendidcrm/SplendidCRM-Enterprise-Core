if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACCOUNTS_OPPORTUNITIES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACCOUNTS_OPPORTUNITIES_Update;
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
-- 02/19/2008 Paul.  Move relationship management to spACCOUNTS_OPPORTUNITIES_Update. 
-- There should only be one active relationship, but don't update if nothing changed. 
-- 02/19/2008 Paul.  Now that we are using triggers, we need to minimize unnecessary updates.
-- 11/13/2009 Paul.  Remove the unnecessary update as it will reduce offline client conflicts. 
Create Procedure dbo.spACCOUNTS_OPPORTUNITIES_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @ACCOUNT_ID        uniqueidentifier
	, @OPPORTUNITY_ID    uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from ACCOUNTS_OPPORTUNITIES
		 where OPPORTUNITY_ID    = @OPPORTUNITY_ID
		   and ACCOUNT_ID        = @ACCOUNT_ID
		   and DELETED           = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		-- 02/19/2008 Paul.  An opportunity can only have one account, so delete if any others exist. 
		if exists(select * from ACCOUNTS_OPPORTUNITIES where DELETED = 0 and OPPORTUNITY_ID = @OPPORTUNITY_ID) begin -- then
			update ACCOUNTS_OPPORTUNITIES
			   set DELETED          = 1
			     , MODIFIED_USER_ID = @MODIFIED_USER_ID 
			     , DATE_MODIFIED    =  getdate()        
			     , DATE_MODIFIED_UTC=  getutcdate()     
			 where DELETED          = 0
			   and OPPORTUNITY_ID   = @OPPORTUNITY_ID;
		end -- if;
		set @ID = newid();
		insert into ACCOUNTS_OPPORTUNITIES
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, OPPORTUNITY_ID   
			, ACCOUNT_ID       
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @OPPORTUNITY_ID   
			, @ACCOUNT_ID       
			);
	end -- if;
  end
GO
 
Grant Execute on dbo.spACCOUNTS_OPPORTUNITIES_Update to public;
GO
 
