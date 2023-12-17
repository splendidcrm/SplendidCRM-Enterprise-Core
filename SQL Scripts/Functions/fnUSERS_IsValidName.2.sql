if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnUSERS_IsValidName' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnUSERS_IsValidName;
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
Create Function dbo.fnUSERS_IsValidName(@ID uniqueidentifier, @USER_NAME nvarchar(20))
returns bit
as
  begin
	declare @IsValid bit;
	set @IsValid = 1;
	if exists(select USER_NAME
	            from dbo.USERS
	           where USER_NAME = @USER_NAME 
	             and USER_NAME is not null  -- 12/06/2005. Don't let an employee be treated as a duplicate. 
	             and DELETED   = 0
	             and (ID <> @ID or @ID is null)
	         ) begin -- then
		set @IsValid = 0;
	end -- if;
	return @IsValid;
  end
GO

Grant Execute on dbo.fnUSERS_IsValidName to public
GO

