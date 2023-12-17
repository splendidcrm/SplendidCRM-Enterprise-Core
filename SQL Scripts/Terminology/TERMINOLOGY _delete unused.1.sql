

-- 03/25/2008 Paul.  Delete unused terminology. 
-- 05/20/2008 Paul.  Clean install is taking a while to cleanup data. Try to be more efficient. 
-- 05/20/2008 Paul.  Change runtime order to 1 so that we do not accidentally delete terms that are used. 
-- 05/25/2008 Paul.  Some line item label were hard to discover (LBL_LINE_ITEMS_TITLE, LBL_CONVERSION_RATE, LBL_CURRENCY, LBL_SHIPPER, LBL_TAXRATE, LBL_LIST_ITEM_TAX_CLASS).
-- 07/08/2010 Paul.  Stop deleting Configurator. 
-- 07/08/2010 Paul.  Stop deleting LBL_CONFIGURATOR_DESC. 
if exists(select * from TERMINOLOGY where MODULE_NAME = 'WebParts') begin -- then
	exec dbo.spTERMINOLOGY_DeleteModule 'Charts';
	-- exec dbo.spTERMINOLOGY_DeleteModule 'Configurator';
	exec dbo.spTERMINOLOGY_DeleteModule 'Groups';
	exec dbo.spTERMINOLOGY_DeleteModule 'History';
	exec dbo.spTERMINOLOGY_DeleteModule 'install';
	exec dbo.spTERMINOLOGY_DeleteModule 'LabelEditor';
	exec dbo.spTERMINOLOGY_DeleteModule 'MailMerge';
	exec dbo.spTERMINOLOGY_DeleteModule 'MergeRecords';
	exec dbo.spTERMINOLOGY_DeleteModule 'Studio';
	exec dbo.spTERMINOLOGY_DeleteModule 'UpgradeWizard';
	
	--exec dbo.spTERMINOLOGY_DeleteModule 'FlexiblePayments';
	--exec dbo.spTERMINOLOGY_DeleteModule 'SimpleStorage';
	--exec dbo.spTERMINOLOGY_DeleteModule 'Jigsaw';
	-- delete from TERMINOLOGY where NAME like 'LBL_AMAZON_%';
	-- delete from TERMINOLOGY where LIST_NAME like 'jigsaw_%';
	-- 05/14/2008 Paul.  Remove TimePeriods and Forecasts. 
	exec dbo.spTERMINOLOGY_DeleteModule 'TimePeriods';
	exec dbo.spTERMINOLOGY_DeleteModule 'Forecasts';
	-- 05/15/2008 Paul.  Remove WebParts. 
	exec dbo.spTERMINOLOGY_DeleteModule 'WebParts';
end -- if;
GO

-- 07/23/2008 Paul.  All modules now share global term names. 
if exists(select *
          from TERMINOLOGY
         where MODULE_NAME is not null
           and NAME in
                ( 'LBL_ID'              
                , 'LBL_DELETED'         
                , 'LBL_CREATED_BY'      
                , 'LBL_DATE_ENTERED'    
                , 'LBL_MODIFIED_USER_ID'
                , 'LBL_DATE_MODIFIED'   
                , 'LBL_MODIFIED_BY'     
                , 'LBL_ASSIGNED_USER_ID'
                , 'LBL_ASSIGNED_TO'     
                , 'LBL_TEAM_ID'         
                , 'LBL_TEAM_NAME'       
                , 'LBL_ID_C'            
                , 'LBL_AUDIT_ID'        
                , 'LBL_AUDIT_ACTION'    
                , 'LBL_AUDIT_DATE'      
                , 'LBL_AUDIT_COLUMNS'   
                , 'LBL_AUDIT_TOKEN'     
                )
        ) begin -- then
	delete from TERMINOLOGY
	 where MODULE_NAME is not null
	   and NAME in
	( 'LBL_ID'              
	, 'LBL_DELETED'         
	, 'LBL_CREATED_BY'      
	, 'LBL_DATE_ENTERED'    
	, 'LBL_MODIFIED_USER_ID'
	, 'LBL_DATE_MODIFIED'   
	, 'LBL_MODIFIED_BY'     
	, 'LBL_ASSIGNED_USER_ID'
	, 'LBL_ASSIGNED_TO'     
	, 'LBL_TEAM_ID'         
	, 'LBL_TEAM_NAME'       
	, 'LBL_ID_C'            
	, 'LBL_AUDIT_ID'        
	, 'LBL_AUDIT_ACTION'    
	, 'LBL_AUDIT_DATE'      
	, 'LBL_AUDIT_COLUMNS'   
	, 'LBL_AUDIT_TOKEN'     
	);
end -- if;

-- 02/11/2009 Paul.  Not ready to cleanup common list labels. 
/*
if exists(select *
          from TERMINOLOGY
         where MODULE_NAME is not null
           and NAME in
                ( 'LBL_LIST_ID'              
                , 'LBL_LIST_DELETED'         
                , 'LBL_LIST_CREATED_BY'      
                , 'LBL_LIST_DATE_ENTERED'    
                , 'LBL_LIST_MODIFIED_USER_ID'
                , 'LBL_LIST_DATE_MODIFIED'   
                , 'LBL_LIST_MODIFIED_BY'     
                , 'LBL_LIST_ASSIGNED_USER_ID'
                , 'LBL_LIST_ASSIGNED_TO'     
                , 'LBL_LIST_TEAM_ID'         
                , 'LBL_LIST_TEAM_NAME'       
                , 'LBL_LIST_ID_C'            
                , 'LBL_LIST_AUDIT_ID'        
                , 'LBL_LIST_AUDIT_ACTION'    
                , 'LBL_LIST_AUDIT_DATE'      
                , 'LBL_LIST_AUDIT_COLUMNS'   
                , 'LBL_LIST_AUDIT_TOKEN'     
                )
        ) begin -- then
	delete from TERMINOLOGY
	 where MODULE_NAME is not null
	   and NAME in
	( 'LBL_LIST_ID'              
	, 'LBL_LIST_DELETED'         
	, 'LBL_LIST_CREATED_BY'      
	, 'LBL_LIST_DATE_ENTERED'    
	, 'LBL_LIST_MODIFIED_USER_ID'
	, 'LBL_LIST_DATE_MODIFIED'   
	, 'LBL_LIST_MODIFIED_BY'     
	, 'LBL_LIST_ASSIGNED_USER_ID'
	, 'LBL_LIST_ASSIGNED_TO'     
	, 'LBL_LIST_TEAM_ID'         
	, 'LBL_LIST_TEAM_NAME'       
	, 'LBL_LIST_ID_C'            
	, 'LBL_LIST_AUDIT_ID'        
	, 'LBL_LIST_AUDIT_ACTION'    
	, 'LBL_LIST_AUDIT_DATE'      
	, 'LBL_LIST_AUDIT_COLUMNS'   
	, 'LBL_LIST_AUDIT_TOKEN'     
	);
end -- if;
*/
GO


if exists(select * from TERMINOLOGY where LIST_NAME = 'web_parts_mode') begin -- then
	exec dbo.spTERMINOLOGY_DeleteList 'case_relationship_type_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'checkbox_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'contract_expiration_notice_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'contract_payment_frequency_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'dashlet_categories_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'document_template_type_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'dom_email_bool';
	exec dbo.spTERMINOLOGY_DeleteList 'dom_email_distribution';
	exec dbo.spTERMINOLOGY_DeleteList 'dom_email_editor_option';
	exec dbo.spTERMINOLOGY_DeleteList 'dom_email_link_type';
	exec dbo.spTERMINOLOGY_DeleteList 'dom_meridiem_lowercase';
	exec dbo.spTERMINOLOGY_DeleteList 'dom_meridiem_uppercase';
	exec dbo.spTERMINOLOGY_DeleteList 'dom_switch_bool';
	exec dbo.spTERMINOLOGY_DeleteList 'dom_timezones';
	exec dbo.spTERMINOLOGY_DeleteList 'forcast_type_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'forecast_schedule_status_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'forecast_type_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'layouts_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'lead_status_noblank_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'merge_operators_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'navigation_paradigms';
	exec dbo.spTERMINOLOGY_DeleteList 'newsletter_frequency_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'opportunity_relationship_type_dom';
-- 05/21/2011 Paul.  out_of_office is use by spEMAILS_InsertInbound.3.sql to prevent an loop with the auto-reply emailer. 
--	exec dbo.spTERMINOLOGY_DeleteList 'out_of_office';
	exec dbo.spTERMINOLOGY_DeleteList 'payment_terms';
-- 01/13/2010 Paul.  New Project fields use these terms. 
--	exec dbo.spTERMINOLOGY_DeleteList 'projects_priority_options';
--	exec dbo.spTERMINOLOGY_DeleteList 'projects_status_options';
	exec dbo.spTERMINOLOGY_DeleteList 'queue_type_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'quote_relationship_type_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'record_type_display_notes';
	exec dbo.spTERMINOLOGY_DeleteList 'report_type_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'scheduler_period_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'schedulers_times_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'team_reports_dom';
	exec dbo.spTERMINOLOGY_DeleteList 'web_parts_mode';
end -- if;
GO

-- 05/15/2008 Paul.  Lists should not have a module associated with them. 
if exists(select * from TERMINOLOGY where MODULE_NAME = 'Schedulers' and LIST_NAME   = 'scheduler_status_dom') begin -- then
	delete from TERMINOLOGY
	 where MODULE_NAME = 'Schedulers'
	   and LIST_NAME   = 'scheduler_status_dom';
end -- if;
if exists(select * from TERMINOLOGY where MODULE_NAME = 'Releases' and LIST_NAME   = 'release_status_dom') begin -- then
	delete from TERMINOLOGY
	 where MODULE_NAME = 'Releases'
	   and LIST_NAME   = 'release_status_dom';
end -- if;
if exists(select * from TERMINOLOGY where MODULE_NAME = 'iFrames' and LIST_NAME   = 'DROPDOWN_TYPE') begin -- then
	delete from TERMINOLOGY
	 where MODULE_NAME = 'iFrames'
	   and LIST_NAME   = 'DROPDOWN_TYPE';
end -- if;
if exists(select * from TERMINOLOGY where MODULE_NAME = 'iFrames' and LIST_NAME   = 'DROPDOWN_PLACEMENT') begin -- then
	delete from TERMINOLOGY
	 where MODULE_NAME = 'iFrames'
	   and LIST_NAME   = 'DROPDOWN_PLACEMENT';
