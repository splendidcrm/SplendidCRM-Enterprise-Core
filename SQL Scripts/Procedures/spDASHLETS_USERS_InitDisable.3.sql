if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDASHLETS_USERS_InitDisable' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDASHLETS_USERS_InitDisable;
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
-- 09/24/2009 Paul.  The new Silverlight charts exceeded the control name length of 50. 
Create Procedure dbo.spDASHLETS_USERS_InitDisable
	( @MODIFIED_USER_ID uniqueidentifier
	, @ASSIGNED_USER_ID uniqueidentifier
	, @DETAIL_NAME      nvarchar(50)
	, @MODULE_NAME      nvarchar(50)
	, @CONTROL_NAME     nvarchar(100)
	)
as
  begin
	set nocount on

	declare @ID uniqueidentifier;
	exec dbo.spDASHLETS_USERS_Init @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @DETAIL_NAME;

	-- BEGIN Oracle Exception
		select @ID = ID
		  from DASHLETS_USERS
		 where ASSIGNED_USER_ID     = @ASSIGNED_USER_ID 
		   and DETAIL_NAME          = @DETAIL_NAME      
		   and MODULE_NAME          = @MODULE_NAME      
		   and CONTROL_NAME         = @CONTROL_NAME     
		   and DELETED              = 0                 ;
	-- END Oracle Exception

	exec dbo.spDASHLETS_USERS_Disable @ID, @MODIFIED_USER_ID;
  end
GO

Grant Execute on dbo.spDASHLETS_USERS_InitDisable to public;
GO

