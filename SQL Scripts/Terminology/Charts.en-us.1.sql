

print 'TERMINOLOGY Charts en-us';
GO

set nocount on;
GO

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADD_FILTER_BUTTON_LABEL'                   , N'en-US', N'Charts', null, null, N'Add Filter';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AVAILABLE_COLUMNS'                         , N'en-US', N'Charts', null, null, N'Available Columns';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CHOOSE_COLUMNS'                            , N'en-US', N'Charts', null, null, N'Choose Columns:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CREATE_BUTTON_LABEL'                       , N'en-US', N'Charts', null, null, N'Create Chart';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DISPLAY_COLUMNS'                           , N'en-US', N'Charts', null, null, N'Display Columns';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DISPLAY_COLUMNS_REQUIRED'                  , N'en-US', N'Charts', null, null, N'Display Columns Required';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FILTERS'                                   , N'en-US', N'Charts', null, null, N'Filters:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_BUTTON_LABEL'                       , N'en-US', N'Charts', null, null, N'Import';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_BUTTON_TITLE'                       , N'en-US', N'Charts', null, null, N'Import';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'Charts', null, null, N'Chart List';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MODULE_NAME'                          , N'en-US', N'Charts', null, null, N'Module Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'Charts', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_RDL'                                  , N'en-US', N'Charts', null, null, N'Rdl';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CHART_NAME'                           , N'en-US', N'Charts', null, null, N'Chart Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CHART_TYPE'                           , N'en-US', N'Charts', null, null, N'Chart Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'Charts', null, null, N'Module Name:';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Charts', null, null, N'Chr';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'Charts', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRINT_BUTTON_LABEL'                        , N'en-US', N'Charts', null, null, N'Print as PDF';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRINT_BUTTON_TITLE'                        , N'en-US', N'Charts', null, null, N'Print as PDF';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RDL'                                       , N'en-US', N'Charts', null, null, N'RDL:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RELATED'                                   , N'en-US', N'Charts', null, null, N'Related:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REMOVE_BUTTON_LABEL'                       , N'en-US', N'Charts', null, null, N'Remove';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REMOVE_BUTTON_TITLE'                       , N'en-US', N'Charts', null, null, N'Remove';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CHART_DASHLET'                             , N'en-US', N'Charts', null, null, N'Chart Dashlet';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CHART_NAME'                                , N'en-US', N'Charts', null, null, N'Chart Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CHART_TYPE'                                , N'en-US', N'Charts', null, null, N'Chart Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RUN_BUTTON_LABEL'                          , N'en-US', N'Charts', null, null, N'Run Chart';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RUN_BUTTON_TITLE'                          , N'en-US', N'Charts', null, null, N'Run Chart';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SAVE_BUTTON_LABEL'                         , N'en-US', N'Charts', null, null, N'Save';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SAVE_BUTTON_TITLE'                         , N'en-US', N'Charts', null, null, N'Save';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SHOW_QUERY'                                , N'en-US', N'Charts', null, null, N'Show Query:';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_ADD_DASHLET'                               , N'en-US', N'Charts', null, null, N'Add Dashlet';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_VIEW'                                      , N'en-US', N'Charts', null, null, N'View';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_CHARTS'                                    , N'en-US', N'Charts', null, null, N'Charts';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TABS_FILTERS'                              , N'en-US', N'Charts', null, null, N'Filters';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TABS_CHART_TYPE'                           , N'en-US', N'Charts', null, null, N'Chart Type';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SERIES'                                    , N'en-US', N'Charts', null, null, N'Legend Entries (Series)';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CATEGORY'                                  , N'en-US', N'Charts', null, null, N'Horizontal (Category) Axis Labels';
GO
/* -- #if Oracle
	COMMIT WORK;
END;
/

BEGIN
-- #endif Oracle */
exec dbo.spTERMINOLOGY_InsertOnly N'Charts'                                        , N'en-US', null, N'moduleList'                        ,  98, N'Charts';

-- 05/28/2021 Paul.  React requires that the chart types match MS Report Builder. 
-- delete from TERMINOLOGY where LIST_NAME = 'dom_chart_types' and LANG = 'en-US';
if exists(select * from TERMINOLOGY where LIST_NAME = 'dom_chart_types' and LANG = 'en-US' and NAME = 'columns') begin -- then
	delete from TERMINOLOGY where LIST_NAME = 'dom_chart_types' and LANG = 'en-US';
end -- if;
exec dbo.spTERMINOLOGY_InsertOnly N'Column'                                        , N'en-US', null, N'dom_chart_types'                   ,   1, N'Column';
exec dbo.spTERMINOLOGY_InsertOnly N'Bar'                                           , N'en-US', null, N'dom_chart_types'                   ,   2, N'Bar';
exec dbo.spTERMINOLOGY_InsertOnly N'Line'                                          , N'en-US', null, N'dom_chart_types'                   ,   3, N'Line';
exec dbo.spTERMINOLOGY_InsertOnly N'Shape'                                         , N'en-US', null, N'dom_chart_types'                   ,   4, N'Shape';
exec dbo.spTERMINOLOGY_InsertOnly N'Area'                                          , N'en-US', null, N'dom_chart_types'                   ,   5, N'Area';

