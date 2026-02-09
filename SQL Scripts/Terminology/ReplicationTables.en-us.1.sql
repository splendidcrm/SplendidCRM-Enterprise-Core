

print 'TERMINOLOGY ReplicationTables en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'ReplicationTables';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REPLICATION_TABLES_TITLE'                  , N'en-US', N'Administration'   , null, null, N'Replication Tables';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REPLICATION_TABLES'                        , N'en-US', N'Administration'   , null, null, N'Manage and run Replication Tables';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATABASE_REPLICATION_TITLE'                , N'en-US', N'Administration'   , null, null, N'Database Replication';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATABASE_REPLICATION'                      , N'en-US', N'Administration'   , null, null, N'Manage and run Replication Tables';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'ReplicationTables', null, null, N'Replication Tables';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'ReplicationTables', null, null, N'Rpl';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_REPLICATION_TABLES_LIST'                   , N'en-US', N'ReplicationTables', null, null, N'Replication Tables List';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_NOT_CONFIGURED'                            , N'en-US', N'ReplicationTables', null, null, N'Replication Not Configured';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TABLE_NAME'                                , N'en-US', N'ReplicationTables', null, null, N'Table Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOCAL_COUNT'                               , N'en-US', N'ReplicationTables', null, null, N'Local Count:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOCAL_LAST_MODIFIED'                       , N'en-US', N'ReplicationTables', null, null, N'Local Last Modified:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REMOTE_COUNT'                              , N'en-US', N'ReplicationTables', null, null, N'Remote Count:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REMOTE_LAST_MODIFIED'                      , N'en-US', N'ReplicationTables', null, null, N'Remote Last Modified:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'ReplicationTables', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PENDING_COUNT'                             , N'en-US', N'ReplicationTables', null, null, N'Pending Count:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_ERROR'                                , N'en-US', N'ReplicationTables', null, null, N'Last Error:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IS_PENDING'                                , N'en-US', N'ReplicationTables', null, null, N'Is Pending:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TABLE_NAME'                           , N'en-US', N'ReplicationTables', null, null, N'Table Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LOCAL_COUNT'                          , N'en-US', N'ReplicationTables', null, null, N'Local Count';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LOCAL_LAST_MODIFIED'                  , N'en-US', N'ReplicationTables', null, null, N'Local Last Modified';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_REMOTE_COUNT'                         , N'en-US', N'ReplicationTables', null, null, N'Remote Count';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_REMOTE_LAST_MODIFIED'                 , N'en-US', N'ReplicationTables', null, null, N'Remote Last Modified';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'ReplicationTables', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PENDING_COUNT'                        , N'en-US', N'ReplicationTables', null, null, N'Pending Count';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LAST_ERROR'                           , N'en-US', N'ReplicationTables', null, null, N'Last Error';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_IS_PENDING'                           , N'en-US', N'ReplicationTables', null, null, N'Is Pending';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RUN_SYNC'                                  , N'en-US', N'ReplicationTables', null, null, N'Run Sync';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_UPDATE_STATS'                              , N'en-US', N'ReplicationTables', null, null, N'Update Stats';

exec dbo.spTERMINOLOGY_InsertOnly N'ReplicationTables'                             , N'en-US', null, N'moduleList', 180, N'Replication Tables';

exec dbo.spTERMINOLOGY_InsertOnly N'Processing'                                    , N'en-US', null, N'replication_status_dom', 1, N'Processing';
exec dbo.spTERMINOLOGY_InsertOnly N'Complete'                                      , N'en-US', null, N'replication_status_dom', 2, N'Complete';
exec dbo.spTERMINOLOGY_InsertOnly N'Failed'                                        , N'en-US', null, N'replication_status_dom', 3, N'Failed';
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

call dbo.spTERMINOLOGY_ReplicationTables_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_ReplicationTables_en_us')
/
-- #endif IBM_DB2 */
