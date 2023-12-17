


print 'TERMINOLOGY DataPrivacy en-us';
GO

set nocount on;
GO

-- delete from TERMINOLOGY where MODULE_NAME = 'DataPrivacy';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_NAME'                                      , N'en-US', N'DataPrivacy', null, null, N'Subject:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATA_PRIVACY_NUMBER'                       , N'en-US', N'DataPrivacy', null, null, N'Number:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_TYPE'                                      , N'en-US', N'DataPrivacy', null, null, N'Type:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_STATUS'                                    , N'en-US', N'DataPrivacy', null, null, N'Status:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_PRIORITY'                                  , N'en-US', N'DataPrivacy', null, null, N'Priority:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATE_OPENED'                               , N'en-US', N'DataPrivacy', null, null, N'Date Opened:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATE_DUE'                                  , N'en-US', N'DataPrivacy', null, null, N'Date Due:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATE_CLOSED'                               , N'en-US', N'DataPrivacy', null, null, N'Date Closed:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SOURCE'                                    , N'en-US', N'DataPrivacy', null, null, N'Source:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REQUESTED_BY'                              , N'en-US', N'DataPrivacy', null, null, N'Requested By:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_BUSINESS_PURPOSE'                          , N'en-US', N'DataPrivacy', null, null, N'Business Purpose:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DESCRIPTION'                               , N'en-US', N'DataPrivacy', null, null, N'Description:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_RESOLUTION'                                , N'en-US', N'DataPrivacy', null, null, N'Resolution:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_WORK_LOG'                                  , N'en-US', N'DataPrivacy', null, null, N'Work Log:';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_FIELDS_TO_ERASE'                           , N'en-US', N'DataPrivacy', null, null, N'Fields to Erase:';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_NAME'                                 , N'en-US', N'DataPrivacy', null, null, N'Subject';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DATA_PRIVACY_NUMBER'                  , N'en-US', N'DataPrivacy', null, null, N'Number';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_TYPE'                                 , N'en-US', N'DataPrivacy', null, null, N'Type';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_STATUS'                               , N'en-US', N'DataPrivacy', null, null, N'Status';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_PRIORITY'                             , N'en-US', N'DataPrivacy', null, null, N'Priority';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DATE_OPENED'                          , N'en-US', N'DataPrivacy', null, null, N'Date Opened';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DATE_DUE'                             , N'en-US', N'DataPrivacy', null, null, N'Date Due';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DATE_CLOSED'                          , N'en-US', N'DataPrivacy', null, null, N'Date Closed';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_SOURCE'                               , N'en-US', N'DataPrivacy', null, null, N'Source';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_REQUESTED_BY'                         , N'en-US', N'DataPrivacy', null, null, N'Requested By';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_BUSINESS_PURPOSE'                     , N'en-US', N'DataPrivacy', null, null, N'Purpose';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_DESCRIPTION'                          , N'en-US', N'DataPrivacy', null, null, N'Description';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_RESOLUTION'                           , N'en-US', N'DataPrivacy', null, null, N'Resolution';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_WORK_LOG'                             , N'en-US', N'DataPrivacy', null, null, N'Work Log';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FIELDS_TO_ERASE'                      , N'en-US', N'DataPrivacy', null, null, N'Fields to Erase';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_ABBREVIATION'                       , N'en-US', N'DataPrivacy', null, null, N'DP';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_MODULE_NAME'                               , N'en-US', N'DataPrivacy', null, null, N'Data Privacy';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_LIST_FORM_TITLE'                           , N'en-US', N'DataPrivacy', null, null, N'Data Privacy';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_SEARCH_FORM_TITLE'                         , N'en-US', N'DataPrivacy', null, null, N'Search';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_NEW_DATA_PRIVACY'                          , N'en-US', N'DataPrivacy', null, null, N'Create Privacy Request';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_DATA_PRIVACY_LIST'                         , N'en-US', N'DataPrivacy', null, null, N'Data Privacy';

exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATA_PRIVACY_DESC'                         , N'en-US', N'DataPrivacy', null, null, N'Manage Data Privacy';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATA_PRIVACY_TITLE'                        , N'en-US', N'DataPrivacy', null, null, N'Data Privacy';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ENABLE_DATA_PRIVACY'                       , N'en-US', N'DataPrivacy', null, null, N'Enable';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DISABLE_DATA_PRIVACY'                      , N'en-US', N'DataPrivacy', null, null, N'Disable';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATA_PRIVACY_ENABLED'                      , N'en-US', N'DataPrivacy', null, null, N'Data Privacy is Enabled';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_DATA_PRIVACY_DISABLED'                     , N'en-US', N'DataPrivacy', null, null, N'Data Privacy is Disabled';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_REJECT_BUTTON'                             , N'en-US', N'DataPrivacy', null, null, N'Reject';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_COMPLETE_BUTTON'                           , N'en-US', N'DataPrivacy', null, null, N'Complete';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ERASE_BUTTON'                              , N'en-US', N'DataPrivacy', null, null, N'Erase & Complete';
exec dbo.spTERMINOLOGY_InsertOnly N'LBL_ERASED_VALUE'                              , N'en-US', N'DataPrivacy', null, null, N'Erased Value';
exec dbo.spTERMINOLOGY_InsertOnly N'LNK_MARK_TO_ERASE'                             , N'en-US', N'DataPrivacy', null, null, N'Mark to Erase';