end -- if;
if exists(select * from TERMINOLOGY where MODULE_NAME = 'Activities' and LIST_NAME   = 'appointment_filter_dom') begin -- then
	delete from TERMINOLOGY
	 where MODULE_NAME = 'Activities'
	   and LIST_NAME   = 'appointment_filter_dom';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME is null and NAME = 'ERR_CREATING_FIELDS') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm '.bug_priority_default_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.bug_status_default_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.bug_type_default_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.call_direction_default';
	exec dbo.spTERMINOLOGY_DeleteTerm '.call_status_default';
	exec dbo.spTERMINOLOGY_DeleteTerm '.case_priority_default_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.case_relationship_type_default_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.case_status_default_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.Closed Lost';
	exec dbo.spTERMINOLOGY_DeleteTerm '.Closed Won';
	exec dbo.spTERMINOLOGY_DeleteTerm '.default_order_stage_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.default_quote_stage_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_CREATING_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_CREATING_TABLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_DATABASE_CONN_DROPPED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_DECIMAL_SEP_EQ_THOUSANDS_SEP';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_EXPORT_DISABLED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_EXPORT_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_INVALID_AMOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_INVALID_DATE_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_INVALID_DAY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_INVALID_FILE_REFERENCE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_INVALID_HOUR';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_INVALID_MONTH';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_INVALID_VALUE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_INVALID_YEAR';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_MSSQL_DB_CONTEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_NEED_ACTIVE_SESSION';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_NO_SINGLE_QUOTE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_NO_SUCH_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_NOT_ADMIN';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_NOTHING_SELECTED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_OPPORTUNITY_NAME_DUPE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_OPPORTUNITY_NAME_MISSING';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_POTENTIAL_SEGFAULT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_SELF_REPORTING';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_SINGLE_QUOTE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_SQS_NO_MATCH';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERR_SQS_NO_MATCH_FIELD';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERROR_FULLY_EXPIRED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERROR_JS_ALERT_SYSTEM_CLASS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERROR_JS_ALERT_TIMEOUT_MSG_1';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERROR_JS_ALERT_TIMEOUT_MSG_2';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERROR_JS_ALERT_TIMEOUT_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERROR_LICENSE_EXPIRED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERROR_LICENSE_VALIDATION';
	exec dbo.spTERMINOLOGY_DeleteTerm '.ERROR_NO_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm '.Id. Decision Makers';
	exec dbo.spTERMINOLOGY_DeleteTerm '.language_pack_name';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ACCOUNTS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ACCUMULATED_HISTORY_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ACCUMULATED_HISTORY_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ACCUMULATED_HISTORY_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ADD_ALL_LEAD_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ADD_DOCUMENT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ADD_TO_FAVORITES';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ADD_TO_PROSPECT_LIST_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ADD_TO_PROSPECT_LIST_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ADD_TO_PROSPECT_LIST_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ADDITIONAL_DETAILS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ADDITIONAL_DETAILS_CLOSE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ADDITIONAL_DETAILS_CLOSE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ARCHIVE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_BILL_TO_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_BILL_TO_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_BUGS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CALLS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CAMPAIGN';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CAMPAIGN_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CASE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CASES';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CHARSET';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CLOSE_AND_CREATE_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CLOSE_AND_CREATE_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CLOSE_AND_CREATE_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CLOSE_WINDOW';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CLOSEALL_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CLOSEALL_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CLOSEALL_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CONTACT_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CONTACTS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CREATE_CASE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CREATE_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CREATE_NOTE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CREATE_OPPORTUNITY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CREATE_TASK';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_DELETE_BUTTON';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_DELETED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_DETAILVIEW';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_DIRECT_REPORTS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_DISPLAY_COLUMNS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_DISPLAY_LOG';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_DST_NEEDS_FIXIN';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_DUP_MERGE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_DUPLICATE_BUTTON';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_EDIT_BUTTON';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_EDITVIEW';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_EMAIL_PDF_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_EMAIL_PDF_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_EMAIL_PDF_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_EMAILS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_EXPORT_ALL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_FAILED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_FULL_FORM_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_FULL_FORM_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_FULL_FORM_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_GENERATE_WEB_TO_LEAD_FORM';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_GRID_SELECTED_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_GRID_SELECTED_FILES';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_HIDE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_HIDE_COLUMNS';
	-- 02/11/2009 Paul.  LBL_ID is a field. 
	--exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_IMPORT_DATABASE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_IMPORT_DATABASE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_IMPORT_PROSPECTS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_IMPORT_STARTED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LAST_MODIFIED_BY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LAST_MODIFIED_ON';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LEADS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LEFT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LIST_ACCOUNT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LIST_CONTACT_ROLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LIST_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LIST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LIST_TEAM_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LIST_USER_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LISTVIEW';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LISTVIEW_MASS_UPDATE_CONFIRM';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LISTVIEW_SELECTED_OBJECTS';
	-- 02/11/2009 Paul.  LBL_LISTVIEW_TWO_REQUIRED is used. 
	--exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LISTVIEW_TWO_REQUIRED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LOADING';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LOCALE_NAME_EXAMPLE_FIRST';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LOCALE_NAME_EXAMPLE_LAST';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_LOCALE_NAME_EXAMPLE_SALUTATION';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_MAILMERGE_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_MANAGE_SUBSCRIPTIONS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_MANAGE_SUBSCRIPTIONS_FOR';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_MASS_UPDATE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_MEETINGS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_MEMBERS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_MERGE_DUPLICATES';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_MISSING_CUSTOM_DELIMITER';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_NOTES';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ONLY_IMAGE_ATTACHMENT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_OPENALL_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_OPENALL_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_OPENALL_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_OPENTO_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_OPENTO_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_OPENTO_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_OPPORTUNITIES';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_OPPORTUNITY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_OPPORTUNITY_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_ORDER_BY_COLUMNS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_PERCENTAGE_SYMBOL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_PLEASE_SELECT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_PROCESSING_REQUEST';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_PRODUCT_BUNDLES';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_PRODUCTS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_PROJECT_TASKS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_PROJECTS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_QUOTE_TO_OPPORTUNITY_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_QUOTE_TO_OPPORTUNITY_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_QUOTE_TO_OPPORTUNITY_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_QUOTES';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_QUOTES_SHIP_TO';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_REDIRECT_URL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_RELATED_CAMPAIGN';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_REMOVE_ALL_LEAD_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_REMOVE_FROM_FAVORITES';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_REQUEST_PROCESSED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_RIGHT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SAVE_AS_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SAVE_AS_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SAVE_AS_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SAVE_WEB_TO_LEAD_FORM';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SAVED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SAVED_LAYOUT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SAVED_SEARCH_ERROR';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SAVED_VIEWS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SAVING';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SAVING_LAYOUT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SCHEDULE_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SCHEDULE_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SEARCH_CRITERIA';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SEARCH_POPULATE_ONLY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SEARCHFORM';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SELECT_CONTACT_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SELECT_CONTACT_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SELECT_CONTACT_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SELECT_REPORTS_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SELECT_REPORTS_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SELECT_USER_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SELECT_USER_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SELECT_USER_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SERVER_RESPONSE_RESOURCES';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SERVER_RESPONSE_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SERVER_RESPONSE_TIME_SECONDS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SHIP_TO_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SHIP_TO_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SHOW';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_STATUS_UPDATED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SUBJECT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SUBSCRIBE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SYSTEM_CHECK';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_SYSTEM_CHECK_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_TASKS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_TEAM';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_TEAMS_LINK';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_THOUSANDS_SYMBOL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_TRACK_EMAIL_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_TRACK_EMAIL_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_TRACK_EMAIL_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_UNASSIGNED_ONLY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_UNDELETE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_UNDELETE_BUTTON';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_UNDELETE_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_UNDELETE_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_UNSUBSCRIBE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_USER_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_USERS';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_USERS_SYNC';
	-- 04/27/2010 Paul.  vCard label is now supported. 
	-- exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_VCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_VIEW_BUTTON';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_VIEW_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_VIEW_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_VIEW_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_VIEW_PDF_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_VIEW_PDF_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LBL_VIEW_PDF_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.lead_source_default_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LNK_DELETE_ALL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LNK_GET_LATEST_TOOLTIP';
	-- 05/15/2008 Paul.  LNK_LIST_NEXT is used in grid pagination. 
	exec dbo.spTERMINOLOGY_DeleteTerm '.LNK_LOAD_SIGNED';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LNK_LOAD_SIGNED_TOOLTIP';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LNK_RESUME';
	exec dbo.spTERMINOLOGY_DeleteTerm '.LOGIN_LOGO_ERROR';
	exec dbo.spTERMINOLOGY_DeleteTerm '.meeting_status_default';
	exec dbo.spTERMINOLOGY_DeleteTerm '.MSG_JS_ALERT_MTG_REMINDER_AGENDA';
	exec dbo.spTERMINOLOGY_DeleteTerm '.MSG_JS_ALERT_MTG_REMINDER_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm '.MSG_JS_ALERT_MTG_REMINDER_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm '.MSG_JS_ALERT_MTG_REMINDER_LOC';
	exec dbo.spTERMINOLOGY_DeleteTerm '.MSG_JS_ALERT_MTG_REMINDER_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm '.MSG_JS_ALERT_MTG_REMINDER_MSG';
	exec dbo.spTERMINOLOGY_DeleteTerm '.MSG_JS_ALERT_MTG_REMINDER_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm '.Needs Analysis';
	exec dbo.spTERMINOLOGY_DeleteTerm '.Negotiation/Review';
	exec dbo.spTERMINOLOGY_DeleteTerm '.NTC_CLICK_BACK';
	exec dbo.spTERMINOLOGY_DeleteTerm '.NTC_DATE_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.NTC_DATE_TIME_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.NTC_DELETE_CONFIRMATION_MULTIPLE';
	exec dbo.spTERMINOLOGY_DeleteTerm '.NTC_REMOVE_CONFIRMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm '.NTC_SUPPORT_SUGARCRM';
	exec dbo.spTERMINOLOGY_DeleteTerm '.NTC_TIME_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.NTC_YEAR_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm '.opportunity_relationship_type_default_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.Perception Analysis';
	exec dbo.spTERMINOLOGY_DeleteTerm '.Proposal/Price Quote';
	exec dbo.spTERMINOLOGY_DeleteTerm '.Prospecting';
	exec dbo.spTERMINOLOGY_DeleteTerm '.Qualification';
	exec dbo.spTERMINOLOGY_DeleteTerm '.quote_relationship_type_default_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.record_type_default_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.sales_stage_default_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.source_default_key';
	exec dbo.spTERMINOLOGY_DeleteTerm '.task_priority_default';
	exec dbo.spTERMINOLOGY_DeleteTerm '.task_status_default';
	exec dbo.spTERMINOLOGY_DeleteTerm '.Value Proposition';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Accounts' and NAME = 'db_billing_address_city') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.db_billing_address_city';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.db_name';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.db_website';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_ACTIVITIES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_BILLING_ADDRESS_STREET_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_BILLING_ADDRESS_STREET_3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_BILLING_ADDRESS_STREET_4';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_BUG_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_BUGS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_CASES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_CHARTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_CONTACTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_DEFAULT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_DUPLICATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_HISTORY_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_HOMEPAGE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_INVITEE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_LEADS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_LIST_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_LIST_EMAIL_ADDRESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_LIST_STATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_MEMBER_ORG_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_MISC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_MODIFIED_BY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_OPPORTUNITIES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_PARENT_ACCOUNT_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_PHONE_ALT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_PRODUCTS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_PROJECTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_PUSH_CONTACTS_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_PUSH_CONTACTS_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_SAVE_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_SHIPPING_ADDRESS_STREET_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_SHIPPING_ADDRESS_STREET_3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_SHIPPING_ADDRESS_STREET_4';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_TEAMS_LINK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_USERS_ASSIGNED_LINK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_USERS_CREATED_LINK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_USERS_MODIFIED_LINK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_UTILS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LBL_VIEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.LNK_ACCOUNT_REPORTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.MSG_DUPLICATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.MSG_SHOW_DUPLICATES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.NTC_DELETE_CONFIRMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Accounts.NTC_REMOVE_ACCOUNT_CONFIRMATION';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'ACL' and NAME = 'LBL_ALLOW_ALL') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACL.LBL_ALLOW_ALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACL.LBL_ALLOW_NONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACL.LBL_ALLOW_OWNER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACL.LBL_DESCRIPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACL.LBL_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACL.LBL_ROLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACL.LBL_ROLES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACL.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACL.LBL_USERS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACL.LIST_ROLES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACL.LIST_ROLES_BY_USER';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'ACLActions' and NAME = 'LBL_ACCESS_ADMIN') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLActions.LBL_ACCESS_ADMIN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLActions.LBL_ACCESS_DEFAULT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLActions.LBL_ACCESS_NORMAL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLActions.LBL_ACTION_ADMIN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLActions.LBL_DESCRIPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLActions.LBL_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLActions.LBL_ROLES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLActions.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLActions.LBL_USERS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLActions.LIST_ROLES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLActions.LIST_ROLES_BY_USER';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'ACLRoles' and NAME = 'LBL_ACCESS_DEFAULT') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLRoles.LBL_ACCESS_DEFAULT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLRoles.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLRoles.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLRoles.LBL_ROLES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ACLRoles.LBL_USERS_SUBPANEL_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Activities' and NAME = 'ERR_DELETE_RECORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_COLON';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_DATE_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_DEFAULT_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_DESCRIPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_DESCRIPTION_INFORMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_DIRECTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_DURATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_HOURS_MINS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_INVITEE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_LIST_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_LIST_DIRECTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_LIST_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_LOCATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_SUBJECT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LBL_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LNK_IMPORT_NOTES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.LNK_VIEW_CALENDAR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.NTC_NONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.NTC_NONE_SCHEDULED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Activities.NTC_REMOVE_INVITEE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Administration' and NAME = 'BTN_REBUILD_CONFIG') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.BTN_REBUILD_CONFIG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.DESC_FILES_INSTALLED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.DESC_FILES_QUEUED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.DESC_MODULES_INSTALLED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.DESC_MODULES_QUEUED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.DOWNLOAD_QUESTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_CANNOT_CREATE_RESTORE_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_CREDENTIALS_MISSING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_ENABLE_CURL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_NOT_FOR_MSSQL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_NOT_FOR_MYSQL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_NOT_FOR_ORACLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_SUGAR_DEPOT_DOWN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_ACCEPT_LICENSE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_CONFIG_FAILED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_COPY_FAILED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_INVALID_VIEW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NO_DEPENDENCY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NO_FILES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NO_INSTALL_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NO_LANG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NO_LANG_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NO_MANIFEST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NO_MODE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NO_TEMP_DIR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NO_UPDATE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NO_UPLOAD_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NO_VIEW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NOT_ACCEPTIBLE_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NOT_RECOGNIZED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_NOT_VALID_UPLOAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_ONLY_PATCHES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_REMOVE_FAILED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_REMOVE_PACKAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_RUN_SQL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_UPDATE_CONFIG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERR_UW_UPLOAD_ERROR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERROR_FLAVOR_INCOMPATIBLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERROR_LICENSE_EXPIRED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERROR_LICENSE_EXPIRED2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERROR_MANIFEST_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERROR_PACKAGE_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERROR_VALIDATION_EXPIRED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERROR_VALIDATION_EXPIRED2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ERROR_VERSION_INCOMPATIBLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.FATAL_LICENSE_ALTERED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.FATAL_LICENSE_EXPIRED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.FATAL_LICENSE_EXPIRED2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.FATAL_LICENSE_REQUIRED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.FATAL_VALIDATION_EXPIRED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.FATAL_VALIDATION_EXPIRED2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.FATAL_VALIDATION_REQUIRED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.HDR_LOGIN_PANEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ACCEPT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ACCEPT_TERMS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ALLOW_USER_TABS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_APPLY_DST_FIX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_APPLY_DST_FIX_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_AVAILABLE_MODULES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_AVAILABLE_UPDATES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_BACK_HOME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_CONFIRM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_CONFIRMED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_DIRECTORY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_DIRECTORY_ERROR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_DIRECTORY_EXISTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_DIRECTORY_NOT_WRITABLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_DIRECTORY_WRITABLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_FILE_AS_SUB';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_FILE_EXISTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_FILE_STORED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_INSTRUCTIONS_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_INSTRUCTIONS_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_RUN_BACKUP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BACKUP_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_BROWSE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_CAT_VIEW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_CHECK_FOR_UPDATES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_CLEAR_CHART_DATA_CACHE_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_CLEAR_CHART_DATA_CACHE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_CONFIG_CHECK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_CONFIG_TABS';
	-- exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_CONFIGURATOR_DESC';
	-- exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_CONFIGURATOR_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_CONFIGURE_GROUP_TABS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_CONFIGURE_GROUP_TABS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_COULD_NOT_CONNECT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_CREATE_RESOTRE_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DENY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAG_CANCEL_BUTTON';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAG_EXECUTE_BUTTON';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_ACCESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_BEANLIST_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_BEANLIST_GREEN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_BEANLIST_ORANGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_BEANLIST_RED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_BLBF';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_CALCMD5';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_CONFIGPHP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_CUSTOMDIR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_DELETED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_DELETELINK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_DONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_DOWNLOADLINK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_EXECUTING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_FILESMD5';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_GETBEANFILES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_GETCONFPHP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_GETCUSTDIR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_GETMD5INFO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_GETMYSQLINFO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_GETMYSQLTD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_GETMYSQLTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_GETPHPINFO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_GETSUGARLOG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_GETTING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_MD5';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_MYSQLDUMPS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_MYSQLINFO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_MYSQLSCHEMA';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_NO_MYSQL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_PHPINFO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_SUGARLOG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DIAGNOSTIC_VARDEFS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DISPLAY_TABS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_APPLY_FIX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_BEFORE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_BEFORE_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_CURRENT_SERVER_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_CURRENT_SERVER_TIME_ZONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_CURRENT_SERVER_TIME_ZONE_LOCALE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_END_DATE_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_FIX_CONFIRM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_FIX_CONFIRM_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_FIX_DONE_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_FIX_TARGET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_FIX_USER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_FIX_USER_TZ';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_SET_USER_TZ';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_START_DATE_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_DST_UPGRADE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ENABLE_MAILMERGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ERROR_VERSION_INFO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_EXECUTE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_EXPAND_DATABASE_COLUMNS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_EXPAND_DATABASE_COLUMNS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_EXPAND_DATABASE_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_EXPORT_CUSTOM_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_EXPORT_CUSTOM_FIELDS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_EXPORT_DOWNLOAD_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_EXTERNAL_DEV_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_EXTERNAL_DEV_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_FORECAST_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_GLOBAL_TEAM_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_GO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_HELP_BOOKMARK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_HELP_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_HELP_LINK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_HELP_PRINT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_HIDDEN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_HIDE_TABS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_HT_DONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_HT_NO_WRITE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_HT_NO_WRITE_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ICF_ADDING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ICF_DROPPING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ICF_IMPORT_S';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_IMPORT_CUSTOM_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_IMPORT_CUSTOM_FIELDS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_IMPORT_CUSTOM_FIELDS_STRUCT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_IMPORT_CUSTOM_FIELDS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_IMPORT_LANGUAGE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_IMPORT_VALIDATION_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LICENSE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LIST_VIEW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOADING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_DB_COLLATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_DB_COLLATION_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_DEFAULT_CURRENCY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_DEFAULT_CURRENCY_ISO4217';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_DEFAULT_CURRENCY_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_DEFAULT_CURRENCY_SYMBOL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_DEFAULT_DATE_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_DEFAULT_DECIMAL_SEP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_DEFAULT_LANGUAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_DEFAULT_NAME_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_DEFAULT_NUMBER_GROUPING_SEP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_DEFAULT_SYSTEM_SETTINGS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_DEFAULT_TIME_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_EXAMPLE_NAME_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_NAME_FORMAT_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_LOCALE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MANAGE_GROUPS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MANAGE_GROUPS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MANAGE_LOCALE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MANAGE_MAILBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MANAGE_OPPORTUNITIES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MANUAL_VALIDATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MANUAL_VALIDATION_TXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MANUAL_VALIDATION1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MANUAL_VALIDATION2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MANUAL_VALIDATION3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MANUAL_VALIDATION4';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MANUAL_VALIDATION5';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MASS_EMAIL_MANAGER_HEADER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MASSAGE_MASS_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MASSAGE_MASS_EMAIL_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ML_ACTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ML_CANCEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ML_COMMIT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ML_DESCRIPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ML_INSTALLED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ML_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ML_PUBLISHED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ML_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ML_UNINSTALLABLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_ML_VERSION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MODIFY_CREDENTIALS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MODULE_LICENSE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MODULE_LOADER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MODULE_LOADER_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_MODULES_TO_DOWNLOAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_NEVER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_NEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_NOTIFY_SUBJECT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_OOTB_BOUNCE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_OOTB_CAMPAIGN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_OOTB_PRUNE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_OOTB_REPORTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_OOTB_WORKFLOW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_PASSWORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_PERFORM_UPDATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_PLUGINS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_PLUGINS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_PROXY_AUTH';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_PROXY_HOST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_PROXY_ON';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_PROXY_ON_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_PROXY_PASSWORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_PROXY_PORT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_PROXY_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_PROXY_USERNAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_README';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_AUDIT_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_AUDIT_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_CONFIG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_CONFIG_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_DASHLETS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_DASHLETS_DESC_SHORT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_DASHLETS_DESC_SUCCESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_DASHLETS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_EXTENSIONS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_EXTENSIONS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_HTACCESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_HTACCESS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_JAVASCRIPT_LANG_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_JAVASCRIPT_LANG_DESC_SHORT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_JAVASCRIPT_LANG_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_REL_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_REL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_SCHEDULERS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_SCHEDULERS_DESC_SHORT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_SCHEDULERS_DESC_SUCCESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REBUILD_SCHEDULERS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_ACTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_DATABASE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_DATABASE_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_DATABASE_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_DISPLAYSQL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_ENTRY_POINTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_ENTRY_POINTS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_EXECUTESQL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_EXPORTSQL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_IE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_IE_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_IE_FAILURE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_IE_SUCCESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_INDEX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_INDEX_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_ROLES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_ROLES_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIR_XSS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIRXSS_COUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIRXSS_INSTRUCTIONS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIRXSS_REPAIRED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REPAIRXSS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_RETURN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_REVALIDATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_SEARCH_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_SKYPEOUT_ON';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_SKYPEOUT_ON_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_SKYPEOUT_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_STUDIO_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_SUGAR_NETWORK_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_SUGAR_UPDATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_SUGAR_UPDATE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_SUGARCRM_HELP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_SUPPORT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_SUPPORT_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_SYSTEM_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_TERMS_AND_CONDITIONS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_TIMEZONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_TO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPDATE_CHECK_AUTO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPDATE_CHECK_MANUAL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPDATE_DESCRIPTIONS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPDATE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPGRADE_CURRENCY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPGRADE_CUSTOM_LABELS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPGRADE_CUSTOM_LABELS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPGRADE_DB';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPGRADE_DB_BEGIN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPGRADE_DB_COMPLETE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPGRADE_DB_FAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPGRADE_DB_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPGRADE_STUDIO_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPGRADE_STUDIO_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPGRADE_VERSION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPGRADE_WIZARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPGRADE_WIZARD_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPLOAD_MODULE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UPLOAD_UPGRADE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_USERNAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_BTN_BACK_TO_MOD_LOADER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_BTN_BACK_TO_UW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_BTN_DELETE_PACKAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_BTN_DOWNLOAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_BTN_INSTALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_BTN_UPLOAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_CHECK_ALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_DESC_MODULES_INSTALLED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_DESC_MODULES_QUEUED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_FOLLOWING_FILES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_HIDE_DETAILS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_INCLUDING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_MODULE_READY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_MODULE_READY_UNISTALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_NO_FILES_SELECTED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_NO_INSTALLED_UPGRADES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_NONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_NOT_AVAILABLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_OP_MODE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_PACKAGE_REMOVED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_PATCH_READY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_SHOW_DETAILS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_SUCCESSFUL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_UNINSTALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_UPGRADE_SUCCESSFUL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_UPLOAD_MODULE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_UW_UPLOAD_SUCCESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_VALIDATION_FAIL_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_VALIDATION_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LBL_VALIDATION_SUCCESS_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LNK_FORGOT_PASS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LNK_REPAIR_CUSTOM_FIELD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.LNK_SELECT_CUSTOM_FIELD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.MI_REDIRECT_TO_UPGRADE_WIZARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ML_DESC_DOCUMENTATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ML_LBL_DETAIILS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ML_LBL_DO_NOT_REMOVE_TABLES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ML_LBL_DOCUMENTATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ML_LBL_INSTALL_FROM_LOCAL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ML_LBL_INSTALL_FROM_SERVER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ML_LBL_REMOVE_TABLES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ML_LBL_REVIEWS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.ML_LBL_SCREENSHOTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.MSG_CONFIG_FILE_READY_FOR_REBUILD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.MSG_CONFIG_FILE_REBUILD_FAILED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.MSG_CONFIG_FILE_REBUILD_SUCCESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.MSG_INCREASE_UPLOAD_MAX_FILESIZE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.MSG_MAKE_CONFIG_FILE_WRITABLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.MSG_REBUILD_EXTENSIONS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.MSG_REBUILD_RELATIONSHIPS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.REMOVE_QUESTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.WARN_INSTALLER_LOCKED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.WARN_LICENSE_EXPIRED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.WARN_LICENSE_EXPIRED2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.WARN_LICENSE_SEATS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.WARN_LICENSE_SEATS2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.WARN_REPAIR_CONFIG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.WARN_UPGRADE_APP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.WARN_UPGRADE2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.WARN_VALIDATION_EXPIRED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.WARN_VALIDATION_EXPIRED2';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Audit' and NAME = 'LBL_AUDITED_FIELDS') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Audit.LBL_AUDITED_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Audit.LBL_NO_AUDITED_FIELDS_TEXT';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Bugs' and NAME = 'ERR_DELETE_RECORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_ACCOUNTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_ACTIVITIES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_BUG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_BUG_SUBJECT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_CASES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_CONTACT_BUG_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_CONTACT_ROLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_CONTACTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_DATE_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_DATE_LAST_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_HISTORY_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_INVITEE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_LIST_ACCOUNT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_LIST_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_LIST_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_LIST_EMAIL_ADDRESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_LIST_LAST_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_LIST_PHONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_MODIFIED_BY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_MODULE_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_NUMBER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.LBL_SYSTEM_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Bugs.NTC_DELETE_CONFIRMATION';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Calendar' and NAME = 'LBL_AM') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calendar.LBL_AM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calendar.LBL_BUSY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calendar.LBL_CONFLICT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calendar.LBL_FILTER_BY_TEAM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calendar.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calendar.LBL_NEXT_SHARED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calendar.LBL_PM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calendar.LBL_PREVIOUS_SHARED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calendar.LBL_REFRESH';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calendar.LBL_SCHEDULED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calendar.LBL_USER_CALENDARS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calendar.LNK_NEW_TASK';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Calls' and NAME = 'ERR_DELETE_RECORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_CONTACTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_DEFAULT_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_DEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_DESCRIPTION_INFORMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_HISTORY_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_INVITEE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_LIST_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_LOG_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_MEMBER_OF';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_RELATED_TO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_SEARCH_BUTTON';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_SELECT_FROM_DROPDOWN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_SEND_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_SEND_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_SEND_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_TIME_END';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LBL_USERS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LNK_EMAIL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LNK_MEETING_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LNK_NEW_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LNK_NEW_APPOINTMENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LNK_NEW_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LNK_NEW_NOTE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LNK_NEW_OPPORTUNITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LNK_NEW_TASK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LNK_NOTE_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LNK_SELECT_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LNK_TASK_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Calls.LNK_VIEW_CALENDAR';
