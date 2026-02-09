if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spREPLICATION_TABLES_UpdateStatus' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spREPLICATION_TABLES_UpdateStatus;
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
Create Procedure dbo.spREPLICATION_TABLES_UpdateStatus
	( @MODIFIED_USER_ID     uniqueidentifier
	, @TABLE_NAME           nvarchar(50)
	, @STATUS               nvarchar(25)
	, @PENDING_COUNT        int
	, @LAST_ERROR           nvarchar(max)
	)
as
  begin
	set nocount on
	
	update REPLICATION_TABLES
	   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
	     , DATE_MODIFIED        =  getdate()           
	     , DATE_MODIFIED_UTC    =  getutcdate()        
	     , STATUS               = isnull(@STATUS       , STATUS       )
	     , PENDING_COUNT        = isnull(@PENDING_COUNT, PENDING_COUNT)
	     , LAST_ERROR           = isnull(@LAST_ERROR   , LAST_ERROR   )
	 where TABLE_NAME           = @TABLE_NAME          ;
  end
GO

Grant Execute on dbo.spREPLICATION_TABLES_UpdateStatus to public;
GO

