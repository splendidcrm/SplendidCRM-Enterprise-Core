if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDETAILVIEWS_RELATIONSHIPS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDETAILVIEWS_RELATIONSHIPS_Update;
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
-- 09/08/2007 Paul.  We need a title when we migrate to WebParts. 
-- 09/24/2009 Paul.  The new Silverlight charts exceeded the control name length of 50. 
-- 10/13/2012 Paul.  Add table info for HTML5 Offline Client. 
-- 03/14/2016 Paul.  The new layout editor needs to update the RELATIONSHIP_ENABLED field. 
-- 03/20/2016 Paul.  Increase PRIMARY_FIELD size to 255 to support OfficeAddin. 
-- 03/30/2022 Paul.  Add Insight fields. 
Create Procedure dbo.spDETAILVIEWS_RELATIONSHIPS_Update
	( @ID                  uniqueidentifier output
	, @MODIFIED_USER_ID    uniqueidentifier
	, @DETAIL_NAME         nvarchar(50)
	, @MODULE_NAME         nvarchar(50)
	, @CONTROL_NAME        nvarchar(100)
	, @RELATIONSHIP_ORDER  int
	, @TITLE               nvarchar(100)
	, @TABLE_NAME          nvarchar(50) = null
	, @PRIMARY_FIELD       nvarchar(255) = null
	, @SORT_FIELD          nvarchar(50) = null
	, @SORT_DIRECTION      nvarchar(10) = null
	, @RELATIONSHIP_ENABLED bit = null
	, @INSIGHT_VIEW         nvarchar(50) = null
	, @INSIGHT_LABEL        nvarchar(100) = null
	)
as
  begin
	-- 01/09/2006 Paul.  Can't convert EDIT_NAME and FIELD_INDEX into an ID
	-- as it would prevent the Layout Manager from working properly. 
	if not exists(select * from DETAILVIEWS_RELATIONSHIPS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into DETAILVIEWS_RELATIONSHIPS
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, DETAIL_NAME        
			, MODULE_NAME        
			, CONTROL_NAME       
			, RELATIONSHIP_ORDER 
			, RELATIONSHIP_ENABLED
			, TITLE              
			, TABLE_NAME         
			, PRIMARY_FIELD      
			, SORT_FIELD         
			, SORT_DIRECTION     
			, INSIGHT_VIEW       
			, INSIGHT_LABEL      
			)
		values 
			( @ID                 
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @DETAIL_NAME        
			, @MODULE_NAME        
			, @CONTROL_NAME       
			, @RELATIONSHIP_ORDER 
			, @RELATIONSHIP_ENABLED
			, @TITLE              
			, @TABLE_NAME         
			, @PRIMARY_FIELD      
			, @SORT_FIELD         
			, @SORT_DIRECTION     
			, @INSIGHT_VIEW       
			, @INSIGHT_LABEL      
			);
	end else begin
		update DETAILVIEWS_RELATIONSHIPS
		   set MODIFIED_USER_ID     = @MODIFIED_USER_ID   
		     , DATE_MODIFIED        =  getdate()          
		     , DATE_MODIFIED_UTC    =  getutcdate()       
		     , DETAIL_NAME          = @DETAIL_NAME        
		     , MODULE_NAME          = @MODULE_NAME        
		     , CONTROL_NAME         = @CONTROL_NAME       
		     , RELATIONSHIP_ORDER   = @RELATIONSHIP_ORDER 
		     , TITLE                = @TITLE              
		     , TABLE_NAME           = @TABLE_NAME         
		     , PRIMARY_FIELD        = @PRIMARY_FIELD      
		     , SORT_FIELD           = @SORT_FIELD         
		     , SORT_DIRECTION       = @SORT_DIRECTION     
		     , RELATIONSHIP_ENABLED = isnull(@RELATIONSHIP_ENABLED, RELATIONSHIP_ENABLED)
		     , INSIGHT_VIEW         = isnull(@INSIGHT_VIEW, INSIGHT_VIEW)
		     , INSIGHT_LABEL        = isnull(@INSIGHT_LABEL, INSIGHT_LABEL)
		 where ID                   = @ID                 ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spDETAILVIEWS_RELATIONSHIPS_Update to public;
GO
 
