if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnWeekOnly' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnWeekOnly;
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
Create Function dbo.fnWeekOnly(@VALUE datetime)
returns nvarchar(10)
as
  begin
	if datepart(week, @VALUE) >= 10 begin -- then
		return cast(year(@VALUE) as char(4)) + ' W'  + cast(datepart(week, @VALUE) as char(2));
	end -- if;
	return cast(year(@VALUE) as char(4)) + ' W0' + cast(datepart(week, @VALUE) as char(1));
  end
GO

Grant Execute on dbo.fnWeekOnly to public;
GO