-- select * from TERMINOLOGY where LIST_NAME = 'moduleList' order by LIST_ORDER desc;
exec dbo.spTERMINOLOGY_InsertOnly N'DataPrivacy'                                   , N'en-US', null, N'moduleList'              , 174, N'Data Privacy';

-- delete from TERMINOLOGY where LIST_NAME = 'dataprivacy_type_dom';
exec dbo.spTERMINOLOGY_InsertOnly N'Request for Policy'                            , N'en-US', null, N'dataprivacy_type_dom'    ,   0, N'Request for Data Privacy Policy';
exec dbo.spTERMINOLOGY_InsertOnly N'Send Personal'                                 , N'en-US', null, N'dataprivacy_type_dom'    ,   1, N'Send Personal Information';
exec dbo.spTERMINOLOGY_InsertOnly N'Request to Erase'                              , N'en-US', null, N'dataprivacy_type_dom'    ,   2, N'Request to Erase Information';
exec dbo.spTERMINOLOGY_InsertOnly N'Request to Correct'                            , N'en-US', null, N'dataprivacy_type_dom'    ,   3, N'Request to Correct Information';
exec dbo.spTERMINOLOGY_InsertOnly N'Export Information'                            , N'en-US', null, N'dataprivacy_type_dom'    ,   4, N'Export Information';
exec dbo.spTERMINOLOGY_InsertOnly N'Restrict Processing'                           , N'en-US', null, N'dataprivacy_type_dom'    ,   5, N'Restrict Processing';
exec dbo.spTERMINOLOGY_InsertOnly N'Object to Processing'                          , N'en-US', null, N'dataprivacy_type_dom'    ,   6, N'Object to Processing';
exec dbo.spTERMINOLOGY_InsertOnly N'Consent to Process'                            , N'en-US', null, N'dataprivacy_type_dom'    ,   7, N'Consent to Process';
exec dbo.spTERMINOLOGY_InsertOnly N'Withdraw Consent'                              , N'en-US', null, N'dataprivacy_type_dom'    ,   8, N'Withdraw Consent';

exec dbo.spTERMINOLOGY_InsertOnly N'Email from subject'                            , N'en-US', null, N'dataprivacy_source_dom'  ,   1, N'Email from subject';
exec dbo.spTERMINOLOGY_InsertOnly N'Gaining consent per policy'                    , N'en-US', null, N'dataprivacy_source_dom'  ,   2, N'Gaining consent per policy';
exec dbo.spTERMINOLOGY_InsertOnly N'Other'                                         , N'en-US', null, N'dataprivacy_source_dom'  ,   3, N'Other';

exec dbo.spTERMINOLOGY_InsertOnly N'Low'                                           , N'en-US', null, N'dataprivacy_priority_dom',   0, N'Low';
exec dbo.spTERMINOLOGY_InsertOnly N'Medium'                                        , N'en-US', null, N'dataprivacy_priority_dom',   1, N'Medium';
exec dbo.spTERMINOLOGY_InsertOnly N'High'                                          , N'en-US', null, N'dataprivacy_priority_dom',   2, N'High';

exec dbo.spTERMINOLOGY_InsertOnly N'Open'                                          , N'en-US', null, N'dataprivacy_status_dom'  ,   0, N'Open';
exec dbo.spTERMINOLOGY_InsertOnly N'Rejected'                                      , N'en-US', null, N'dataprivacy_status_dom'  ,   1, N'Rejected';
exec dbo.spTERMINOLOGY_InsertOnly N'Completed'                                     , N'en-US', null, N'dataprivacy_status_dom'  ,   2, N'Completed';
exec dbo.spTERMINOLOGY_InsertOnly N'Consent Expired'                               , N'en-US', null, N'dataprivacy_status_dom'  ,   3, N'Consent Expired';
exec dbo.spTERMINOLOGY_InsertOnly N'Erased'                                        , N'en-US', null, N'dataprivacy_status_dom'  ,   4, N'Erased';

exec dbo.spTERMINOLOGY_InsertOnly N'Business Communication'                        , N'en-US', null, N'business_purpose_dom'    ,   0, N'Business Communication';
exec dbo.spTERMINOLOGY_InsertOnly N'Marketing by Company'                          , N'en-US', null, N'business_purpose_dom'    ,   1, N'Marketing Communications by Company';
exec dbo.spTERMINOLOGY_InsertOnly N'Marketing by Parnters'                         , N'en-US', null, N'business_purpose_dom'    ,   2, N'Marketing Communications by Partners';
exec dbo.spTERMINOLOGY_InsertOnly N'Other'                                         , N'en-US', null, N'business_purpose_dom'    ,   3, N'Other';
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

call dbo.spTERMINOLOGY_DataPrivacy_en_us()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_DataPrivacy_en_us')
/
-- #endif IBM_DB2 */
