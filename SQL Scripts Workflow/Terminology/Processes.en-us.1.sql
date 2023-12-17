


print 'TERMINOLOGY Processes en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'Processes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROCESS_NUMBER'                            , N'en-US', N'Processes', null, null, N'Process Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PROCESS_NUMBER'                       , N'en-US', N'Processes', null, null, N'Num';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUSINESS_PROCESS_NAME'                     , N'en-US', N'Processes', null, null, N'Business Process:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BUSINESS_PROCESS_NAME'                , N'en-US', N'Processes', null, null, N'Definition';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROCESS_NAME'                              , N'en-US', N'Processes', null, null, N'Process Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PROCESS_NAME'                         , N'en-US', N'Processes', null, null, N'Process Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROCESS_USER_NAME'                         , N'en-US', N'Processes', null, null, N'Process User:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PROCESS_USER_NAME'                    , N'en-US', N'Processes', null, null, N'Process User';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROCESS_OWNER_NAME'                        , N'en-US', N'Processes', null, null, N'Process Owner:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PROCESS_OWNER_NAME'                   , N'en-US', N'Processes', null, null, N'Process Owner';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACTIVITY_NAME'                             , N'en-US', N'Processes', null, null, N'Activity Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ACTIVITY_NAME'                        , N'en-US', N'Processes', null, null, N'Activity Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROCESS_USER'                              , N'en-US', N'Processes', null, null, N'Process User:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PROCESS_USER'                         , N'en-US', N'Processes', null, null, N'Process User';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROCESS_OWNER'                             , N'en-US', N'Processes', null, null, N'Process Owner:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PROCESS_OWNER'                        , N'en-US', N'Processes', null, null, N'Process Owner';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROCESS_DUE_DATE'                          , N'en-US', N'Processes', null, null, N'Process Due Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PROCESS_DUE_DATE'                     , N'en-US', N'Processes', null, null, N'Process Due Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_NAME'                               , N'en-US', N'Processes', null, null, N'Record Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PARENT_NAME'                          , N'en-US', N'Processes', null, null, N'Record Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_TYPE'                               , N'en-US', N'Processes', null, null, N'Record Module:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PARENT_TYPE'                          , N'en-US', N'Processes', null, null, N'Record Module';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DURATION'                                  , N'en-US', N'Processes', null, null, N'Duration:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'Processes', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'Processes', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APPROVAL_DATE'                             , N'en-US', N'Processes', null, null, N'Approval Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APPROVAL_USER_NAME'                        , N'en-US', N'Processes', null, null, N'Approved By:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APPROVAL_RESPONSE'                         , N'en-US', N'Processes', null, null, N'Approval Response:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Processes', null, null, N'Pro';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'Processes', null, null, N'Processes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'Processes', null, null, N'Processes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_FORM_TITLE'                         , N'en-US', N'Processes', null, null, N'Search';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_BUSINESS_PROCESSES_LIST'                   , N'en-US', N'Processes', null, null, N'Processes';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_APPROVE'                                   , N'en-US', N'Processes', null, null, N'Approve';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REJECT'                                    , N'en-US', N'Processes', null, null, N'Reject';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ROUTE'                                     , N'en-US', N'Processes', null, null, N'Route';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CLAIM'                                     , N'en-US', N'Processes', null, null, N'Claim';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CANCEL'                                    , N'en-US', N'Processes', null, null, N'Cancel';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CHANGE_ASSIGNED_USER'                      , N'en-US', N'Processes', null, null, N'Change Assigned User';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CHANGE_PROCESS_USER'                       , N'en-US', N'Processes', null, null, N'Change Process User';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PROCESS_NOTES'                             , N'en-US', N'Processes', null, null, N'Process Notes:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ADD_NOTES'                                 , N'en-US', N'Processes', null, null, N'Add Notes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NOTES'                                     , N'en-US', N'Processes', null, null, N'Notes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HISTORY'                                   , N'en-US', N'Processes', null, null, N'History';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CURRENT'                                   , N'en-US', N'Processes', null, null, N'Current';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OVERDUE'                                   , N'en-US', N'Processes', null, null, N'Overdue';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MY_PROCESSES'                              , N'en-US', N'Processes', null, null, N'My Processes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_MY_PROCESSES'                         , N'en-US', N'Processes', null, null, N'My Processes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SELF_SERVICE_PROCESSES'                    , N'en-US', N'Processes', null, null, N'Self-Service Processes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DUE_DATE_FORMAT'                           , N'en-US', N'Processes', null, null, N'Due Date {0}';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_OVERDUE_FORMAT'                            , N'en-US', N'Processes', null, null, N'Overdue {0}';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MY_PROCESSES_NAME_FORMAT'                  , N'en-US', N'Processes', null, null, N'Process # {0} - {1}';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_YEARS_AGO_FORMAT'                          , N'en-US', N'Processes', null, null, N'{0} years ago';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MONTHS_AGO_FORMAT'                         , N'en-US', N'Processes', null, null, N'{0} months ago';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DAYS_AGO_FORMAT'                           , N'en-US', N'Processes', null, null, N'{0} days ago';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HOURS_AGO_FORMAT'                          , N'en-US', N'Processes', null, null, N'{0} hours ago';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MINUTES_AGO_FORMAT'                        , N'en-US', N'Processes', null, null, N'{0} minutes ago';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SECONDS_AGO_FORMAT'                        , N'en-US', N'Processes', null, null, N'{0} seconds ago';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HISTORY_ASSIGNED_FORMAT'                   , N'en-US', N'Processes', null, null, N'<b>{0}</b> has been <b>assigned</b> to activity "{1}".';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HISTORY_APPROVE_FORMAT'                    , N'en-US', N'Processes', null, null, N'<b>{0}</b> has <b>approved</b> activity "{1}".';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HISTORY_REJECT_FORMAT'                     , N'en-US', N'Processes', null, null, N'<b>{0}</b> has <b>rejected</b> activity "{1}".';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HISTORY_CLAIM_FORMAT'                      , N'en-US', N'Processes', null, null, N'<b>{0}</b> has <b>claimed</b> activity "{1}".';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HISTORY_ROUTE_FORMAT'                      , N'en-US', N'Processes', null, null, N'<b>{0}</b> has <b>routed</b> activity "{1}".';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HISTORY_CHANGE_ASSIGNED_USER_FORMAT'       , N'en-US', N'Processes', null, null, N'<b>{0}</b> has <b>changed</b> the assigned user to <b>{1}</b>.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HISTORY_CHANGE_PROCESS_USER_FORMAT'        , N'en-US', N'Processes', null, null, N'<b>{0}</b> has <b>changed</b> the process user to <b>{1}</b>.';

