if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnDateSpecial' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnDateSpecial;
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
-- 02/21/2011 Paul.  Add Tomorrow, Next Week, Next Month, Next Quarter, Next Year. 
Create Function dbo.fnDateSpecial(@NAME varchar(20))
returns datetime
as
  begin
	if @NAME = 'today' begin -- then
		return dbo.fnDateOnly(getdate());
	end else if @NAME = 'yesterday' begin -- then
		return dbo.fnDateAdd('day', -1, dbo.fnDateOnly(getdate()));
	end else if @NAME = 'tomorrow' begin -- then
		return dbo.fnDateAdd('day',  1, dbo.fnDateOnly(getdate()));
	end else if @NAME = 'this week' begin -- then
		return dbo.fnDateAdd('day', -(dbo.fnDatePart('weekday', getdate())-1), dbo.fnDateOnly(getdate()));
	end else if @NAME = 'last week' begin -- then
		return dbo.fnDateAdd('day', -(dbo.fnDatePart('weekday', getdate())-1)-7, dbo.fnDateOnly(getdate()));
	end else if @NAME = 'next week' begin -- then
		return dbo.fnDateAdd('day', -(dbo.fnDatePart('weekday', getdate())-1)+7, dbo.fnDateOnly(getdate()));
	end else if @NAME = 'this month' begin -- then
		return dbo.fnDateAdd('day', -(dbo.fnDatePart('day', getdate())-1), dbo.fnDateOnly(getdate()));
	end else if @NAME = 'last month' begin -- then
		return dbo.fnDateAdd('month', -1, dbo.fnDateAdd('day', -(dbo.fnDatePart('day', getdate())-1), dbo.fnDateOnly(getdate())));
	end else if @NAME = 'next month' begin -- then
		return dbo.fnDateAdd('month',  1, dbo.fnDateAdd('day', -(dbo.fnDatePart('day', getdate())-1), dbo.fnDateOnly(getdate())));
	end else if @NAME = 'this quarter' begin -- then
		return dateadd(qq, datediff(qq, 0, getdate()),  0);
	end else if @NAME = 'last quarter' begin -- then
		return dbo.fnDateAdd('month', -3, dateadd(qq, datediff(qq, 0, getdate()),  0));
	end else if @NAME = 'next quarter' begin -- then
		return dbo.fnDateAdd('month',  3, dateadd(qq, datediff(qq, 0, getdate()),  0));
	end else if @NAME = 'this year' begin -- then
		return dbo.fnDateAdd('month', -(dbo.fnDatePart('month', getdate())-1), dbo.fnDateAdd('day', -(dbo.fnDatePart('day', getdate())-1), dbo.fnDateOnly(getdate())));
	end else if @NAME = 'last year' begin -- then
		return dbo.fnDateAdd('year', -1, dbo.fnDateAdd('month', -(dbo.fnDatePart('month', getdate())-1), dbo.fnDateAdd('day', -(dbo.fnDatePart('day', getdate())-1), dbo.fnDateOnly(getdate()))));
	end else if @NAME = 'next year' begin -- then
		return dbo.fnDateAdd('year',  1, dbo.fnDateAdd('month', -(dbo.fnDatePart('month', getdate())-1), dbo.fnDateAdd('day', -(dbo.fnDatePart('day', getdate())-1), dbo.fnDateOnly(getdate()))));
	end -- if;
	return null;
  end
GO

/*
select dbo.fnDateSpecial('today'       ) as Today
     , dbo.fnDateSpecial('yesterday'   ) as Yesterday
     , dbo.fnDateSpecial('this week'   ) as ThisWeek
     , dbo.fnDateSpecial('last week'   ) as LastWeek
     , dbo.fnDateSpecial('this month'  ) as ThisMonth
     , dbo.fnDateSpecial('last month'  ) as LastMonth
     , dbo.fnDateSpecial('this quarter') as ThisQuarter
     , dbo.fnDateSpecial('last quarter') as LastQuarter
     , dbo.fnDateSpecial('this year'   ) as ThisYear
     , dbo.fnDateSpecial('last year'   ) as LastYear
*/

Grant Execute on dbo.fnDateSpecial to public;
GO

