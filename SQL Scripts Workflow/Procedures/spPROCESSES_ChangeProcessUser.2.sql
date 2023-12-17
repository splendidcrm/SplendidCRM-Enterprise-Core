if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROCESSES_ChangeProcessUser' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROCESSES_ChangeProcessUser;
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
-- 03/20/2020 Paul.  Not sure why, but notes were not being saved until now. 
Create Procedure dbo.spPROCESSES_ChangeProcessUser
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @PROCESS_USER_ID   uniqueidentifier
	, @PROCESS_NOTES     nvarchar(max)
	)
as
  begin
	set nocount on

	declare @STATUS                       nvarchar(50);
	declare @BUSINESS_PROCESS_INSTANCE_ID uniqueidentifier;

	-- BEGIN Oracle Exception
		select @BUSINESS_PROCESS_INSTANCE_ID = BUSINESS_PROCESS_INSTANCE_ID
		     , @STATUS                       = STATUS        
		  from PROCESSES
		 where ID = @ID;
	-- END Oracle Exception

	update PROCESSES
	   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
	     , DATE_MODIFIED     =  getdate()        
	     , DATE_MODIFIED_UTC =  getutcdate()     
	     , PROCESS_USER_ID   = @PROCESS_USER_ID
	 where ID                = @ID               
	   and DELETED           = 0;

	exec dbo.spPROCESSES_HISTORY_InsertOnly @MODIFIED_USER_ID, @ID, @BUSINESS_PROCESS_INSTANCE_ID, N'ChangeProcessUser', @PROCESS_USER_ID, null, null, @STATUS;

	-- 03/20/2020 Paul.  Not sure why, but notes were not being saved until now. 
	if @PROCESS_NOTES is not null begin -- then
		exec dbo.spPROCESSES_NOTES_InsertOnly @MODIFIED_USER_ID, @ID, @PROCESS_NOTES;
	end -- if;
  end
GO
 
Grant Execute on dbo.spPROCESSES_ChangeProcessUser to public;
GO
 
