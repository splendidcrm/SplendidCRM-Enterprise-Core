

print 'WORKFLOWS Calls Notification';
GO

set nocount on;
GO

declare @ID uniqueidentifier;
set @ID = '72daf748-dd45-4369-a0dc-cc8ac6189ade';
if not exists(select * from WORKFLOW where ID = @ID) begin -- then
	exec dbo.spWORKFLOWS_Update @ID, null, 'Calls Notification', 'Calls', 'CALLS_AUDIT', 1, 'normal', 'alerts_actions', 'all', null, 'select *
  from            vwCALLS_AUDIT           CALLS
  left outer join vwCALLS_AUDIT      CALLS_AUDIT_OLD
               on CALLS_AUDIT_OLD.ID = CALLS.ID
              and CALLS_AUDIT_OLD.AUDIT_VERSION = (select max(vwCALLS_AUDIT.AUDIT_VERSION)
                                                  from vwCALLS_AUDIT
                                                 where vwCALLS_AUDIT.ID            =  CALLS.ID
                                                   and vwCALLS_AUDIT.AUDIT_VERSION <  CALLS.AUDIT_VERSION
                                                   and vwCALLS_AUDIT.AUDIT_TOKEN   <> CALLS.AUDIT_TOKEN
                                               )
  left outer join vwUSERS                     USERS_ASSIGNED_USER_ID
               on USERS_ASSIGNED_USER_ID.ID = CALLS.ASSIGNED_USER_ID
 where CALLS.AUDIT_ID = @AUDIT_ID
   and CALLS.DELETED  = 0
   and (CALLS_AUDIT_OLD.AUDIT_ID is null      or (not(CALLS.ASSIGNED_USER_ID             is null     and CALLS_AUDIT_OLD.ASSIGNED_USER_ID             is null    ) and (CALLS.ASSIGNED_USER_ID             <> CALLS_AUDIT_OLD.ASSIGNED_USER_ID             or CALLS.ASSIGNED_USER_ID is null or CALLS_AUDIT_OLD.ASSIGNED_USER_ID is null)))
   and USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS = 1
   and USERS_ASSIGNED_USER_ID.EMAIL1 is not null
   and CALLS.REPEAT_PARENT_ID is null
', '<?xml version="1.0" encoding="UTF-8"?><Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><CustomProperties><CustomProperty><Name>crm:Module</Name><Value>Calls</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;fc05339a-12e0-4ee2-8c19-097270e63d86&lt;/ID&gt;&lt;MODULE&gt;Calls&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Calls CALLS_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;CALLS_AUDIT_OLD&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;CALLS_AUDIT_OLD.ASSIGNED_USER_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;ASSIGNED_USER_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;guid&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;changed&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;6b764cbd-4899-43d5-ad96-842d9217071a&lt;/ID&gt;&lt;MODULE&gt;Users&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;USERS_ASSIGNED_USER_ID&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;RECEIVE_NOTIFICATIONS&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;bool&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;equals&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;1&lt;/SEARCH_TEXT&gt;&lt;SEARCH_TEXT_VALUES&gt;1&lt;/SEARCH_TEXT_VALUES&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;c72dca28-5095-45c3-a7aa-75992a921b09&lt;/ID&gt;&lt;MODULE&gt;Users&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;USERS_ASSIGNED_USER_ID&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;USERS_ASSIGNED_USER_ID.EMAIL1&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;EMAIL1&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;string&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;not_empty&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;473002b9-01d4-4332-8b97-2f8e21abd516&lt;/ID&gt;&lt;MODULE&gt;Calls&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Calls CALLS&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;CALLS&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;CALLS.REPEAT_PARENT_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;REPEAT_PARENT_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;guid&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;empty&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties><DataSets><DataSet><Query><CommandText>select *
  from            vwCALLS_AUDIT           CALLS
  left outer join vwCALLS_AUDIT      CALLS_AUDIT_OLD
               on CALLS_AUDIT_OLD.ID = CALLS.ID
              and CALLS_AUDIT_OLD.AUDIT_VERSION = (select max(vwCALLS_AUDIT.AUDIT_VERSION)
                                                  from vwCALLS_AUDIT
                                                 where vwCALLS_AUDIT.ID            =  CALLS.ID
                                                   and vwCALLS_AUDIT.AUDIT_VERSION &lt;  CALLS.AUDIT_VERSION
                                                   and vwCALLS_AUDIT.AUDIT_TOKEN   &lt;&gt; CALLS.AUDIT_TOKEN
                                               )
  left outer join vwUSERS                     USERS_ASSIGNED_USER_ID
               on USERS_ASSIGNED_USER_ID.ID = CALLS.ASSIGNED_USER_ID
 where CALLS.AUDIT_ID = @AUDIT_ID
   and CALLS.DELETED  = 0
   and (CALLS_AUDIT_OLD.AUDIT_ID is null      or (not(CALLS.ASSIGNED_USER_ID             is null     and CALLS_AUDIT_OLD.ASSIGNED_USER_ID             is null    ) and (CALLS.ASSIGNED_USER_ID             &lt;&gt; CALLS_AUDIT_OLD.ASSIGNED_USER_ID             or CALLS.ASSIGNED_USER_ID is null or CALLS_AUDIT_OLD.ASSIGNED_USER_ID is null)))
   and USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS = 1
   and USERS_ASSIGNED_USER_ID.EMAIL1 is not null
   and CALLS.REPEAT_PARENT_ID is null
