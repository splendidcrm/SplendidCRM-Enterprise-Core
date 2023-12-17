if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnDatePart' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnDatePart;
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
Create Function dbo.fnDatePart(@DATE_PART varchar(20), @VALUE datetime)
returns int
as
  begin
	if          @DATE_PART = 'year'        or @DATE_PART = 'yy' or @DATE_PART = 'yyyy' begin -- then
		return datepart(  year       ,    @VALUE);
	end else if @DATE_PART = 'quarter'     or @DATE_PART = 'qq' or @DATE_PART = 'q' begin -- then
		return datepart(  quarter    ,    @VALUE);
	end else if @DATE_PART = 'month'       or @DATE_PART = 'mm' or @DATE_PART = 'm' begin -- then
		return datepart(  month      ,    @VALUE);
	end else if @DATE_PART = 'dayofyear'   or @DATE_PART = 'dy' or @DATE_PART = 'y' begin -- then
		return datepart(  dayofyear  ,    @VALUE);
	end else if @DATE_PART = 'day'         or @DATE_PART = 'dd' or @DATE_PART = 'd' begin -- then
		return datepart(  day        ,    @VALUE);
	end else if @DATE_PART = 'week'        or @DATE_PART = 'ww' or @DATE_PART = 'wk' begin -- then
		return datepart(  week       ,    @VALUE);
	end else if @DATE_PART = 'weekday'     or @DATE_PART = 'dw' begin -- then
		return datepart(  weekday    ,    @VALUE);
	end else if @DATE_PART = 'hour'        or @DATE_PART = 'hh' begin -- then
		return datepart(  hour       ,    @VALUE);
	end else if @DATE_PART = 'minute'      or @DATE_PART = 'mi' or @DATE_PART = 'n' begin -- then
		return datepart(  minute     ,    @VALUE);
	end else if @DATE_PART = 'second'      or @DATE_PART = 'ss' or @DATE_PART = 's' begin -- then
		return datepart(  second     ,    @VALUE);
	end else if @DATE_PART = 'millisecond' or @DATE_PART = 'ms' begin -- then
		return datepart(  millisecond,    @VALUE);
	end -- if;
	return null;
  end
GO

Grant Execute on dbo.fnDatePart to public;
GO


