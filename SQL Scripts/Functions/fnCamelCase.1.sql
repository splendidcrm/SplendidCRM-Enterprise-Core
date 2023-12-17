if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnCamelCase' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnCamelCase;
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
Create Function dbo.fnCamelCase(@NAME nvarchar(255))
returns nvarchar(255)
as
  begin
	declare @CAMEL_NAME  nvarchar(255);
	declare @CurrentPosR  int;
	declare @NextPosR     int;
	set @CAMEL_NAME = lower(@NAME);
	set @CAMEL_NAME = upper(left(@CAMEL_NAME, 1)) + substring(@CAMEL_NAME, 2, len(@NAME));

	set @CurrentPosR = 1;
	while charindex(' ', @CAMEL_NAME,  @CurrentPosR) > 0 begin -- do
		set @NextPosR = charindex(' ', @CAMEL_NAME,  @CurrentPosR);
		set @CAMEL_NAME = left(@CAMEL_NAME, @NextPosR-1) + ' ' + upper(substring(@CAMEL_NAME, @NextPosR+1, 1)) + substring(@CAMEL_NAME, @NextPosR+2, len(@NAME));
		set @CurrentPosR = @NextPosR+1;
	end -- while;
	return @CAMEL_NAME;
  end
GO

Grant Execute on dbo.fnCamelCase to public
GO

