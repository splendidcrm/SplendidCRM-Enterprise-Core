if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDETAILVIEWS_FIELDS_CnvTags' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDETAILVIEWS_FIELDS_CnvTags;
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
Create Procedure dbo.spDETAILVIEWS_FIELDS_CnvTags
	( @DETAIL_NAME       nvarchar( 50)
	, @FIELD_INDEX       int
	, @COLSPAN           int
	)
as
  begin
	declare @TEMP_FIELD_INDEX int;
	declare @ID               uniqueidentifier;
	declare @DATA_LABEL       nvarchar(150);
	declare @DATA_FIELD       nvarchar(1000);
	declare @DATA_FORMAT      nvarchar(max);
	
	set @DATA_LABEL       = N'.LBL_TAG_SET_NAME';
	set @DATA_FIELD       = N'TAG_SET_NAME';
	set @DATA_FORMAT      = N'{0}';
	set @TEMP_FIELD_INDEX = @FIELD_INDEX;
	-- 11/24/2006 Paul.  First make sure that the data field does not already exist. 
	-- BEGIN Oracle Exception
		select @ID = ID
		  from DETAILVIEWS_FIELDS
		 where DETAIL_NAME  = @DETAIL_NAME
		   and DATA_FIELD   = @DATA_FIELD
		   and DELETED      = 0            
		   and DEFAULT_VIEW = 0            ;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		-- 11/24/2006 Paul.  Search for a Blank record at the specified index position. 
		-- BEGIN Oracle Exception
			select @ID = ID
			  from DETAILVIEWS_FIELDS
			 where DETAIL_NAME  = @DETAIL_NAME
			   and FIELD_INDEX  = @TEMP_FIELD_INDEX
			   and FIELD_TYPE   = N'Blank'     
			   and DELETED      = 0            
			   and DEFAULT_VIEW = 0            ;
		-- END Oracle Exception
		-- 11/24/2006 Paul.  If blank was not found at the expected position, try and locate the first blank. 
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			-- BEGIN Oracle Exception
				select @ID = ID
				  from DETAILVIEWS_FIELDS
				 where DETAIL_NAME  = @DETAIL_NAME
				   and FIELD_INDEX  = (select min(FIELD_INDEX)
				                         from DETAILVIEWS_FIELDS
				                        where DETAIL_NAME  = @DETAIL_NAME
				                          and FIELD_TYPE   = N'Blank'
				                          and DELETED      = 0
				                          and DEFAULT_VIEW = 0)
				   and FIELD_TYPE   = N'Blank'     
				   and DELETED      = 0            
				   and DEFAULT_VIEW = 0            ;
			-- END Oracle Exception
		end -- if;

		if dbo.fnIsEmptyGuid(@ID) = 0 begin -- then
			update DETAILVIEWS_FIELDS
			   set MODIFIED_USER_ID = null              
			     , DATE_MODIFIED    = getdate()
			     , DATE_MODIFIED_UTC= getutcdate()
			     , FIELD_TYPE       = N'Tags'           
			     , DATA_LABEL       = @DATA_LABEL       
			     , DATA_FIELD       = @DATA_FIELD       
			     , DATA_FORMAT      = @DATA_FORMAT      
			     , COLSPAN          = @COLSPAN          
			 where ID = @ID;
		end else begin
			select @TEMP_FIELD_INDEX = max(FIELD_INDEX) + 1
			  from DETAILVIEWS_FIELDS
			 where DETAIL_NAME  = @DETAIL_NAME
			   and DELETED      = 0            
			   and DEFAULT_VIEW = 0            ;
			exec dbo.spDETAILVIEWS_FIELDS_InsTags @DETAIL_NAME, @TEMP_FIELD_INDEX, @COLSPAN;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spDETAILVIEWS_FIELDS_CnvTags to public;
GO

