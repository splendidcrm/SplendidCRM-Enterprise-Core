if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEDITVIEWS_FIELDS_CnvAutoComplete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEDITVIEWS_FIELDS_CnvAutoComplete;
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
Create Procedure dbo.spEDITVIEWS_FIELDS_CnvAutoComplete
	( @EDIT_NAME         nvarchar( 50)
	, @FIELD_INDEX       int
	, @DATA_LABEL        nvarchar(150)
	, @DATA_FIELD        nvarchar(100)
	, @DATA_REQUIRED     bit
	, @FORMAT_TAB_INDEX  int
	, @FORMAT_MAX_LENGTH int
	, @FORMAT_SIZE       int
	, @MODULE_TYPE       nvarchar(25)
	, @COLSPAN           int
	)
as
  begin
	-- 08/26/2009 Paul.  We are going to ignore the following fields for now. 
	-- Keeping them in the method will make it easy to duplicate the InsModulePopup call. 
	-- @DATA_REQUIRED     bit
	-- @FORMAT_TAB_INDEX  int
	-- @FORMAT_MAX_LENGTH int
	-- @FORMAT_SIZE       int
	-- @COLSPAN           int

	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = @EDIT_NAME and DATA_FIELD = @DATA_FIELD and FIELD_TYPE = N'TextBox' and DELETED = 0) begin -- then
		-- 08/27/2009 Paul.  The update will take care of the main record and the default view record. 
		update EDITVIEWS_FIELDS
		   set FIELD_TYPE        = N'ModuleAutoComplete'
		     , MODULE_TYPE       = @MODULE_TYPE
		     , DISPLAY_FIELD     = null
		     , ONCLICK_SCRIPT    = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = @EDIT_NAME
		   and DATA_FIELD        = @DATA_FIELD
		   and FIELD_TYPE        = N'TextBox'
		   and DELETED           = 0;
	end -- if;
	-- 09/10/2009 Paul.  Allow conversion from ModulePopup, where data field matches display field. 
	if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = @EDIT_NAME and DISPLAY_FIELD = @DATA_FIELD and FIELD_TYPE = N'ModulePopup' and DELETED = 0) begin -- then
		-- 08/27/2009 Paul.  The update will take care of the main record and the default view record. 
		update EDITVIEWS_FIELDS
		   set FIELD_TYPE        = N'ModuleAutoComplete'
		     , MODULE_TYPE       = @MODULE_TYPE
		     , DATA_FIELD        = @DATA_FIELD
		     , DISPLAY_FIELD     = null
		     , ONCLICK_SCRIPT    = null
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID  = null
		 where EDIT_NAME         = @EDIT_NAME
		   and DISPLAY_FIELD     = @DATA_FIELD
		   and FIELD_TYPE        = N'ModulePopup'
		   and DELETED           = 0;
	end -- if;
  end
GO

Grant Execute on dbo.spEDITVIEWS_FIELDS_CnvAutoComplete to public;
GO

