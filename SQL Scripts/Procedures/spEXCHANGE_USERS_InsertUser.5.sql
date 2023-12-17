if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEXCHANGE_USERS_InsertUser' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEXCHANGE_USERS_InsertUser;
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
Create Procedure dbo.spEXCHANGE_USERS_InsertUser
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @EXCHANGE_ALIAS    nvarchar(60)
	, @EXCHANGE_EMAIL    nvarchar(100)
	, @EXCHANGE_FIRST    nvarchar(30)
	, @EXCHANGE_LAST     nvarchar(30)
	, @EXCHANGE_TITLE    nvarchar(50)
	, @EXCHANGE_PHONE    nvarchar(50)
	, @IMPERSONATED_TYPE nvarchar(25)
	)
as
  begin
	set nocount on

	declare @EXCHANGE_ID      uniqueidentifier;
	declare @ASSIGNED_USER_ID uniqueidentifier;
	
	if @IMPERSONATED_TYPE = 'SmtpAddress' begin -- then
		-- BEGIN Oracle Exception
			select @EXCHANGE_ID = ID
			  from EXCHANGE_USERS
			 where EXCHANGE_EMAIL = @EXCHANGE_EMAIL
			   and DELETED        = 0;
		-- END Oracle Exception
		
		-- BEGIN Oracle Exception
			select @ASSIGNED_USER_ID = ID
			  from vwUSERS
			 where EMAIL1 = @EXCHANGE_EMAIL;
		-- END Oracle Exception
	end else begin
		-- BEGIN Oracle Exception
			select @EXCHANGE_ID = ID
			  from EXCHANGE_USERS
			 where EXCHANGE_ALIAS = @EXCHANGE_ALIAS
			   and DELETED        = 0;
		-- END Oracle Exception
		
		-- BEGIN Oracle Exception
			select @ASSIGNED_USER_ID = ID
			  from vwUSERS
			 where USER_NAME = @EXCHANGE_ALIAS;
		-- END Oracle Exception
	end -- if;
	
	if dbo.fnIsEmptyGuid(@EXCHANGE_ID) = 1 and dbo.fnIsEmptyGuid(@ASSIGNED_USER_ID) = 1 begin -- then
		exec dbo.spUSERS_Update
			  @ASSIGNED_USER_ID out
			, @MODIFIED_USER_ID
			, @EXCHANGE_ALIAS -- @USER_NAME
			, @EXCHANGE_FIRST -- @FIRST_NAME
			, @EXCHANGE_LAST  -- @LAST_NAME
			, null            -- @REPORTS_TO_ID
			, 0               -- @IS_ADMIN
			, 1               -- @RECEIVE_NOTIFICATIONS
			, null            -- @DESCRIPTION
			, @EXCHANGE_TITLE -- @TITLE
			, null            -- @DEPARTMENT
			, null            -- @PHONE_HOME
			, null            -- @PHONE_MOBILE
			, @EXCHANGE_PHONE -- @PHONE_WORK
			, null            -- @PHONE_OTHER
			, null            -- @PHONE_FAX
			, @EXCHANGE_EMAIL -- @EMAIL1
			, null            -- @EMAIL2
			, N'Active'       -- @STATUS
			, null            -- @ADDRESS_STREET
			, null            -- @ADDRESS_CITY
			, null            -- @ADDRESS_STATE
			, null            -- @ADDRESS_POSTALCODE
			, null            -- @ADDRESS_COUNTRY
			, null            -- @USER_PREFERENCES
			, null            -- @PORTAL_ONLY
			, null            -- @EMPLOYEE_STATUS
			, null            -- @MESSENGER_ID
			, null            -- @MESSENGER_TYPE
			, null            -- @PARENT_TYPE
			, null            -- @PARENT_ID
			, 0               -- @IS_GROUP
			, null            -- @DEFAULT_TEAM
			, 0               -- @IS_ADMIN_DELEGATE
			;
		exec dbo.spEXCHANGE_USERS_Update @ID out, @MODIFIED_USER_ID, @EXCHANGE_ALIAS, @EXCHANGE_EMAIL, @IMPERSONATED_TYPE, @ASSIGNED_USER_ID;
	end -- if;
  end
GO
 
Grant Execute on dbo.spEXCHANGE_USERS_InsertUser to public;
GO
 
