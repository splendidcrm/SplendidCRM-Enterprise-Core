

print 'TERMINOLOGY ReportDesigner en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'ReportDesigner';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'ReportDesigner', null, null, N'Report List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULES'                                   , N'en-US', N'ReportDesigner', null, null, N'Modules';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SELECTED_FIELDS'                           , N'en-US', N'ReportDesigner', null, null, N'Selected Fields';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_GROUP_AND_AGGREGATE'                       , N'en-US', N'ReportDesigner', null, null, N'Group and Aggregate';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIELD'                                     , N'en-US', N'ReportDesigner', null, null, N'Field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DISPLAY_NAME'                              , N'en-US', N'ReportDesigner', null, null, N'Display Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DISPLAY_WIDTH'                             , N'en-US', N'ReportDesigner', null, null, N'Display Width';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AGGREGATE'                                 , N'en-US', N'ReportDesigner', null, null, N'Aggregate';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SORT_DIRECTION'                            , N'en-US', N'ReportDesigner', null, null, N'Sort Direction';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RELATIONSHIPS'                             , N'en-US', N'ReportDesigner', null, null, N'Relationships';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEFT_TABLE'                                , N'en-US', N'ReportDesigner', null, null, N'Left Table';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_JOIN_TYPE'                                 , N'en-US', N'ReportDesigner', null, null, N'Join Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RIGHT_TABLE'                               , N'en-US', N'ReportDesigner', null, null, N'Right Table';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_JOIN_FIELDS'                               , N'en-US', N'ReportDesigner', null, null, N'Join Fields';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APPLIED_FILTERS'                           , N'en-US', N'ReportDesigner', null, null, N'Applied Filters';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIELD_NAME'                                , N'en-US', N'ReportDesigner', null, null, N'Field Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OPERATOR'                                  , N'en-US', N'ReportDesigner', null, null, N'Operator';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_VALUE'                                     , N'en-US', N'ReportDesigner', null, null, N'Value';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARAMETER'                                 , N'en-US', N'ReportDesigner', null, null, N'Paramter';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NONE'                                      , N'en-US', N'ReportDesigner', null, null, N'(none)';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EDIT_INSTRUCTIONS'                         , N'en-US', N'ReportDesigner', null, null, N'Click to edit';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TABLES_IN_QUERY'                           , N'en-US', N'ReportDesigner', null, null, N'Tables in Query';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULES'                                   , N'en-US', N'ReportDesigner', null, null, N'Modules';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TABLES'                                    , N'en-US', N'ReportDesigner', null, null, N'Tables';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RELATIONSHIP_TABLES'                       , N'en-US', N'ReportDesigner', null, null, N'Relationship Tables';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LEFT_JOIN_FIELD'                           , N'en-US', N'ReportDesigner', null, null, N'Left Join Field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RIGHT_JOIN_FIELD'                          , N'en-US', N'ReportDesigner', null, null, N'Right Join Field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EDIT_RELATED_FIELDS'                       , N'en-US', N'ReportDesigner', null, null, N'Edit Related Fields';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_JOIN_FIELDS_INSTRUCTIONS'                  , N'en-US', N'ReportDesigner', null, null, N'Choose fields to join "{0}" to "{1}".';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MISSING_JOIN_TABLE'                        , N'en-US', N'ReportDesigner', null, null, N'You must specify both a left and a right table.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MISSING_JOIN_FIELD'                        , N'en-US', N'ReportDesigner', null, null, N'You must specify both a left and a right field.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OK'                                        , N'en-US', N'ReportDesigner', null, null, N'OK';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CANCEL'                                    , N'en-US', N'ReportDesigner', null, null, N'Cancel';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MISSING_JOIN_FIELDS'                       , N'en-US', N'ReportDesigner', null, null, N'Missing join fields between "{0}" and "{1}".';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMBINE_RELATIONSHIPS'                     , N'en-US', N'ReportDesigner', null, null, N'All related columns between "{0}" and "{1}" must be within the same relationship.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_UNRELATED_ERROR'                           , N'en-US', N'ReportDesigner', null, null, N'The following tables are unrelated to the query: {0}';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MISSING_FILTER_FIELD'                      , N'en-US', N'ReportDesigner', null, null, N'Missing filter field for filter number {0}.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MISSING_FILTER_OPERATOR'                   , N'en-US', N'ReportDesigner', null, null, N'Missing filter operator for field {0}.';
-- 02/11/2018 Paul.  Workflow mode uses older style of operators. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_UNKNOWN_OPERATOR'                          , N'en-US', N'ReportDesigner', null, null, N'Unknown filter operator for field {0}.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MISSING_FILTER_VALUE'                      , N'en-US', N'ReportDesigner', null, null, N'Missing filter value for field {0}.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_INVALID_ARRAY_VALUE'                       , N'en-US', N'ReportDesigner', null, null, N'Array value is not valid for field {0} and operator {1}.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_WIDTH'                                , N'en-US', N'ReportDesigner', null, null, N'Page Width:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PAGE_HEIGHT'                               , N'en-US', N'ReportDesigner', null, null, N'Page Height:';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_INVALID_REPORT_UNITS'                      , N'en-US', N'ReportDesigner', null, null, N'Invalid report units.  Units must be in, cm, mm, pt or pc.';
-- 04/17/2018 Paul.  Add CustomView to simplify reporting. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CUSTOM_REPORT_VIEWS'                       , N'en-US', N'ReportDesigner', null, null, N'Custom Report Views';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'ReportDesigner', null, null, N'RpD';
-- 05/26/2019 Paul.  All modules should have a LBL_NEW_FORM_TITLE for the React client. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEW_FORM_TITLE'                            , N'en-US', N'ReportDesigner', null, null, N'Report Designer';

