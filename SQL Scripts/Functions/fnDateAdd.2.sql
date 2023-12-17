if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnDateAdd' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnDateAdd;
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
Create Function dbo.fnDateAdd(@DATE_PART varchar(20), @INTERVAL int, @VALUE datetime)
returns datetime
as
  begin
	if @DATE_PART = 'year' begin -- then
		return dateadd(year, @INTERVAL, @VALUE);
	end else if @DATE_PART = 'quarter' begin -- then
		return dateadd(quarter, @INTERVAL, @VALUE);
	end else if @DATE_PART = 'month' begin -- then
		return dateadd(month, @INTERVAL, @VALUE);
	end else if @DATE_PART = 'week' begin -- then
		return dateadd(week, @INTERVAL, @VALUE);
	end else if @DATE_PART = 'day' begin -- then
		return dateadd(day, @INTERVAL, @VALUE);
	end else if @DATE_PART = 'hour' begin -- then
		return dateadd(hour, @INTERVAL, @VALUE);
	end else if @DATE_PART = 'minute' begin -- then
		return dateadd(minute, @INTERVAL, @VALUE);
	end else if @DATE_PART = 'second' begin -- then
		return dateadd(second, @INTERVAL, @VALUE);
	end -- if;
	return null;
  end
GO

Grant Execute on dbo.fnDateAdd to public;
GO

