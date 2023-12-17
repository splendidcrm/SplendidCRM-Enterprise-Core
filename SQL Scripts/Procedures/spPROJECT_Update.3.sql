if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROJECT_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROJECT_Update;
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
-- 08/13/2008 Paul.  We need an update version that matches the table name to simplify the worflow code. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 01/13/2010 Paul.  New Project fields in SugarCRM. 
-- 04/07/2010 Paul.  Add EXCHANGE_FOLDER.
-- 05/12/2016 Paul.  Add Tags module. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spPROJECT_Update
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @ASSIGNED_USER_ID     uniqueidentifier
	, @NAME                 nvarchar(50)
	, @DESCRIPTION          nvarchar(max)
	, @PARENT_TYPE          nvarchar(25)
	, @PARENT_ID            uniqueidentifier
	, @TEAM_ID              uniqueidentifier = null
	, @TEAM_SET_LIST        varchar(8000) = null
	, @ESTIMATED_START_DATE datetime = null
	, @ESTIMATED_END_DATE   datetime = null
	, @STATUS               nvarchar(25) = null
	, @PRIORITY             nvarchar(25) = null
	, @IS_TEMPLATE          bit = null
	, @EXCHANGE_FOLDER      bit = null
	, @TAG_SET_NAME         nvarchar(4000) = null
	, @ASSIGNED_SET_LIST    varchar(8000) = null
	)
as
  begin
	set nocount on
	
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spPROJECTS_Update @ID out
		, @MODIFIED_USER_ID
		, @ASSIGNED_USER_ID
		, @NAME
		, @DESCRIPTION
		, @PARENT_TYPE
		, @PARENT_ID
		, @TEAM_ID
		, @TEAM_SET_LIST
		, @ESTIMATED_START_DATE
		, @ESTIMATED_END_DATE
		, @STATUS
		, @PRIORITY
		, @IS_TEMPLATE
		, @EXCHANGE_FOLDER
		, @TAG_SET_NAME
		, @ASSIGNED_SET_LIST
		;
  end
GO

Grant Execute on dbo.spPROJECT_Update to public;
GO

