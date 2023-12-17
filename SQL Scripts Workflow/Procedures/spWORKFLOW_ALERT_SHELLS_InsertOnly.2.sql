if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOW_ALERT_SHELLS_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOW_ALERT_SHELLS_InsertOnly;
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
Create Procedure dbo.spWORKFLOW_ALERT_SHELLS_InsertOnly
	( @MODIFIED_USER_ID    uniqueidentifier
	, @PARENT_ID           uniqueidentifier
	, @NAME                nvarchar(100)
	, @ALERT_TYPE          nvarchar(25)
	, @SOURCE_TYPE         nvarchar(25)
	, @CUSTOM_TEMPLATE_ID  uniqueidentifier
	, @ALERT_TEXT          nvarchar(max)
	, @RDL                 nvarchar(max)
	, @XOML                nvarchar(max)
	)
as
  begin
	set nocount on
	
	declare @ID               uniqueidentifier;
	declare @ASSIGNED_USER_ID uniqueidentifier;
	declare @TEAM_ID          uniqueidentifier;
	declare @TEAM_SET_ID      uniqueidentifier;
	declare @TEAM_SET_LIST    varchar(8000);
	set @ID = newid();
	-- 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
	exec dbo.spWORKFLOW_ALERT_SHELLS_Update @ID out, @MODIFIED_USER_ID, @PARENT_ID, @NAME, @ALERT_TYPE, @SOURCE_TYPE, @CUSTOM_TEMPLATE_ID, @ALERT_TEXT, @RDL, @XOML, @ASSIGNED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
  end
GO

Grant Execute on dbo.spWORKFLOW_ALERT_SHELLS_InsertOnly to public;
GO

