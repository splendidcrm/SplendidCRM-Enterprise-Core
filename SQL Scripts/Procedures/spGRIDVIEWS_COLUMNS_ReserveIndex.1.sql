if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spGRIDVIEWS_COLUMNS_ReserveIndex' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spGRIDVIEWS_COLUMNS_ReserveIndex;
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
Create Procedure dbo.spGRIDVIEWS_COLUMNS_ReserveIndex
	( @MODIFIED_USER_ID            uniqueidentifier
	, @GRID_NAME                   nvarchar(50)
	, @RESERVE_INDEX               int
	)
as
  begin
	declare @MIN_INDEX int;
	-- BEGIN Oracle Exception
		select @MIN_INDEX = min(COLUMN_INDEX)
		  from GRIDVIEWS_COLUMNS
		 where GRID_NAME         = @GRID_NAME       
		   and DELETED           = 0                
		   and DEFAULT_VIEW      = 0                ;
	-- END Oracle Exception
	while @MIN_INDEX < @RESERVE_INDEX begin -- do
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX      = COLUMN_INDEX + 1 
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where GRID_NAME         = @GRID_NAME       
		   and DELETED           = 0                
		   and DEFAULT_VIEW      = 0                ;
		set @MIN_INDEX = @MIN_INDEX + 1;
	end -- while;

	-- BEGIN Oracle Exception
		select @MIN_INDEX = min(COLUMN_INDEX)
		  from GRIDVIEWS_COLUMNS
		 where GRID_NAME         = @GRID_NAME       
		   and DELETED           = 0                
		   and DEFAULT_VIEW      = 1                ;
	-- END Oracle Exception
	while @MIN_INDEX < @RESERVE_INDEX begin -- do
		update GRIDVIEWS_COLUMNS
		   set COLUMN_INDEX      = COLUMN_INDEX + 1 
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where GRID_NAME         = @GRID_NAME       
		   and DELETED           = 0                
		   and DEFAULT_VIEW      = 1                ;
		set @MIN_INDEX = @MIN_INDEX + 1;
	end -- while;
  end
GO
 
Grant Execute on dbo.spGRIDVIEWS_COLUMNS_ReserveIndex to public;
GO
 
