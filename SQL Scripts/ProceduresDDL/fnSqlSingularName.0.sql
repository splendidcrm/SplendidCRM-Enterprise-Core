if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnSqlSingularName' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnSqlSingularName;
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
Create Function dbo.fnSqlSingularName(@NAME varchar(80))
returns varchar(80)
as
  begin
	declare @SINGULAR_NAME varchar(80);
	if right(@NAME, 3) = 'IES' begin -- then
		set @SINGULAR_NAME = substring(@NAME, 1, len(@NAME) - 3) + 'Y';
	end else if right(@NAME, 1) = 'S' begin -- then
		set @SINGULAR_NAME = substring(@NAME, 1, len(@NAME) - 1);
	end else begin
		set @SINGULAR_NAME = @NAME;
	end -- if;
	return @SINGULAR_NAME;
  end
GO

Grant Execute on dbo.fnSqlSingularName to public
GO



