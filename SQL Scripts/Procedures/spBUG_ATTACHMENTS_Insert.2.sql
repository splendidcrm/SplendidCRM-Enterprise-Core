if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spBUG_ATTACHMENTS_Insert' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spBUG_ATTACHMENTS_Insert;
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
-- 09/13/2008 Paul.  DB2 does not support optional parameters. 
-- 08/23/2009 Paul.  Since we create a note, we need to pass the team information to the new note. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spBUG_ATTACHMENTS_Insert
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @BUG_ID            uniqueidentifier
	, @DESCRIPTION       nvarchar(255)
	, @FILENAME          nvarchar(255)
	, @FILE_EXT          nvarchar(25)
	, @FILE_MIME_TYPE    nvarchar(100)
	, @TEAM_ID           uniqueidentifier = null
	, @TEAM_SET_LIST     varchar(8000) = null
	, @ASSIGNED_SET_LIST varchar(8000) = null
	)
as
  begin
	set nocount on
	declare @NOTE_ID uniqueidentifier;
	
	-- 08/21/2005 Paul.  Don't use a separate table for bug attachments as SugarCRM already has a relationship with Notes.
	-- 08/23/2009 Paul.  Since we create a note, we need to pass the team information to the new note. 
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spNOTES_Update @NOTE_ID out
		, @MODIFIED_USER_ID
		, @DESCRIPTION, N'Bugs'
		, @BUG_ID
		, null
		, null
		, @TEAM_ID
		, @TEAM_SET_LIST
		, @ASSIGNED_SET_LIST
		;

	exec dbo.spNOTE_ATTACHMENTS_Insert @ID out, @MODIFIED_USER_ID, @NOTE_ID, @DESCRIPTION, @FILENAME, @FILE_EXT, @FILE_MIME_TYPE;
  end
GO

Grant Execute on dbo.spBUG_ATTACHMENTS_Insert to public;
GO

