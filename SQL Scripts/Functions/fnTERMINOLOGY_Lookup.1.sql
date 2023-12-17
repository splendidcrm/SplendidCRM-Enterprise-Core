if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnTERMINOLOGY_Lookup' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnTERMINOLOGY_Lookup;
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
-- 03/06/2012 Paul.  Increase size of the NAME field so that it can include a date formula. 
Create Function dbo.fnTERMINOLOGY_Lookup
	( @NAME              nvarchar(150)
	, @LANG              nvarchar(10)
	, @MODULE_NAME       nvarchar(25)
	, @LIST_NAME         nvarchar(50)
	)
returns nvarchar(2000)
as
  begin
	declare @DISPLAY_NAME nvarchar(max);
	if @LIST_NAME is not null begin -- then
		set @DISPLAY_NAME = (select top 1 DISPLAY_NAME
		                       from TERMINOLOGY
		                      where LANG        = @LANG
		                        and NAME        = @NAME
		                        and LIST_NAME   = @LIST_NAME
		                        and DELETED     = 0
		                    );
	end else if @MODULE_NAME is not null begin -- then
		set @DISPLAY_NAME = (select top 1 DISPLAY_NAME
		                       from TERMINOLOGY
		                      where LANG        = @LANG
		                        and NAME        = @NAME
		                        and MODULE_NAME = @MODULE_NAME
		                        and DELETED     = 0
		                    );
	end else begin
		set @DISPLAY_NAME = (select top 1 DISPLAY_NAME
		                       from TERMINOLOGY
		                      where LANG        = @LANG
		                        and NAME        = @NAME
		                        and MODULE_NAME is null
		                        and DELETED     = 0
		                    );
	end -- if;
	return @DISPLAY_NAME;
  end
GO

Grant Execute on dbo.fnTERMINOLOGY_Lookup to public
GO

