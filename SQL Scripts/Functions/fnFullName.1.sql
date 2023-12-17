if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnFullName' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnFullName;
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
-- 04/07/2010 Paul.  We want to trim the middle space. 
-- 08/01/2010 Paul.  Now that we are using this function in the list views, we need to be more efficient. 
Create Function dbo.fnFullName(@FIRST_NAME nvarchar(100), @LAST_NAME nvarchar(100))
returns nvarchar(200)
as
  begin
	declare @FULL_NAME nvarchar(200);
	if @FIRST_NAME is null begin -- then
		set @FULL_NAME = @LAST_NAME;
	end else if @LAST_NAME is null begin -- then
		set @FULL_NAME = @FIRST_NAME;
	end else begin
		set @FULL_NAME = @FIRST_NAME + N' ' + @LAST_NAME;
	end -- if;
	return @FULL_NAME;
  end
GO

Grant Execute on dbo.fnFullName to public
GO

