

print 'WORKFLOWS ProjectTask Notifications';
GO

set nocount on;
GO

declare @ID uniqueidentifier;
set @ID = 'E7363269-2B21-44C7-AD39-561C47706322';
if not exists(select * from WORKFLOW where ID = @ID) begin -- then
	-- 07/19/2010 Paul.  Add PARENT_ID. 
	exec dbo.spWORKFLOWS_Update @ID, null, 'ProjectTask Notification', 'ProjectTask', 'PROJECT_TASK_AUDIT', 1, 'Normal', 'alerts_actions', 'All', null, 'select *
  from            PROJECT_TASK_AUDIT        PROJECT_TASK
  left outer join PROJECT_TASK_AUDIT        PROJECT_TASK_AUDIT_OLD
               on PROJECT_TASK_AUDIT_OLD.ID = PROJECT_TASK.ID
              and PROJECT_TASK_AUDIT_OLD.AUDIT_VERSION = (select max(PROJECT_TASK_AUDIT.AUDIT_VERSION)
                                                  from PROJECT_TASK_AUDIT
                                                 where PROJECT_TASK_AUDIT.ID            =  PROJECT_TASK.ID
                                                   and PROJECT_TASK_AUDIT.AUDIT_VERSION <  PROJECT_TASK.AUDIT_VERSION
                                                   and PROJECT_TASK_AUDIT.AUDIT_TOKEN   <> PROJECT_TASK.AUDIT_TOKEN
                                               )
  left outer join vwUSERS                     USERS_ASSIGNED_USER_ID
               on USERS_ASSIGNED_USER_ID.ID = PROJECT_TASK.ASSIGNED_USER_ID
 where PROJECT_TASK.AUDIT_ID = @AUDIT_ID
   and PROJECT_TASK.DELETED  = 0
   and (PROJECT_TASK_AUDIT_OLD.AUDIT_ID is null      or (not(PROJECT_TASK.ASSIGNED_USER_ID          is null     and PROJECT_TASK_AUDIT_OLD.ASSIGNED_USER_ID          is null    ) and (PROJECT_TASK.ASSIGNED_USER_ID          <> PROJECT_TASK_AUDIT_OLD.ASSIGNED_USER_ID          or PROJECT_TASK.ASSIGNED_USER_ID is null or PROJECT_TASK_AUDIT_OLD.ASSIGNED_USER_ID is null)))
   and USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS = 1
   and USERS_ASSIGNED_USER_ID.EMAIL1 is not null
