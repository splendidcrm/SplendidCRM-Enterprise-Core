

print 'TERMINOLOGY Asterisk en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'Asterisk';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ASTERISK_TITLE'                            , N'en-US', N'Asterisk', null, null, N'Asterisk PBX';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ASTERISK_SETTINGS'                         , N'en-US', N'Asterisk', null, null, N'Asterisk Settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ASTERISK_SETTINGS_DESC'                    , N'en-US', N'Asterisk', null, null, N'Configure Asterisk settings';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HOST_SERVER'                               , N'en-US', N'Asterisk', null, null, N'Server:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_HOST_PORT'                                 , N'en-US', N'Asterisk', null, null, N'Port:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER_NAME'                                 , N'en-US', N'Asterisk', null, null, N'User Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PASSWORD'                                  , N'en-US', N'Asterisk', null, null, N'Password:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FROM_TRUNK'                                , N'en-US', N'Asterisk', null, null, N'Trunk:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FROM_CONTEXT'                              , N'en-US', N'Asterisk', null, null, N'Context:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TEST_BUTTON_LABEL'                         , N'en-US', N'Asterisk', null, null, N'Test';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CONNECTION_SUCCESSFUL'                     , N'en-US', N'Asterisk', null, null, N'Connection successful';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOG_MISSED_INCOMING_CALLS'                 , N'en-US', N'Asterisk', null, null, N'Log missed incoming calls:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOG_MISSED_OUTGOING_CALLS'                 , N'en-US', N'Asterisk', null, null, N'Log missed outgoing calls:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOG_CALL_DETAILS'                          , N'en-US', N'Asterisk', null, null, N'Log call details:';
-- 09/01/2015 Paul.  Allow Extension to be dialed first. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ORIGINATE_EXTENSION_FIRST'                 , N'en-US', N'Asterisk', null, null, N'Originate Extension First:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEW_INCOMING_CALL_TEMPLATE'                , N'en-US', N'Asterisk', null, null, N'New incoming call from {0} to {1}';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NEW_OUTGOING_CALL_TEMPLATE'                , N'en-US', N'Asterisk', null, null, N'New outgoing call from {0} to {1}';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MISSED_INCOMING_CALL_TEMPLATE'             , N'en-US', N'Asterisk', null, null, N'Missed incoming call from {0} to {1}';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MISSED_OUTGOING_CALL_TEMPLATE'             , N'en-US', N'Asterisk', null, null, N'Unanswered outgoing call from {0} to {1}';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANSWERED_INCOMING_CALL_TEMPLATE'           , N'en-US', N'Asterisk', null, null, N'Incoming call from {0} to {1}';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANSWERED_OUTGOING_CALL_TEMPLATE'           , N'en-US', N'Asterisk', null, null, N'Outgoing call from {0} to {1}';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CALLING'                                   , N'en-US', N'Asterisk', null, null, N'Calling {0}';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ASTERISK_CREATE_CALL'                      , N'en-US', N'Asterisk', null, null, N'Asterisk Create Call';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ASTERISK_OUTGOING_CALL'                    , N'en-US', N'Asterisk', null, null, N'Asterisk Outgoing Call';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ASTERISK_INCOMING_CALL'                    , N'en-US', N'Asterisk', null, null, N'Asterisk Incoming Call';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ASTERISK_OUTGOING_COMPLETE'                , N'en-US', N'Asterisk', null, null, N'Asterisk Outgoing Complete';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ASTERISK_INCOMING_COMPLETE'                , N'en-US', N'Asterisk', null, null, N'Asterisk Incoming Complete';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ASTERISK_OUTGOING_INCOMPLETE'              , N'en-US', N'Asterisk', null, null, N'Asterisk Outgoing Incomplete';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ASTERISK_INCOMING_INCOMPLETE'              , N'en-US', N'Asterisk', null, null, N'Asterisk Incoming Incomplete';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CALL_DATA_RECORDS_DESC'                    , N'en-US', N'Asterisk', null, null, N'Search and manage Call Data Records';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CALL_DATA_RECORDS'                         , N'en-US', N'Asterisk', null, null, N'Call Data Records';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'Asterisk', null, null, N'Call Data Records';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_UNIQUEID'                                  , N'en-US', N'Asterisk', null, null, N'Asterisk ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ACCOUNT_CODE_ID'                           , N'en-US', N'Asterisk', null, null, N'Account Code ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PARENT_NAME'                               , N'en-US', N'Asterisk', null, null, N'Parent:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_START_TIME'                                , N'en-US', N'Asterisk', null, null, N'Start Time:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ANSWER_TIME'                               , N'en-US', N'Asterisk', null, null, N'Answer Time:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_END_TIME'                                  , N'en-US', N'Asterisk', null, null, N'End Time:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DURATION'                                  , N'en-US', N'Asterisk', null, null, N'Duration (seconds):';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BILLABLE_SECONDS'                          , N'en-US', N'Asterisk', null, null, N'Billable Seconds:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SOURCE'                                    , N'en-US', N'Asterisk', null, null, N'Source:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESTINATION'                               , N'en-US', N'Asterisk', null, null, N'Destination:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESTINATION_CONTEXT'                       , N'en-US', N'Asterisk', null, null, N'Destination Context:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_CALLERID'                                  , N'en-US', N'Asterisk', null, null, N'Caller ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SOURCE_CHANNEL'                            , N'en-US', N'Asterisk', null, null, N'Source Channel:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESTINATION_CHANNEL'                       , N'en-US', N'Asterisk', null, null, N'Destination Channel:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DISPOSITION'                               , N'en-US', N'Asterisk', null, null, N'Desposition:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AMA_FLAGS'                                 , N'en-US', N'Asterisk', null, null, N'AMA Flags:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_APPLICATION'                          , N'en-US', N'Asterisk', null, null, N'Last Application:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_DATA'                                 , N'en-US', N'Asterisk', null, null, N'Last Data:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER_FIELD'                                , N'en-US', N'Asterisk', null, null, N'User Field:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_UNIQUEID'                             , N'en-US', N'Asterisk', null, null, N'Asterisk ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ACCOUNT_CODE_ID'                      , N'en-US', N'Asterisk', null, null, N'Account Code ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PARENT_NAME'                          , N'en-US', N'Asterisk', null, null, N'Parent';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_START_TIME'                           , N'en-US', N'Asterisk', null, null, N'Start Time';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_ANSWER_TIME'                          , N'en-US', N'Asterisk', null, null, N'Answer Time';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_END_TIME'                             , N'en-US', N'Asterisk', null, null, N'End Time';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DURATION'                             , N'en-US', N'Asterisk', null, null, N'Duration';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BILLABLE_SECONDS'                     , N'en-US', N'Asterisk', null, null, N'Billable';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SOURCE'                               , N'en-US', N'Asterisk', null, null, N'Source';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESTINATION'                          , N'en-US', N'Asterisk', null, null, N'Destination';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESTINATION_CONTEXT'                  , N'en-US', N'Asterisk', null, null, N'Dst Context';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_CALLERID'                             , N'en-US', N'Asterisk', null, null, N'Caller ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SOURCE_CHANNEL'                       , N'en-US', N'Asterisk', null, null, N'Src Channel';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESTINATION_CHANNEL'                  , N'en-US', N'Asterisk', null, null, N'Dst Channel';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DISPOSITION'                          , N'en-US', N'Asterisk', null, null, N'Disposition';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_AMA_FLAGS'                            , N'en-US', N'Asterisk', null, null, N'AMA Flags';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LAST_APPLICATION'                     , N'en-US', N'Asterisk', null, null, N'Last App';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LAST_DATA'                            , N'en-US', N'Asterisk', null, null, N'Last Data';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_USER_FIELD'                           , N'en-US', N'Asterisk', null, null, N'User Field';

exec dbo.spTERMINOLOGY_InsertOnly N'ERR_CALL_NOT_FOUND'                            , N'en-US', N'Asterisk', null, null, N'Call not found.';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_FAILED_TO_CONNECT'                         , N'en-US', N'Asterisk', null, null, N'Failed to connect: {0}';
-- 06/04/2015 Paul.  Add module abbreviation. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'Asterisk', null, null, N'Ast';
GO

exec dbo.spTERMINOLOGY_InsertOnly N'Asterisk'                                      , N'en-US', null, N'moduleList', 116, N'Asterisk';
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

call dbo.spTERMINOLOGY_Asterisk_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_Asterisk_en_us')
/
-- #endif IBM_DB2 */
