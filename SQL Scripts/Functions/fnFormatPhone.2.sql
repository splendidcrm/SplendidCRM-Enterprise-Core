if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnFormatPhone' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnFormatPhone;
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
Create Function dbo.fnFormatPhone(@PHONE nvarchar(25))
returns nvarchar(25)
as
  begin
	declare @FORMATTED nvarchar(25);
	set @FORMATTED = dbo.fnNormalizePhone(@PHONE);
	if @FORMATTED is not null begin -- then
		if substring(@FORMATTED, 1, 1) = '1' and len(@FORMATTED) = 11 begin -- then
			if @FORMATTED like '1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' begin -- then
				set @FORMATTED = substring(@FORMATTED, 2, 10);
			end -- if;
		end -- if;
	
		-- 11/24/2017 Paul.  Any phone numbers without 10 characters are returned unmodified, except for trim. 
		if len(@FORMATTED) <> 10 begin -- then
			return ltrim(rtrim(@PHONE));
		end -- if;
	
		-- 11/24/2017 Paul.  Build US standard phone number. 
		set @FORMATTED = '(' + substring(@FORMATTED,1,3) + ') ' + substring(@FORMATTED, 4, 3) + '-' + substring(@FORMATTED, 7 ,4);
	end -- if;
	return @FORMATTED;
  end
GO

Grant Execute on dbo.fnFormatPhone to public
GO