end -- if;
GO

-- 07/09/2010 Paul.  We are now using Users.LBL_MAIL_SMTPUSER and Users.LBL_MAIL_SMTPPASS. 
if exists(select * from TERMINOLOGY where MODULE_NAME = 'CampaignLog' and NAME = 'LBL_ACTIVITY_DATE') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_ASSIGNED_TO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_CAMPAIGN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_CAMPAIGN_ACTUAL_COST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_CAMPAIGN_BUDGET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_CAMPAIGN_CONTENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_CAMPAIGN_END_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_CAMPAIGN_EXPECTED_COST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_CAMPAIGN_EXPECTED_REVENUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_CAMPAIGN_OBJECTIVE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_CAMPAIGN_START_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_CAMPAIGN_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_CAMPAIGN_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_CLICKED_URL_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_DATE_ENTERED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_DATE_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_DELETED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_INVITEE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_LIST_CAMPAIGN_OBJECTIVE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_LIST_END_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_LIST_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_LIST_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_LIST_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_MORE_INFO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_TEAM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignLog.LBL_URL_CLICKED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.ERR_FIX_MESSAGES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.ERR_INT_ONLY_EMAIL_PER_RUN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.ERR_MESS_DUPLICATE_FOR_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.ERR_MESS_NOT_FOUND_FOR_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.ERR_NO_EMAIL_MARKETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.ERR_NO_MAILBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.ERR_NO_TARGET_LISTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.ERR_NO_TEST_TARGET_LISTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_ADD_TARGET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_ADD_TRACKER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_ALL_PROSPECT_LISTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_ALREADY_SUBSCRIBED_HEADER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_AVALAIBLE_FIELDS_HEADER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_BACK_TO_CAMPAIGNS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CAMP_MESSAGE_COPY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CAMPAIGN_DIAGNOSTICS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CAMPAIGN_FREQUENCY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CAMPAIGN_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CAMPAIGN_NOT_SELECTED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CAMPAIGN_WIZARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CAMPAIGN_WIZARD_START_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CHOOSE_CAMPAIGN_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CHOOSE_NEXT_STEP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CONFIRM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CONFIRM_CAMPAIGN_SAVE_CONTINUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CONFIRM_CAMPAIGN_SAVE_EXIT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CONFIRM_CAMPAIGN_SAVE_OPTIONS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CONFIRM_SEND_SAVE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_COPY_OF';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CREATE_EMAIL_TEMPLATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CREATE_MAILBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CREATE_NEW_MARKETING_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CREATE_NEWSLETTER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CREATE_TARGET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CREATE_WEB_TO_LEAD_FORM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_CUSTOM_LOCATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DATE_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DATE_LAST_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DATE_START';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DEFAULT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DEFAULT_FROM_ADDR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DEFAULT_LEAD_SUBMIT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DEFAULT_LIST_ENTRIES_NOT_FOUND';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DEFAULT_LIST_ENTRIES_WERE_PROCESSED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DEFAULT_LIST_NOT_FOUND';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DEFAULT_LOCATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DEFINE_LEAD_HEADER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DEFINE_LEAD_POST_URL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DEFINE_LEAD_REDIRECT_URL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DEFINE_LEAD_SUBMIT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DESCRIPTION_LEAD_FORM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DESCRIPTION_TEXT_LEAD_FORM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DIAGNOSTIC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DIAGNOSTIC_WIZARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DOWNLOAD_TEXT_WEB_TO_LEAD_FORM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DOWNLOAD_WEB_TO_LEAD_FORM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_DRAG_DROP_COLUMNS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EDIT_EMAIL_TEMPLATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EDIT_EXISTING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EDIT_LEAD_POST_URL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EDIT_OPT_OUT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EDIT_OPT_OUT_';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EDIT_TARGET_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EDIT_TRACKER_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EDIT_TRACKER_URL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EMAIL_CAMPAIGNS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EMAIL_MARKETING_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EMAIL_SETUP_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EMAIL_SETUP_WIZ';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EMAIL_SETUP_WIZARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EMAIL_SETUP_WIZARD_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EMAILS_PER_RUN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_EMAILS_SCHEDULED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_FILTER_CHART_BY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_FINISH';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_FROM_ADDR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_FROM_MAILBOX_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_FROM_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_HOME_START_MESSAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_INVITEE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_LEAD_DEFAULT_HEADER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_LEAD_FOOTER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_LEAD_FORM_FIRST_HEADER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_LEAD_FORM_SECOND_HEADER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_LEAD_MODULE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_LEAD_NOTIFY_CAMPAIGN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_LIST_TO_ACTIVITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_LOCATION_TRACK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_LOG_ENTRIES_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_LOGIN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAIL_SENDTYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAIL_SMTPAUTH_REQ';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAIL_SMTPPASS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAIL_SMTPPORT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAIL_SMTPSERVER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAIL_SMTPUSER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAILBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAILBOX_CHECK_WIZ_BAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAILBOX_CHECK_WIZ_GOOD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAILBOX_CHECK1_BAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAILBOX_CHECK1_GOOD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAILBOX_CHECK2_BAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAILBOX_CHECK2_GOOD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAILBOX_DEFAULT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MAILBOX_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MANAGE_SUBSCRIPTIONS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MARK_AS_SENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MARKETING_CHECK1_BAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MARKETING_CHECK1_GOOD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MARKETING_CHECK2_BAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MARKETING_CHECK2_GOOD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MESSAGE_FOR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MODIFIED_BY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MORE_DETAILS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_MRKT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NAVIGATION_MENU_GEN1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NAVIGATION_MENU_GEN2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NAVIGATION_MENU_MARKETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NAVIGATION_MENU_NEW_MAILBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NAVIGATION_MENU_SEND_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NAVIGATION_MENU_SETUP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NAVIGATION_MENU_SUBSCRIPTIONS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NAVIGATION_MENU_SUMMARY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NAVIGATION_MENU_TRACKERS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NEWSLETTER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NEWSLETTER WIZARD_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NEWSLETTER_FORENTRY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NEWSLETTER_WIZARD_START_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NEWSLETTERS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NO_SUBS_ENTRIES_WARNING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NO_TARGET_ENTRIES_WARNING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NO_TARGETS_WARNING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NON_ADMIN_ERROR_MSG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_NOTIFY_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_OTHER_TYPE_CAMPAIGN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_PASSWORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_PORT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_PROSPECT_LIST_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_PROVIDE_WEB_TO_LEAD_FORM_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_REMOVE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SAVE_CONTINUE_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SAVE_EXIT_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SCHEDULER_CHECK_BAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SCHEDULER_CHECK_GOOD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SCHEDULER_CHECK1_BAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SCHEDULER_CHECK2_BAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SCHEDULER_LINK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SCHEDULER_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SCHEDULER_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SELECT_LEAD_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SELECT_REQUIRED_LEAD_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SELECT_TARGET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SEND_AS_TEST';
	-- 02/11/2009 Paul.  LBL_SEND_DATE_TIME is a field name. 
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SEND_DATE_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SEND_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SERVER_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SERVER_URL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_START';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_START_DATE_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_STATUS_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SUBSCRIPTION_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SUBSCRIPTION_LIST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SUBSCRIPTION_TARGET_WIZARD_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_SUBSCRIPTION_TYPE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TARGET_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TARGET_LISTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TARGET_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TARGET_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TEAM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TEMPLATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TEST_EMAILS_SENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TEST_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TEST_LIST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TEST_TARGET_WIZARD_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TEST_TYPE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TIME_START';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TO_WIZARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TO_WIZARD_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TODETAIL_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TOTAL_ENTRIES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TRACK_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TRACK_DELETE_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TRACK_DELETE_CONFIRM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_TRACKERS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_UNSUBSCRIBED_HEADER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_UNSUBSCRIPTION_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_UNSUBSCRIPTION_LIST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_UNSUBSCRIPTION_TARGET_WIZARD_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_UNSUBSCRIPTION_TYPE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_USE_EXISTING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WEB_TO_LEAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WEB_TO_LEAD_FORM_TITLE1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WEB_TO_LEAD_FORM_TITLE2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZ_FROM_ADDRESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZ_FROM_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZ_MARKETING_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZ_NEWSLETTER_TITLE_STEP1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZ_NEWSLETTER_TITLE_STEP2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZ_NEWSLETTER_TITLE_STEP3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZ_NEWSLETTER_TITLE_STEP4';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZ_NEWSLETTER_TITLE_SUMMARY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZ_SENDMAIL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZ_TEST_EMAIL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZARD_BUDGET_MESSAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZARD_FIRST_STEP_MESSAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZARD_HEADER_MESSAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZARD_LAST_STEP_MESSAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZARD_MARKETING_MESSAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZARD_SENDMAIL_MESSAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZARD_SUBSCRIPTION_MESSAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZARD_TARGET_MESSAGE1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZARD_TARGET_MESSAGE2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_WIZARD_TRACKER_MESSAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LBL_YES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LNK_CAMPAIGN_DIGNOSTIC_LINK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LNK_EMAIL_TEMPLATE_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.LNK_NEW_EMAIL_TEMPLATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Campaigns.TRACKING_ENTRIES_LOCATION_DEFAULT_VALUE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'CampaignTrackers' and NAME = 'LBL_CAMPAIGN') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignTrackers.LBL_CAMPAIGN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignTrackers.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignTrackers.LBL_OPTOUT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignTrackers.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignTrackers.LBL_SUBPANEL_TRACKER_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignTrackers.LBL_SUBPANEL_TRACKER_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'CampaignTrackers.LBL_SUBPANEL_TRACKER_URL';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Cases' and NAME = 'ERR_DELETE_RECORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_ACTIVITIES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_BUGS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_CASE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_CASE_SUBJECT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_CONTACT_CASE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_CONTACT_ROLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_CONTACTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_HISTORY_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_INVITEE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_LIST_ASSIGNED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_LIST_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_LIST_CLOSE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_LIST_DATE_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_LIST_LAST_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_MEMBER_OF';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_NUMBER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Cases.LBL_SYSTEM_ID';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Contacts' and NAME = 'db_email1') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.db_email1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.db_email2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.db_first_name';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.db_last_name';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.db_title';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.ERR_DELETE_RECORD';
	-- 02/11/2009 Paul.  LBL_ACCOUNT_ID is a field. 
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_ACCOUNT_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_ACTIVITIES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_ADD_BUSINESSCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_ADDMORE_BUSINESSCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_ALT_ADDRESS_STREET_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_ALT_ADDRESS_STREET_3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_BUGS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_BUSINESSCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_CAMPAIGN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_CAMPAIGN_LIST_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_CAMPAIGNS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_CASES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_CONTACT_OPP_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_CONTACT_ROLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_COPY_ADDRESS_CHECKED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_CREATED_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_CREATED_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_CREATED_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_CREATED_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_CREATED_OPPORTUNITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_DUPLICATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_EXISTING_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_EXISTING_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_EXISTING_OPPORTUNITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_FULL_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_HISTORY_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_HOMEPAGE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_IMPORT_VCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_IMPORT_VCARDTEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_INVITEE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_LEADS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_LIST_ACCEPT_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_LIST_CITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_LIST_OTHER_EMAIL_ADDRESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_LIST_STATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_MODIFIED_BY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_NEW_PORTAL_PASSWORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_NOTE_SUBJECT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_OPP_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_OPPORTUNITIES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_OPPORTUNITY_ROLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_OPPORTUNITY_ROLE_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_PORTAL_INFORMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_PORTAL_PASSWORD_ISSET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_PRIMARY_ADDRESS_STREET_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_PRIMARY_ADDRESS_STREET_3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_PRODUCTS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_PROJECTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_RELATED_CONTACTS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_SAVE_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_TARGET_OF_CAMPAIGNS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_USER_PASSWORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LBL_VIEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LNK_CONTACT_REPORTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LNK_IMPORT_VCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LNK_NEW_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LNK_NEW_APPOINTMENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LNK_NEW_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LNK_NEW_CASE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LNK_NEW_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LNK_NEW_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LNK_NEW_NOTE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LNK_NEW_OPPORTUNITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LNK_NEW_TASK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.LNK_SELECT_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.MSG_DUPLICATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.MSG_SHOW_DUPLICATES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.NTC_COPY_ALTERNATE_ADDRESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.NTC_COPY_PRIMARY_ADDRESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.NTC_DELETE_CONFIRMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.NTC_OPPORTUNITY_REQUIRES_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contacts.NTC_REMOVE_CONFIRMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contracts.LBL_LIST_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contracts.LBL_LIST_OPPORTUNITY_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contracts.LBL_LIST_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Contracts.LBL_SEARCH_FORM_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Currencies' and NAME = 'LNK_NEW_ACCOUNT') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LBL_ADD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LBL_DELETE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LBL_MERGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LBL_MERGE_TXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LBL_UPDATE';
	-- 02/11/2009 Paul.  LBL_US_DOLLAR is a  field. 
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LBL_US_DOLLAR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LNK_NEW_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LNK_NEW_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LNK_NEW_CASE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LNK_NEW_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LNK_NEW_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LNK_NEW_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LNK_NEW_NOTE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LNK_NEW_OPPORTUNITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.LNK_NEW_TASK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Currencies.NTC_DELETE_CONFIRMATION';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'CustomFields' and NAME = 'NOTE_CREATE_DROPDOWN') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'CustomFields.NOTE_CREATE_DROPDOWN';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Dashboard' and NAME = 'ERR_NO_OPPS') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.ERR_NO_OPPS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_ADD_A_CHART';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_ALL_OPPORTUNITIES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_BASIC_CHARTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_DELETE_FROM_DASHBOARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_MOVE_CHARTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_MOVE_DOWN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_MOVE_UP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_MY_REPORTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_PUBLISHED_REPORTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_REPORT_NO_CHART';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_SALES_STAGE_FORM_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LBL_TEAM_REPORTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.LNK_NEW_ISSUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dashboard.NTC_NO_LEGENDS';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'DocumentRevisions' and NAME = 'ERR_DELETE_CONFIRM') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.ERR_DELETE_CONFIRM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.ERR_DELETE_LATEST_VERSION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.ERR_DOC_VERSION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.ERR_FILENAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_ACTIVE_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_CHANGE_LOG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_CURRENT_DOC_VERSION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_DET_CREATED_BY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_DET_DATE_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_DOC_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_DOC_VERSION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_DOCUMENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_EXPIRATION_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_FILE_EXTENSION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_FILENAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_LATEST_REVISION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_MIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_REV_LIST_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_REV_LIST_ENTERED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_REV_LIST_FILENAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_REV_LIST_LOG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_REV_LIST_REVISION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_REVISION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_REVISION_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DocumentRevisions.LBL_SEARCH_FORM_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Documents' and NAME = 'DEF_CREATE_LOG') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.DEF_CREATE_LOG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.ERR_DOC_ACTIVE_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.ERR_DOC_EXP_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.ERR_DOC_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.ERR_DOC_VERSION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.ERR_FILENAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_CAT_OR_SUBCAT_UNSPEC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_CATEGORY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_CONTRACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_CONTRACTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_DET_IS_TEMPLATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_DET_RELATED_DOCUMENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_DET_RELATED_DOCUMENT_VERSION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_DET_TEMPLATE_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_DOC_REV_HEADER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_DOCUMENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_DOCUMENT_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_EXPIRATION_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_FILE_EXTENSION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_LAST_REV_CREATE_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_LATEST_REVISION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_LIST_DOWNLOAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_LIST_LATEST_REVISION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_MIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_MODIFIED_USER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_MODULE_TITLE';
	-- 02/11/2009 Paul.  LBL_NAME is a field. 
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_RELATED_DOCUMENT_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_RELATED_DOCUMENT_REVISION_ID';
	-- 02/11/2009 Paul.  LBL_REVISION is a field. 
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_REVISION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_REVISION_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_SUBCATEGORY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LBL_TREE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Documents.LNK_NEW_MAIL_MERGE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Dropdown' and NAME = 'LBL_ACCOUNT_NAME') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dropdown.LBL_ACCOUNT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dropdown.LBL_ADD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dropdown.LBL_DELETE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dropdown.LBL_EDIT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dropdown.LBL_INSERT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dropdown.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dropdown.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dropdown.LBL_MOVE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dropdown.LNK_INSERT';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Administration' and NAME = 'BTN_REBUILD_CONFIG') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dynamic.LNK_CALL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dynamic.LNK_EMAIL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dynamic.LNK_MEETING_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dynamic.LNK_NEW_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dynamic.LNK_NEW_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dynamic.LNK_NEW_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dynamic.LNK_NEW_NOTE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dynamic.LNK_NEW_TASK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dynamic.LNK_NOTE_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Dynamic.LNK_TASK_LIST';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'DynamicFields' and NAME = 'LNK_CALL_LIST') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicFields.LNK_CALL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicFields.LNK_EMAIL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicFields.LNK_MEETING_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicFields.LNK_NEW_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicFields.LNK_NEW_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicFields.LNK_NEW_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicFields.LNK_NEW_NOTE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicFields.LNK_NEW_TASK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicFields.LNK_NOTE_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicFields.LNK_TASK_LIST';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'DynamicLayout' and NAME = 'DESC_USING_LAYOUT_ADD_FIELD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_ADD_FIELD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_BLK1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_BLK10';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_BLK2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_BLK3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_BLK4';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_BLK5';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_BLK6';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_BLK7';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_BLK8';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_BLK9';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_DISPLAY_HTML';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_EDIT_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_EDIT_ROWS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_REMOVE_ITEM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_SELECT_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_SHORTCUTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.DESC_USING_LAYOUT_TOOLBAR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_ADD_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_ADVANCED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_DISPLAY_HTML';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_EDIT_COLUMNS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_EDIT_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_EDIT_IN_PLACE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_EDIT_LABELS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_EDIT_LAYOUT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_EDIT_ROWS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_SAVE_LAYOUT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_SELECT_A_SUBPANEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_SELECT_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_SELECT_SUBPANEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_STAGING_AREA';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_SUGAR_BIN_STAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_SUGAR_FIELDS_STAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_TOOLBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_VIEW_SUGAR_BIN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.LBL_VIEW_SUGAR_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'DynamicLayout.NO_RECORDS_LISTVIEW';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'EditCustomFields' and NAME = 'COLUMN_TITLE_DEFAULT_EMAIL') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.COLUMN_TITLE_DEFAULT_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.COLUMN_TITLE_DISPLAYED_ITEM_COUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.COLUMN_TITLE_DUPLICATE_MERGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.COLUMN_TITLE_EXT1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.COLUMN_TITLE_EXT2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.COLUMN_TITLE_EXT3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.COLUMN_TITLE_HELP_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.COLUMN_TITLE_HTML_CONTENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.COLUMN_TITLE_MASS_UPDATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.COLUMN_TITLE_MAX_VALUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.COLUMN_TITLE_MIN_VALUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.COLUMN_TITLE_PRECISION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.COLUMN_TITLE_URL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.LBL_AUDITED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.LBL_DATA_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.LBL_DEFAULT_VALUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.LBL_DROP_DOWN_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.LBL_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.LBL_MULTI_SELECT_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.LBL_RADIO_FIELDS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.LNK_REPAIR_CUSTOM_FIELD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.MSG_DELETE_CONFIRM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.POPUP_EDIT_HEADER_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EditCustomFields.POPUP_INSERT_HEADER_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'EmailMan' and NAME = 'ERR_INT_ONLY_EMAIL_PER_RUN') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.ERR_INT_ONLY_EMAIL_PER_RUN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_ATTACHMENT_AUDIT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_CAMP_MESSAGE_COPY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_CONFIGURE_SETTINGS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_EMAIL_DEFAULT_CHARSET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_EMAIL_DEFAULT_CLIENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_EMAIL_DEFAULT_DELETE_ATTACHMENTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_EMAIL_DEFAULT_EDITOR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_EMAIL_PER_RUN_REQ';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_EMAIL_USER_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_LIST_FORM_PROCESSED_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_LIST_FROM_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_LIST_FROM_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_LOCATION_ONLY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_MODULE_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_OLD_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_OUTBOUND_EMAIL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_PREPEND_TEST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_SAVE_OUTBOUND_RAW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_SEARCH_FORM_PROCESSED_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_VIEW_PROCESSED_EMAILS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_VIEW_QUEUED_EMAILS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_YES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.TRACKING_ENTRIES_LOCATION_DEFAULT_VALUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.TXT_REMOVE_ME_ALT';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'EmailMarketing' and NAME = 'LBL_CREATE_EMAIL_TEMPLATE') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_CREATE_EMAIL_TEMPLATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_DATE_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_DATE_LAST_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_EDIT_EMAIL_TEMPLATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_FROM_MAILBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_LIST_PROSPECT_LIST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_MESSAGE_FOR_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_MODIFIED_BY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_MODULE_SEND_EMAILS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_MODULE_SEND_TEST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_PROSPECT_LIST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_PROSPECT_LIST_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_RELATED_PROSPECT_LISTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_SCHEDULE_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_SCHEDULE_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_SCHEDULE_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_SCHEDULE_MESSAGE_EMAILS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_SCHEDULE_MESSAGE_TEST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMarketing.LBL_SEARCH_FORM_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Emails' and NAME = 'ERR_ARCHIVE_EMAIL') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.ERR_ARCHIVE_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.ERR_DATE_START';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.ERR_TIME_START';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_ACCOUNTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_ADD_ANOTHER_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_ADD_DASHLETS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_ADD_DOCUMENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_ALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_ARCHIVED_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_ASSIGN_WARN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_BACK_TO_GROUP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_BUGS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_BUTTON_DISTRIBUTE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_BUTTON_DISTRIBUTE_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_BUTTON_DISTRIBUTE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_BUTTON_GRAB';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_BUTTON_GRAB_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_BUTTON_GRAB_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_CASES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_COLON';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_CONFIRM_DELETE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_CONTACT_FIRST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_CONTACT_LAST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_CONTACTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_CREATE_BUG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_CREATE_CASE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_CREATE_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_CREATE_LEAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_CREATE_TASK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_DIST_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EDIT_ALT_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EDIT_MY_SETTINGS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAIL_EDITOR_OPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAIL_SELECTOR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAILS_ACCOUNTS_REL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAILS_BUGS_REL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAILS_CASES_REL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAILS_CONTACTS_REL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAILS_LEADS_REL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAILS_NOTES_REL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAILS_OPPORTUNITIES_REL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAILS_PROJECT_REL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAILS_PROJECT_TASK_REL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAILS_PROJECTTASK_REL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAILS_PROSPECT_REL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAILS_TASKS_REL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_EMAILS_USERS_REL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_ERROR_SENDING_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_HTML_BODY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_INVITEE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LEADS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_ASSIGNED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_BUG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_CASE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_DATE_SENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_FORM_DRAFTS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_LEAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_TASK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_TITLE_GROUP_INBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_TITLE_MY_ARCHIVES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_TITLE_MY_DRAFTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_TITLE_MY_INBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_TITLE_MY_SENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LIST_TO_ADDR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LOCK_FAIL_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_LOCK_FAIL_USER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_MASS_DELETE_ERROR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_MEMBER_OF';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_MESSAGE_SENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_MODIFIED_BY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_MODULE_NAME_NEW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_NEW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_NEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_NEXT_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_NO_GRAB_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_NOT_SENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_NOTES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_OPPORTUNITY_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_PROJECT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_PROJECT_TASK_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_QUICK_CREATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_QUICK_REPLY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_RAW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_REPLIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_REPLY_HEADER_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_REPLY_HEADER_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_REPLY_TO_ADDRESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_SEARCH_FORM_DRAFTS_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_SEARCH_FORM_SENT_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_SELECT_TEAM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_SEND_ANYWAYS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_SENT_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_SHOW_ALT_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_SIGNATURE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_TAKE_ONE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_TEXT_BODY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_TITLE_SEARCH_RESULTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_TOGGLE_ALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_UNKNOWN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_UNREAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_UNREAD_HOME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_USE_ALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_USE_CHECKED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_USE_MAILBOX_INFO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_USER_SELECT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_USERS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_USERS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_USING_RULES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_WARN_NO_DIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LBL_WARN_NO_USERS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_ARCHIVED_EMAIL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_CALL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_CHECK_MY_INBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_DATE_SENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_GROUP_INBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_MEETING_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_MY_ARCHIVED_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_MY_DRAFTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_MY_INBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_NEW_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_NEW_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_NEW_NOTE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_NEW_TASK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_NOTE_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_QUICK_REPLY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_SENT_EMAIL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_TASK_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.LNK_VIEW_CALENDAR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.WARNING_NO_UPLOAD_DIR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.WARNING_SETTINGS_NOT_CONF';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Emails.WARNING_UPLOAD_DIR_NOT_WRITABLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'EmailTemplates' and NAME = 'LBL_ACCOUNT') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_ADD_ANOTHER_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_ADD_DOCUMENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_ADD_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_ATTACHMENTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_CLOSE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_COLON';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_EDIT_ALT_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_HTML_BODY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_NEW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_NEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_PUBLISH';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_RELATED_TO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_SEND_AS_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_SHOW_ALT_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_TEAM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_TEAMS_LINK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LBL_TEXT_BODY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LNK_ARCHIVED_EMAIL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LNK_CHECK_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LNK_CHECK_MY_INBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LNK_GROUP_INBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LNK_IMPORT_NOTES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LNK_MY_ARCHIVED_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LNK_MY_DRAFTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LNK_MY_INBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LNK_NEW_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailTemplates.LNK_SENT_EMAIL_LIST';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Employees' and NAME = 'ERR_DELETE_RECORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.ERR_EMPLOYEE_NAME_EXISTS_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.ERR_EMPLOYEE_NAME_EXISTS_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.ERR_LAST_ADMIN_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.ERR_LAST_ADMIN_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_ADMIN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_CREATE_USER_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_CREATE_USER_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_CREATE_USER_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_CURRENCY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_DATE_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_EMPLOYEE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_ERROR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_FAVORITE_COLOR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_GROUP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_IS_ADMIN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_LANGUAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_LIST_ADMIN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_LIST_EMPLOYEE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_LIST_LAST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_LOGIN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_NEW_EMPLOYEE_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_NEW_EMPLOYEE_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_NEW_EMPLOYEE_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_NEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_OTHER_PHONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_PASSWORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_PORTAL_ONLY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_RECEIVE_NOTIFICATIONS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_SUGAR_LOGIN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_THEME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_TIME_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Employees.LBL_TIMEZONE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Feeds' and NAME = 'ERR_DELETE_RECORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Feeds.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Feeds.LBL_ADD_FAV_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Feeds.LBL_DELETE_FAV_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Feeds.LBL_DELETE_FAVORITES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Feeds.LBL_FEED_NOT_AVAILABLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Feeds.LBL_MODULE_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Feeds.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Feeds.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Feeds.LBL_ONLY_MY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Feeds.LBL_REFRESH_CACHE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Feeds.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Feeds.LBL_TILE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Feeds.NTC_DELETE_CONFIRMATION';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Forcasts' and NAME = 'LNK_REPORTS') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Forcasts.LNK_REPORTS';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Forums' and NAME = 'LBL_ASSIGNED_TO') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Forums.LBL_ASSIGNED_TO';
	-- 02/11/2009 Paul.  LBL_LAST_THREAD_CREATED_BY and LBL_LAST_THREAD_TITLE are used. 
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Forums.LBL_LAST_THREAD_CREATED_BY';
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Forums.LBL_LAST_THREAD_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Forums.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Forums.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ForumTopics.LBL_ORDER_DESC';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Help' and NAME = 'ERR_DELETE_RECORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LBL_DISPLAY_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LBL_LANG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LBL_LIST_DISPLAY_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LBL_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LBL_NEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LNK_NEW_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LNK_NEW_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LNK_NEW_CASE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LNK_NEW_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LNK_NEW_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LNK_NEW_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LNK_NEW_NOTE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LNK_NEW_OPPORTUNITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Help.LNK_NEW_TASK';
end -- if;
GO

