


print 'TERMINOLOGY BusinessProcesses en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'BusinessProcesses';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'BusinessProcesses', null, null, N'Name:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'BusinessProcesses', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BASE_MODULE'                               , N'en-US', N'BusinessProcesses', null, null, N'Base Module:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BASE_MODULE'                          , N'en-US', N'BusinessProcesses', null, null, N'Base Module';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_AUDIT_TABLE'                               , N'en-US', N'BusinessProcesses', null, null, N'Audit Table:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_AUDIT_TABLE'                          , N'en-US', N'BusinessProcesses', null, null, N'Audit Table';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'BusinessProcesses', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'BusinessProcesses', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TYPE'                                      , N'en-US', N'BusinessProcesses', null, null, N'Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TYPE'                                 , N'en-US', N'BusinessProcesses', null, null, N'Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RECORD_TYPE'                               , N'en-US', N'BusinessProcesses', null, null, N'Record Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_RECORD_TYPE'                          , N'en-US', N'BusinessProcesses', null, null, N'Record Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_JOB_INTERVAL'                              , N'en-US', N'BusinessProcesses', null, null, N'Job Interval:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_JOB_INTERVAL'                         , N'en-US', N'BusinessProcesses', null, null, N'Job Interval';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LAST_RUN'                                  , N'en-US', N'BusinessProcesses', null, null, N'Last Run:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_LAST_RUN'                             , N'en-US', N'BusinessProcesses', null, null, N'Last Run';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'BusinessProcesses', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'BusinessProcesses', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FILTER_SQL'                                , N'en-US', N'BusinessProcesses', null, null, N'SQL Filter:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FREQUENCY_LIMIT'                           , N'en-US', N'BusinessProcesses', null, null, N'Frequency Limit:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN'                                      , N'en-US', N'BusinessProcesses', null, null, N'BPMN:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_XAML'                                      , N'en-US', N'BusinessProcesses', null, null, N'Xaml:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_START_DATE'                                , N'en-US', N'BusinessProcesses', null, null, N'Start Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_START_DATE'                           , N'en-US', N'BusinessProcesses', null, null, N'Start Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_END_DATE'                                  , N'en-US', N'BusinessProcesses', null, null, N'End Date:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_END_DATE'                             , N'en-US', N'BusinessProcesses', null, null, N'End Date';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUSINESS_PROCESS_INSTANCE_ID'              , N'en-US', N'BusinessProcesses', null, null, N'Instance ID:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BUSINESS_PROCESS_INSTANCE_ID'         , N'en-US', N'BusinessProcesses', null, null, N'Instance ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EVENTS_TITLE'                              , N'en-US', N'BusinessProcesses', null, null, N'Events';
-- 03/31/2017 Paul.  Allow export as SQL. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXPORT_BPMN'                               , N'en-US', N'BusinessProcesses', null, null, N'Export BPMN';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_EXPORT_SQL'                                , N'en-US', N'BusinessProcesses', null, null, N'Export SQL';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_GENERAL_TAB'                          , N'en-US', N'BusinessProcesses', null, null, N'General';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_METADATA_TAB'                         , N'en-US', N'BusinessProcesses', null, null, N'Metadata';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_METADATA_GROUP'                       , N'en-US', N'BusinessProcesses', null, null, N'Metadata';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_GENERAL_GROUP'                        , N'en-US', N'BusinessProcesses', null, null, N'General';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_DETAILS_GROUP'                        , N'en-US', N'BusinessProcesses', null, null, N'Details';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_EVENTS_GROUP'                         , N'en-US', N'BusinessProcesses', null, null, N'Events';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MODULES_GROUP'                        , N'en-US', N'BusinessProcesses', null, null, N'Modules';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_DOCUMENTATION_GROUP'                  , N'en-US', N'BusinessProcesses', null, null, N'Documentation';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MESSAGE_TEMPLATE_GROUP'               , N'en-US', N'BusinessProcesses', null, null, N'Message';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MESSAGE_RECIPIENT_GROUP'              , N'en-US', N'BusinessProcesses', null, null, N'Recipients';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MESSAGE_REPORT_GROUP'                 , N'en-US', N'BusinessProcesses', null, null, N'Reports';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_VARIABLES_GROUP'                      , N'en-US', N'BusinessProcesses', null, null, N'Variables';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_FIELDS_TAB'                           , N'en-US', N'BusinessProcesses', null, null, N'Fields';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_FIELDS_GROUP'                         , N'en-US', N'BusinessProcesses', null, null, N'Read-Only &amp; Required Fields';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MODULE_ADD_READ_ONLY_FIELD'           , N'en-US', N'BusinessProcesses', null, null, N'Add Read-Only Field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MODULE_ADD_REQUIRED_FIELD'            , N'en-US', N'BusinessProcesses', null, null, N'Add Required Field';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ADD_VARIABLE'                         , N'en-US', N'BusinessProcesses', null, null, N'Add Variable';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_VARIABLE'                             , N'en-US', N'BusinessProcesses', null, null, N'Variable';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_VARIABLE_TYPE'                        , N'en-US', N'BusinessProcesses', null, null, N'Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_VARIABLE_DEFAULT'                     , N'en-US', N'BusinessProcesses', null, null, N'Default';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_DOCUMENTATION'                        , N'en-US', N'BusinessProcesses', null, null, N'Documentation';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_NAME'                                 , N'en-US', N'BusinessProcesses', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PROCESS_STATUS'                       , N'en-US', N'BusinessProcesses', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PROCESS_USER'                         , N'en-US', N'BusinessProcesses', null, null, N'Process User';
--exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PROCESS_STATUS_DESCRIPTION'           , N'en-US', N'BusinessProcesses', null, null, N'A process can be active or inactive.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_BASE_MODULE'                          , N'en-US', N'BusinessProcesses', null, null, N'Base Module';
--exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_BASE_MODULE_DESCRIPTION'              , N'en-US', N'BusinessProcesses', null, null, N'The module that this event is based on.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MODULE_FILTER'                        , N'en-US', N'BusinessProcesses', null, null, N'Module Filter';
--exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MODULE_FILTER_DESCRIPTION'            , N'en-US', N'BusinessProcesses', null, null, N'The filter applied to the module to determine if process should run.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_FREQUENCY_LIMIT_UNITS'                , N'en-US', N'BusinessProcesses', null, null, N'Frequency Limit Units';
--exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_FREQUENCY_LIMIT_UNITS_DESCRIPTION'    , N'en-US', N'BusinessProcesses', null, null, N'The time until the next event is allowed.  Use 100 years to execute only once for the record.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_FREQUENCY_LIMIT_VALUE'                , N'en-US', N'BusinessProcesses', null, null, N'Frequency Limit Value';
--exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_FREQUENCY_LIMIT_VALUE_DESCRIPTION'    , N'en-US', N'BusinessProcesses', null, null, N'The time until the next event is allowed.  Use 100 years to execute only once for the record.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_JOB_INTERVAL'                         , N'en-US', N'BusinessProcesses', null, null, N'Job Interval';
--exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_JOB_INTERVAL_DESCRIPTION'             , N'en-US', N'BusinessProcesses', null, null, N'This is a CRON formatted string that represents the repeat interval.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_RECORD_TYPE'                          , N'en-US', N'BusinessProcesses', null, null, N'Record Type';
--exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_RECORD_TYPE_DESCRIPTION'              , N'en-US', N'BusinessProcesses', null, null, N'The type of the event.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MESSAGE_TEMPLATE'                     , N'en-US', N'BusinessProcesses', null, null, N'Message Template';
--exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MESSAGE_TEMPLATE_DESCRIPTION'         , N'en-US', N'BusinessProcesses', null, null, N'The HTML template used as a template for the message.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_RECIPIENT'                            , N'en-US', N'BusinessProcesses', null, null, N'Recipient';
--exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_RECIPIENT_DESCRIPTION'                , N'en-US', N'BusinessProcesses', null, null, N'A recipient can be a user, role, team or record field, such Assigned User ID, or the record ID.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MESSAGE_REPORT'                       , N'en-US', N'BusinessProcesses', null, null, N'Report';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_RENDER_FORMAT'                        , N'en-US', N'BusinessProcesses', null, null, N'Render Format';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_RECIPIENT_USERS'                      , N'en-US', N'BusinessProcesses', null, null, N'Users';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_RECIPIENT_TEAMS'                      , N'en-US', N'BusinessProcesses', null, null, N'Teams';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_RECIPIENT_ROLES'                      , N'en-US', N'BusinessProcesses', null, null, N'Roles';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PARAMETER_NAME'                       , N'en-US', N'BusinessProcesses', null, null, N'Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PARAMETER_VALUE'                      , N'en-US', N'BusinessProcesses', null, null, N'Value';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_BPMN_PARAMETER_NAME_SPACES'                , N'en-US', N'BusinessProcesses', null, null, N'Name must not contain spaces';
exec dbo.spTERMINOLOGY_InsertOnly N'ERR_BPMN_PARAMETER_NAME_REQUIRED'              , N'en-US', N'BusinessProcesses', null, null, N'Parameter must have a name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_REPORT_PROPERTIES'                    , N'en-US', N'BusinessProcesses', null, null, N'Properties';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ALERT_TYPE'                           , N'en-US', N'BusinessProcesses', null, null, N'Message Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MESSAGE_ASSIGNED_TO'                  , N'en-US', N'BusinessProcesses', null, null, N'Assigned To';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MESSAGE_TEAM'                         , N'en-US', N'BusinessProcesses', null, null, N'Team';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_SOURCE_TYPE'                          , N'en-US', N'BusinessProcesses', null, null, N'Source Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ALERT_SUBJECT'                        , N'en-US', N'BusinessProcesses', null, null, N'Message Subject';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ALERT_TEXT'                           , N'en-US', N'BusinessProcesses', null, null, N'Message Template';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_SEND_TYPE'                            , N'en-US', N'BusinessProcesses', null, null, N'Send Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_RECIPIENT_TYPE'                       , N'en-US', N'BusinessProcesses', null, null, N'Recipient Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_RECIPIENT_FIELD'                      , N'en-US', N'BusinessProcesses', null, null, N'Recipient Field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_DURATION'                             , N'en-US', N'BusinessProcesses', null, null, N'Duration';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_OPERATION'                            , N'en-US', N'BusinessProcesses', null, null, N'Operation';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MODULE_NAME'                          , N'en-US', N'BusinessProcesses', null, null, N'Module';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_FIELD_PREFIX'                         , N'en-US', N'BusinessProcesses', null, null, N'Field Prefix';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_SOURCE_ID'                            , N'en-US', N'BusinessProcesses', null, null, N'Source ID';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MODULE_FIELD'                         , N'en-US', N'BusinessProcesses', null, null, N'Field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MODULE_EXPRESSION'                    , N'en-US', N'BusinessProcesses', null, null, N'Expression';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MODULE_ADD_FIELD'                     , N'en-US', N'BusinessProcesses', null, null, N'Add Field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LOAD_MODULE_FIELDS'                        , N'en-US', N'BusinessProcesses', null, null, N'(Leave fields empty to load all)';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SAVE_MODULE_FIELDS'                        , N'en-US', N'BusinessProcesses', null, null, N'(You must specify at least one field to save)';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_APPROVAL_VARIABLE_NAME'               , N'en-US', N'BusinessProcesses', null, null, N'Approval Variable Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ESCALATION_TYPE'                      , N'en-US', N'BusinessProcesses', null, null, N'Escalation Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_USER_TASK_TYPE'                       , N'en-US', N'BusinessProcesses', null, null, N'User Task Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_CHANGE_ASSIGNED_USER'                 , N'en-US', N'BusinessProcesses', null, null, N'Allow Change Assigned User';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_CHANGE_ASSIGNED_TEAM'                 , N'en-US', N'BusinessProcesses', null, null, N'Change Assigned User from Team';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_CHANGE_PROCESS_USER'                  , N'en-US', N'BusinessProcesses', null, null, N'Allow Change Process User';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_CHANGE_PROCESS_TEAM'                  , N'en-US', N'BusinessProcesses', null, null, N'Change Process User from Team';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_USER_ASSIGNMENT_METHOD'               , N'en-US', N'BusinessProcesses', null, null, N'User Assignment Method';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_STATIC_ASSIGNED_USER'                 , N'en-US', N'BusinessProcesses', null, null, N'Static Assigned User';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_STATIC_ASSIGNED_TEAM'                 , N'en-US', N'BusinessProcesses', null, null, N'Static Assigned Team';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_DYNAMIC_PROCESS_TEAM'                 , N'en-US', N'BusinessProcesses', null, null, N'Dynamic Process Team';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_DYNAMIC_PROCESS_ROLE'                 , N'en-US', N'BusinessProcesses', null, null, N'Dynamic Process Role';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_DURATION_VALUE'                       , N'en-US', N'BusinessProcesses', null, null, N'Duration Value';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_DURATION_UNITS'                       , N'en-US', N'BusinessProcesses', null, null, N'Duration Units';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_EXPRESSION'                           , N'en-US', N'BusinessProcesses', null, null, N'Expression';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_INPUT_PARAMETERS'                     , N'en-US', N'BusinessProcesses', null, null, N'Input Parameters';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_OUTPUT_PARAMETERS'                    , N'en-US', N'BusinessProcesses', null, null, N'Output Parameters';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PALETTE_START_EVENT'                  , N'en-US', N'BusinessProcesses', null, null, N'Create Start Event';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PALETTE_TIMER_START_EVENT'            , N'en-US', N'BusinessProcesses', null, null, N'Create Timer Start Event' 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PALETTE_INTERMEDIATE_THROW_EVENT'     , N'en-US', N'BusinessProcesses', null, null, N'Create IntermediateThrowEvent/BoundaryEvent'
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PALETTE_MESSAGE_EVENT'                , N'en-US', N'BusinessProcesses', null, null, N'Create Message Intermediate Throw Event'
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PALETTE_ESCALATION_EVENT'             , N'en-US', N'BusinessProcesses', null, null, N'Create Escalation Intermediate Throw Event'
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PALETTE_TIMER_EVENT'                  , N'en-US', N'BusinessProcesses', null, null, N'Create Timer Intermediate Catch Event'
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PALETTE_EXCLUSIVE_GATEWAY'            , N'en-US', N'BusinessProcesses', null, null, N'Create Exclusive Gateway';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PALETTE_EVENT_BASED_GATEWAY'          , N'en-US', N'BusinessProcesses', null, null, N'Create Event-Based Gateway';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PALETTE_TASK'                         , N'en-US', N'BusinessProcesses', null, null, N'Create Task';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PALETTE_USER_TASK'                    , N'en-US', N'BusinessProcesses', null, null, N'Create User Task';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PALETTE_BUSINESS_RULE_TASK'           , N'en-US', N'BusinessProcesses', null, null, N'Create Business Rule Task';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PALETTE_END_EVENT'                    , N'en-US', N'BusinessProcesses', null, null, N'Create End Event';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PALETTE_MESSAGE_END_EVENT'            , N'en-US', N'BusinessProcesses', null, null, N'Create Message End Event';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_BUSINESS_RULE_OPERATION'              , N'en-US', N'BusinessProcesses', null, null, N'Operation';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ACTIVITY_NAME'                        , N'en-US', N'BusinessProcesses', null, null, N'C# Activity Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PROCEDURE_NAME'                       , N'en-US', N'BusinessProcesses', null, null, N'SQL Procedure Name';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PARAMETERS'                           , N'en-US', N'BusinessProcesses', null, null, N'Parameters';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_SWITCH_FIELD'                         , N'en-US', N'BusinessProcesses', null, null, N'Switch Field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_SWITCH_KEY'                           , N'en-US', N'BusinessProcesses', null, null, N'Key';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_SWITCH_VALUE'                         , N'en-US', N'BusinessProcesses', null, null, N'Value';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_SWITCH_DEFAULT'                       , N'en-US', N'BusinessProcesses', null, null, N'Default';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_COPY'                                 , N'en-US', N'BusinessProcesses', null, null, N'Copy [Ctrl+C]';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_PASTE'                                , N'en-US', N'BusinessProcesses', null, null, N'Paste [Ctrl+V]';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_UNDO'                                 , N'en-US', N'BusinessProcesses', null, null, N'Undo [Ctrl+Z]';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_REDO'                                 , N'en-US', N'BusinessProcesses', null, null, N'Redo [Ctrol+Y]';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ALIGN_BOTTOM'                         , N'en-US', N'BusinessProcesses', null, null, N'Align Bottom';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ALIGN_LEFT'                           , N'en-US', N'BusinessProcesses', null, null, N'Align Left';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ALIGN_HORIZONTAL_CENTER'              , N'en-US', N'BusinessProcesses', null, null, N'Align Center Horz.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ALIGN_RIGHT'                          , N'en-US', N'BusinessProcesses', null, null, N'Align Right';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ALIGN_TOP'                            , N'en-US', N'BusinessProcesses', null, null, N'Align Top';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ALIGN_VERTICAL_CENTER'                , N'en-US', N'BusinessProcesses', null, null, N'Align Center Vert.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_DISTRIBUTE_HORIZONTALLY'              , N'en-US', N'BusinessProcesses', null, null, N'Distribute Horz.';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_DISTRIBUTE_VERTICALLY'                , N'en-US', N'BusinessProcesses', null, null, N'Distribute Vert.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_MODULE_FIELD'                         , N'en-US', N'BusinessProcesses', null, null, N'Module Field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ASSIGN_FIELD'                         , N'en-US', N'BusinessProcesses', null, null, N'Assign Field';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BPMN_ASSIGN_TYPE'                          , N'en-US', N'BusinessProcesses', null, null, N'Assign Type';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'BusinessProcesses', null, null, N'BP';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'BusinessProcesses', null, null, N'Business Processes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'BusinessProcesses', null, null, N'Business Processes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_FORM_TITLE'                         , N'en-US', N'BusinessProcesses', null, null, N'Search';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_BUSINESS_PROCESS'                      , N'en-US', N'BusinessProcesses', null, null, N'Create Business Process';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_BUSINESS_PROCESSES_LIST'                   , N'en-US', N'BusinessProcesses', null, null, N'Business Processes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_BUTTON_LABEL'                       , N'en-US', N'BusinessProcesses', null, null, N'Import';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_IMPORT_BUTTON_TITLE'                       , N'en-US', N'BusinessProcesses', null, null, N'Import';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_TERMINATE'                                 , N'en-US', N'BusinessProcesses', null, null, N'Terminate';
-- 11/10/2016 Paul.  User termination messages. 
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TERMINATE_INVALID_IDENTIFIER'              , N'en-US', N'BusinessProcesses', null, null, N'Identifier not provided';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_USER_TERMINATE_MESSAGE'                    , N'en-US', N'BusinessProcesses', null, null, N'The process has been terminated.  You will not receive any more messages related to the process.';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_BUSINESS_PROCESSES'                 , N'en-US', N'Administration', null, null, N'Manage Business Processes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MANAGE_BUSINESS_PROCESSES_TITLE'           , N'en-US', N'Administration', null, null, N'Business Processes';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUSINESS_PROCESS_LOG'                      , N'en-US', N'Administration', null, null, N'Business Process Log';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUSINESS_PROCESS_LOG_TITLE'                , N'en-US', N'Administration', null, null, N'Business Process Log';

