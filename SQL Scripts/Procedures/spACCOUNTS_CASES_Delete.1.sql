if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACCOUNTS_CASES_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACCOUNTS_CASES_Delete;
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
-- 12/19/2017 Paul.  ACCOUNTS_CASES use was ended back in 2005. The table needs to be removed as it causes problems with archiving. 
Create Procedure dbo.spACCOUNTS_CASES_Delete
	( @MODIFIED_USER_ID uniqueidentifier
	, @ACCOUNT_ID       uniqueidentifier
	, @CASE_ID          uniqueidentifier
	)
as
  begin
	set nocount on
	
	-- 12/19/2017 Paul.  Deleting the relationship means that the field is set to null. 
	if exists(select * from CASES where ACCOUNT_ID = @ACCOUNT_ID and ID = @CASE_ID and DELETED = 0) begin -- then
		update CASES
		   set ACCOUNT_ID       = null
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where ACCOUNT_ID       = @ACCOUNT_ID
		   and ID               = @CASE_ID
		   and DELETED          = 0;
		update CASES_CSTM
		   set ID_C             = ID_C
		 where ID_C             = @CASE_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spACCOUNTS_CASES_Delete to public;
GO