</CommandText></Query><Fields></Fields></DataSet></DataSets></Report>', null;

	exec dbo.spWORKFLOWS_UpdateXOML @ID, null, 0, '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="72daf748-dd45-4369-a0dc-cc8ac6189ade" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">

<SequenceActivity x:Name="Sequence1" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:CallActivity x:Name="Calls1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}">
		<crm:WorkflowLogActivity x:Name="Calls1_Log" MODULE_TABLE="CALLS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

		<CodeActivity x:Name="Calls1_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Calls1,Path=LoadByAUDIT_ID}" />
	</crm:CallActivity>
	<crm:AlertActivity x:Name="Alert1" SUBJECT="SplendidCRM Call - $call_name" ALERT_TYPE="Notification" SOURCE_TYPE="normal message" CUSTOM_TEMPLATE_ID="00000000-0000-0000-0000-000000000000" AUDIT_ID="{ActivityBind Calls1,Path=AUDIT_ID}" PARENT_ID="{ActivityBind Calls1,Path=ID}" PARENT_TYPE="Calls" PARENT_ACTIVITY="Calls1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" ALERT_TEXT="$call_modified_by has assigned an Call to $call_assigned_to.&#xA;&#xA;Subject: $call_name&#xA;Status: $call_status&#xA;Start Date: $call_date_start&#xA;Duration: $call_duration_hours hours, $call_duration_minutes minutes&#xA;Description: $call_description&#xA;&#xA;You may review this Call at:&#xA;&lt;a href=&quot;$view_url&quot;&gt;$view_url&lt;/a&gt;&#xA;&#xA;">
		<crm:WorkflowLogActivity x:Name="Alert1_Log" MODULE_TABLE="MEETINGS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />
		<crm:AddRecipientActivity x:Name="Alert1_Calls1_AssignedUserID" ALERT_NAME="Alert1" RECIPIENT_NAME="" RECIPIENT_ID="{ActivityBind Calls1,Path=ASSIGNED_USER_ID}" RECIPIENT_TYPE="User" SEND_TYPE="to" RECIPIENT_TABLE="" RECIPIENT_FIELD="" />

		<CodeActivity x:Name="Alert1_Send" ExecuteCode="{ActivityBind Alert1,Path=Send}" />
	</crm:AlertActivity>
</SequenceActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_ALERT_SHELLS_InsertOnly null, @ID, 'SplendidCRM Call - $call_name', 'Notification', 'normal message', null, '$call_modified_by has assigned an Call to $call_assigned_to.

Subject: $call_name
Status: $call_status
Start Date: $call_date_start
Duration: $call_duration_hours hours, $call_duration_minutes minutes
Description: $call_description

You may review this Call at:
<a href="$view_url">$view_url</a>

