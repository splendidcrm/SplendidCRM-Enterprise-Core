if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROCESSES_EndEventGateway' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROCESSES_EndEventGateway;
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
Create Procedure dbo.spPROCESSES_EndEventGateway
	( @MODIFIED_USER_ID             uniqueidentifier
	, @BUSINESS_PROCESS_INSTANCE_ID uniqueidentifier
	, @BOOKMARK_NAME                nvarchar(100)
	)
as
  begin
	set nocount on

	declare @STATUS  nvarchar(50);
	declare @ID      uniqueidentifier;

	-- BEGIN Oracle Exception
		select @ID = ID
		  from vwPROCESSES_Pending
		 where BUSINESS_PROCESS_INSTANCE_ID = @BUSINESS_PROCESS_INSTANCE_ID
		   and @BOOKMARK_NAME               = BOOKMARK_NAME;
	-- END Oracle Exception

	if @ID is not null begin -- then
		set @STATUS = N'Skipped';
		update PROCESSES
		   set MODIFIED_USER_ID             = @MODIFIED_USER_ID 
		     , DATE_MODIFIED                =  getdate()        
		     , DATE_MODIFIED_UTC            =  getutcdate()     
		     , STATUS                       = @STATUS
		 where ID                           = @ID               
		   and DELETED                      = 0;
		exec dbo. spPROCESSES_HISTORY_InsertOnly @MODIFIED_USER_ID, @ID, @BUSINESS_PROCESS_INSTANCE_ID, N'Skip', null, null, null, @STATUS;
	end -- if;
  end
GO
 
Grant Execute on dbo.spPROCESSES_EndEventGateway to public;
GO
 
