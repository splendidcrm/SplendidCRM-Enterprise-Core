if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnBillingFrequency_BeginDate' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnBillingFrequency_BeginDate;
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
Create Function dbo.fnBillingFrequency_BeginDate(@BILLING_FREQUENCY nvarchar(25), @ORIGINAL_ORDER_DATE datetime, @BILLING_DATE datetime)
returns datetime
as
  begin
	-- 09/22/2008 Paul.  The previous logic called the EndDate, then subtracted the frequency. 
	-- There was a flaw with the logic, so we are going to calculate the start date, and have the end call add the frequency. 
	-- 09/22/2008 Paul.  The problem was fixed by using floor. 
	declare @BEGIN_DATE datetime;
	-- 09/17/2008 Paul.  We should also truncate the billing date. 
	set @BILLING_DATE        = cast(floor(cast(@BILLING_DATE        as float)) as datetime);
	-- 08/15/2007 Paul.  datediff is not rounding properly.  Do the math by days to get a better count. 
	set @ORIGINAL_ORDER_DATE = cast(floor(cast(@ORIGINAL_ORDER_DATE as float)) as datetime);

	-- 09/17/2008 Paul.  Expand dateadd parameters for clarity.
	-- 09/17/2008 Paul.  The previous date calculations were based on previous period.  
	-- We will require pre-pay, so the date ranges need to add one range. 
	if @BILLING_FREQUENCY = 'Yearly'     begin -- then
		set @BEGIN_DATE = dateadd(year, datediff(day, @ORIGINAL_ORDER_DATE, @BILLING_DATE)/364, @ORIGINAL_ORDER_DATE);
	end else if @BILLING_FREQUENCY = 'Bi-Yearly'     begin -- then
		-- 10/11/2007 Paul.  Bi-Yearly might mean every two years, or twice a year.  Assume twice a year for now. 
		-- 09/03/2008 Paul.  Add 6 months for every 182 days. 
		-- 09/22/2008 Paul.  We must use floor, otherwise the multipler will treat as a float. 
		set @BEGIN_DATE = dateadd(month, 6 * floor(datediff(day, @ORIGINAL_ORDER_DATE, @BILLING_DATE)/182), @ORIGINAL_ORDER_DATE);
	end else if @BILLING_FREQUENCY = 'Quarterly'  begin -- then
		-- 09/22/2008 Paul.  We must use floor, otherwise the multipler will treat as a float. 
		set @BEGIN_DATE = dateadd(quarter, floor(datediff(day, @ORIGINAL_ORDER_DATE, @BILLING_DATE)/90), @ORIGINAL_ORDER_DATE);
	end else if @BILLING_FREQUENCY = 'Monthly'    begin -- then
		-- 09/22/2008 Paul.  We must use floor, otherwise the multipler will treat as a float. 
		set @BEGIN_DATE = dateadd(month, floor(datediff(day, @ORIGINAL_ORDER_DATE, @BILLING_DATE)/30), @ORIGINAL_ORDER_DATE);
		if datediff(day, @BEGIN_DATE, @BILLING_DATE) <= 0 begin -- then
			-- 09/17/2008 Paul.  The billing date is not hitting properly when diving by 31, so try 30.5. 
			set @BEGIN_DATE = dateadd(month, floor(datediff(day, @ORIGINAL_ORDER_DATE, @BILLING_DATE)/30.5), @ORIGINAL_ORDER_DATE);
		end -- if;
	end else if @BILLING_FREQUENCY = 'Bi-Monthly' begin -- then
		-- 08/20/2007 Paul.  Bi-Monthly means every two months. 
		-- 09/22/2008 Paul.  We must use floor, otherwise the multipler will treat as a float. 
		set @BEGIN_DATE = dateadd(month, 2*floor(datediff(day, @ORIGINAL_ORDER_DATE, @BILLING_DATE)/60), @ORIGINAL_ORDER_DATE);
		if datediff(day, @BEGIN_DATE, @BILLING_DATE) <= 0 begin -- then
			set @BEGIN_DATE = dateadd(month, 2*floor(datediff(day, @ORIGINAL_ORDER_DATE, @BILLING_DATE)/61), @ORIGINAL_ORDER_DATE);
		end -- if;
	end else if @BILLING_FREQUENCY = 'Weekly'     begin -- then
		-- 09/22/2008 Paul.  We must use floor, otherwise the multipler will treat as a float. 
		set @BEGIN_DATE = dateadd(week, floor(datediff(day, @ORIGINAL_ORDER_DATE, @BILLING_DATE)/7), @ORIGINAL_ORDER_DATE);
	end -- if;
	return @BEGIN_DATE;
  end
GO

Grant Execute on dbo.fnBillingFrequency_BeginDate to public
GO


