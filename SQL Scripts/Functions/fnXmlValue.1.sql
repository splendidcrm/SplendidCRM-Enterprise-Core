if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnXmlValue' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnXmlValue;
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
Create Function dbo.fnXmlValue(@SEARCH nvarchar(max), @FIND nvarchar(60))
returns nvarchar(255)
as
  begin
	declare @BEGIN_TAG int;
	declare @END_TAG   int;
	declare @VALUE     nvarchar(255);
	set @BEGIN_TAG = charindex('<'  + @FIND + '>', @SEARCH);
	if @BEGIN_TAG > 0 begin -- then
		set @BEGIN_TAG = @BEGIN_TAG + len(@FIND) + 2;
		set @END_TAG   = charindex('</' + @FIND + '>', @SEARCH, @BEGIN_TAG);
		if @END_TAG > 0 and @END_TAG > @BEGIN_TAG begin -- then
			set @VALUE = substring(@SEARCH, @BEGIN_TAG, @END_TAG - @BEGIN_TAG);
		end -- if;
	end -- if;
	return @VALUE;
  end
GO

Grant Execute on dbo.fnXmlValue to public
GO