', '<?xml version="1.0" encoding="UTF-8"?><Report Name="" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><CustomProperties><CustomProperty><Name>crm:Module</Name><Value>ProjectTask</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:RelatedModules</Name><Value>&lt;Relationships /&gt;</Value></CustomProperty><CustomProperty><Name>crm:Relationships</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;ProjectTask&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;ProjectTask&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROJECT_TASK&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;PROJECT_TASK&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;ProjectTask PROJECT_TASK&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[ProjectTask PROJECT_TASK] ProjectTask&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;project_task_assigned_user&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;ProjectTask&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;PROJECT_TASK&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ASSIGNED_USER_ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;one-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_ASSIGNED_USER_ID&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_ASSIGNED_USER_ID] Project Tasks: Assigned to User&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;project_task_created_by&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;ProjectTask&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;PROJECT_TASK&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;CREATED_BY_ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;one-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_CREATED_BY_ID&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_CREATED_BY_ID&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_CREATED_BY_ID] Project Tasks: Created by User&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;project_task_modified_user&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;ProjectTask&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;PROJECT_TASK&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;MODIFIED_USER_ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;one-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_MODIFIED_USER_ID&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_MODIFIED_USER_ID&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_MODIFIED_USER_ID] Project Tasks: Modified by User&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;project_project_tasks&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Project&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROJECT&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;ProjectTask&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;PROJECT_TASK&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;PARENT_ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;one-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;PROJECT_PARENT_ID&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Project PROJECT_PARENT_ID&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Project PROJECT_PARENT_ID] Project Tasks: Projects Parent ID&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;projecttask_audit_old&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;ProjectTask&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROJECT_TASK_AUDIT&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;ProjectTask&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;PROJECT_TASK&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;PROJECT_TASK_AUDIT_OLD&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;ProjectTask PROJECT_TASK_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[ProjectTask PROJECT_TASK_AUDIT_OLD] ProjectTask: Audit Old&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;523b6316-ad17-4316-aa9e-f934f6e8e6e7&lt;/ID&gt;&lt;MODULE&gt;ProjectTask&lt;/MODULE&gt;&lt;MODULE_NAME&gt;ProjectTask PROJECT_TASK_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;PROJECT_TASK_AUDIT_OLD&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;PROJECT_TASK_AUDIT_OLD.ASSIGNED_USER_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;ASSIGNED_USER_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;guid&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;changed&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;0d8ab27f-1a42-4120-a130-710359e12d63&lt;/ID&gt;&lt;MODULE&gt;Users&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;USERS_ASSIGNED_USER_ID&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;RECEIVE_NOTIFICATIONS&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;bool&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;equals&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;1&lt;/SEARCH_TEXT&gt;&lt;SEARCH_TEXT_VALUES&gt;1&lt;/SEARCH_TEXT_VALUES&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;970caca0-95a4-4540-98ca-3af129a27683&lt;/ID&gt;&lt;MODULE&gt;Users&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;USERS_ASSIGNED_USER_ID&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;USERS_ASSIGNED_USER_ID.EMAIL1&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;EMAIL1&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;string&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;not_empty&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties><DataSets><DataSet><Query><CommandText>select *    from            PROJECT_TASK_AUDIT    PROJECT_TASK    left outer join vwUSERS                     USERS_ASSIGNED_USER_ID                 on USERS_ASSIGNED_USER_ID.ID = PROJECT_TASK.ASSIGNED_USER_ID    left outer join PROJECT_TASK_AUDIT        PROJECT_TASK_AUDIT_OLD                 on PROJECT_TASK_AUDIT_OLD.ID = PROJECT_TASK.ID                and PROJECT_TASK_AUDIT_OLD.AUDIT_VERSION = (select max(PROJECT_TASK_AUDIT.AUDIT_VERSION)                                                    from PROJECT_TASK_AUDIT                                                   where PROJECT_TASK_AUDIT.ID            =  PROJECT_TASK.ID                                                     and PROJECT_TASK_AUDIT.AUDIT_VERSION &lt;  PROJECT_TASK.AUDIT_VERSION                                                     and PROJECT_TASK_AUDIT.AUDIT_TOKEN   &lt;&gt; PROJECT_TASK.AUDIT_TOKEN                                                 )   where PROJECT_TASK.AUDIT_ID = @AUDIT_ID     and PROJECT_TASK.DELETED  = 0     and (PROJECT_TASK_AUDIT_OLD.AUDIT_ID is null      or (not(PROJECT_TASK.ASSIGNED_USER_ID      is null     and PROJECT_TASK_AUDIT_OLD.ASSIGNED_USER_ID      is null    ) and (PROJECT_TASK.ASSIGNED_USER_ID      &lt;&gt; PROJECT_TASK_AUDIT_OLD.ASSIGNED_USER_ID      or PROJECT_TASK.ASSIGNED_USER_ID is null or PROJECT_TASK_AUDIT_OLD.ASSIGNED_USER_ID is null)))     and USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS = 1     and USERS_ASSIGNED_USER_ID.EMAIL1 is not null  </CommandText></Query><Fields></Fields></DataSet></DataSets></Report>', null;

	exec dbo.spWORKFLOWS_UpdateXOML @ID, null, 0, '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="E7363269-2B21-44C7-AD39-561C47706322" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
	<SequenceActivity x:Name="Sequence1" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:ProjectTaskActivity x:Name="ProjectTask1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}">
			<crm:WorkflowLogActivity x:Name="ProjectTask1_Log" MODULE_TABLE="PROJECT_TASK" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

			<CodeActivity x:Name="ProjectTask1_LoadByAUDIT_ID" ExecuteCode="{ActivityBind ProjectTask1,Path=LoadByAUDIT_ID}" />
		</crm:ProjectTaskActivity>
		<crm:AlertActivity x:Name="Alert1" SUBJECT="SplendidCRM ProjectTask - $projecttask_name" ALERT_TYPE="Notification" ALERT_TEXT="$projecttask_modified_by has assigned an ProjectTask to $projecttask_assigned_to.&#xD;&#xA;&#xD;&#xA;Name: $projecttask_name&#xD;&#xA;Type: $projecttask_project_task_type&#xD;&#xA;Description: $projecttask_description&#xD;&#xA;&#xD;&#xA;You may review this ProjectTask at:&#xD;&#xA;&lt;a href=&quot;$view_url&quot;&gt;$view_url&lt;/a&gt;&#xD;&#xA;&#xD;&#xA;" SOURCE_TYPE="normal message" CUSTOM_TEMPLATE_ID="00000000-0000-0000-0000-000000000000" PARENT_TYPE="ProjectTask" PARENT_ACTIVITY="ProjectTask1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}">
			<crm:WorkflowLogActivity x:Name="Alert1_Log" MODULE_TABLE="EMAILS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />
			<crm:AddRecipientActivity x:Name="Alert1_ProjectTask1_AssignedUserID" ALERT_NAME="Alert1" RECIPIENT_NAME="" RECIPIENT_ID="{ActivityBind ProjectTask1,Path=ASSIGNED_USER_ID}" RECIPIENT_TYPE="User" SEND_TYPE="to" />

			<CodeActivity x:Name="Alert1_Send" ExecuteCode="{ActivityBind Alert1,Path=Send}" />
		</crm:AlertActivity>
	</SequenceActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_ALERT_SHELLS_InsertOnly null, @ID, 'SplendidCRM ProjectTask - $projecttask_name', 'Email', 'normal message', null, '$projecttask_modified_by has assigned an ProjectTask to $projecttask_assigned_to.