-- select * from TERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc;
exec dbo.spTERMINOLOGY_InsertOnly N'BusinessProcesses'                             , N'en-US', null, N'moduleList'                        , 163, N'Business Processes';

-- delete from TERMINOLOGY where LIST_NAME = 'workflow_filter_operator_dom';
exec dbo.spTERMINOLOGY_InsertOnly N'='                                             , N'en-US', null, N'workflow_filter_operator_dom',   1, N'is';
exec dbo.spTERMINOLOGY_InsertOnly N'<>'                                            , N'en-US', null, N'workflow_filter_operator_dom',   2, N'is not';
exec dbo.spTERMINOLOGY_InsertOnly N'like'                                          , N'en-US', null, N'workflow_filter_operator_dom',   3, N'is like';
exec dbo.spTERMINOLOGY_InsertOnly N'not like'                                      , N'en-US', null, N'workflow_filter_operator_dom',   4, N'is not like';
exec dbo.spTERMINOLOGY_InsertOnly N'in'                                            , N'en-US', null, N'workflow_filter_operator_dom',   5, N'is any of';
exec dbo.spTERMINOLOGY_InsertOnly N'not in'                                        , N'en-US', null, N'workflow_filter_operator_dom',   6, N'is none of';
exec dbo.spTERMINOLOGY_InsertOnly N'>'                                             , N'en-US', null, N'workflow_filter_operator_dom',   7, N'is more than';
exec dbo.spTERMINOLOGY_InsertOnly N'>='                                            , N'en-US', null, N'workflow_filter_operator_dom',   8, N'is more than or equal to';
exec dbo.spTERMINOLOGY_InsertOnly N'<'                                             , N'en-US', null, N'workflow_filter_operator_dom',   9, N'is less than';
exec dbo.spTERMINOLOGY_InsertOnly N'<='                                            , N'en-US', null, N'workflow_filter_operator_dom',  10, N'is less than or equal to';
exec dbo.spTERMINOLOGY_InsertOnly N'is null'                                       , N'en-US', null, N'workflow_filter_operator_dom',  11, N'is null';
exec dbo.spTERMINOLOGY_InsertOnly N'is not null'                                   , N'en-US', null, N'workflow_filter_operator_dom',  12, N'is not null';
exec dbo.spTERMINOLOGY_InsertOnly N'between'                                       , N'en-US', null, N'workflow_filter_operator_dom',  13, N'is between';
exec dbo.spTERMINOLOGY_InsertOnly N'changed'                                       , N'en-US', null, N'workflow_filter_operator_dom',  14, N'changed';

