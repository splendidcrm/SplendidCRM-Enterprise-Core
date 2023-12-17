

print 'WORKFLOWS Meetings Notification';
GO

set nocount on;
GO

declare @ID uniqueidentifier;
set @ID = '8df58b29-0f2d-4326-b2a9-e85873f90656';
if not exists(select * from WORKFLOW where ID = @ID) begin -- then
	exec dbo.spWORKFLOWS_Update @ID, null, 'Meetings Notification', 'Meetings', 'MEETINGS_AUDIT', 1, 'normal', 'alerts_actions', 'all', null, 'select *
  from            vwMEETINGS_AUDIT        MEETINGS
  left outer join vwMEETINGS_AUDIT      MEETINGS_AUDIT_OLD
               on MEETINGS_AUDIT_OLD.ID = MEETINGS.ID
              and MEETINGS_AUDIT_OLD.AUDIT_VERSION = (select max(vwMEETINGS_AUDIT.AUDIT_VERSION)
                                                  from vwMEETINGS_AUDIT
                                                 where vwMEETINGS_AUDIT.ID            =  MEETINGS.ID
                                                   and vwMEETINGS_AUDIT.AUDIT_VERSION <  MEETINGS.AUDIT_VERSION
                                                   and vwMEETINGS_AUDIT.AUDIT_TOKEN   <> MEETINGS.AUDIT_TOKEN
                                               )
  left outer join vwUSERS                     USERS_ASSIGNED_USER_ID
               on USERS_ASSIGNED_USER_ID.ID = MEETINGS.ASSIGNED_USER_ID
 where MEETINGS.AUDIT_ID = @AUDIT_ID
   and MEETINGS.DELETED  = 0
   and (MEETINGS_AUDIT_OLD.AUDIT_ID is null      or (not(MEETINGS.ASSIGNED_USER_ID          is null     and MEETINGS_AUDIT_OLD.ASSIGNED_USER_ID          is null    ) and (MEETINGS.ASSIGNED_USER_ID          <> MEETINGS_AUDIT_OLD.ASSIGNED_USER_ID          or MEETINGS.ASSIGNED_USER_ID is null or MEETINGS_AUDIT_OLD.ASSIGNED_USER_ID is null)))
   and USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS = 1
   and USERS_ASSIGNED_USER_ID.EMAIL1 is not null
   and MEETINGS.REPEAT_PARENT_ID is null