-- 07/11/2009 Paul.  Dashlets are now being supported, so don't delete the terms.
if exists(select * from TERMINOLOGY where MODULE_NAME = 'Home' and NAME = 'LBL_NO_RESULTS') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_ADD_BUSINESSCARD';
--	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_ADD_DASHLETS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_ADDED_DASHLET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_ADDING_DASHLET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_CAMPAIGN_ROI_FORM_TITLE';
--	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_CLOSE_DASHLETS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_DASHLET_CONFIGURE_DISPLAY_ROWS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_DASHLET_CONFIGURE_FILTERS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_DASHLET_CONFIGURE_GENERAL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_DASHLET_CONFIGURE_MY_ITEMS_ONLY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_DASHLET_CONFIGURE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_EMAIL_ADDRESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_FIRST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_LAST_30_DAYS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_LAST_7_DAYS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_LAST_MONTH';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_LAST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_LAST_QUARTER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_LAST_WEEK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_LAST_YEAR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_LIST_LAST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_MAX_DASHLETS_REACHED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_NEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_NEXT_30_DAYS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_NEXT_7_DAYS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_NEXT_MONTH';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_NEXT_WEEK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_NEXT_YEAR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_NO_RESULTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_NO_RESULTS_IN_MODULE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_NO_RESULTS_TIPS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_OPEN_TASKS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_OPTIONS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_PHONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_RELOAD_PAGE';
--	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_REMOVE_DASHLET_CONFIRM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_REMOVED_DASHLET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_REMOVING_DASHLET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_SEARCH_RESULTS_IN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_THIS_MONTH';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_THIS_QUARTER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_THIS_YEAR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_TODAY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_TOMORROW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_TRAINING_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LBL_YESTERDAY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Home.LNK_COMPOSE_EMAIL';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'iFrames' and NAME = 'DEFAULT_URL') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'iFrames.DEFAULT_URL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'iFrames.LBL_CHECKED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'iFrames.LBL_MODULE_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'iFrames.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'iFrames.LBL_MODULE_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Import' and NAME = 'ERR_MULTIPLE_PARENTS') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.ERR_MULTIPLE_PARENTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.ERR_SELECT_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.ERR_SELECT_FULL_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_ASSIGNED_USER_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_BACK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_CANNOT_OPEN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_CSV';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_DELETE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_DUPLICATE_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_DUPLICATES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_FILE_ALREADY_BEEN_OR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_FINISHED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IDS_EXISTED_OR_LONGER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_MODULE_ERROR_LARGE_FILE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_MODULE_ERROR_LARGE_FILE_END';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_MODULE_ERROR_NO_MOVE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_MODULE_ERROR_NO_UPLOAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_MODULE_NO_DIRECTORY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_MODULE_NO_DIRECTORY_END';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_MORE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_NOW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_OUTLOOK_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_INDEX_NOT_USED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_INDEX_USED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_LAST_IMPORT_UNDONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_MICROSOFT_OUTLOOK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NO_IMPORT_TO_UNDO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NO_LINES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NOT_SAME_NUMBER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NOW_CHOOSE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NUM_12';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_OUTLOOK_NUM_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_OUTLOOK_NUM_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_OUTLOOK_NUM_3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_OUTLOOK_NUM_4';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_OUTLOOK_NUM_5';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_OUTLOOK_NUM_6';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_OUTLOOK_NUM_7';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_PUBLISH';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_PUBLISHED_SOURCES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_RECORDS_SKIPPED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_RESULTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_SAVE_AS_CUSTOM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_SAVE_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_STEP_1_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_STEP_2_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_STEP_3_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_TRY_AGAIN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_UNDO_LAST_IMPORT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_UNIQUE_INDEX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_UNPUBLISH';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_VERIFY_DUPS';
end -- if;
GO

