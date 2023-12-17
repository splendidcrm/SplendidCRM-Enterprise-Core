if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDYNAMIC_BUTTONS_InsEdit' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDYNAMIC_BUTTONS_InsEdit;
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
-- 09/12/2010 Paul.  Add default parameter ONCLICK_SCRIPT to ease migration to EffiProz. 
Create Procedure dbo.spDYNAMIC_BUTTONS_InsEdit
	( @VIEW_NAME           nvarchar(50)
	, @CONTROL_INDEX       int
	, @MODULE_NAME         nvarchar(25)
	)
as
  begin
	set nocount on
	
	exec dbo.spDYNAMIC_BUTTONS_InsButtonLink
		  @VIEW_NAME
		, @CONTROL_INDEX
		, @MODULE_NAME
		, N'edit'
		, null
		, null
		, N'Edit'
		, N'edit.aspx?ID={0}'
		, N'ID'
		, N'.LBL_EDIT_BUTTON_LABEL'
		, N'.LBL_EDIT_BUTTON_TITLE'
		, N'.LBL_EDIT_BUTTON_KEY'
		, null
		, null
		, null          -- ONCLICK_SCRIPT
		;

  end
GO

Grant Execute on dbo.spDYNAMIC_BUTTONS_InsEdit to public;
GO