exec dbo.spTERMINOLOGY_InsertOnly N'ReportDesigner'                                , N'en-US', null, N'moduleList',  125, N'Report Designer';
-- 04/08/2020 Paul.  Additional labels for the React Client. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SELECT_FIELD'                              , N'en-US', N'ReportDesigner', null, null, N'Select Field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SELECT_TABLE'                              , N'en-US', N'ReportDesigner', null, null, N'Select Table';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SELECT_OPERATOR'                           , N'en-US', N'ReportDesigner', null, null, N'Select Operator';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'inner'                                         , N'en-US', null, N'report_join_type_dom'      ,   1, N'Inner';
exec dbo.spTERMINOLOGY_InsertOnly N'left outer'                                    , N'en-US', null, N'report_join_type_dom'      ,   2, N'Left Outer';
exec dbo.spTERMINOLOGY_InsertOnly N'right outer'                                   , N'en-US', null, N'report_join_type_dom'      ,   3, N'Right Outer';
exec dbo.spTERMINOLOGY_InsertOnly N'full outer'                                    , N'en-US', null, N'report_join_type_dom'      ,   4, N'Full Outer';

-- delete from TERMINOLOGY where LIST_NAME = 'report_filter_operator_dom';
exec dbo.spTERMINOLOGY_InsertOnly N'='                                             , N'en-US', null, N'report_filter_operator_dom',   1, N'is';
exec dbo.spTERMINOLOGY_InsertOnly N'<>'                                            , N'en-US', null, N'report_filter_operator_dom',   2, N'is not';
exec dbo.spTERMINOLOGY_InsertOnly N'like'                                          , N'en-US', null, N'report_filter_operator_dom',   3, N'is like';
exec dbo.spTERMINOLOGY_InsertOnly N'not like'                                      , N'en-US', null, N'report_filter_operator_dom',   4, N'is not like';
exec dbo.spTERMINOLOGY_InsertOnly N'in'                                            , N'en-US', null, N'report_filter_operator_dom',   5, N'is any of';
exec dbo.spTERMINOLOGY_InsertOnly N'not in'                                        , N'en-US', null, N'report_filter_operator_dom',   6, N'is none of';
exec dbo.spTERMINOLOGY_InsertOnly N'>'                                             , N'en-US', null, N'report_filter_operator_dom',   7, N'is more than';
exec dbo.spTERMINOLOGY_InsertOnly N'>='                                            , N'en-US', null, N'report_filter_operator_dom',   8, N'is more than or equal to';
exec dbo.spTERMINOLOGY_InsertOnly N'<'                                             , N'en-US', null, N'report_filter_operator_dom',   9, N'is less than';
exec dbo.spTERMINOLOGY_InsertOnly N'<='                                            , N'en-US', null, N'report_filter_operator_dom',  10, N'is less than or equal to';
exec dbo.spTERMINOLOGY_InsertOnly N'is null'                                       , N'en-US', null, N'report_filter_operator_dom',  11, N'is null';
exec dbo.spTERMINOLOGY_InsertOnly N'is not null'                                   , N'en-US', null, N'report_filter_operator_dom',  12, N'is not null';
exec dbo.spTERMINOLOGY_InsertOnly N'between'                                       , N'en-US', null, N'report_filter_operator_dom',  13, N'is between';

