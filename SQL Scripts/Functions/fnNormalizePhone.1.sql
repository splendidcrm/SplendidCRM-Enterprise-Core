if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnNormalizePhone' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnNormalizePhone;
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
-- 11/24/2017 Paul.  Convert empty string to null. 
-- 08/15/2018 Paul.  Use like clause for more flexible phone number lookup. 
Create Function dbo.fnNormalizePhone(@PHONE nvarchar(25))
returns nvarchar(25)
as
  begin
	declare @NORMALIZED nvarchar(25);
	set @NORMALIZED = @PHONE;
	if @NORMALIZED is not null begin -- then
		set @NORMALIZED = replace(@NORMALIZED, N' ', N'');
		set @NORMALIZED = replace(@NORMALIZED, N'+', N'');
		set @NORMALIZED = replace(@NORMALIZED, N'(', N'');
		set @NORMALIZED = replace(@NORMALIZED, N')', N'');
		set @NORMALIZED = replace(@NORMALIZED, N'-', N'');
		set @NORMALIZED = replace(@NORMALIZED, N'.', N'');
		-- 08/15/2018 Paul.  Use like clause for more flexible phone number lookup. 
		set @NORMALIZED = replace(@NORMALIZED, N'[', N'');
		set @NORMALIZED = replace(@NORMALIZED, N']', N'');
		set @NORMALIZED = replace(@NORMALIZED, N'#', N'');
		set @NORMALIZED = replace(@NORMALIZED, N'*', N'');
		set @NORMALIZED = replace(@NORMALIZED, N'%', N'');
		if len(@NORMALIZED) = 0 begin -- then
			set @NORMALIZED = null;
		end -- if;
	end -- if;
	return @NORMALIZED;
  end
GO

Grant Execute on dbo.fnNormalizePhone to public
GO

