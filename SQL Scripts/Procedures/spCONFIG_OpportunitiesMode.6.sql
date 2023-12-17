if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCONFIG_OpportunitiesMode' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCONFIG_OpportunitiesMode;
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
Create Procedure dbo.spCONFIG_OpportunitiesMode
	( @MODIFIED_USER_ID    uniqueidentifier
	, @OPPORTUNITIES_MODE  nvarchar(25)
	)
as
  begin
	set nocount on

	if @OPPORTUNITIES_MODE = N'Revenue' begin -- then
		exec dbo.spCONFIG_Update @MODIFIED_USER_ID, N'System', N'OpportunitiesMode', @OPPORTUNITIES_MODE;
		if exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.EditView' and DATA_FIELD in ('CURRENCY_ID', 'AMOUNT', 'OPPORTUNITY_TYPE', 'LEAD_SOURCE', 'NEXT_STEP', 'SALES_STAGE', 'PROBABILITY', 'DESCRIPTION') and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			update EDITVIEWS_FIELDS
			   set DELETED           = 1
			     , DATE_MODIFIED     = getdate()
			     , DATE_MODIFIED_UTC = getutcdate()
			     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
			 where EDIT_NAME         = 'Opportunities.EditView'
			   and DATA_FIELD        in ('CURRENCY_ID', 'AMOUNT', 'OPPORTUNITY_TYPE', 'LEAD_SOURCE', 'NEXT_STEP', 'SALES_STAGE', 'PROBABILITY', 'DESCRIPTION')
			   and DEFAULT_VIEW      = 0
			   and DELETED           = 0;
		end -- if;

		if exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView' and DATA_FIELD in ('CURRENCY_ID', 'AMOUNT', 'OPPORTUNITY_TYPE', 'LEAD_SOURCE', 'NEXT_STEP', 'SALES_STAGE', 'PROBABILITY', 'DESCRIPTION') and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			update DETAILVIEWS_FIELDS
			   set DELETED           = 1
			     , DATE_MODIFIED     = getdate()
			     , DATE_MODIFIED_UTC = getutcdate()
			     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
			 where DETAIL_NAME       = 'Opportunities.DetailView'
			   and DATA_FIELD        in ('CURRENCY_ID', 'AMOUNT', 'OPPORTUNITY_TYPE', 'LEAD_SOURCE', 'NEXT_STEP', 'SALES_STAGE', 'PROBABILITY', 'DESCRIPTION')
			   and DEFAULT_VIEW      = 0
			   and DELETED           = 0;
		end -- if;
	end else begin
		-- 08/08/2015 Paul.  Incase the wrong value is used, force any non Revenue value to be Opportunities. 
		exec dbo.spCONFIG_Update @MODIFIED_USER_ID, N'System', N'OpportunitiesMode', N'Opportunities';
		if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.EditView' and DATA_FIELD = 'CURRENCY_ID' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Opportunities.EditView'  , -1, 'Opportunities.LBL_CURRENCY'             , 'CURRENCY_ID'                , 0, 2, 'Currencies'          , null, null;
		end -- if;
		if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.EditView' and DATA_FIELD = 'AMOUNT' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_InsBound       'Opportunities.EditView'  , -1, 'Opportunities.LBL_AMOUNT'               , 'AMOUNT'                     , 1, 2,  25, 15, null;
		end -- if;
		if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.EditView' and DATA_FIELD = 'OPPORTUNITY_TYPE' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Opportunities.EditView'  , -1, 'Opportunities.LBL_TYPE'                 , 'OPPORTUNITY_TYPE'           , 0, 1, 'opportunity_type_dom', null, null;
		end -- if;
		if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.EditView' and DATA_FIELD = 'LEAD_SOURCE' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Opportunities.EditView'  , -1, 'Opportunities.LBL_LEAD_SOURCE'          , 'LEAD_SOURCE'                , 0, 1, 'lead_source_dom'     , null, null;
		end -- if;
		if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.EditView' and DATA_FIELD = 'NEXT_STEP' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_InsBound       'Opportunities.EditView'  , -1, 'Opportunities.LBL_NEXT_STEP'            , 'NEXT_STEP'                  , 0, 2,  25, 15, null;
		end -- if;
		if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.EditView' and DATA_FIELD = 'PROBABILITY' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_InsBound       'Opportunities.EditView'  , -1, 'Opportunities.LBL_PROBABILITY'          , 'PROBABILITY'                , 0, 2,   3,  4, null;
		end -- if;
		if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.EditView' and DATA_FIELD = 'SALES_STAGE' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_InsBoundList   'Opportunities.EditView'  , -1, 'Opportunities.LBL_SALES_STAGE'          , 'SALES_STAGE'                , 0, 2, 'sales_stage_dom'     , null, null;
		end -- if;
		if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'Opportunities.EditView' and DATA_FIELD = 'DESCRIPTION' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spEDITVIEWS_FIELDS_InsMultiLine   'Opportunities.EditView'  , -1, 'Opportunities.LBL_DESCRIPTION'          , 'DESCRIPTION'                , 0, 3,   8, 60, 3;
		end -- if;

		if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView' and DATA_FIELD = 'AMOUNT_USDOLLAR' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView', -1, 'Opportunities.LBL_AMOUNT'          , 'AMOUNT_USDOLLAR'                  , '{0:c}'      , null;
		end -- if;
		if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView' and DATA_FIELD = 'OPPORTUNITY_TYPE' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'Opportunities.DetailView', -1, 'Opportunities.LBL_TYPE'            , 'OPPORTUNITY_TYPE'                 , '{0}'        , 'opportunity_type_dom', null;
		end -- if;
		if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView' and DATA_FIELD = 'NEXT_STEP' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView', -1, 'Opportunities.LBL_NEXT_STEP'       , 'NEXT_STEP'                        , '{0}'        , null;
		end -- if;
		if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView' and DATA_FIELD = 'LEAD_SOURCE' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'Opportunities.DetailView', -1, 'Opportunities.LBL_LEAD_SOURCE'     , 'LEAD_SOURCE'                      , '{0}'        , 'lead_source_dom'     , null;
		end -- if;
		if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView' and DATA_FIELD = 'SALES_STAGE' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  'Opportunities.DetailView', -1, 'Opportunities.LBL_SALES_STAGE'     , 'SALES_STAGE'                      , '{0}'        , 'sales_stage_dom'     , null;
		end -- if;
		if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView' and DATA_FIELD = 'PROBABILITY' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spDETAILVIEWS_FIELDS_InsBound      'Opportunities.DetailView', -1, 'Opportunities.LBL_PROBABILITY'     , 'PROBABILITY'                      , '{0}'        , null;
		end -- if;
		if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'Opportunities.DetailView' and DATA_FIELD = 'DESCRIPTION' and DEFAULT_VIEW = 0 and DELETED = 0) begin -- then
			exec dbo.spDETAILVIEWS_FIELDS_InsertOnly    'Opportunities.DetailView', -1, 'TextBox', 'Opportunities.LBL_DESCRIPTION', 'DESCRIPTION', null, null, null, null, null, 3, null;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spCONFIG_OpportunitiesMode to public;
GO

-- exec spCONFIG_OpportunitiesMode null, 'Revenue';