-- select * from TERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc;
exec dbo.spTERMINOLOGY_InsertOnly N'Processes'                                     , N'en-US', null, N'moduleList', 165, N'Processes';

exec dbo.spTERMINOLOGY_InsertOnly N'In Progress'                                   , N'en-US', null, N'process_status',   1, N'In Progress';
exec dbo.spTERMINOLOGY_InsertOnly N'Unclaimed'                                     , N'en-US', null, N'process_status',   2, N'Unclaimed';
exec dbo.spTERMINOLOGY_InsertOnly N'Completed'                                     , N'en-US', null, N'process_status',   3, N'Completed';
exec dbo.spTERMINOLOGY_InsertOnly N'Terminated'                                    , N'en-US', null, N'process_status',   4, N'Terminated';
exec dbo.spTERMINOLOGY_InsertOnly N'Cancelled'                                     , N'en-US', null, N'process_status',   5, N'Cancelled';
exec dbo.spTERMINOLOGY_InsertOnly N'Error'                                         , N'en-US', null, N'process_status',   6, N'Error';
exec dbo.spTERMINOLOGY_InsertOnly N'Approved'                                      , N'en-US', null, N'process_status',   7, N'Approved';
exec dbo.spTERMINOLOGY_InsertOnly N'Rejected'                                      , N'en-US', null, N'process_status',   8, N'Rejected';
exec dbo.spTERMINOLOGY_InsertOnly N'Claimed'                                       , N'en-US', null, N'process_status',   9, N'Claimed';
exec dbo.spTERMINOLOGY_InsertOnly N'Routed'                                        , N'en-US', null, N'process_status',  10, N'Routed';
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

call dbo.spTERMINOLOGY_Processes_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Processes_en_us')
/
-- #endif IBM_DB2 */
