if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spGRIDVIEWS_COLUMNS_InsHyperLink' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spGRIDVIEWS_COLUMNS_InsHyperLink;
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
-- 04/28/2006 Paul.  Added URL_MODULE.
-- 05/02/2006 Paul.  Add URL_ASSIGNED_FIELD to support ACL. 
-- 07/24/2006 Paul.  Increase the HEADER_TEXT to 150 to allow a fully-qualified (NAME+MODULE_NAME+LIST_NAME) TERMINOLOGY name. 
-- 11/24/2006 Paul.  COLUMN_TYPE should be of national character type. 
-- 09/12/2010 Paul.  Add default parameter MODULE_TYPE to ease migration to EffiProz. 
-- 10/09/2010 Paul.  Add PARENT_FIELD so that we can establish dependent listboxes. 
-- 05/02/2013 Paul.  Allow a field to be added to the end using an index of -1. 
-- 10/30/2013 Paul.  Increase size of URL_TARGET. 
Create Procedure dbo.spGRIDVIEWS_COLUMNS_InsHyperLink
	( @GRID_NAME                   nvarchar( 50)
	, @COLUMN_INDEX                int
	, @HEADER_TEXT                 nvarchar(150)
	, @DATA_FIELD                  nvarchar( 50)
	, @SORT_EXPRESSION             nvarchar( 50)
	, @ITEMSTYLE_WIDTH             nvarchar( 10)
	, @ITEMSTYLE_CSSCLASS          nvarchar( 50)
	, @URL_FIELD                   nvarchar(max)
	, @URL_FORMAT                  nvarchar(max)
	, @URL_TARGET                  nvarchar( 60)
	, @URL_MODULE                  nvarchar( 25)
	, @URL_ASSIGNED_FIELD          nvarchar( 30)
	)
as
  begin
	declare @ID        uniqueidentifier;
	declare @COLUMN_ID uniqueidentifier;
	
	-- 05/02/2013 Paul.  Allow a field to be added to the end using an index of -1. 
	declare @TEMP_COLUMN_INDEX int;	
	set @TEMP_COLUMN_INDEX = @COLUMN_INDEX;
	if @COLUMN_INDEX is null or @COLUMN_INDEX = -1 begin -- then
		-- BEGIN Oracle Exception
			select @TEMP_COLUMN_INDEX = isnull(max(COLUMN_INDEX), 0) + 1
			  from GRIDVIEWS_COLUMNS
			 where GRID_NAME    = @GRID_NAME
			   and DELETED      = 0            
			   and DEFAULT_VIEW = 0            ;
		-- END Oracle Exception
		-- BEGIN Oracle Exception
			select @ID = ID
			  from GRIDVIEWS_COLUMNS
			 where GRID_NAME    = @GRID_NAME
			   and DATA_FIELD   = @DATA_FIELD
			   and DELETED      = 0            
			   and DEFAULT_VIEW = 0            ;
		-- END Oracle Exception
	end else begin
		-- BEGIN Oracle Exception
			select @ID = ID
			  from GRIDVIEWS_COLUMNS
			 where GRID_NAME    = @GRID_NAME
			   and COLUMN_INDEX = @COLUMN_INDEX
			   and DELETED      = 0            
			   and DEFAULT_VIEW = 0            ;
		-- END Oracle Exception
	end -- if;
	if not exists(select * from GRIDVIEWS_COLUMNS where ID = @ID) begin -- then
		-- GRID_NAME, COLUMN_INDEX, COLUMN_TYPE, HEADER_TEXT, DATA_FIELD, SORT_EXPRESSION, ITEMSTYLE_WIDTH, ITEMSTYLE-CSSCLASS, URL_FIELD, URL_FORMAT, URL_MODULE, URL_ASSIGNED_FIELD
		exec dbo.spGRIDVIEWS_COLUMNS_Update
			  @COLUMN_ID out
			, null
			, @GRID_NAME
			, @TEMP_COLUMN_INDEX
			, N'TemplateColumn'
			, @HEADER_TEXT
			, @SORT_EXPRESSION
			, @ITEMSTYLE_WIDTH
			, @ITEMSTYLE_CSSCLASS
			, null
			, null
			, null
			, @DATA_FIELD
			, N'HyperLink'
			, @URL_FIELD
			, @URL_FORMAT
			, @URL_TARGET
			, null
			, @URL_MODULE
			, @URL_ASSIGNED_FIELD
			, null             -- MODULE_TYPE       
			, null             -- PARENT_FIELD      
			;
	end -- if;
  end
GO
 
Grant Execute on dbo.spGRIDVIEWS_COLUMNS_InsHyperLink to public;
GO
 