-- delete from TERMINOLOGY where LIST_NAME = 'bpmn_task_operation';
exec dbo.spTERMINOLOGY_InsertOnly N'load_module'                                   , N'en-US', null, N'bpmn_task_operation'         ,   1, N'Load Module';
exec dbo.spTERMINOLOGY_InsertOnly N'save_module'                                   , N'en-US', null, N'bpmn_task_operation'         ,   2, N'Save Module';
exec dbo.spTERMINOLOGY_InsertOnly N'assign_module'                                 , N'en-US', null, N'bpmn_task_operation'         ,   3, N'Assign Module';

-- delete from TERMINOLOGY where LIST_NAME = 'bpmn_business_rule_operation';
exec dbo.spTERMINOLOGY_InsertOnly N'assign_activity'                               , N'en-US', null, N'bpmn_business_rule_operation',   1, N'Assign Activity';
exec dbo.spTERMINOLOGY_InsertOnly N'switch_activity'                               , N'en-US', null, N'bpmn_business_rule_operation',   2, N'Switch Activity';
exec dbo.spTERMINOLOGY_InsertOnly N'call_sql_procedure'                            , N'en-US', null, N'bpmn_business_rule_operation',   3, N'Call SQL Procedure';
exec dbo.spTERMINOLOGY_InsertOnly N'call_c#_activity'                              , N'en-US', null, N'bpmn_business_rule_operation',   4, N'Call C# Activity';