', '<?xml version="1.0" encoding="UTF-8"?><Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><CustomProperties><CustomProperty><Name>crm:Module</Name><Value>Meetings</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;e1c396a5-a42a-48ac-9ba0-33941db8ac34&lt;/ID&gt;&lt;MODULE&gt;Meetings&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Meetings MEETINGS_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;MEETINGS_AUDIT_OLD&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;MEETINGS_AUDIT_OLD.ASSIGNED_USER_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;ASSIGNED_USER_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;guid&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;changed&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;1248f646-f0cc-4e18-a3dc-f01e22dc004f&lt;/ID&gt;&lt;MODULE&gt;Users&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;USERS_ASSIGNED_USER_ID&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;RECEIVE_NOTIFICATIONS&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;bool&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;equals&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;1&lt;/SEARCH_TEXT&gt;&lt;SEARCH_TEXT_VALUES&gt;1&lt;/SEARCH_TEXT_VALUES&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;241acd04-46d1-441d-b6c5-abd31a648a9f&lt;/ID&gt;&lt;MODULE&gt;Users&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;USERS_ASSIGNED_USER_ID&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;USERS_ASSIGNED_USER_ID.EMAIL1&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;EMAIL1&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;string&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;not_empty&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;ba7d849e-6a89-43a3-94fc-16b98ecae8e6&lt;/ID&gt;&lt;MODULE&gt;Meetings&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Meetings MEETINGS&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;MEETINGS&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;MEETINGS.REPEAT_PARENT_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;REPEAT_PARENT_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;guid&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;empty&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties><DataSets><DataSet><Query><CommandText>select *
  from            vwMEETINGS_AUDIT        MEETINGS
  left outer join vwMEETINGS_AUDIT      MEETINGS_AUDIT_OLD
               on MEETINGS_AUDIT_OLD.ID = MEETINGS.ID
              and MEETINGS_AUDIT_OLD.AUDIT_VERSION = (select max(vwMEETINGS_AUDIT.AUDIT_VERSION)
                                                  from vwMEETINGS_AUDIT
                                                 where vwMEETINGS_AUDIT.ID            =  MEETINGS.ID
                                                   and vwMEETINGS_AUDIT.AUDIT_VERSION &lt;  MEETINGS.AUDIT_VERSION
                                                   and vwMEETINGS_AUDIT.AUDIT_TOKEN   &lt;&gt; MEETINGS.AUDIT_TOKEN
                                               )
  left outer join vwUSERS                     USERS_ASSIGNED_USER_ID
               on USERS_ASSIGNED_USER_ID.ID = MEETINGS.ASSIGNED_USER_ID
 where MEETINGS.AUDIT_ID = @AUDIT_ID
   and MEETINGS.DELETED  = 0
   and (MEETINGS_AUDIT_OLD.AUDIT_ID is null      or (not(MEETINGS.ASSIGNED_USER_ID          is null     and MEETINGS_AUDIT_OLD.ASSIGNED_USER_ID          is null    ) and (MEETINGS.ASSIGNED_USER_ID          &lt;&gt; MEETINGS_AUDIT_OLD.ASSIGNED_USER_ID          or MEETINGS.ASSIGNED_USER_ID is null or MEETINGS_AUDIT_OLD.ASSIGNED_USER_ID is null)))
   and USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS = 1
   and USERS_ASSIGNED_USER_ID.EMAIL1 is not null
   and MEETINGS.REPEAT_PARENT_ID is null
</CommandText></Query><Fields></Fields></DataSet></DataSets></Report>', null;

	exec dbo.spWORKFLOWS_UpdateXOML @ID, null, 0, '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="8df58b29-0f2d-4326-b2a9-e85873f90656" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">

<SequenceActivity x:Name="Sequence1" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:MeetingActivity x:Name="Meetings1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}">
		<crm:WorkflowLogActivity x:Name="Meetings1_Log" MODULE_TABLE="MEETINGS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

		<CodeActivity x:Name="Meetings1_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Meetings1,Path=LoadByAUDIT_ID}" />
	</crm:MeetingActivity>
	<crm:AlertActivity x:Name="Alert1" SUBJECT="SplendidCRM Meeting - $meeting_name" ALERT_TYPE="Notification" SOURCE_TYPE="normal message" CUSTOM_TEMPLATE_ID="00000000-0000-0000-0000-000000000000" AUDIT_ID="{ActivityBind Meetings1,Path=AUDIT_ID}" PARENT_ID="{ActivityBind Meetings1,Path=ID}" PARENT_TYPE="Meetings" PARENT_ACTIVITY="Meetings1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" ALERT_TEXT="$meeting_modified_by has assigned an Meeting to $meeting_assigned_to.&#xA;&#xA;Name: $meeting_name&#xA;Status: $meeting_status&#xA;Start Date: $meeting_date_start&#xA;Duration: $meeting_duration_hours hours, $meeting_duration_minutes minutes&#xA;Description: $meeting_description&#xA;&#xA;You may review this Meeting at:&#xA;&lt;a href=&quot;$view_url&quot;&gt;$view_url&lt;/a&gt;&#xA;&#xA;">
		<crm:WorkflowLogActivity x:Name="Alert1_Log" MODULE_TABLE="MEETINGS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />
		<crm:AddRecipientActivity x:Name="Alert1_Meetings1_AssignedUserID" ALERT_NAME="Alert1" RECIPIENT_NAME="" RECIPIENT_ID="{ActivityBind Meetings1,Path=ASSIGNED_USER_ID}" RECIPIENT_TYPE="User" SEND_TYPE="to" RECIPIENT_TABLE="" RECIPIENT_FIELD="" />

		<CodeActivity x:Name="Alert1_Send" ExecuteCode="{ActivityBind Alert1,Path=Send}" />
	</crm:AlertActivity>
</SequenceActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_ALERT_SHELLS_InsertOnly null, @ID, 'SplendidCRM Meeting - $meeting_name', 'Notification', 'normal message', null, '$meeting_modified_by has assigned an Meeting to $meeting_assigned_to.

Name: $meeting_name
Status: $meeting_status
Start Date: $meeting_date_start
Duration: $meeting_duration_hours hours, $meeting_duration_minutes minutes
Description: $meeting_description

You may review this Meeting at:
<a href="$view_url">$view_url</a>

', '<?xml version="1.0" encoding="UTF-8"?><Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><Width>11in</Width><PageWidth>11in</PageWidth><PageHeight>8.5in</PageHeight><LeftMargin>.5in</LeftMargin><RightMargin>.5in</RightMargin><TopMargin>.5in</TopMargin><BottomMargin>.5in</BottomMargin><Description></Description><Author></Author><CustomProperties><CustomProperty><Name>crm:Module</Name><Value>Meetings</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:RelatedModules</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;meetings_leads&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Meetings&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;MEETINGS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Leads&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;LEADS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;MEETINGS_LEADS&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;MEETING_ID&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;LEAD_ID&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Leads LEADS meetings_leads&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Leads LEADS] Meetings Leads&lt;/DISPLAY_NAME&gt;&lt;RELATIONSHIP_ROLE_COLUMN&gt;&lt;/RELATIONSHIP_ROLE_COLUMN&gt;&lt;RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;meetings_contacts&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Meetings&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;MEETINGS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Contacts&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;CONTACTS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;MEETINGS_CONTACTS&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;MEETING_ID&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;CONTACT_ID&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Contacts CONTACTS meetings_contacts&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Contacts CONTACTS] Meetings Contacts&lt;/DISPLAY_NAME&gt;&lt;RELATIONSHIP_ROLE_COLUMN&gt;&lt;/RELATIONSHIP_ROLE_COLUMN&gt;&lt;RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;meetings_users&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Meetings&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;MEETINGS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Users&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;USERS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;MEETINGS_USERS&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;MEETING_ID&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;USER_ID&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Users USERS meetings_users&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS] Meetings Users&lt;/DISPLAY_NAME&gt;&lt;RELATIONSHIP_ROLE_COLUMN&gt;&lt;/RELATIONSHIP_ROLE_COLUMN&gt;&lt;RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;meetings_notes&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Meetings&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;MEETINGS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Notes&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;NOTES&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;PARENT_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Notes NOTES meetings_notes&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Notes NOTES] Notes&lt;/DISPLAY_NAME&gt;&lt;RELATIONSHIP_ROLE_COLUMN&gt;PARENT_TYPE&lt;/RELATIONSHIP_ROLE_COLUMN&gt;&lt;RELATIONSHIP_ROLE_COLUMN_VALUE&gt;Meetings&lt;/RELATIONSHIP_ROLE_COLUMN_VALUE&gt;&lt;/Relationship&gt;
&lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Relationships</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;Meetings&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Meetings&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;MEETINGS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;MEETINGS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Meetings MEETINGS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Meetings MEETINGS] Meetings&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;meetings_audit_old&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Meetings&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;MEETINGS_AUDIT&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Meetings&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;MEETINGS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;MEETINGS_AUDIT_OLD&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Meetings MEETINGS_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Meetings MEETINGS_AUDIT_OLD] Meetings: Audit Old&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;users_all&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_ALL&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_ALL&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_ALL] Users All&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;teams&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Teams&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;TEAMS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;TEAMS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Teams TEAMS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Teams TEAMS] Teams&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;
&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;roles&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;ACLRoles&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;ACL_ROLES&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;ACL_ROLES&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;ACLRoles ACL_ROLES&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Roles ACL_ROLES] Roles&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;
&lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;a01a5090-fe61-4230-815b-9b7cf9815fd3&lt;/ID&gt;&lt;ACTION_TYPE&gt;current_user&lt;/ACTION_TYPE&gt;&lt;RELATIONSHIP_NAME&gt;&lt;/RELATIONSHIP_NAME&gt;&lt;MODULE&gt;Meetings&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Meetings MEETINGS&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;MEETINGS&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;MEETINGS.ASSIGNED_USER_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;ASSIGNED_USER_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;to&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;RECIPIENT_NAME&gt;&lt;/RECIPIENT_NAME&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties><DataSources><DataSource Name="dataSource1"><ConnectionProperties><DataProvider>SQL</DataProvider><ConnectString></ConnectString></ConnectionProperties></DataSource></DataSources><DataSets><DataSet Name="dataSet"><Query><DataSourceName>dataSource1</DataSourceName><CommandText></CommandText></Query><Fields></Fields></DataSet></DataSets><Body><ReportItems><Table Name="table1"><DataSetName>dataSet</DataSetName><Header><RepeatOnNewPage>true</RepeatOnNewPage><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Header><Details><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Details><TableColumns></TableColumns></Table></ReportItems><Height>8.5in</Height></Body></Report>', '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="8df58b29-0f2d-4326-b2a9-e85873f90656" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
	<crm:MeetingActivity x:Name="Meetings2" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="Meetings2_Log" MODULE_TABLE="MEETINGS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

		<CodeActivity x:Name="Meetings2_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Meetings2,Path=LoadByAUDIT_ID}" />
	</crm:MeetingActivity>
	<crm:AlertActivity x:Name="Alert2" SUBJECT="SplendidCRM Meeting - $meeting_name" ALERT_TYPE="Notification" SOURCE_TYPE="normal message" CUSTOM_TEMPLATE_ID="00000000-0000-0000-0000-000000000000" AUDIT_ID="{ActivityBind Meetings2,Path=AUDIT_ID}" PARENT_ID="{ActivityBind Meetings2,Path=ID}" PARENT_TYPE="Meetings" PARENT_ACTIVITY="Meetings2" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" ALERT_TEXT="$meeting_modified_by has assigned an Meeting to $meeting_assigned_to.&#xA;&#xA;Name: $meeting_name&#xA;Status: $meeting_status&#xA;Start Date: $meeting_date_start&#xA;Duration: $meeting_duration_hours hours, $meeting_duration_minutes minutes&#xA;Description: $meeting_description&#xA;&#xA;You may review this Meeting at:&#xA;&lt;a href=&quot;$view_url&quot;&gt;$view_url&lt;/a&gt;&#xA;&#xA;" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="Alert2_Log" MODULE_TABLE="MEETINGS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />
		<crm:AddRecipientActivity x:Name="Alert2_Meetings2_AssignedUserID" ALERT_NAME="Alert2" RECIPIENT_NAME="" RECIPIENT_ID="{ActivityBind Meetings2,Path=ASSIGNED_USER_ID}" RECIPIENT_TYPE="User" SEND_TYPE="to" RECIPIENT_TABLE="" RECIPIENT_FIELD="" />

		<CodeActivity x:Name="Alert2_Send" ExecuteCode="{ActivityBind Alert2,Path=Send}" />
	</crm:AlertActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'ASSIGNED_USER_ID', 'compare_change', 'Primary', 'changed', 0, 'Meetings', null, null;
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

call dbo.spWORKFLOWS_Meetings_Notification()
/

call dbo.spSqlDropProcedure('spWORKFLOWS_Meetings_Notification')
/

-- #endif IBM_DB2 */

