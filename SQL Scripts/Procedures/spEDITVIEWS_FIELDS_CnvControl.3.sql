if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEDITVIEWS_FIELDS_CnvControl' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEDITVIEWS_FIELDS_CnvControl;
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
-- 09/16/2012 Paul.  Increase ONCLICK_SCRIPT to nvarchar(max). 
Create Procedure dbo.spEDITVIEWS_FIELDS_CnvControl
	( @EDIT_NAME         nvarchar( 50)
	, @FIELD_INDEX       int
	, @DATA_LABEL        nvarchar(150)
	, @DATA_FIELD        nvarchar(100)
	, @DATA_REQUIRED     bit
	, @FORMAT_TAB_INDEX  int
	, @FIELD_TYPE        nvarchar( 50)
	, @ONCLICK_SCRIPT    nvarchar(max)
	, @COLSPAN           int
	, @ROWSPAN           int
	)
as
  begin
	declare @ID uniqueidentifier;
	
	-- 11/24/2006 Paul.  First make sure that the data field does not already exist. 
	-- BEGIN Oracle Exception
		select @ID = ID
		  from EDITVIEWS_FIELDS
		 where EDIT_NAME    = @EDIT_NAME
		   and DATA_FIELD   = @DATA_FIELD
		   and DELETED      = 0            
		   and DEFAULT_VIEW = 0            ;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		-- 11/24/2006 Paul.  Search for a Blank record at the specified index position. 
		-- BEGIN Oracle Exception
			select @ID = ID
			  from EDITVIEWS_FIELDS
			 where EDIT_NAME    = @EDIT_NAME
			   and FIELD_INDEX  = @FIELD_INDEX
			   and FIELD_TYPE   = N'Blank'     
			   and DELETED      = 0            
			   and DEFAULT_VIEW = 0            ;
		-- END Oracle Exception
		-- 11/24/2006 Paul.  If blank was not found at the expected position, try and locate the first blank. 
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			-- BEGIN Oracle Exception
				select @ID = ID
				  from EDITVIEWS_FIELDS
				 where EDIT_NAME    = @EDIT_NAME
				   and FIELD_INDEX  = (select min(FIELD_INDEX)
				                         from EDITVIEWS_FIELDS
				                        where EDIT_NAME    = @EDIT_NAME
				                          and FIELD_TYPE   = N'Blank'
				                          and DELETED      = 0
				                          and DEFAULT_VIEW = 0)
				   and FIELD_TYPE   = N'Blank'     
				   and DELETED      = 0            
				   and DEFAULT_VIEW = 0            ;
			-- END Oracle Exception
		end -- if;
		if dbo.fnIsEmptyGuid(@ID) = 0 begin -- then
			update EDITVIEWS_FIELDS
			   set MODIFIED_USER_ID =  null             
			     , DATE_MODIFIED    =  getdate()        
			     , DATE_MODIFIED_UTC=  getutcdate()     
			     , FIELD_TYPE        = @FIELD_TYPE       
			     , DATA_LABEL        = @DATA_LABEL       
			     , DATA_FIELD        = @DATA_FIELD       
			     , DATA_REQUIRED     = @DATA_REQUIRED    
			     , UI_REQUIRED       = @DATA_REQUIRED    
			     , ONCLICK_SCRIPT    = @ONCLICK_SCRIPT   
			     , FORMAT_TAB_INDEX  = @FORMAT_TAB_INDEX 
			     , COLSPAN           = @COLSPAN          
			     , ROWSPAN           = @ROWSPAN          
			 where ID = @ID;
		end else begin
			-- 11/24/2006 Paul.  If a blank cannot be found at the expected location, just insert a new record. 
			-- 11/25/2006 Paul.  In order to force the insert, make sure to specify a unique FIELD_INDEX. 
			select @FIELD_INDEX = max(FIELD_INDEX) + 1
			  from EDITVIEWS_FIELDS
			 where EDIT_NAME    = @EDIT_NAME
			   and DELETED      = 0            
			   and DEFAULT_VIEW = 0            ;
			exec dbo.spEDITVIEWS_FIELDS_InsControl @EDIT_NAME, @FIELD_INDEX, @DATA_LABEL, @DATA_FIELD, @DATA_REQUIRED, @FORMAT_TAB_INDEX, @FIELD_TYPE, @ONCLICK_SCRIPT, @COLSPAN, @ROWSPAN;
		end -- if;
	end -- if;
  end
GO
 
Grant Execute on dbo.spEDITVIEWS_FIELDS_CnvControl to public;
GO
 
