if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnWF4GetExpirationTime' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnWF4GetExpirationTime;
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
Create Function dbo.fnWF4GetExpirationTime(@offsetInMilliseconds bigint)
returns datetime
as
  begin
	if @offsetInMilliseconds is null begin -- then
		return null;
	end -- if;
	
	declare @hourInMillisecond             bigint;
	declare @offsetInHours                 bigint;
	declare @remainingOffsetInMilliseconds bigint;
	declare @expirationTimer               datetime;
	
	set @hourInMillisecond             = 60 * 60 * 1000;
	set @offsetInHours                 = @offsetInMilliseconds / @hourInMillisecond;
	set @remainingOffsetInMilliseconds = @offsetInMilliseconds % @hourInMillisecond;
	
	set @expirationTimer = getutcdate();
	set @expirationTimer = dateadd (hour, @offsetInHours, @expirationTimer);
	set @expirationTimer = dateadd (millisecond,@remainingOffsetInMilliseconds, @expirationTimer);
	return @expirationTimer;
  end
GO

Grant Execute on dbo.fnWF4GetExpirationTime to public;
GO



