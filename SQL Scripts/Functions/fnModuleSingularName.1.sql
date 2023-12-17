if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnModuleSingularName' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnModuleSingularName;
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
Create Function dbo.fnModuleSingularName(@COLUMN_NAME nvarchar(80))
returns nvarchar(80)
as
  begin
	declare @SINGULAR_NAME nvarchar(80);
	if @COLUMN_NAME is not null and len(@COLUMN_NAME) > 0 begin -- then
		if substring(@COLUMN_NAME, len(@COLUMN_NAME) - 2, 3) = 'IES' begin -- then
			set @SINGULAR_NAME = substring(@COLUMN_NAME, 1, len(@COLUMN_NAME) - 3) + 'Y';
		end else if substring(@COLUMN_NAME, len(@COLUMN_NAME), 1) = 'S' begin -- then
			set @SINGULAR_NAME = substring(@COLUMN_NAME, 1, len(@COLUMN_NAME) - 1);
		end else begin
			set @SINGULAR_NAME = @COLUMN_NAME;
		end -- if;
	end -- if;
	return @SINGULAR_NAME;
  end
GO

Grant Execute on dbo.fnModuleSingularName to public
GO