-- 11/18/2010 Paul.  Remove unused Users fields. 
if exists(select * from TERMINOLOGY where MODULE_NAME = 'Users' and NAME like 'LBL_%_SEP%') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_DST_INSTRUCTIONS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_GRIDLINE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_GRIDLINE_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_NUMBER_GROUPING_SEP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_NUMBER_GROUPING_SEP_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_DECIMAL_SEP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_DECIMAL_SEP_TEXT';
end -- if;
GO

-- 11/18/2010 Paul.  Remove unused Schedulers fields. 
if exists(select * from TERMINOLOGY where MODULE_NAME = 'Schedulers' and NAME = 'LBL_CATCH_UP_WARNING') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_CATCH_UP_WARNING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_CRONTAB_EXAMPLES';
end -- if;
GO

-- 11/18/2010 Paul.  Remove unused Schedulers fields. 
if exists(select * from TERMINOLOGY where MODULE_NAME = 'EmailMan' and NAME = 'LBL_NOTIFICATION_ON_DESC') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_NOTIFICATION_ON_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'EmailMan.LBL_NOTIFY_ON';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Administration.HEARTBEAT_MESSAGE';
end -- if;
GO

-- 11/18/2010 Paul.  Separate text lines have been replaced by a single term. 
if exists(select * from TERMINOLOGY where MODULE_NAME = 'Import' and NAME like 'LBL_%_NUM_%') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_CUSTOM_NUM_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_CUSTOM_NUM_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_CUSTOM_NUM_3';

	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_TAB_NUM_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_TAB_NUM_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_TAB_NUM_3';

	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_ACT_NUM_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_ACT_NUM_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_ACT_NUM_3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_ACT_NUM_4';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_ACT_NUM_5';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_ACT_NUM_6';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_ACT_NUM_7';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_ACT_NUM_8';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_ACT_NUM_9';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_ACT_NUM_10';

	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_SF_NUM_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_SF_NUM_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_SF_NUM_3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_SF_NUM_4';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_SF_NUM_5';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_SF_NUM_6';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_SF_NUM_7';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_SF_NUM_8';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_SF_NUM_9';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_SF_NUM_10';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_SF_NUM_11';

	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NUM_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NUM_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NUM_3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NUM_4';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NUM_5';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NUM_6';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NUM_7';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NUM_8';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NUM_9';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NUM_10';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_NUM_11';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'InboundEmail' and NAME = 'ERR_BAD_LOGIN_PASSWORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.ERR_BAD_LOGIN_PASSWORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.ERR_BODY_TOO_LONG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.ERR_INI_ZLIB';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.ERR_MAILBOX_FAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.ERR_NO_IMAP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.ERR_NO_OPTS_SAVED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.ERR_TEST_MAILBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_APPLY_OPTIMUMS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_ASSIGN_TO_USER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_AUTOREPLY_OPTIONS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_CASE_MACRO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_CASE_MACRO_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_CASE_MACRO_DESC2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_CERT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_CERT_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_CLOSE_POPUP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_CREATE_TEMPLATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_DEFAULT_FROM_ADDR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_DEFAULT_FROM_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_EDIT_TEMPLATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_FILTER_DOMAIN_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_FIND_OPTIMUM_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_FIND_OPTIMUM_MSG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_FIND_OPTIMUM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_FIND_SSL_WARN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_FORCE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_FORCE_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_FOUND_MAILBOXES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_FOUND_OPTIMUM_MSG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_FROM_NAME_ADDR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_HOME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_MAILBOX_SSL_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_MARK_READ_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_MARK_READ_NO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_MARK_READ_YES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_NO_OPTIMUMS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_ONLY_SINCE_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_ONLY_SINCE_NO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_ONLY_SINCE_YES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_PASSWORD_CHECK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_POP3_SUCCESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_POPUP_FAILURE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_POPUP_SUCCESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_POPUP_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_QUEUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_SAVE_RAW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_SAVE_RAW_DESC_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_SAVE_RAW_DESC_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_SSL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_SSL_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_SYSTEM_DEFAULT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_TEST_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_TEST_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_TEST_SETTINGS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_TEST_SUCCESSFUL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_TEST_WAIT_MESSAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_TLS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_TLS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_WARN_IMAP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_WARN_IMAP_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LBL_WARN_NO_IMAP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LNK_CREATE_GROUP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LNK_LIST_QUEUES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LNK_LIST_SCHEDULER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LNK_LIST_TEST_IMPORT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LNK_NEW_QUEUES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'InboundEmail.LNK_SEED_QUEUES';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Invoices' and NAME = 'LBL_ADD_COMMENT_BUTTON_LABEL') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_ADD_COMMENT_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_ADD_GROUP_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_ADD_ROW_BUTTON_LABEL';