-- USER_ASSIGNMENT_METHOD: Current Process User, Record Owner, Supervisor, Static User, Round Robin Team, Round Robin Role, Self-Service Team, Self-Service Role
exec dbo.spTERMINOLOGY_InsertOnly N'Current Process User'                          , N'en-US', null, N'bpmn_user_assignment_method' ,   1, N'Current Process User';
exec dbo.spTERMINOLOGY_InsertOnly N'Record Owner'                                  , N'en-US', null, N'bpmn_user_assignment_method' ,   2, N'Record Owner';
exec dbo.spTERMINOLOGY_InsertOnly N'Supervisor'                                    , N'en-US', null, N'bpmn_user_assignment_method' ,   3, N'Supervisor';
exec dbo.spTERMINOLOGY_InsertOnly N'Static User'                                   , N'en-US', null, N'bpmn_user_assignment_method' ,   4, N'Static User';
exec dbo.spTERMINOLOGY_InsertOnly N'Round Robin Team'                              , N'en-US', null, N'bpmn_user_assignment_method' ,   5, N'Round Robin Team';
exec dbo.spTERMINOLOGY_InsertOnly N'Round Robin Role'                              , N'en-US', null, N'bpmn_user_assignment_method' ,   6, N'Round Robin Role';
exec dbo.spTERMINOLOGY_InsertOnly N'Self-Service Team'                             , N'en-US', null, N'bpmn_user_assignment_method' ,   7, N'Self-Service Team';
exec dbo.spTERMINOLOGY_InsertOnly N'Self-Service Role'                             , N'en-US', null, N'bpmn_user_assignment_method' ,   8, N'Self-Service Role';

