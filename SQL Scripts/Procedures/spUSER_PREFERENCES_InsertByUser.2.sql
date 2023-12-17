if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spUSER_PREFERENCES_InsertByUser' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spUSER_PREFERENCES_InsertByUser;
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
-- 08/27/2008 Paul.  PostgreSQL does not allow modifying input parameters.  Use a local temp variable. 
-- 10/21/2008 Paul.  Increase USER_NAME to 60 to match table. 
Create Procedure dbo.spUSER_PREFERENCES_InsertByUser
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @USER_NAME         nvarchar(60)
	, @CATEGORY          nvarchar(255)
	)
as
  begin
	set nocount on

	declare @ASSIGNED_USER_ID uniqueidentifier;
	declare @TEMP_USER_NAME   nvarchar(60);
	declare @TEMP_CATEGORY    nvarchar(255);
	-- 01/25/2007 Paul.  Convert to lowercase to support Oracle. 	
	set @TEMP_CATEGORY  = lower(@CATEGORY );
	set @TEMP_USER_NAME = lower(@USER_NAME);

	-- BEGIN Oracle Exception
		select @ASSIGNED_USER_ID = ID
		  from USERS
		 where lower(USER_NAME) = @TEMP_USER_NAME
		   and DELETED          = 0;
	-- END Oracle Exception

	exec dbo.spUSER_PREFERENCES_Insert @ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @TEMP_CATEGORY;
  end
GO

Grant Execute on dbo.spUSER_PREFERENCES_InsertByUser to public;
GO

