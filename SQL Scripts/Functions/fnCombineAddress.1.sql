if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnCombineAddress' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnCombineAddress;
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
Create Function dbo.fnCombineAddress
	( @ADDRESS_STREET1    nvarchar(150)
	, @ADDRESS_STREET2    nvarchar(150)
	, @ADDRESS_STREET3    nvarchar(150)
	, @ADDRESS_STREET4    nvarchar(150)
	)
returns nvarchar(600)
as
  begin
	declare @FULL_ADDRESS nvarchar(600);
	set @FULL_ADDRESS = @ADDRESS_STREET1;
	if @ADDRESS_STREET2 is not null and len(@ADDRESS_STREET2) > 0 begin -- then
		if @FULL_ADDRESS is not null begin -- then
			set @FULL_ADDRESS = isnull(@FULL_ADDRESS, N'') + nchar(13) + nchar(10);
		end -- if;
		set @FULL_ADDRESS = isnull(@FULL_ADDRESS, N'') + @ADDRESS_STREET2;
	end -- if;
	if @ADDRESS_STREET3 is not null and len(@ADDRESS_STREET3) > 0 begin -- then
		if @FULL_ADDRESS is not null begin -- then
			set @FULL_ADDRESS = isnull(@FULL_ADDRESS, N'') + nchar(13) + nchar(10);
		end -- if;
		set @FULL_ADDRESS = isnull(@FULL_ADDRESS, N'') + @ADDRESS_STREET3;
	end -- if;
	if @ADDRESS_STREET4 is not null and len(@ADDRESS_STREET4) > 0 begin -- then
		if @FULL_ADDRESS is not null begin -- then
			set @FULL_ADDRESS = isnull(@FULL_ADDRESS, N'') + nchar(13) + nchar(10);
		end -- if;
		set @FULL_ADDRESS = isnull(@FULL_ADDRESS, N'') + @ADDRESS_STREET4;
	end -- if;
	return @FULL_ADDRESS;
  end
GO

Grant Execute on dbo.fnCombineAddress to public
GO