-- delete from TERMINOLOGY where LIST_NAME = 'bpmn_record_assignment_method';
exec dbo.spTERMINOLOGY_InsertOnly N'Round Robin Team'                              , N'en-US', null, N'bpmn_record_assignment_method',   1, N'Round Robin Team';
exec dbo.spTERMINOLOGY_InsertOnly N'Round Robin Role'                              , N'en-US', null, N'bpmn_record_assignment_method',   2, N'Round Robin Role';
exec dbo.spTERMINOLOGY_InsertOnly N'Static User'                                   , N'en-US', null, N'bpmn_record_assignment_method',   3, N'Static User';
exec dbo.spTERMINOLOGY_InsertOnly N'Static Team'                                   , N'en-US', null, N'bpmn_record_assignment_method',   4, N'Static Team';
exec dbo.spTERMINOLOGY_InsertOnly N'Supervisor'                                    , N'en-US', null, N'bpmn_record_assignment_method',   5, N'Supervisor';

-- ESCALATION_TYPE: Approve/Reject, Route
exec dbo.spTERMINOLOGY_InsertOnly N'Approve/Reject'                                , N'en-US', null, N'bpmn_escalation_type'        ,   1, N'Approve/Reject';
exec dbo.spTERMINOLOGY_InsertOnly N'Route'                                         , N'en-US', null, N'bpmn_escalation_type'        ,   2, N'Route';

