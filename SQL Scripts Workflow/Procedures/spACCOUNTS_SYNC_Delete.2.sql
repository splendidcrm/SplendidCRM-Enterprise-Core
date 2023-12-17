if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACCOUNTS_SYNC_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACCOUNTS_SYNC_Delete;
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
Create Procedure dbo.spACCOUNTS_SYNC_Delete
	( @MODIFIED_USER_ID         uniqueidentifier
	, @ASSIGNED_USER_ID         uniqueidentifier
	, @LOCAL_ID                 uniqueidentifier
	, @REMOTE_KEY               varchar(800)
	, @SERVICE_NAME             nvarchar(25)
	)
as
  begin
	set nocount on

	update ACCOUNTS_SYNC
	   set DELETED           = 1
	     , DATE_MODIFIED     =  getdate()               
	     , DATE_MODIFIED_UTC =  getutcdate()            
	     , MODIFIED_USER_ID  = @MODIFIED_USER_ID        
	 where ASSIGNED_USER_ID  = @ASSIGNED_USER_ID 
	   and REMOTE_KEY        = @REMOTE_KEY 
	   and LOCAL_ID          = @LOCAL_ID 
	   and SERVICE_NAME      = @SERVICE_NAME
	   and DELETED           = 0;
  end
GO

Grant Execute on dbo.spACCOUNTS_SYNC_Delete to public;
GO


