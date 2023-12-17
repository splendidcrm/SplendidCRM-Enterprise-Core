if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROSPECT_LISTS_Import' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROSPECT_LISTS_Import;
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
-- 01/10/2010 Paul.  We are not going to allow the importing of Dynamic SQL.
-- 02/04/2010 Paul.  The Dynamic SQL fields were removed.
-- 01/10/2011 Paul.  Prevent duplicate lists by searching for an existing list. 
-- 01/11/2011 Paul.  If @TEAM_SET_LIST is null, then ignore the existing value for this field. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spPROSPECT_LISTS_Import
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @ASSIGNED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(50)
	, @DESCRIPTION       nvarchar(max)
	, @PARENT_TYPE       nvarchar(25)
	, @PARENT_ID         uniqueidentifier
	, @LIST_TYPE         nvarchar(255)
	, @DOMAIN_NAME       nvarchar(255)
	, @TEAM_ID           uniqueidentifier = null
	, @TEAM_SET_LIST     varchar(8000) = null
	, @TAG_SET_NAME      nvarchar(4000) = null
	, @ASSIGNED_SET_LIST varchar(8000) = null
	)
as
  begin
	set nocount on
	
	declare @DYNAMIC_LIST      bit;
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		select top 1 @ID     = ID
		  from vwPROSPECT_LISTS
		 where NAME    = @NAME
		   and (ASSIGNED_USER_ID = @ASSIGNED_USER_ID or (ASSIGNED_USER_ID is null and @ASSIGNED_USER_ID is null))
		   and (TEAM_ID          = @TEAM_ID          or (TEAM_ID          is null and @TEAM_ID          is null))
		   and (TEAM_SET_LIST    = @TEAM_SET_LIST    or (@TEAM_SET_LIST   is null));
	end -- if;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spPROSPECT_LISTS_Update @ID out
		, @MODIFIED_USER_ID
		, @ASSIGNED_USER_ID
		, @NAME
		, @DESCRIPTION
		, @PARENT_TYPE
		, @PARENT_ID
		, @LIST_TYPE
		, @DOMAIN_NAME
		, @TEAM_ID
		, @TEAM_SET_LIST
		, @DYNAMIC_LIST
		, @TAG_SET_NAME
		, @ASSIGNED_SET_LIST
		;
  end
GO

Grant Execute on dbo.spPROSPECT_LISTS_Import to public;
GO