exec dbo.spTERMINOLOGY_InsertOnly N'Approve/Reject'                                , N'en-US', null, N'bpmn_user_task_type'         ,   1, N'Approve/Reject';
exec dbo.spTERMINOLOGY_InsertOnly N'Route'                                         , N'en-US', null, N'bpmn_user_task_type'         ,   2, N'Route';

-- delete from TERMINOLOGY where LIST_NAME = 'bpmn_variable_type';
exec dbo.spTERMINOLOGY_InsertOnly N'string'                                        , N'en-US', null, N'bpmn_variable_type'          ,   1, N'String';
exec dbo.spTERMINOLOGY_InsertOnly N'Int32'                                         , N'en-US', null, N'bpmn_variable_type'          ,   2, N'Integer';
exec dbo.spTERMINOLOGY_InsertOnly N'bool'                                          , N'en-US', null, N'bpmn_variable_type'          ,   3, N'Boolean';
exec dbo.spTERMINOLOGY_InsertOnly N'DateTime'                                      , N'en-US', null, N'bpmn_variable_type'          ,   4, N'Date';
exec dbo.spTERMINOLOGY_InsertOnly N'Guid'                                          , N'en-US', null, N'bpmn_variable_type'          ,   5, N'Guid';
exec dbo.spTERMINOLOGY_InsertOnly N'decimal'                                       , N'en-US', null, N'bpmn_variable_type'          ,   6, N'Decimal';
exec dbo.spTERMINOLOGY_InsertOnly N'Int64'                                         , N'en-US', null, N'bpmn_variable_type'          ,   7, N'Long';
exec dbo.spTERMINOLOGY_InsertOnly N'float'                                         , N'en-US', null, N'bpmn_variable_type'          ,   8, N'Float';