Name: $projecttask_name
Type: $projecttask_project_task_type
Description: $projecttask_description

You may review this ProjectTask at:
<a href="$view_url">$view_url</a>

', '<?xml version="1.0" encoding="UTF-8"?><Report Name="" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><Width>11in</Width><PageWidth>11in</PageWidth><PageHeight>8.5in</PageHeight><LeftMargin>.5in</LeftMargin><RightMargin>.5in</RightMargin><TopMargin>.5in</TopMargin><BottomMargin>.5in</BottomMargin><Description></Description><Author></Author><CustomProperties><CustomProperty><Name>crm:Module</Name><Value>ProjectTask</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:RelatedModules</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;project_task_notes&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;ProjectTask&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROJECT_TASK&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Notes&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;NOTES&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;PARENT_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Notes NOTES&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Notes NOTES] Notes&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;project_task_emails&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;ProjectTask&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROJECT_TASK&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Emails&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;EMAILS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;PARENT_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Emails EMAILS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Emails EMAILS] Emails&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;project_task_meetings&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;ProjectTask&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROJECT_TASK&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Meetings&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;MEETINGS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;PARENT_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Meetings MEETINGS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Meetings MEETINGS] Meetings&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;project_task_calls&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;ProjectTask&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROJECT_TASK&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Calls&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;CALLS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;PARENT_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Calls CALLS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Calls CALLS] Calls&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Relationships</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;ProjectTask&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;ProjectTask&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROJECT_TASK&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;PROJECT_TASK&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;ProjectTask PROJECT_TASK&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[ProjectTask PROJECT_TASK] ProjectTask&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;projecttask_audit_old&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;ProjectTask&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROJECT_TASK_AUDIT&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;ProjectTask&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;PROJECT_TASK&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;PROJECT_TASK_AUDIT_OLD&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;ProjectTask PROJECT_TASK_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[ProjectTask PROJECT_TASK_AUDIT_OLD] ProjectTask: Audit Old&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;users_all&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_ALL&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_ALL&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_ALL] Users All&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;teams&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Teams&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;TEAMS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;TEAMS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Teams TEAMS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Teams TEAMS] Teams&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;roles&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Roles&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;ACL_ROLES&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;ACL_ROLES&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Roles ACL_ROLES&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Roles ACL_ROLES] Roles&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;1556a290-9eb4-42b6-b3b2-7f0bea5df561&lt;/ID&gt;&lt;ACTION_TYPE&gt;current_user&lt;/ACTION_TYPE&gt;&lt;RELATIONSHIP_NAME&gt;&lt;/RELATIONSHIP_NAME&gt;&lt;MODULE&gt;ProjectTask&lt;/MODULE&gt;&lt;MODULE_NAME&gt;ProjectTask PROJECT_TASK&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;PROJECT_TASK&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;PROJECT_TASK.ASSIGNED_USER_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;ASSIGNED_USER_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;to&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;RECIPIENT_NAME&gt;&lt;/RECIPIENT_NAME&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties><DataSources><DataSource Name="dataSource1"><ConnectionProperties><DataProvider>SQL</DataProvider><ConnectString></ConnectString></ConnectionProperties></DataSource></DataSources><DataSets><DataSet Name="dataSet"><Query><DataSourceName>dataSource1</DataSourceName><CommandText></CommandText></Query><Fields></Fields></DataSet></DataSets><Body><ReportItems><Table Name="table1"><DataSetName>dataSet</DataSetName><Header><RepeatOnNewPage>true</RepeatOnNewPage><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Header><Details><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Details><TableColumns></TableColumns></Table></ReportItems><Height>8.5in</Height></Body></Report>'
, '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="E7363269-2B21-44C7-AD39-561C47706322" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
	<crm:ProjectTaskActivity x:Name="ProjectTask2" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="ProjectTask2_Log" MODULE_TABLE="PROJECT_TASK" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

		<CodeActivity x:Name="ProjectTask2_LoadByAUDIT_ID" ExecuteCode="{ActivityBind ProjectTask2,Path=LoadByAUDIT_ID}" />
	</crm:ProjectTaskActivity>
	<crm:AlertActivity x:Name="Alert2" SUBJECT="SplendidCRM ProjectTask - $projecttask_name" ALERT_TYPE="Notification" ALERT_TEXT="$projecttask_modified_by has assigned an ProjectTask to $projecttask_assigned_to.&#xD;&#xA;&#xD;&#xA;Name: $projecttask_name&#xD;&#xA;Type: $projecttask_project_task_type&#xD;&#xA;Description: $projecttask_description&#xD;&#xA;&#xD;&#xA;You may review this ProjectTask at:&#xD;&#xA;&lt;a href=&quot;$view_url&quot;&gt;$view_url&lt;/a&gt;&#xD;&#xA;&#xD;&#xA;" SOURCE_TYPE="normal message" CUSTOM_TEMPLATE_ID="00000000-0000-0000-0000-000000000000" PARENT_TYPE="ProjectTask" PARENT_ACTIVITY="ProjectTask2" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="Alert2_Log" MODULE_TABLE="EMAILS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />
		<crm:AddRecipientActivity x:Name="Alert2_ProjectTask2_AssignedUserID" ALERT_NAME="Alert2" RECIPIENT_NAME="" RECIPIENT_ID="{ActivityBind ProjectTask2,Path=ASSIGNED_USER_ID}" RECIPIENT_TYPE="User" SEND_TYPE="to" />

		<CodeActivity x:Name="Alert2_Send" ExecuteCode="{ActivityBind Alert2,Path=Send}" />
	</crm:AlertActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'RECEIVE_NOTIFICATIONS', 'compare_specific', 'Primary', 'equals'   , 0, 'Users'   , null, '1';
	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'EMAIL1'               , 'compare_specific', 'Primary', 'not_empty', 0, 'Users'   , null, null;
	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'ASSIGNED_USER_ID'     , 'compare_change'  , 'Primary', 'changed'  , 0, 'ProjectTask', null, null;
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

call dbo.spWORKFLOWS_ProjectTask_Notifications()
/

call dbo.spSqlDropProcedure('spWORKFLOWS_ProjectTask_Notifications')
/

-- #endif IBM_DB2 */
