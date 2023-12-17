if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnTERMINOLOGY_Changed' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnTERMINOLOGY_Changed;
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
-- 07/24/2006 Paul.  Increase the MODULE_NAME to 25 to match the size in the MODULES table.
-- 01/14/2010 Paul.  In order to detect a case-significant change in the DISPLAY_NAME, first convert to binary. 
-- http://vyaskn.tripod.com/case_sensitive_search_in_sql_server.htm
-- 03/06/2012 Paul.  Increase size of the NAME field so that it can include a date formula. 
Create Function dbo.fnTERMINOLOGY_Changed
	( @NAME              nvarchar(150)
	, @LANG              nvarchar(10)
	, @MODULE_NAME       nvarchar(25)
	, @LIST_NAME         nvarchar(50)
	, @LIST_ORDER        int
	, @DISPLAY_NAME      nvarchar(max)
	)
returns bit
as
  begin
	declare @Changed bit;
	set @Changed = 0;
	if not exists(select *
	                from TERMINOLOGY
	               where DELETED = 0
	                 and (NAME         = @NAME         or (NAME         is null and @NAME         is null))
	                 and (LANG         = @LANG         or (LANG         is null and @LANG         is null))
	                 and (MODULE_NAME  = @MODULE_NAME  or (MODULE_NAME  is null and @MODULE_NAME  is null))
	                 and (LIST_NAME    = @LIST_NAME    or (LIST_NAME    is null and @LIST_NAME    is null))
	                 and (cast(DISPLAY_NAME as varbinary(4000)) = cast(@DISPLAY_NAME as varbinary(4000)) or (DISPLAY_NAME is null and @DISPLAY_NAME is null))
	                 and isnull(LIST_ORDER, 0) = isnull(@LIST_ORDER, 0)) begin -- then
		set @Changed = 1;
	end -- if;
	return @Changed;
  end
GO

Grant Execute on dbo.fnTERMINOLOGY_Changed to public
GO