-- 01/20/2009 Paul.  LBL_SHOW_LINE_NUMS is used in ~/_controls/EditLineItemsView.ascx.
--	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_CALC_GRAND_TOTAL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_DELETE_GROUP_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_GRAND_TOTAL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_GROUP_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_GROUP_STAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_BILLING_ACCOUNT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_BILLING_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_BOOK_VALUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_CALC_GRAND_TOTAL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_CITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_CONVERSION_RATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_COST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_COUNTRY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_CURRENCY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_POSTAL_CODE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_PRODUCT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_SHIPPER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_SHIPPING_ACCOUNT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_SHIPPING_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_SHOW_LINE_NUMS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_STATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_STREET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_LIST_TAXRATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_NEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_REMOVE_COMMENT_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_REMOVE_ROW_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_SEARCH_FORM_TITLE';
-- 01/20/2009 Paul.  LBL_SHOW_LINE_NUMS is used in ~/_controls/EditLineItemsView.ascx.
--	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LBL_SHOW_LINE_NUMS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Invoices.LNK_REPORTS';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Leads' and NAME = 'db_account_name') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.db_account_name';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.db_email1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.db_email2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.db_first_name';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.db_last_name';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.db_title';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_ACTIVITIES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_ADD_BUSINESSCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_ALT_ADDRESS_STREET_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_ALT_ADDRESS_STREET_3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_BACKTOLEADS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_BUSINESSCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_CAMPAIGN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_CAMPAIGN_LIST_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_CONTACT_OPP_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_CONTACT_ROLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_CONVERTLEAD_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_CREATED_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_CREATED_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_CREATED_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_CREATED_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_CREATED_OPPORTUNITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_DUPLICATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_EXISTING_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_EXISTING_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_EXISTING_OPPORTUNITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_FULL_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_HISTORY_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_IMPORT_VCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_IMPORT_VCARDTEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_INVITEE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_LIST_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_LIST_CONTACT_ROLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_NEW_PORTAL_PASSWORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_OPP_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_PORTAL_ACTIVE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_PORTAL_INFORMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_PORTAL_PASSWORD_ISSET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_PRIMARY_ADDRESS_STREET_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_PRIMARY_ADDRESS_STREET_3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_SERVER_IS_CURRENTLY_UNAVAILABLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_TARGET_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_TARGET_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_TARGET_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_THANKS_FOR_SUBMITTING_LEAD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LBL_VIEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.LNK_IMPORT_VCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.MSG_DUPLICATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.NTC_COPY_ALTERNATE_ADDRESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.NTC_COPY_PRIMARY_ADDRESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.NTC_DELETE_CONFIRMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.NTC_OPPORTUNITY_REQUIRES_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.NTC_REMOVE_CONFIRMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Leads.NTC_REMOVE_DIRECT_REPORT_CONFIRMATION';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Meetings' and NAME = 'ERR_DELETE_RECORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_ACCEPT_THIS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_BLANK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_COLON';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_CONTACTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_DEFAULT_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_DEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_DESCRIPTION_INFORMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_HISTORY_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_HOURS_MINS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_INVITEE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_LIST_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_LIST_DUE_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_MODIFIED_BY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_SEARCH_BUTTON';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_SEND_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_SEND_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_SEND_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LBL_USERS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LNK_CALL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LNK_EMAIL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LNK_NEW_APPOINTMENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LNK_NEW_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LNK_NEW_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LNK_NEW_NOTE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LNK_NEW_TASK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LNK_NOTE_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LNK_TASK_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Meetings.LNK_VIEW_CALENDAR';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Notes' and NAME = 'ERR_DELETE_RECORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.ERR_REMOVING_ATTACHMENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_ACCOUNT_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_ASSIGNED_USER_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_CASE_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_CLOSE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_COLON';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_FILE_URL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_LEAD_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_LIST_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_LIST_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_LIST_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_MEMBER_OF';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_NOTE_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_NOTES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_OPPORTUNITY_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_PRODUCT_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_QUOTE_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_RELATED_TO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_REMOVING_ATTACHMENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LBL_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LNK_CALL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LNK_EMAIL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LNK_MEETING_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LNK_NEW_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LNK_NEW_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LNK_NEW_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LNK_NEW_TASK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LNK_TASK_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Notes.LNK_VIEW_CALENDAR';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Opportunities' and NAME = 'db_amount') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.db_amount';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.db_date_closed';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.db_name';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.db_sales_stage';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.ERR_DELETE_RECORD';
	-- 02/11/2009 Paul.  LBL_ACCOUNT_ID is a field. 
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_ACCOUNT_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_ACTIVITIES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_CAMPAIGN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_CONTACTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_DUPLICATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_HISTORY_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_INVITEE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_LEADS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_LIST_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_OPPORTUNITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_PROJECTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_RAW_AMOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LBL_VIEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.LNK_OPPORTUNITY_REPORTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.MSG_DUPLICATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_BUG_COUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_BUGFOUND_COUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_COUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_CREATE_CURRENCY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_DOLLARAMOUNTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_DOLLARAMOUNTS_TXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_DONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_FAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_FIX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_FIX_TXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_INCLUDE_CLOSE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_MERGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_MERGE_TXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_NULL_VALUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_RESTORE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_RESTORE_COUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_RESTORE_TXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_VERIFY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_VERIFY_CURAMOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_VERIFY_FAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_VERIFY_FIX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_VERIFY_NEWAMOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_VERIFY_NEWCURRENCY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Opportunities.UPDATE_VERIFY_TXT';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Orders' and NAME = 'LBL_ADD_COMMENT_BUTTON_LABEL') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_ADD_COMMENT_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_ADD_GROUP_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_ADD_ROW_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_DELETE_GROUP_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_GRAND_TOTAL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_GROUP_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_GROUP_STAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_BILLING_ACCOUNT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_BILLING_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_BOOK_VALUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_CITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_CONVERSION_RATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_COST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_COUNTRY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_CURRENCY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_OPPORTUNITY_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_ORDER_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_POSTAL_CODE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_PRODUCT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_SHIPPER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_SHIPPING_ACCOUNT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_SHIPPING_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_STATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_STREET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_LIST_TAXRATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_NEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_REMOVE_COMMENT_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_REMOVE_ROW_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Orders.LNK_REPORTS';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Payments' and NAME = 'LBL_ADDRESS_CITY') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_ADDRESS_CITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_ADDRESS_COUNTRY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_ADDRESS_POSTALCODE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_ADDRESS_STATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_ADDRESS_STREET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_AUTHORIZATION_CODE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_AVS_CODE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_BANK_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_CARD_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_CARD_NUMBER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_CARD_NUMBER_DISPLAY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_CARD_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_CONVERSION_RATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_ERROR_CODE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_ERROR_MESSAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_INVOICE_NUMBER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_ADDRESS_CITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_ADDRESS_COUNTRY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_ADDRESS_POSTALCODE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_ADDRESS_STATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_ADDRESS_STREET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_AMOUNT_DUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_AVS_CODE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_BANK_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_CARD_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_CARD_NUMBER_DISPLAY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_CARD_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_CONVERSION_RATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_EMAIL';
	-- 02/11/2009 Paul.  LBL_LIST_ERROR_MESSAGE is a field. 
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_ERROR_MESSAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_INVOICE_NUMBER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_PAYMENT_GATEWAY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_PAYMENT_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_PHONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_REFERENCE_NUMBER';
	-- 02/11/2009 Paul.  LBL_LIST_STATUS is a field. 
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_LIST_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_PAYMENT_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_PHONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_REFERENCE_NUMBER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_TRANSACTION_NUMBER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LBL_TRANSACTION_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Payments.LNK_REPORTS';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Posts' and NAME = 'LBL_DESCRIPTION_HTML') begin -- then
	-- 02/11/2009 Paul.  LBL_DESCRIPTION_HTML is a field name. 
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Posts.LBL_DESCRIPTION_HTML';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Posts.LBL_LIST_DESCRIPTION_HTML';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Posts.LBL_SEARCH_FORM_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'ProductCategories' and NAME = 'LBL_LIST_PARENT') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProductCategories.LBL_LIST_PARENT';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Products' and NAME = 'LBL_ACCOUNT') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Products.LBL_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Products.LBL_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Products.LBL_COST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Products.LBL_DATE_COST_PRICE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Products.LBL_LIST_CATEGORY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Products.LBL_LIST_CURRENCY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Products.LBL_LIST_MANUFACTURER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Products.LBL_LIST_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Products.LBL_SEARCH_FORM_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'ProductTemplates' and NAME = 'LBL_LIST_ACCOUNT_NAME') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProductTemplates.LBL_LIST_BOOK_VALUE_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProductTemplates.LBL_LIST_CURRENCY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProductTemplates.LBL_PRICING_FACTOR_PERCENTAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProductTemplates.LBL_PRICING_FACTOR_POINTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProductTemplates.LBL_SEARCH_FORM_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Project' and NAME = 'LBL_ACCOUNT_SUBPANEL_TITLE') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_ACCOUNT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_ACCOUNTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_ACTIVITIES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_ACTIVITIES_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_CONTACT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_CONTACTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_HISTORY_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_HISTORY_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_OPPORTUNITIES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_OPPORTUNITY_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_PROJECT_TASK_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_PROJECT_TASKS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_QUICK_NEW_PROJECT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_QUOTE_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Project.LBL_SEARCH_FORM_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'ProjectTask' and NAME = 'DATE_JS_ERROR') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProjectTask.DATE_JS_ERROR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProjectTask.LBL_ACTIVITIES_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProjectTask.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProjectTask.LBL_HISTORY_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProjectTask.LBL_HISTORY_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProjectTask.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProjectTask.LBL_SEARCH_FORM_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'ProspectLists' and NAME = 'LBL_ASSIGNED_TO') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_CONTACTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_COPY_PREFIX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_DATE_CREATED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_DATE_LAST_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_DOMAIN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_ENTRIES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_LEADS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_LIST_END_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_LIST_PROSPECTLIST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_LIST_TYPE_LIST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_LIST_TYPE_NO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_MARKETING_MESSAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_MODIFIED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_MODIFIED_BY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_MODULE_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_PROSPECT_LISTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_PROSPECTS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_TEAM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'ProspectLists.LBL_USERS_SUBPANEL_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Prospects' and NAME = 'db_email1') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.db_email1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.db_email2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.db_first_name';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.db_last_name';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.db_title';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_ADD_BUSINESSCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_ADDMORE_BUSINESSCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_BACKTO_PROSPECTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_BUSINESSCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_CAMPAIGN_LIST_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_CAMPAIGNS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_CONVERT_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_CREATED_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_CREATED_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_CREATED_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_CREATED_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_CREATED_OPPORTUNITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_CREATED_PROSPECT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_DUPLICATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_EDIT_ACCOUNT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_EXISTING_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_EXISTING_PROSPECT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_IMPORT_VCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_IMPORT_VCARDTEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_INVITEE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_LIST_OTHER_EMAIL_ADDRESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_LIST_PROSPECT_ROLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_MODULE_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_OPP_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_PROSPECT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_PROSPECT_ROLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_SAVE_PROSPECT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LNK_IMPORT_VCARD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LNK_NEW_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LNK_NEW_APPOINTMENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LNK_NEW_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LNK_NEW_CASE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LNK_NEW_CONTACT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LNK_NEW_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LNK_NEW_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LNK_NEW_NOTE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LNK_NEW_OPPORTUNITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LNK_NEW_TASK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.LNK_SELECT_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.MSG_DUPLICATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.MSG_SHOW_DUPLICATES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.NTC_COPY_ALTERNATE_ADDRESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.NTC_COPY_PRIMARY_ADDRESS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.NTC_DELETE_CONFIRMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.NTC_OPPORTUNITY_REQUIRES_ACCOUNT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.NTC_REMOVE_CONFIRMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Prospects.NTC_REMOVE_DIRECT_REPORT_CONFIRMATION';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Quotes' and NAME = 'LBL_ADD_COMMENT_BUTTON_LABEL') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_ADD_COMMENT_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_ADD_GROUP_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_ADD_ROW_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_DELETE_GROUP_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_GRAND_TOTAL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_GROUP_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_GROUP_STAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_BILLING_ACCOUNT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_BILLING_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_BOOK_VALUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_CITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_CONVERSION_RATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_COST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_COUNTRY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_CURRENCY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_OPPORTUNITY_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_POSTAL_CODE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_PRODUCT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_SHIPPER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_SHIPPING_ACCOUNT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_SHIPPING_CONTACT_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_STATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_STREET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_LIST_TAXRATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_REMOVE_COMMENT_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_REMOVE_ROW_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Quotes.LBL_SEARCH_FORM_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Relationships' and NAME = 'LBL_DELETED') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_DELETED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_ID';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_JOIN_KEY_LHS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_JOIN_KEY_RHS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_JOIN_TABLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_LHS_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_LHS_MODULE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_LHS_TABLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_RELATIONSHIP_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_RELATIONSHIP_ROLE_COLUMN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_RELATIONSHIP_ROLE_COLUMN_VALUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_RELATIONSHIP_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_REVERSE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_RHS_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_RHS_MODULE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Relationships.LBL_RHS_TABLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Releases' and NAME = 'ERR_DELETE_RECORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Releases.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Releases.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Releases.LBL_NEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Releases.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Releases.NTC_DELETE_CONFIRMATION';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Reports' and NAME = 'LBL_ADD_COLUMN_BUTTON_LABEL') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_ADD_COLUMN_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_CHART_DESCRIPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_CHART_OPTIONS_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_CHART_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_DATA_SERIES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_DISPLAY_COLUMNS_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_DISPLAY_SUMMARIES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_DISPLAY_SUMMARIES_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_FILTERS_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_GROUP_BY';
	-- 02/11/2009 Paul.  LBL_LIST_FORM_TITLE is used. 
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_LIST_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_LIST_SCHEDULE_REPORT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_SCHEDULE_REPORT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_SHOW_DETAILS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LBL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LNK_DELETE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Reports.LNK_EXPORT_RDL';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Roles' and NAME = 'LBL_DEFAULT_SUBPANEL_TITLE') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Roles.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Roles.LBL_LANGUAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Roles.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Roles.LBL_USERS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Roles.LBL_USERS_SUBPANEL_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'SavedSearch' and NAME = 'LBL_DELETE_BUTTON_TITLE') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'SavedSearch.LBL_DELETE_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'SavedSearch.LBL_DELETE_CONFIRM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'SavedSearch.LBL_LIST_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'SavedSearch.LBL_LIST_MODULE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'SavedSearch.LBL_LIST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'SavedSearch.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'SavedSearch.LBL_PREVIOUS_SAVED_SEARCH';
	exec dbo.spTERMINOLOGY_DeleteTerm 'SavedSearch.LBL_PREVIOUS_SAVED_SEARCH_HELP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'SavedSearch.LBL_SAVE_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'SavedSearch.LBL_SAVE_SEARCH_AS_HELP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'SavedSearch.LBL_SEARCH_FORM_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Schedulers' and NAME = 'ERR_DELETE_RECORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_ALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_AT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_AT_THE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_CRON_INSTRUCTIONS_LINUX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_CRON_INSTRUCTIONS_WINDOWS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_CRON_LINUX_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_CRON_WINDOWS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_EVERY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_EVERY_DAY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_EXECUTE_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_FRI';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_JOBS_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_LIST_EXECUTE_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_LIST_LIST_ORDER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_LIST_REMOVE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_MINUTES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_NEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_NO_PHP_CLI';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_OOTB_BOUNCE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_OOTB_CAMPAIGN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_OOTB_IE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_OOTB_PRUNE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_OOTB_REPORTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_OOTB_WORKFLOW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_RUN_NOW';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_SAT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_SUN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_THU';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_TOGGLE_ADV';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_TOGGLE_BASIC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_TUE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_WARN_CURL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_WARN_CURL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_WARN_NO_CURL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LBL_WED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.LNK_LIST_SCHEDULED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.NTC_DELETE_CONFIRMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.NTC_LIST_ORDER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.NTC_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Schedulers.SOCK_GREETING';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Shortcuts' and NAME = 'LNK_INS') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Shortcuts.LNK_INS';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Tasks' and NAME = 'ERR_DELETE_RECORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.DATE_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.ERR_INVALID_HOUR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_COLON';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_CONTACT_FIRST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_CONTACT_LAST_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_DEFAULT_PRIORITY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_DEFAULT_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_DESCRIPTION_INFORMATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_DUE_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_LIST_ASSIGNED_TO_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_LIST_COMPLETE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_LIST_DUE_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_LIST_START_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_LIST_START_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_MODULE_NAME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_NEW_FORM_DUE_DATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_NEW_FORM_DUE_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_NEW_FORM_SUBJECT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_NEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_NEW_TIME_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_START_TIME';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LBL_TASK';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LNK_CALL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LNK_EMAIL_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LNK_MEETING_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LNK_NEW_CALL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LNK_NEW_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LNK_NEW_MEETING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LNK_NEW_NOTE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LNK_NOTE_LIST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Tasks.LNK_VIEW_CALENDAR';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'TeamNotices' and NAME = 'LBL_SEARCH_FORM_TITLE') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'TeamNotices.LBL_SEARCH_FORM_TITLE';
