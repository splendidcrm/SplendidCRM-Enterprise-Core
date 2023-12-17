

print 'GRIDVIEWS_COLUMNS MachineLearningModels';
GO

set nocount on;
GO

-- delete from GRIDVIEWS_COLUMNS where GRID_NAME like 'MachineLearningModels.ListView';
if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'MachineLearningModels.ListView' and DELETED = 0) begin -- then
	print 'GRIDVIEWS_COLUMNS MachineLearningModels.ListView';
	exec dbo.spGRIDVIEWS_InsertOnly             'MachineLearningModels.ListView'     , 'MachineLearningModels', 'vwMACHINE_LEARNING_MODELS_List';
	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink   'MachineLearningModels.ListView'     ,  1, 'MachineLearningModels.LBL_LIST_NAME'                 , 'NAME'                  , 'NAME'                 , '20%', 'listViewTdLinkS1', 'ID', 'view.aspx?ID={0}', null, 'MachineLearningModels', null;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'MachineLearningModels.ListView'     ,  2, 'MachineLearningModels.LBL_LIST_BASE_MODULE'          , 'BASE_MODULE'           , 'BASE_MODULE'          , '10%', 'ml_modules_dom'     ;
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'MachineLearningModels.ListView'     ,  3, 'MachineLearningModels.LBL_LIST_STATUS'               , 'STATUS'                , 'STATUS'               , '10%', 'ml_model_status_dom';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate   'MachineLearningModels.ListView'     ,  4, 'MachineLearningModels.LBL_LIST_LAST_TRAINING_DATE'   , 'LAST_TRAINING_DATE'    , 'LAST_TRAINING_DATE'   , '20', 'Date';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'MachineLearningModels.ListView'     ,  5, 'MachineLearningModels.LBL_LIST_LAST_TRAINING_COUNT'  , 'LAST_TRAINING_COUNT'   , 'LAST_TRAINING_COUNT'  , '10%';
	exec dbo.spGRIDVIEWS_COLUMNS_InsBound       'MachineLearningModels.ListView'     ,  6, 'MachineLearningModels.LBL_LIST_LAST_TRAINING_STATUS' , 'LAST_TRAINING_STATUS'  , null                   , '30%';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Contacts.ListView' and DATA_FIELD = 'PREDICTION' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Contacts.ListView'     ,  -1, 'MachineLearningModels.LBL_LIST_PREDICTION'               , 'PREDICTION'                , 'PREDICTION'               , '5%', 'ml_contact_prediction_dom';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Leads.ListView' and DATA_FIELD = 'PREDICTION' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Leads.ListView'        ,  -1, 'MachineLearningModels.LBL_LIST_PREDICTION'               , 'PREDICTION'                , 'PREDICTION'               , '5%', 'ml_contact_prediction_dom';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Prospects.ListView' and DATA_FIELD = 'PREDICTION' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Prospects.ListView'    ,  -1, 'MachineLearningModels.LBL_LIST_PREDICTION'               , 'PREDICTION'                , 'PREDICTION'               , '5%', 'ml_contact_prediction_dom';
end -- if;
GO

if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = 'Opportunities.ListView' and DATA_FIELD = 'PREDICTION' and DELETED = 0) begin -- then
	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList   'Opportunities.ListView',  -1, 'MachineLearningModels.LBL_LIST_PREDICTION'               , 'PREDICTION'                , 'PREDICTION'               , '5%', 'ml_opportunity_prediction_dom';
end -- if;
GO

set nocount off;
GO


/* -- #if Oracle
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			StoO_selcnt := 0;
		WHEN OTHERS THEN
			RAISE;
	END;
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spGRIDVIEWS_COLUMNS_MachineLearningModels()
/

call dbo.spSqlDropProcedure('spGRIDVIEWS_COLUMNS_MachineLearningModels')
/

-- #endif IBM_DB2 */