-- ansistring, bool, datetime, decimal, enum, float, guid, int32, string
-- delete from vwTERMINOLOGY where name in ('count_all', 'count_not_empty')
exec dbo.spTERMINOLOGY_InsertOnly N'count'                                         , N'en-US', null, N'series_ansistring_operator_dom'    ,   1, N'Count:All';
exec dbo.spTERMINOLOGY_InsertOnly N'count_not_empty'                               , N'en-US', null, N'series_ansistring_operator_dom'    ,   2, N'Count:Non-empty';
exec dbo.spTERMINOLOGY_InsertOnly N'count'                                         , N'en-US', null, N'series_bool_operator_dom'          ,   1, N'Count:All';
exec dbo.spTERMINOLOGY_InsertOnly N'count_not_empty'                               , N'en-US', null, N'series_bool_operator_dom'          ,   2, N'Count:Non-empty';
exec dbo.spTERMINOLOGY_InsertOnly N'count'                                         , N'en-US', null, N'series_datetime_operator_dom'      ,   1, N'Count:All';
exec dbo.spTERMINOLOGY_InsertOnly N'count_not_empty'                               , N'en-US', null, N'series_datetime_operator_dom'      ,   2, N'Count:Non-empty';
exec dbo.spTERMINOLOGY_InsertOnly N'count'                                         , N'en-US', null, N'series_enum_operator_dom'          ,   1, N'Count:All';
exec dbo.spTERMINOLOGY_InsertOnly N'count_not_empty'                               , N'en-US', null, N'series_enum_operator_dom'          ,   2, N'Count:Non-empty';
exec dbo.spTERMINOLOGY_InsertOnly N'count'                                         , N'en-US', null, N'series_guid_operator_dom'          ,   1, N'Count:All';
exec dbo.spTERMINOLOGY_InsertOnly N'count_not_empty'                               , N'en-US', null, N'series_guid_operator_dom'          ,   2, N'Count:Non-empty';
exec dbo.spTERMINOLOGY_InsertOnly N'count'                                         , N'en-US', null, N'series_string_operator_dom'        ,   1, N'Count:All';
exec dbo.spTERMINOLOGY_InsertOnly N'count_not_empty'                               , N'en-US', null, N'series_string_operator_dom'        ,   2, N'Count:Non-empty';

exec dbo.spTERMINOLOGY_InsertOnly N'sum'                                           , N'en-US', null, N'series_decimal_operator_dom'       ,   1, N'Sum';
exec dbo.spTERMINOLOGY_InsertOnly N'avg'                                           , N'en-US', null, N'series_decimal_operator_dom'       ,   2, N'Avg';
exec dbo.spTERMINOLOGY_InsertOnly N'min'                                           , N'en-US', null, N'series_decimal_operator_dom'       ,   3, N'Min';
exec dbo.spTERMINOLOGY_InsertOnly N'max'                                           , N'en-US', null, N'series_decimal_operator_dom'       ,   4, N'Max';
exec dbo.spTERMINOLOGY_InsertOnly N'count'                                         , N'en-US', null, N'series_decimal_operator_dom'       ,   5, N'Count:All';
exec dbo.spTERMINOLOGY_InsertOnly N'count_not_empty'                               , N'en-US', null, N'series_decimal_operator_dom'       ,   6, N'Count:Non-empty';

exec dbo.spTERMINOLOGY_InsertOnly N'sum'                                           , N'en-US', null, N'series_float_operator_dom'         ,   1, N'Sum';
exec dbo.spTERMINOLOGY_InsertOnly N'avg'                                           , N'en-US', null, N'series_float_operator_dom'         ,   2, N'Avg';
exec dbo.spTERMINOLOGY_InsertOnly N'min'                                           , N'en-US', null, N'series_float_operator_dom'         ,   3, N'Min';
exec dbo.spTERMINOLOGY_InsertOnly N'max'                                           , N'en-US', null, N'series_float_operator_dom'         ,   4, N'Max';
exec dbo.spTERMINOLOGY_InsertOnly N'count'                                         , N'en-US', null, N'series_float_operator_dom'         ,   1, N'Count:All';
exec dbo.spTERMINOLOGY_InsertOnly N'count_not_empty'                               , N'en-US', null, N'series_float_operator_dom'         ,   2, N'Count:Non-empty';

exec dbo.spTERMINOLOGY_InsertOnly N'sum'                                           , N'en-US', null, N'series_int32_operator_dom'         ,   1, N'Sum';
exec dbo.spTERMINOLOGY_InsertOnly N'avg'                                           , N'en-US', null, N'series_int32_operator_dom'         ,   2, N'Avg';
exec dbo.spTERMINOLOGY_InsertOnly N'min'                                           , N'en-US', null, N'series_int32_operator_dom'         ,   3, N'Min';
exec dbo.spTERMINOLOGY_InsertOnly N'max'                                           , N'en-US', null, N'series_int32_operator_dom'         ,   4, N'Max';
exec dbo.spTERMINOLOGY_InsertOnly N'count'                                         , N'en-US', null, N'series_int32_operator_dom'         ,   1, N'Count:All';
exec dbo.spTERMINOLOGY_InsertOnly N'count_not_empty'                               , N'en-US', null, N'series_int32_operator_dom'         ,   2, N'Count:Non-empty';

exec dbo.spTERMINOLOGY_InsertOnly N'day'                                           , N'en-US', null, N'category_datetime_operator_dom'    ,   1, N'Day';
exec dbo.spTERMINOLOGY_InsertOnly N'week'                                          , N'en-US', null, N'category_datetime_operator_dom'    ,   2, N'Week';
exec dbo.spTERMINOLOGY_InsertOnly N'month'                                         , N'en-US', null, N'category_datetime_operator_dom'    ,   3, N'Month';
exec dbo.spTERMINOLOGY_InsertOnly N'quarter'                                       , N'en-US', null, N'category_datetime_operator_dom'    ,   4, N'Quarter';
exec dbo.spTERMINOLOGY_InsertOnly N'year'                                          , N'en-US', null, N'category_datetime_operator_dom'    ,   5, N'Year';
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

call dbo.spTERMINOLOGY_Charts_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Charts_en_us')
/
-- #endif IBM_DB2 */
