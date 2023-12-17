if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnTimeRoundSeconds' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnTimeRoundSeconds;
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
Create Function dbo.fnTimeRoundSeconds(@VALUE datetime, @SECOND_DIVISOR int)
returns datetime
as
  begin
	declare @SECONDS      int;
	declare @MILLISECONDS int;
	if @VALUE is null or @SECOND_DIVISOR is null or @SECOND_DIVISOR <= 0 begin -- then
		return null;
	end -- if;
	set @SECONDS      = datepart(second     , @VALUE);
	set @MILLISECONDS = datepart(millisecond, @VALUE);
	return dateadd(second, -(@SECONDS % @SECOND_DIVISOR), dateadd(millisecond, -@MILLISECONDS, @VALUE));
  end
GO

Grant Execute on dbo.fnTimeRoundSeconds to public;
GO



