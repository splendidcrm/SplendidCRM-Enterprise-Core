if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spGRIDVIEWS_COLUMNS_UpdateStyle' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spGRIDVIEWS_COLUMNS_UpdateStyle;
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
Create Procedure dbo.spGRIDVIEWS_COLUMNS_UpdateStyle
	( @MODIFIED_USER_ID            uniqueidentifier
	, @GRID_NAME                   nvarchar(50)
	, @COLUMN_INDEX                int
	, @ITEMSTYLE_WIDTH             nvarchar(10)
	, @ITEMSTYLE_CSSCLASS          nvarchar(50)
	, @ITEMSTYLE_HORIZONTAL_ALIGN  nvarchar(10)
	, @ITEMSTYLE_VERTICAL_ALIGN    nvarchar(10)
	, @ITEMSTYLE_WRAP              bit
	)
as
  begin
	update GRIDVIEWS_COLUMNS
	   set MODIFIED_USER_ID            = @MODIFIED_USER_ID 
	     , DATE_MODIFIED               =  getdate()        
	     , DATE_MODIFIED_UTC           =  getutcdate()     
	     , ITEMSTYLE_WIDTH             = isnull(@ITEMSTYLE_WIDTH           , ITEMSTYLE_WIDTH           )
	     , ITEMSTYLE_CSSCLASS          = isnull(@ITEMSTYLE_CSSCLASS        , ITEMSTYLE_CSSCLASS        )
	     , ITEMSTYLE_HORIZONTAL_ALIGN  = isnull(@ITEMSTYLE_HORIZONTAL_ALIGN, ITEMSTYLE_HORIZONTAL_ALIGN)
	     , ITEMSTYLE_VERTICAL_ALIGN    = isnull(@ITEMSTYLE_VERTICAL_ALIGN  , ITEMSTYLE_VERTICAL_ALIGN  )
	     , ITEMSTYLE_WRAP              = isnull(@ITEMSTYLE_WRAP            , ITEMSTYLE_WRAP            )
	 where GRID_NAME                   = @GRID_NAME
	   and COLUMN_INDEX                = @COLUMN_INDEX
	   and DELETED                     = 0            
	   and DEFAULT_VIEW                = 0            ;
  end
GO
 
Grant Execute on dbo.spGRIDVIEWS_COLUMNS_UpdateStyle to public;
GO
 
