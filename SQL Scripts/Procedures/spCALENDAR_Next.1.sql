if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCALENDAR_Next' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCALENDAR_Next;
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
Create Procedure dbo.spCALENDAR_Next
	( @DATE_TIME           datetime
	, @REPEAT_TYPE         nvarchar(25)
	, @REPEAT_INTERVAL     int
	, @REPEAT_DOW          nvarchar(7)
	, @REPEAT_INDEX        int
	, @DATE_START          datetime output
	, @WEEK_START          datetime output
	, @WEEKDAY             int output
	)
as
  begin
	set nocount on
	
	declare @WEEKDAY_CHAR char(1);
	if @REPEAT_TYPE = N'Daily' begin -- then
		set @DATE_START = dbo.fnDateAdd(N'day', @REPEAT_INDEX * @REPEAT_INTERVAL, @DATE_TIME);
	end else if @REPEAT_TYPE = N'Weekly' begin -- then
		set @WEEKDAY = @WEEKDAY + 1;
		set @WEEKDAY_CHAR = cast(@WEEKDAY as char(1));
		-- @REPEAT_DOW pattern uses 0-6 to mean Sunday-Saturday. 
		while @WEEKDAY < 7 and charindex(@WEEKDAY_CHAR, @REPEAT_DOW, 1) = 0 begin -- do
			set @WEEKDAY = @WEEKDAY + 1;
			set @WEEKDAY_CHAR  = cast(@WEEKDAY as char(1));
		end -- while;
		if @WEEKDAY >= 7 begin -- then
			set @WEEK_START = dbo.fnDateAdd(N'day', 7 * @REPEAT_INTERVAL, @WEEK_START);
			set @WEEKDAY = 0;
			set @WEEKDAY_CHAR  = cast(@WEEKDAY as char(1));
			while @WEEKDAY < 7 and charindex(@WEEKDAY_CHAR, @REPEAT_DOW, 1) = 0 begin -- do
				set @WEEKDAY = @WEEKDAY + 1;
				set @WEEKDAY_CHAR  = cast(@WEEKDAY as char(1));
			end -- while;
			-- 03/22/2013 Paul.  We should never hit the end twice as it suggests no digits in the DOW field. 
			if @WEEKDAY >= 7 begin -- then
				set @WEEKDAY = -1;
			end -- if;
		end -- if;
		set @DATE_START = dbo.fnDateAdd(N'day', @WEEKDAY, @WEEK_START);
	end else if @REPEAT_TYPE = N'Monthly' begin -- then
		-- 03/22/2013 Paul.  We use the repeat index so that we don't get date truncation when crossing Feb 28th. 
		set @DATE_START = dbo.fnDateAdd(N'month', @REPEAT_INDEX * @REPEAT_INTERVAL, @DATE_TIME);
	end else if @REPEAT_TYPE = N'Yearly' begin -- then
		set @DATE_START = dbo.fnDateAdd(N'year', @REPEAT_INDEX * @REPEAT_INTERVAL, @DATE_TIME);
	end -- if;
  end
GO

Grant Execute on dbo.spCALENDAR_Next to public;
GO

