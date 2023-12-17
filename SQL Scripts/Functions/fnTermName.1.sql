if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnTermName' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnTermName;
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
-- 04/23/2017 Paul.  Module name can be 25 chars. 
Create Function dbo.fnTermName(@MODULE_NAME nvarchar(25), @LIST_NAME nvarchar(50), @NAME nvarchar(50))
returns nvarchar(150)
as
  begin
	declare @TERM_NAME nvarchar(200);
	if @LIST_NAME is null or @LIST_NAME = '' begin -- then
		set @TERM_NAME = isnull(@MODULE_NAME, N'') + N'.' + isnull(@NAME, N'');
	end else begin
		set @TERM_NAME = isnull(@MODULE_NAME, N'') + N'.' + isnull(@LIST_NAME, N'') + N'.' + isnull(@NAME, N'');
	end -- if;
	return @TERM_NAME;
  end
GO

Grant Execute on dbo.fnTermName to public
GO