-- 07/31/2016 Paul.  Use empty in list so that can be removed. 
exec dbo.spTERMINOLOGY_InsertOnly N''                                              , N'en-US', null, N'bpmn_duration_units'         ,   0, N'';
exec dbo.spTERMINOLOGY_InsertOnly N'hour'                                          , N'en-US', null, N'bpmn_duration_units'         ,   1, N'hour';
exec dbo.spTERMINOLOGY_InsertOnly N'day'                                           , N'en-US', null, N'bpmn_duration_units'         ,   2, N'day';
exec dbo.spTERMINOLOGY_InsertOnly N'week'                                          , N'en-US', null, N'bpmn_duration_units'         ,   3, N'week';
exec dbo.spTERMINOLOGY_InsertOnly N'month'                                         , N'en-US', null, N'bpmn_duration_units'         ,   4, N'month';
exec dbo.spTERMINOLOGY_InsertOnly N'quarter'                                       , N'en-US', null, N'bpmn_duration_units'         ,   5, N'quarter';
exec dbo.spTERMINOLOGY_InsertOnly N'year'                                          , N'en-US', null, N'bpmn_duration_units'         ,   6, N'year';

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

call dbo.spTERMINOLOGY_BusinessProcesses_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_BusinessProcesses_en_us')
/
-- #endif IBM_DB2 */
