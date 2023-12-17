if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spGRIDVIEWS_COLUMNS_InsHidden' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spGRIDVIEWS_COLUMNS_InsHidden;
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
Create Procedure dbo.spGRIDVIEWS_COLUMNS_InsHidden
	( @GRID_NAME                   nvarchar( 50)
	, @DATA_FIELD                  nvarchar( 50)
	)
as
  begin
	declare @ID                uniqueidentifier;
	declare @COLUMN_INDEX      int;
	
	-- 08/20/2016 Paul.  We only need one record for the hidden field, so the index is not important. 
	-- BEGIN Oracle Exception
		select @ID = ID
		  from GRIDVIEWS_COLUMNS
		 where GRID_NAME    = @GRID_NAME
		   and DATA_FIELD   = @DATA_FIELD
		   and DELETED      = 0            
		   and DEFAULT_VIEW = 0            ;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		-- BEGIN Oracle Exception
			select @COLUMN_INDEX = isnull(max(COLUMN_INDEX), 0) + 1
			  from GRIDVIEWS_COLUMNS
			 where GRID_NAME    = @GRID_NAME
			   and DELETED      = 0            
			   and DEFAULT_VIEW = 0            ;
		-- END Oracle Exception

		exec dbo.spGRIDVIEWS_COLUMNS_Update
			  @ID out
			, null               -- MODIFIED_USER_ID
			, @GRID_NAME         -- GRID_NAME
			, @COLUMN_INDEX      -- COLUMN_INDEX
			, N'TemplateColumn'  -- COLUMN_TYPE
			, null               -- HEADER_TEXT
			, null               -- SORT_EXPRESSION
			, null               -- ITEMSTYLE_WIDTH
			, null               -- ITEMSTYLE_CSSCLASS
			, null               -- ITEMSTYLE_HORIZONTAL_ALIGN
			, null               -- ITEMSTYLE_VERTICAL_ALIGN
			, null               -- ITEMSTYLE_WRAP    
			, @DATA_FIELD        -- DATA_FIELD        
			, N'Hidden'          -- DATA_FORMAT       
			, null               -- URL_FIELD         
			, null               -- URL_FORMAT        
			, null               -- URL_TARGET        
			, null               -- LIST_NAME         
			, null               -- URL_MODULE        
			, null               -- URL_ASSIGNED_FIELD
			, null               -- MODULE_TYPE       
			, null               -- PARENT_FIELD      
			;
	end -- if;
  end
GO

Grant Execute on dbo.spGRIDVIEWS_COLUMNS_InsHidden to public;
GO

