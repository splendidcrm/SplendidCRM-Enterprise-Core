

print 'DATA SimpleStorage';
GO

set nocount on;
GO

-- 05/18/2010 Paul.  Add defaults for Exchange Folders and Exchange Create Parent. 
-- 12/06/2010 Paul.  Convert display name to use moduleList. 
-- 09/12/2011 Paul.  REST_ENABLED provides a way to enable/disable a module in the REST API. 
exec dbo.spMODULES_InsertOnly null, 'SimpleStorage', '.moduleList.SimpleStorage', '~/Administration/SimpleStorage/', 1, 0,  0, 0, 0, 0, 0, 1, null, 0, 0, 0, 0, 0, 0;

exec dbo.spSHORTCUTS_InsertOnly null, 'SimpleStorage', 'SimpleStorage.LNK_BUCKET_LIST', '~/Administration/SimpleStorage/default.aspx', 'SimpleStorageBuckets.gif'      , 1,  1, 'SimpleStorage', 'list';
exec dbo.spSHORTCUTS_InsertOnly null, 'SimpleStorage', 'SimpleStorage.LNK_NEW_BUCKET' , '~/Administration/SimpleStorage/edit.aspx'   , 'CreateSimpleStorageBuckets.gif', 1,  2, 'SimpleStorage', 'edit';

/*
-- delete from GRIDVIEWS where NAME = 'SimpleStorage.ListView';
exec dbo.spGRIDVIEWS_InsertOnly 'SimpleStorage.ListView', 'SimpleStorage', 'vwSimpleStorage_List';

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME = 'SimpleStorage.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'SimpleStorage.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS SimpleStorage.ListView';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink 'SimpleStorage.ListView', 0, 'SimpleStorage.LBL_LIST_NAME'        , 'NAME'        , 'NAME'        , '70%', 'listViewTdLinkS1', 'NAME', '~/Administration/SimpleStorage/view.aspx?NAME={0}', null, 'SimpleStorage', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     'SimpleStorage.ListView', 1, 'SimpleStorage.LBL_LIST_DATE_ENTERED', 'DATE_ENTERED', 'DATE_ENTERED', '25%';
end -- if;
*/
GO

/*
-- delete from DETAILVIEWS where NAME = 'SimpleStorage.DetailView';
exec dbo.spDETAILVIEWS_InsertOnly 'SimpleStorage.DetailView', 'SimpleStorage', 'vwSimpleStorage_Edit', '15%', '35%';

-- delete from DETAILVIEWS_FIELDS where DETAIL_NAME = 'SimpleStorage.DetailView';
if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = 'SimpleStorage.DetailView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_FIELDS SimpleStorage.DetailView';
	exec dbo.spDETAILVIEWS_FIELDS_InsBound 'SimpleStorage.DetailView',  0, 'SimpleStorage.LBL_NAME'          , 'NAME'          , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound 'SimpleStorage.DetailView',  1, 'SimpleStorage.LBL_DATE_ENTERED'  , 'DATE_ENTERED'  , '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound 'SimpleStorage.DetailView',  2, 'SimpleStorage.LBL_LOGGING_BUCKET', 'LOGGING_BUCKET', '{0}', null;
	exec dbo.spDETAILVIEWS_FIELDS_InsBound 'SimpleStorage.DetailView',  3, 'SimpleStorage.LBL_LOGGING_PREFIX', 'LOGGING_PREFIX', '{0}', null;
end -- if;
*/
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'SimpleStorage.DetailView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SimpleStorage.DetailView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'SimpleStorage.DetailView', 0, null, null, null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , '.LBL_CANCEL_BUTTON_KEY'   , null, null;
end -- if;
GO

-- delete from DYNAMIC_BUTTONS where VIEW_NAME = 'SimpleStorage.EditView';
if not exists(select * from DYNAMIC_BUTTONS where VIEW_NAME = 'SimpleStorage.EditView' and DELETED = 0) begin -- then
	exec dbo.spDYNAMIC_BUTTONS_InsButton    'SimpleStorage.EditView'  , 0, null, null, null, null, 'Cancel', null, '.LBL_CANCEL_BUTTON_LABEL'   , '.LBL_CANCEL_BUTTON_TITLE'   , '.LBL_CANCEL_BUTTON_KEY'   , null, null;
end -- if;
GO

-- delete from EDITVIEWS_FIELDS where EDIT_NAME = 'Shortcuts.SearchBasic';
if not exists(select * from EDITVIEWS_FIELDS where EDIT_NAME = 'SimpleStorage.SearchBasic' and DELETED = 0) begin -- then
	print 'EDITVIEWS_FIELDS SimpleStorage.SearchBasic';
	exec dbo.spEDITVIEWS_InsertOnly          'SimpleStorage.SearchBasic', 'SimpleStorage', 'vwSimpleStorage_List', '15%', '35%', 2;
	exec dbo.spEDITVIEWS_FIELDS_InsBound     'SimpleStorage.SearchBasic',  0, 'SimpleStorage.LBL_NAME'              , 'NAME'                , 0, null,  30, 25, null;
	exec dbo.spEDITVIEWS_FIELDS_InsBlank     'SimpleStorage.SearchBasic',  1, null;
end -- if;
GO

-- 04/15/2011 Paul.  Lets duplicate AmazonView here now that FlexiblePayments has been deprecated. 
if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = 'Administration.ListView' and CONTROL_NAME = 'AmazonView' and DELETED = 0) begin -- then
	print 'DETAILVIEWS_RELATIONSHIPS Administration.ListView AmazonView';
	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly 'Administration.ListView'   , 'Administration'   , 'AmazonView'         ,  9, 'Administration.LBL_AMAZON_WEB_SERVICES_TITLE'        ;
end -- if;
GO



set nocount off;
GO

/* -- #if Oracle
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spDATA_SimpleStorage()
/

call dbo.spSqlDropProcedure('spDATA_SimpleStorage')
/
-- #endif IBM_DB2 */