end -- if;
GO

-- 08/20/2010 Paul.  LBL_PRIVATE_TEAM_DESC is used in spTEAMS_InsertPrivate. 
if exists(select * from TERMINOLOGY where MODULE_NAME = 'Teams' and NAME = 'LBL_MEMBERSHIP') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Teams.LBL_MEMBERSHIP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Teams.LBL_NEW_FORM_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Threads' and NAME = 'LBL_LAST_POST_CREATED_BY') begin -- then
	-- 02/11/2009 Paul.  LBL_LAST_POST_CREATED_BY and LBL_LAST_POST_TITLE are field names. 
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Threads.LBL_LAST_POST_CREATED_BY';
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Threads.LBL_LAST_POST_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Threads.LBL_LIST_MODIFIED_BY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Threads.LBL_SEARCH_FORM_TITLE';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Users' and NAME = 'ERR_DELETE_RECORD') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.ERR_DELETE_RECORD';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.ERR_EMAIL_NO_OPTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.ERR_IE_FAILURE1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.ERR_IE_FAILURE2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.ERR_IE_MISSING_REQUIRED';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.ERR_LAST_ADMIN_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.ERR_LAST_ADMIN_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.ERR_PASSWORD_CHANGE_FAILED_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.ERR_PASSWORD_CHANGE_FAILED_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.ERR_PASSWORD_INCORRECT_OLD_1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.ERR_PASSWORD_INCORRECT_OLD_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.ERR_PASSWORD_MISMATCH';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.ERR_REPORT_LOOP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_APPLY_OPTIMUMS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_ASSIGN_TO_USER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_BASIC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_BUTTON_CREATE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_BUTTON_EDIT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_CERT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_CERT_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_CHOOSE_WHICH';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_CLEAR_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_CURRENCY_EXAMPLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_CURRENCY_SIG_DIGITS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_CURRENCY_SIG_DIGITS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_DEFAULT_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_DISPLAY_TABS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EDIT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EDIT_TABS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EMAIL_CHARSET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EMAIL_EDITOR_OPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EMAIL_INBOUND_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EMAIL_LINK_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EMAIL_OTHER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EMAIL_OUTBOUND_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EMAIL_SHOW_COUNTS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EMAIL_SIGNATURE_ERROR1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EXPORT_CHARSET';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EXPORT_CHARSET_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EXPORT_DELIMITER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_EXPORT_DELIMITER_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_FAX_PHONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_FIND_OPTIMUM_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_FIND_OPTIMUM_MSG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_FIND_OPTIMUM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_FORCE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_FORCE_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_FOUND_OPTIMUM_MSG';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_GROUP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_GROUP_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_GROUP_USER_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_HIDE_TABS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_INBOUND_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LAYOUT_OPTIONS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LDAP_ERROR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LDAP_EXTENSION_ERROR';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LIST_ACCEPT_STATUS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LIST_LIST_PRICE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LIST_MEMBERSHIP';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LIST_USER_AGENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LOCALE_DEFAULT_NAME_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LOCALE_DESC_FIRST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LOCALE_DESC_LAST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LOCALE_DESC_SALUTATION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LOCALE_EXAMPLE_NAME_FORMAT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LOCALE_NAME_FORMAT_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LOCALE_NAME_FORMAT_DESC_2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LOGIN_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_LOGIN_WELCOME_TO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAIL_SENDTYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAIL_SMTPAUTH_REQ';
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAIL_SMTPPASS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAIL_SMTPPORT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAIL_SMTPSERVER';
	--exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAIL_SMTPUSER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAILBOX';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAILBOX_DEFAULT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAILBOX_SSL_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAILBOX_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAILMERGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAILMERGE_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MARK_READ';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MARK_READ_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MARK_READ_NO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MARK_READ_YES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAX_SUBTAB';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAX_SUBTAB_DESCRIPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAX_TAB';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MAX_TAB_DESCRIPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_MODULE_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_NAVIGATION_PARADIGM';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_NAVIGATION_PARADIGM_DESCRIPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_NEW_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_NEW_PASSWORD1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_NEW_PASSWORD2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_NEW_USER_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_NEW_USER_BUTTON_LABEL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_NEW_USER_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_ONLY_SINCE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_ONLY_SINCE_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_ONLY_SINCE_NO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_ONLY_SINCE_YES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_OTHER_PHONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_OWN_OPPS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_OWN_OPPS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_PHONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_PROMPT_TIMEZONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_PROMPT_TIMEZONE_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_REMOVED_TABS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_REPORTS_TO';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_RESET_HOMEPAGE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_RESET_HOMEPAGE_WARNING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_RESET_PREFERENCES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_RESET_PREFERENCES_WARNING';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_ROLES_SUBPANEL_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SEARCH_FORM_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SERVER_OPTIONS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SERVER_TYPE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SERVER_URL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SETTINGS_URL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SETTINGS_URL_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SIGNATURE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SIGNATURE_DEFAULT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SIGNATURE_HTML';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SIGNATURE_PREPEND';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SIGNATURES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SSL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SSL_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SUBPANEL_LINKS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SUBPANEL_LINKS_DESCRIPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SUBPANEL_TABS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SUBPANEL_TABS_DESCRIPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SUGAR_LOGIN';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SUPPORTED_THEME_ONLY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SWAP_LAST_VIEWED_DESCRIPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SWAP_LAST_VIEWED_POSITION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SWAP_SHORTCUT_DESCRIPTION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_SWAP_SHORTCUT_POSITION';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_TAB_TITLE_EMAIL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_TAB_TITLE_USER';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_TEST_BUTTON_KEY';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_TEST_BUTTON_TITLE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_TEST_SETTINGS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_TEST_SUCCESSFUL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_TIMEZONE_DST';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_TIMEZONE_DST_TEXT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_TLS';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_TLS_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_TOGGLE_ADV';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_USE_REAL_NAMES';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_USE_REAL_NAMES_DESC';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_USER_AGENT';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_USER_LOCALE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_WORK_PHONE';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_YOUR_QUERY_URL';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Users.LBL_ZONE_TEXT';
