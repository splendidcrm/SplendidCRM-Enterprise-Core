if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPARENT_GetWithTeam' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPARENT_GetWithTeam;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spPARENT_GetWithTeam
	( @ID                uniqueidentifier output
	, @MODULE            nvarchar( 25) output
	, @PARENT_TYPE       nvarchar( 25) output
	, @PARENT_NAME       nvarchar(150) output
	, @ASSIGNED_USER_ID  uniqueidentifier output
	, @ASSIGNED_TO       nvarchar(60) output
	, @ASSIGNED_TO_NAME  nvarchar(100) output
	, @TEAM_ID           uniqueidentifier output
	, @TEAM_NAME         nvarchar(128) output
	, @TEAM_SET_ID       uniqueidentifier output
	, @ASSIGNED_SET_ID   uniqueidentifier output
	)
as
  begin
	set nocount on
	
	declare @PARENT_ID uniqueidentifier;
	select top 1 @PARENT_ID         = PARENT_ID
	     , @MODULE            = MODULE
	     , @PARENT_TYPE       = PARENT_TYPE
	     , @PARENT_NAME       = PARENT_NAME
	     , @ASSIGNED_USER_ID  = PARENT_ASSIGNED_USER_ID
	     , @ASSIGNED_TO       = PARENT_ASSIGNED_TO
	     , @ASSIGNED_TO_NAME  = PARENT_ASSIGNED_TO_NAME
	     , @TEAM_ID           = PARENT_TEAM_ID
	     , @TEAM_NAME         = PARENT_TEAM_NAME
	     , @TEAM_SET_ID       = PARENT_TEAM_SET_ID
	     , @ASSIGNED_SET_ID   = PARENT_ASSIGNED_SET_ID
	  from vwPARENTS_WithTeam
	 where PARENT_ID    = @ID
	 order by PARENT_TYPE;

	-- Return NULL if not found. 
	set @ID = @PARENT_ID;
  end
GO

Grant Execute on dbo.spPARENT_GetWithTeam to public;
GO