', '<?xml version="1.0" encoding="UTF-8"?><Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><Width>11in</Width><PageWidth>11in</PageWidth><PageHeight>8.5in</PageHeight><LeftMargin>.5in</LeftMargin><RightMargin>.5in</RightMargin><TopMargin>.5in</TopMargin><BottomMargin>.5in</BottomMargin><Description></Description><Author></Author><CustomProperties><CustomProperty><Name>crm:Module</Name><Value>Calls</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:RelatedModules</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;calls_contacts&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Calls&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CALLS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Contacts&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;CONTACTS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;CALLS_CONTACTS&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;CALL_ID&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;CONTACT_ID&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Contacts CONTACTS calls_contacts&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Contacts CONTACTS] Calls Contacts&lt;/DISPLAY_NAME&gt;&lt;RELATIONSHIP_ROLE_COLUMN&gt;&lt;/RELATIONSHIP_ROLE_COLUMN&gt;&lt;RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;calls_users&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Calls&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CALLS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Users&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;USERS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;CALLS_USERS&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;CALL_ID&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;USER_ID&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Users USERS calls_users&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS] Calls Users&lt;/DISPLAY_NAME&gt;&lt;RELATIONSHIP_ROLE_COLUMN&gt;&lt;/RELATIONSHIP_ROLE_COLUMN&gt;&lt;RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;calls_leads&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Calls&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CALLS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Leads&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;LEADS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;CALLS_LEADS&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;CALL_ID&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;LEAD_ID&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Leads LEADS calls_leads&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Leads LEADS] Calls Leads&lt;/DISPLAY_NAME&gt;&lt;RELATIONSHIP_ROLE_COLUMN&gt;&lt;/RELATIONSHIP_ROLE_COLUMN&gt;&lt;RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;calls_notes&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Calls&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CALLS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Notes&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;NOTES&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;PARENT_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Notes NOTES calls_notes&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Notes NOTES] Notes&lt;/DISPLAY_NAME&gt;&lt;RELATIONSHIP_ROLE_COLUMN&gt;&lt;/RELATIONSHIP_ROLE_COLUMN&gt;&lt;RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/Relationship&gt;
&lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Relationships</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;Calls&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Calls&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CALLS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;CALLS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Calls CALLS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Calls CALLS] Calls&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;calls_audit_old&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Calls&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CALLS_AUDIT&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Calls&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;CALLS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;CALLS_AUDIT_OLD&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Calls CALLS_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Calls CALLS_AUDIT_OLD] Calls: Audit Old&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;users_all&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_ALL&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_ALL&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_ALL] Users All&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;teams&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Teams&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;TEAMS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;TEAMS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Teams TEAMS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Teams TEAMS] Teams&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;roles&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;ACLRoles&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;ACL_ROLES&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;ACL_ROLES&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;ACLRoles ACL_ROLES&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Roles ACL_ROLES] Roles&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;
&lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;2ceaddb8-e831-4eb4-ba24-ac2e12747200&lt;/ID&gt;&lt;ACTION_TYPE&gt;current_user&lt;/ACTION_TYPE&gt;&lt;RELATIONSHIP_NAME&gt;&lt;/RELATIONSHIP_NAME&gt;&lt;MODULE&gt;Calls&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Calls CALLS&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;CALLS&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;CALLS.ASSIGNED_USER_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;ASSIGNED_USER_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;to&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;RECIPIENT_NAME&gt;&lt;/RECIPIENT_NAME&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties><DataSources><DataSource Name="dataSource1"><ConnectionProperties><DataProvider>SQL</DataProvider><ConnectString></ConnectString></ConnectionProperties></DataSource></DataSources><DataSets><DataSet Name="dataSet"><Query><DataSourceName>dataSource1</DataSourceName><CommandText></CommandText></Query><Fields></Fields></DataSet></DataSets><Body><ReportItems><Table Name="table1"><DataSetName>dataSet</DataSetName><Header><RepeatOnNewPage>true</RepeatOnNewPage><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Header><Details><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Details><TableColumns></TableColumns></Table></ReportItems><Height>8.5in</Height></Body></Report>', '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="72daf748-dd45-4369-a0dc-cc8ac6189ade" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
	<crm:CallActivity x:Name="Calls2" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="Calls2_Log" MODULE_TABLE="CALLS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

		<CodeActivity x:Name="Calls2_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Calls2,Path=LoadByAUDIT_ID}" />
	</crm:CallActivity>
	<crm:AlertActivity x:Name="Alert2" SUBJECT="SplendidCRM Call - $call_name" ALERT_TYPE="Notification" SOURCE_TYPE="normal message" CUSTOM_TEMPLATE_ID="00000000-0000-0000-0000-000000000000" AUDIT_ID="{ActivityBind Calls2,Path=AUDIT_ID}" PARENT_ID="{ActivityBind Calls2,Path=ID}" PARENT_TYPE="Calls" PARENT_ACTIVITY="Calls2" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" ALERT_TEXT="$call_modified_by has assigned an Call to $call_assigned_to.&#xA;&#xA;Subject: $call_name&#xA;Status: $call_status&#xA;Start Date: $call_date_start&#xA;Duration: $call_duration_hours hours, $call_duration_minutes minutes&#xA;Description: $call_description&#xA;&#xA;You may review this Call at:&#xA;&lt;a href=&quot;$view_url&quot;&gt;$view_url&lt;/a&gt;&#xA;&#xA;" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="Alert2_Log" MODULE_TABLE="MEETINGS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />
		<crm:AddRecipientActivity x:Name="Alert2_Calls2_AssignedUserID" ALERT_NAME="Alert2" RECIPIENT_NAME="" RECIPIENT_ID="{ActivityBind Calls2,Path=ASSIGNED_USER_ID}" RECIPIENT_TYPE="User" SEND_TYPE="to" RECIPIENT_TABLE="" RECIPIENT_FIELD="" />

		<CodeActivity x:Name="Alert2_Send" ExecuteCode="{ActivityBind Alert2,Path=Send}" />
	</crm:AlertActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'EMAIL1', 'compare_specific', 'Primary', 'not_empty', 0, 'Users', null, null;
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

call dbo.spWORKFLOWS_Calls_Notification()
/

call dbo.spSqlDropProcedure('spWORKFLOWS_Calls_Notification')
/

-- #endif IBM_DB2 */