end -- if;
GO

if exists(select * from TERMINOLOGY where MODULE_NAME = 'Import' and NAME = 'LBL_IMPORT_STEP1') begin -- then
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_STEP1';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_STEP2';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_STEP3';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_STEP4';
	exec dbo.spTERMINOLOGY_DeleteTerm 'Import.LBL_IMPORT_STEP5';
end -- if;
GO

-- 10/21/2010 Paul.  IMAP is now supported, but we need to delete existing records, otherwise InsertOnly will do nothing. 
-- 05/25.2014 Paul.  This file is getting executed in the wrong order, so IMAP record is still not getting created.  Just undelete. 
if exists(select *
            from TERMINOLOGY
           where NAME         = 'imap'
             and MODULE_NAME is null
             and LIST_NAME    = 'dom_email_server_type'
             and DELETED      = 1) begin -- then
	update TERMINOLOGY
	   set DELETED          = 0
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = null
	 where NAME             = 'imap'
	   and MODULE_NAME is null
	   and LIST_NAME        = 'dom_email_server_type'
	   and DELETED          = 1;
end -- if;
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

call dbo.spTERMINOLOGY_delete_unused()
/

call dbo.spSqlDropProcedure('spTERMINOLOGY_delete_unused')
/

-- #endif IBM_DB2 */

