if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCALL_MARKETING_GenerateCalls' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCALL_MARKETING_GenerateCalls;
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
-- 12/23/2013 Paul.  Add SMS_REMINDER_TIME. 
Create Procedure dbo.spCALL_MARKETING_GenerateCalls
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on

	declare @CAMPAIGN_ID        uniqueidentifier;
	declare @ASSIGNED_USER_ID   uniqueidentifier;
	declare @TEAM_ID            uniqueidentifier;
	declare @DISTRIBUTION       nvarchar(25);
	declare @SUBJECT            nvarchar(50);
	declare @DURATION_HOURS     int;
	declare @DURATION_MINUTES   int;
	declare @DATE_START         datetime;
	declare @TIME_START         datetime;
	declare @DATE_END           datetime;
	declare @TIME_END           datetime;
	declare @REMINDER_TIME      int;
	declare @DESCRIPTION        nvarchar(max);

	declare @RELATED_NAME       nvarchar(200);
	declare @PHONE_WORK         nvarchar(25);

	declare @CALL_ID            uniqueidentifier;
	declare @CALL_SUBJECT       nvarchar(50);
	declare @DATE_TIME          datetime;
	declare @PARENT_TYPE        nvarchar(25);
	declare @PARENT_ID          uniqueidentifier;
	declare @STATUS             nvarchar(25);
	declare @DIRECTION          nvarchar(25);
	declare @INVITEE_LIST       varchar(8000);
	declare @TEAM_SET_LIST      varchar(8000);
	declare @TEAM_USER_LIST     varchar(8000);
	declare @NEXT_DATE          int;
	declare @CurrentPosR        int;
	declare @NextPosR           int;

	-- 03/22/2013 Paul.  Add REPEAT fields. 
	declare @EMAIL_REMINDER_TIME int;
	declare @ALL_DAY_EVENT       bit;
	declare @REPEAT_TYPE         nvarchar(25);
	declare @REPEAT_INTERVAL     int;
	declare @REPEAT_DOW          nvarchar(7);
	declare @REPEAT_UNTIL        datetime;
	declare @REPEAT_COUNT        int;
	-- 12/23/2013 Paul.  Add SMS_REMINDER_TIME. 
	declare @SMS_REMINDER_TIME   int;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	declare @ASSIGNED_SET_LIST   varchar(8000);


-- #if SQL_Server /*
	declare CAMPAIGN_CALL_CURSOR cursor for
	select RELATED_ID
	     , RELATED_TYPE
	     , RELATED_NAME
	     , PHONE_WORK
	  from vwCAMPAIGNS_Call
	 where CALL_MARKETING_ID = @ID
	 order by RELATED_TYPE, RELATED_NAME;
-- #endif SQL_Server */

/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	select @CAMPAIGN_ID      = CAMPAIGN_ID     
	     , @ASSIGNED_USER_ID = ASSIGNED_USER_ID
	     , @TEAM_ID          = TEAM_ID         
	     , @DISTRIBUTION     = DISTRIBUTION    
	     , @SUBJECT          = SUBJECT         
	     , @DURATION_HOURS   = DURATION_HOURS  
	     , @DURATION_MINUTES = DURATION_MINUTES
	     , @DATE_START       = DATE_START      
	     , @TIME_START       = TIME_START      
	     , @DATE_END         = DATE_END        
	     , @TIME_END         = TIME_END        
	     , @REMINDER_TIME    = REMINDER_TIME   
	     , @DESCRIPTION      = DESCRIPTION     
	     , @ASSIGNED_SET_LIST= ASSIGNED_SET_LIST
	  from vwCALL_MARKETING
	 where ID = @ID;

	set @STATUS        = N'Planned';
	set @DIRECTION     = N'Outbound';
	set @INVITEE_LIST  = null;
	set @TEAM_SET_LIST = null;
	set @CurrentPosR   = 1;
	if @TEAM_ID is not null begin -- then
		set @TEAM_USER_LIST = '';
		select @TEAM_USER_LIST = substring(@TEAM_USER_LIST + (case when len(@TEAM_USER_LIST) > 0 then  ',' else  '' end) + cast(USER_ID as char(36)), 1, 2000)
		  from vwUSERS_TEAM_MEMBERSHIPS
		 where TEAM_ID = @TEAM_ID
		 order by USER_ID asc;
	end -- if;
	if @DISTRIBUTION = N'team' begin -- then
		set @INVITEE_LIST = @TEAM_USER_LIST;
	end -- if;

	set @NEXT_DATE = 0;
	set @DATE_TIME = @DATE_START;
	open CAMPAIGN_CALL_CURSOR;
	fetch next from CAMPAIGN_CALL_CURSOR into @PARENT_ID, @PARENT_TYPE, @RELATED_NAME, @PHONE_WORK;
	while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
		set @CALL_ID          = null;
		set @CALL_SUBJECT     = rtrim(@SUBJECT) + N': ' + @RELATED_NAME;
		if @DISTRIBUTION = N'round_robin' begin -- then
			set @NextPosR = charindex(',', @TEAM_USER_LIST,  @CurrentPosR);
			if @NextPosR = 0 or @NextPosR is null begin -- then
				set @NextPosR = len(@TEAM_USER_LIST) + 1;
			end -- if;
			set @ASSIGNED_USER_ID = cast(rtrim(ltrim(substring(@TEAM_USER_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
			-- 08/28/2012 Paul.  Use the private team instead of the provided TEAM_ID value. 
			select @TEAM_ID = PRIVATE_TEAM_ID
			  from vwUSERS_Login
			 where ID = @ASSIGNED_USER_ID;
			
			set @CurrentPosR = @NextPosR + 1;
			if @CurrentPosR > len(@TEAM_USER_LIST) begin -- then
				set @CurrentPosR = 1;
			end -- if;
		end -- if;
		-- 03/22/2013 Paul.  Add REPEAT fields. 
		-- 12/23/2013 Paul.  Add SMS_REMINDER_TIME. 
		-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
		exec dbo.spCALLS_Update @CALL_ID out
			, @MODIFIED_USER_ID
			, @ASSIGNED_USER_ID
			, @CALL_SUBJECT
			, @DURATION_HOURS
			, @DURATION_MINUTES
			, @DATE_TIME
			, @PARENT_TYPE
			, @PARENT_ID
			, @STATUS
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
			, @ASSIGNED_SET_LIST
			;
		set @DATE_TIME = dbo.fnDateAdd_Minutes(@DURATION_MINUTES, dbo.fnDateAdd_Hours(@DURATION_HOURS, @DATE_TIME));
		if dbo.fnStoreTimeOnly(@DATE_TIME) > @TIME_END begin -- then
			set @NEXT_DATE = @NEXT_DATE + 1;
			set @DATE_TIME = dbo.fnDateAdd('day', @NEXT_DATE, @DATE_START);
		end -- if;
		fetch next from CAMPAIGN_CALL_CURSOR into @PARENT_ID, @PARENT_TYPE, @RELATED_NAME, @PHONE_WORK;
/* -- #if Oracle
		IF CAMPAIGN_CALL_CURSOR%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close CAMPAIGN_CALL_CURSOR;
	deallocate CAMPAIGN_CALL_CURSOR;
  end
GO

Grant Execute on dbo.spCALL_MARKETING_GenerateCalls to public;
GO

