if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEDITVIEWS_FIELDS_LstChange' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEDITVIEWS_FIELDS_LstChange;
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
-- 11/25/2006 Paul.  Create a procedure to convert a BoundList to a ChangeButton. 
-- This is because SugarCRM changed the Assigned To listbox to a Change field. 
-- 09/16/2012 Paul.  Increase ONCLICK_SCRIPT to nvarchar(max). 
Create Procedure dbo.spEDITVIEWS_FIELDS_LstChange
	( @EDIT_NAME         nvarchar( 50)
	, @FIELD_INDEX       int
	, @DATA_LABEL        nvarchar(150)
	, @DATA_FIELD        nvarchar(100)
	, @DATA_REQUIRED     bit
	, @FORMAT_TAB_INDEX  int
	, @DISPLAY_FIELD     nvarchar(100)
	, @ONCLICK_SCRIPT    nvarchar(max)
	, @COLSPAN           int
	)
as
  begin
	declare @ID uniqueidentifier;
	
	-- 11/25/2006 Paul.  First make sure that the data field exists. 
	-- BEGIN Oracle Exception
		select @ID = ID
		  from EDITVIEWS_FIELDS
		 where EDIT_NAME    = @EDIT_NAME
		   and DATA_FIELD   = @DATA_FIELD
		   and FIELD_TYPE   = N'ListBox'
		   and DELETED      = 0            
		   and DEFAULT_VIEW = 0            ;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 0 begin -- then
		update EDITVIEWS_FIELDS
		   set MODIFIED_USER_ID =  null             
		     , DATE_MODIFIED    =  getdate()        
		     , DATE_MODIFIED_UTC=  getutcdate()     
		     , FIELD_TYPE       = N'ChangeButton'   
		     , DATA_LABEL       = @DATA_LABEL       
		     , CACHE_NAME       = null
		     , DISPLAY_FIELD    = @DISPLAY_FIELD    
		     , DATA_REQUIRED    = @DATA_REQUIRED    
		     , UI_REQUIRED      = @DATA_REQUIRED    
		     , ONCLICK_SCRIPT   = @ONCLICK_SCRIPT   
		     , FORMAT_TAB_INDEX = @FORMAT_TAB_INDEX 
		     , COLSPAN          = @COLSPAN          
		 where ID = @ID;
	end -- if;
	
	-- 11/25/2006 Paul.  Also change the default view. 
	-- BEGIN Oracle Exception
		select @ID = ID
		  from EDITVIEWS_FIELDS
		 where EDIT_NAME    = @EDIT_NAME
		   and DATA_FIELD   = @DATA_FIELD
		   and FIELD_TYPE   = N'ListBox'
		   and DELETED      = 0            
		   and DEFAULT_VIEW = 1            ;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 0 begin -- then
		update EDITVIEWS_FIELDS
		   set MODIFIED_USER_ID =  null             
		     , DATE_MODIFIED    =  getdate()        
		     , DATE_MODIFIED_UTC=  getutcdate()     
		     , FIELD_TYPE       = N'ChangeButton'   
		     , DATA_LABEL       = @DATA_LABEL       
		     , CACHE_NAME       = null
		     , DISPLAY_FIELD    = @DISPLAY_FIELD    
		     , DATA_REQUIRED    = @DATA_REQUIRED    
		     , UI_REQUIRED      = @DATA_REQUIRED    
		     , ONCLICK_SCRIPT   = @ONCLICK_SCRIPT   
		     , FORMAT_TAB_INDEX = @FORMAT_TAB_INDEX 
		     , COLSPAN          = @COLSPAN          
		 where ID = @ID;
	end -- if;
  end
GO
 
Grant Execute on dbo.spEDITVIEWS_FIELDS_LstChange to public;
GO
 
