if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnCustomTableName' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnCustomTableName;
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
-- 12/16/2006 Paul.  Not all module names can be easily converted to a custom module name.  Use the MODULES table to convert. 
Create Function dbo.fnCustomTableName(@MODULE_NAME nvarchar(255))
returns nvarchar(255)
as
  begin
	declare @CUSTOM_NAME nvarchar(255);
	select top 1 @CUSTOM_NAME = TABLE_NAME + N'_CSTM'
	  from MODULES
	 where MODULE_NAME = @MODULE_NAME;

	if @CUSTOM_NAME is null begin -- then
		set @CUSTOM_NAME = @MODULE_NAME + N'_CSTM';
	end -- if;
	return @CUSTOM_NAME;
  end
GO

Grant Execute on dbo.fnCustomTableName to public
GO

