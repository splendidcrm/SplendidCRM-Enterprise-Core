if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnSqlColumns_IsEnum' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnSqlColumns_IsEnum;
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
-- 02/09/2007 Paul.  Use the EDITVIEWS_FIELDS to determine if a column is an enum. 
-- 09/16/2010 Paul.  CsType can be SqlDbType.DateTime. 
-- 12/12/2010 Paul.  EffiProz needs the ColumnName field to be greater than 35 due to an internal variable. 
-- 09/13/2011 Paul.  The Workflow EditView will append _AUDIT to the table name, so we need to remove that. 
-- Workflow EditView appends _AUDIT to prevent the inclusion of addtional fields in the base view, such as CITY in the vwACCOUNTS view. 
Create Function dbo.fnSqlColumns_IsEnum(@ModuleView nvarchar(50), @ColumnName nvarchar(50), @CsType nvarchar(20))
returns bit
as
  begin
	declare @IS_ENUM bit;
	declare @TableView nvarchar(50)
	set @IS_ENUM = 0;
	set @TableView = @ModuleView;
	if right(@TableView, 6) = '_AUDIT' begin -- then
		set @TableView = substring(@TableView, 1, len(@TableView) - 6);
	end -- if;
	if @CsType = N'string' or @CsType = N'ansistring' begin -- then
		if exists(select *
		            from      EDITVIEWS_FIELDS
		           inner join EDITVIEWS
		                   on EDITVIEWS.NAME      = EDITVIEWS_FIELDS.EDIT_NAME
		                  and EDITVIEWS.VIEW_NAME = @TableView + N'_Edit'
		                  and EDITVIEWS.DELETED   = 0
		           where EDITVIEWS_FIELDS.DELETED = 0
	                     and EDITVIEWS_FIELDS.FIELD_TYPE   = N'ListBox'
		             and EDITVIEWS_FIELDS.DEFAULT_VIEW = 0
		             and EDITVIEWS_FIELDS.DATA_FIELD   = @ColumnName
		             and EDITVIEWS_FIELDS.CACHE_NAME is not null) begin -- then
			set @IS_ENUM = 1;
		end -- if;
	end -- if;
	return @IS_ENUM;
  end
GO

Grant Execute on dbo.fnSqlColumns_IsEnum to public
GO

