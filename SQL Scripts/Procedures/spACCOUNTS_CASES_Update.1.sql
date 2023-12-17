if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACCOUNTS_CASES_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACCOUNTS_CASES_Update;
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
-- 11/13/2009 Paul.  Remove the unnecessary update as it will reduce offline client conflicts. 
Create Procedure dbo.spACCOUNTS_CASES_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @ACCOUNT_ID        uniqueidentifier
	, @CASE_ID           uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	-- 08/23/2005 Paul.  The ACCOUNTS_CASES table is not used, modify the case directly. 
	-- 04/24/2018 Paul.  ACCOUNTS_CASES use was ended back in 2005. The table needs to be removed as it causes problems with archiving. 
	-- 04/24/2018 Paul.  This procedure will be called within spCASES_Update, so make sure not to update the record if not necessary. 
	-- BEGIN Oracle Exception
		update CASES
		   set ACCOUNT_ID        = @ACCOUNT_ID
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		 where ID                = @CASE_ID
		   and (   (ACCOUNT_ID is null     and @ACCOUNT_ID is not null)
		        or (ACCOUNT_ID is not null and @ACCOUNT_ID is null    )
		        or (ACCOUNT_ID             <>  @ACCOUNT_ID            )
		       )
		   and DELETED           = 0;
	-- END Oracle Raise Exception
	
	/*
	-- BEGIN Oracle Exception
		select @ID = ID
		  from ACCOUNTS_CASES
		 where ACCOUNT_ID        = @ACCOUNT_ID
		   and CASE_ID           = @CASE_ID
		   and DELETED           = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into ACCOUNTS_CASES
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, ACCOUNT_ID       
			, CASE_ID          
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @ACCOUNT_ID       
			, @CASE_ID          
			);
	end -- if;
	*/
  end
GO

Grant Execute on dbo.spACCOUNTS_CASES_Update to public;
GO

