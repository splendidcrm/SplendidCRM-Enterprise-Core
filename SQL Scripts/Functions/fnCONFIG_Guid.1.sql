if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnCONFIG_Guid' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnCONFIG_Guid;
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
-- 04/23/2017 Paul.  Deleted flag was not being checked. 
Create Function dbo.fnCONFIG_Guid(@NAME nvarchar(60))
returns uniqueidentifier
as
  begin
	declare @VALUE_varchar nvarchar(255);
	declare @VALUE_guid    uniqueidentifier;
	select top 1 @VALUE_varchar = convert(nvarchar(255), VALUE)
	  from CONFIG
	 where NAME = @NAME
	   and DELETED = 0;
	set @VALUE_guid = convert(uniqueidentifier, @VALUE_varchar);
	return @VALUE_guid;
  end
GO

Grant Execute on dbo.fnCONFIG_Guid to public
GO