exec dbo.spTERMINOLOGY_InsertOnly N'group by'                                      , N'en-US', null, N'report_aggregate_type_dom',   1, N'Group by';
exec dbo.spTERMINOLOGY_InsertOnly N'avg'                                           , N'en-US', null, N'report_aggregate_type_dom',   2, N'Avg';
exec dbo.spTERMINOLOGY_InsertOnly N'count'                                         , N'en-US', null, N'report_aggregate_type_dom',   3, N'Count';
exec dbo.spTERMINOLOGY_InsertOnly N'count'                                         , N'en-US', null, N'report_aggregate_type_dom',   4, N'Count Big';
exec dbo.spTERMINOLOGY_InsertOnly N'min'                                           , N'en-US', null, N'report_aggregate_type_dom',   5, N'Min';
exec dbo.spTERMINOLOGY_InsertOnly N'max'                                           , N'en-US', null, N'report_aggregate_type_dom',   6, N'Max';
exec dbo.spTERMINOLOGY_InsertOnly N'stdev'                                         , N'en-US', null, N'report_aggregate_type_dom',   7, N'StDev';
exec dbo.spTERMINOLOGY_InsertOnly N'stdevp'                                        , N'en-US', null, N'report_aggregate_type_dom',   8, N'StDevP';
exec dbo.spTERMINOLOGY_InsertOnly N'sum'                                           , N'en-US', null, N'report_aggregate_type_dom',   9, N'Sum';
exec dbo.spTERMINOLOGY_InsertOnly N'var'                                           , N'en-US', null, N'report_aggregate_type_dom',  10, N'Var';
exec dbo.spTERMINOLOGY_InsertOnly N'varp'                                          , N'en-US', null, N'report_aggregate_type_dom',  11, N'VarP';
exec dbo.spTERMINOLOGY_InsertOnly N'avg distinct'                                  , N'en-US', null, N'report_aggregate_type_dom',  12, N'Avg Distinct';
exec dbo.spTERMINOLOGY_InsertOnly N'count distinct'                                , N'en-US', null, N'report_aggregate_type_dom',  13, N'Count Distinct';
exec dbo.spTERMINOLOGY_InsertOnly N'count distinct'                                , N'en-US', null, N'report_aggregate_type_dom',  14, N'Count Big Distinct';
exec dbo.spTERMINOLOGY_InsertOnly N'stdev distinct'                                , N'en-US', null, N'report_aggregate_type_dom',  15, N'StDev Distinct';
exec dbo.spTERMINOLOGY_InsertOnly N'stdevp distinct'                               , N'en-US', null, N'report_aggregate_type_dom',  16, N'StDevP Distinct';
exec dbo.spTERMINOLOGY_InsertOnly N'sum distinct'                                  , N'en-US', null, N'report_aggregate_type_dom',  17, N'Sum Distinct';
exec dbo.spTERMINOLOGY_InsertOnly N'var distinct'                                  , N'en-US', null, N'report_aggregate_type_dom',  18, N'Var Distinct';
exec dbo.spTERMINOLOGY_InsertOnly N'varp distinct'                                 , N'en-US', null, N'report_aggregate_type_dom',  19, N'VarP Distinct';

exec dbo.spTERMINOLOGY_InsertOnly N''                                              , N'en-US', null, N'report_sort_direction_dom',   0, N'(none)';
exec dbo.spTERMINOLOGY_InsertOnly N'asc'                                           , N'en-US', null, N'report_sort_direction_dom',   1, N'Ascending';
exec dbo.spTERMINOLOGY_InsertOnly N'desc'                                          , N'en-US', null, N'report_sort_direction_dom',   2, N'Descending';
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

call dbo.spTERMINOLOGY_ReportDesigner_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_ReportDesigner_en_us')
/
-- #endif IBM_DB2 */
