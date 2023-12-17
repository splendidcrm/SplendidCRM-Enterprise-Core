if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnBillingFrequency_EndDate' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnBillingFrequency_EndDate;
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
Create Function dbo.fnBillingFrequency_EndDate(@BILLING_FREQUENCY nvarchar(25), @ORIGINAL_ORDER_DATE datetime, @BILLING_DATE datetime)
returns datetime
as
  begin
	-- 09/22/2008 Paul.  The previous logic called the EndDate, then subtracted the frequency. 
	-- There was a flaw with the logic, so we are going to calculate the start date, and have the end call add the frequency. 
	declare @END_DATE datetime;

	-- 09/17/2008 Paul.  Truncate the dates. 
	set @BILLING_DATE        = cast(floor(cast(@BILLING_DATE        as float)) as datetime);
	set @ORIGINAL_ORDER_DATE = cast(floor(cast(@ORIGINAL_ORDER_DATE as float)) as datetime);
	set @END_DATE = dbo.fnBillingFrequency_BeginDate(@BILLING_FREQUENCY, @ORIGINAL_ORDER_DATE, @BILLING_DATE);

	-- 09/17/2008 Paul.   Expand dateadd parameters for clarity.
	if @BILLING_FREQUENCY = 'Yearly'     begin -- then
		set @END_DATE = dateadd(year, 1, @END_DATE);
	-- 09/08/2008 Paul.  Fix Bi-Yearly billing frequency.  The IF was not coded properly. 
	end else if @BILLING_FREQUENCY = 'Bi-Yearly'  begin -- then
		-- 10/11/2007 Paul.  Bi-Yearly might mean every two years, or twice a year.  Assume twice a year for now. 
		set @END_DATE = dateadd(month, 6, @END_DATE);
	end else if @BILLING_FREQUENCY = 'Quarterly'  begin -- then
		set @END_DATE = dateadd(quarter, 1, @END_DATE);
	end else if @BILLING_FREQUENCY = 'Monthly'    begin -- then
		set @END_DATE = dateadd(month, 1, @END_DATE);
	end else if @BILLING_FREQUENCY = 'Bi-Monthly' begin -- then
		-- 08/20/2007 Paul.  Bi-Monthly means every two months. 
		set @END_DATE = dateadd(month, 2, @END_DATE);
	end else if @BILLING_FREQUENCY = 'Weekly'     begin -- then
		set @END_DATE = dateadd(week, 1, @END_DATE);
	end -- if;
	return @END_DATE;
  end
GO

Grant Execute on dbo.fnBillingFrequency_EndDate to public
GO

