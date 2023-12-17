if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnEDITVIEWS_FIELDS_MultiSelect' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnEDITVIEWS_FIELDS_MultiSelect;
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
-- 10/13/2011 Paul.  Special list of EditViews for the search area with IS_MULTI_SELECT. 
-- 09/11/2013 Paul.  A CheckBoxList is also a multi-select. 
Create Function dbo.fnEDITVIEWS_FIELDS_MultiSelect(@MODULE_NAME nvarchar(25), @DATA_FIELD nvarchar(100), @FIELD_TYPE nvarchar(25))
returns bit
as
  begin
	declare @IS_MULTI_SELECT bit;
	set @IS_MULTI_SELECT = 0;
	if @FIELD_TYPE = N'ListBox' or @FIELD_TYPE = N'CheckBoxList' begin -- then
		set @IS_MULTI_SELECT = 0;
		if exists(select *
		            from EDITVIEWS_FIELDS
		           where DELETED      = 0
		             and DEFAULT_VIEW = 0
		             and EDIT_NAME    = @MODULE_NAME + N'.EditView'
		             and DATA_FIELD   = @DATA_FIELD
		             and FIELD_TYPE   in (N'ListBox', N'CheckBoxList')
		             and FORMAT_ROWS  > 0
		         ) begin -- then
			set @IS_MULTI_SELECT = 1;
		end -- if;
	end -- if;
	return @IS_MULTI_SELECT;
  end
GO

Grant Execute on dbo.fnEDITVIEWS_FIELDS_MultiSelect to public
GO

