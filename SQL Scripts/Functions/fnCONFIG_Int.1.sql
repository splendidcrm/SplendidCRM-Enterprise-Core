if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnCONFIG_Int' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnCONFIG_Int;
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
-- 11/18/2006 Paul.  convert was using @VALUE instead of the table value.  
-- 04/23/2017 Paul.  Deleted flag was not being checked. 
Create Function dbo.fnCONFIG_Int(@NAME nvarchar(32))
returns int
as
  begin
	declare @VALUE_varchar nvarchar(10);
	declare @VALUE_int     int;
	select top 1 @VALUE_varchar = convert(nvarchar(10), VALUE)
	  from CONFIG
	 where NAME = @NAME
	   and DELETED = 0;
	-- 11/18/2006 Paul.  We cannot convert ntext to int, but we can go from nvarchar to int. 
	set @VALUE_int = convert(int, @VALUE_varchar);
	return @VALUE_int;
  end
GO

Grant Execute on dbo.fnCONFIG_Int to public
GO

