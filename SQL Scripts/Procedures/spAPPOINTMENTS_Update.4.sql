if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spAPPOINTMENTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spAPPOINTMENTS_Update;
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
-- 03/22/2013 Paul.  Add REPEAT fields. 
-- 12/23/2013 Paul.  Add SMS_REMINDER_TIME. 
-- 11/30/2017 Paul.  Add Tags module. 
-- 11/30/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 06/22/2018 Paul.  The status should not be null, so try and use the existing value, but otherwise set to Planned. 
Create Procedure dbo.spAPPOINTMENTS_Update
	( @ID                  uniqueidentifier output
	, @MODIFIED_USER_ID    uniqueidentifier
	, @ASSIGNED_USER_ID    uniqueidentifier
	, @NAME                nvarchar(50)
	, @LOCATION            nvarchar(50)
	, @DURATION_HOURS      int
	, @DURATION_MINUTES    int
	, @DATE_TIME           datetime
	, @PARENT_TYPE         nvarchar(25)
	, @PARENT_ID           uniqueidentifier
	, @STATUS              nvarchar(25)
	, @DIRECTION           nvarchar(25)
	, @REMINDER_TIME       int
	, @DESCRIPTION         nvarchar(max)
	, @INVITEE_LIST        varchar(8000)
	, @TEAM_ID             uniqueidentifier
	, @TEAM_SET_LIST       varchar(8000)
	, @EMAIL_REMINDER_TIME int = null
	, @ALL_DAY_EVENT       bit = null
	, @REPEAT_TYPE         nvarchar(25) = null
	, @REPEAT_INTERVAL     int = null
	, @REPEAT_DOW          nvarchar(7) = null
	, @REPEAT_UNTIL        datetime = null
	, @REPEAT_COUNT        int = null
	, @SMS_REMINDER_TIME   int = null
	, @TAG_SET_NAME        nvarchar(4000) = null
	, @IS_PRIVATE          bit = null
	, @ASSIGNED_SET_LIST   varchar(8000) = null
	)
as
  begin
	set nocount on
	
	declare @APPOINTMENT_TYPE nvarchar(25);
	declare @TEMP_STATUS      nvarchar(25);
	set @TEMP_STATUS = @STATUS;

	-- BEGIN Oracle Exception
		select @APPOINTMENT_TYPE = APPOINTMENT_TYPE
		     , @TEMP_STATUS = STATUS
		  from vwAPPOINTMENTS
		 where ID = @ID;
	-- END Oracle Exception
	-- 06/22/2018 Paul.  The status should not be null, so try and use the existing value, but otherwise set to Planned. 
	if @TEMP_STATUS is null begin -- then
		set @TEMP_STATUS = N'Planned';
	end -- if;

	-- 03/29/2010 Paul.  A new Appointment will be created as a Meeting. 
	-- 03/22/2013 Paul.  Add REPEAT fields. 
	if @APPOINTMENT_TYPE = N'Meetings' or @APPOINTMENT_TYPE is null begin -- then
		-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
		exec dbo.spMEETINGS_Update @ID out
			, @MODIFIED_USER_ID
			, @ASSIGNED_USER_ID
			, @NAME
			, @LOCATION
			, @DURATION_HOURS
			, @DURATION_MINUTES
			, @DATE_TIME
			, @TEMP_STATUS
			, @PARENT_TYPE
			, @PARENT_ID
			, @REMINDER_TIME
			, @DESCRIPTION
			, @INVITEE_LIST
			, @TEAM_ID
			, @TEAM_SET_LIST
			, @EMAIL_REMINDER_TIME
			, @ALL_DAY_EVENT
			, @REPEAT_TYPE
			, @REPEAT_INTERVAL
			, @REPEAT_DOW
			, @REPEAT_UNTIL
			, @REPEAT_COUNT
			, @SMS_REMINDER_TIME
			, @TAG_SET_NAME
			, @IS_PRIVATE
			, @ASSIGNED_SET_LIST
			;
	end else begin
		-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
		exec dbo.spCALLS_Update @ID out
			, @MODIFIED_USER_ID
			, @ASSIGNED_USER_ID
			, @NAME
			, @DURATION_HOURS
			, @DURATION_MINUTES
			, @DATE_TIME
			, @PARENT_TYPE
			, @PARENT_ID
			, @TEMP_STATUS
			, @DIRECTION
			, @REMINDER_TIME
			, @DESCRIPTION
			, @INVITEE_LIST
			, @TEAM_ID
			, @TEAM_SET_LIST
			, @EMAIL_REMINDER_TIME
			, @ALL_DAY_EVENT
			, @REPEAT_TYPE
			, @REPEAT_INTERVAL
			, @REPEAT_DOW
			, @REPEAT_UNTIL
			, @REPEAT_COUNT
			, @SMS_REMINDER_TIME
			, @TAG_SET_NAME
			, @IS_PRIVATE
			, @ASSIGNED_SET_LIST
			;
	end -- if;
  end
GO

Grant Execute on dbo.spAPPOINTMENTS_Update to public;
GO

