

print 'WORKFLOWS Bugs Notifications';
GO

set nocount on;
GO

declare @ID uniqueidentifier;
set @ID = 'E2618FDE-91CD-47D1-88E2-0323077CB11B';
if not exists(select * from WORKFLOW where ID = @ID) begin -- then
	-- 07/19/2010 Paul.  Add PARENT_ID. 
	exec dbo.spWORKFLOWS_Update @ID, null, 'Bugs Notification', 'Bugs', 'BUGS_AUDIT', 1, 'Normal', 'alerts_actions', 'All', null, 'select *
  from            BUGS_AUDIT        BUGS
  left outer join BUGS_AUDIT        BUGS_AUDIT_OLD
               on BUGS_AUDIT_OLD.ID = BUGS.ID
              and BUGS_AUDIT_OLD.AUDIT_VERSION = (select max(BUGS_AUDIT.AUDIT_VERSION)
                                                  from BUGS_AUDIT
                                                 where BUGS_AUDIT.ID            =  BUGS.ID
                                                   and BUGS_AUDIT.AUDIT_VERSION <  BUGS.AUDIT_VERSION
                                                   and BUGS_AUDIT.AUDIT_TOKEN   <> BUGS.AUDIT_TOKEN
                                               )
  left outer join vwUSERS                     USERS_ASSIGNED_USER_ID
               on USERS_ASSIGNED_USER_ID.ID = BUGS.ASSIGNED_USER_ID
 where BUGS.AUDIT_ID = @AUDIT_ID
   and BUGS.DELETED  = 0
   and (BUGS_AUDIT_OLD.AUDIT_ID is null      or (not(BUGS.ASSIGNED_USER_ID          is null     and BUGS_AUDIT_OLD.ASSIGNED_USER_ID          is null    ) and (BUGS.ASSIGNED_USER_ID          <> BUGS_AUDIT_OLD.ASSIGNED_USER_ID          or BUGS.ASSIGNED_USER_ID is null or BUGS_AUDIT_OLD.ASSIGNED_USER_ID is null)))
   and USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS = 1
   and USERS_ASSIGNED_USER_ID.EMAIL1 is not null
', '<?xml version="1.0" encoding="UTF-8"?><Report Name="" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><CustomProperties><CustomProperty><Name>crm:Module</Name><Value>Bugs</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:RelatedModules</Name><Value>&lt;Relationships /&gt;</Value></CustomProperty><CustomProperty><Name>crm:Relationships</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;Bugs&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Bugs&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;BUGS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;BUGS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Bugs BUGS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Bugs BUGS] Bugs&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;bugs_assigned_user&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Bugs&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;BUGS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ASSIGNED_USER_ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;one-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_ASSIGNED_USER_ID&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_ASSIGNED_USER_ID] Bug Tracker: Assigned to User&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;bugs_created_by&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Bugs&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;BUGS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;CREATED_BY_ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;one-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_CREATED_BY_ID&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_CREATED_BY_ID&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_CREATED_BY_ID] Bug Tracker: Created by User&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;bugs_fixed_in_release&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Releases&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;RELEASES&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Bugs&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;BUGS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;FIXED_IN_RELEASE&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;one-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;RELEASES_FIXED_IN_RELEASE&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Releases RELEASES_FIXED_IN_RELEASE&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Releases RELEASES_FIXED_IN_RELEASE] Bug Tracker: Fixed in Release&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;bugs_release&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Releases&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;RELEASES&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Bugs&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;BUGS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;FOUND_IN_RELEASE&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;one-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;RELEASES_FOUND_IN_RELEASE&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Releases RELEASES_FOUND_IN_RELEASE&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Releases RELEASES_FOUND_IN_RELEASE] Bug Tracker: Found in Release&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;bugs_modified_user&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Bugs&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;BUGS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;MODIFIED_USER_ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;one-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_MODIFIED_USER_ID&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_MODIFIED_USER_ID&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_MODIFIED_USER_ID] Bug Tracker: Modified by User&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;bugs_audit_old&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Bugs&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;BUGS_AUDIT&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Bugs&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;BUGS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;BUGS_AUDIT_OLD&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Bugs BUGS_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Bugs BUGS_AUDIT_OLD] Bugs: Audit Old&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;c3d187c3-d83d-4b4f-a812-9642a435d52e&lt;/ID&gt;&lt;MODULE&gt;Bugs&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Bugs BUGS_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;BUGS_AUDIT_OLD&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;BUGS_AUDIT_OLD.ASSIGNED_USER_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;ASSIGNED_USER_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;guid&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;changed&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;2986ffa1-0d5b-4a7a-b778-d6e5c0875cd8&lt;/ID&gt;&lt;MODULE&gt;Users&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;USERS_ASSIGNED_USER_ID&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;RECEIVE_NOTIFICATIONS&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;bool&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;equals&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;1&lt;/SEARCH_TEXT&gt;&lt;SEARCH_TEXT_VALUES&gt;1&lt;/SEARCH_TEXT_VALUES&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;36194aca-8833-49f4-a6ed-f687473f3e73&lt;/ID&gt;&lt;MODULE&gt;Users&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;USERS_ASSIGNED_USER_ID&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;USERS_ASSIGNED_USER_ID.EMAIL1&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;EMAIL1&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;string&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;not_empty&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties><DataSets><DataSet><Query><CommandText>select *    from            BUGS_AUDIT            BUGS    left outer join vwUSERS                     USERS_ASSIGNED_USER_ID                 on USERS_ASSIGNED_USER_ID.ID = BUGS.ASSIGNED_USER_ID    left outer join BUGS_AUDIT                BUGS_AUDIT_OLD                 on BUGS_AUDIT_OLD.ID         = BUGS.ID                and BUGS_AUDIT_OLD.AUDIT_VERSION = (select max(BUGS_AUDIT.AUDIT_VERSION)                                                    from BUGS_AUDIT                                                   where BUGS_AUDIT.ID            =  BUGS.ID                                                     and BUGS_AUDIT.AUDIT_VERSION &lt;  BUGS.AUDIT_VERSION                                                     and BUGS_AUDIT.AUDIT_TOKEN   &lt;&gt; BUGS.AUDIT_TOKEN                                                 )   where BUGS.AUDIT_ID = @AUDIT_ID     and BUGS.DELETED  = 0     and (BUGS_AUDIT_OLD.AUDIT_ID is null      or (not(BUGS.ASSIGNED_USER_ID              is null     and BUGS_AUDIT_OLD.ASSIGNED_USER_ID              is null    ) and (BUGS.ASSIGNED_USER_ID              &lt;&gt; BUGS_AUDIT_OLD.ASSIGNED_USER_ID              or BUGS.ASSIGNED_USER_ID is null or BUGS_AUDIT_OLD.ASSIGNED_USER_ID is null)))     and USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS = 1     and USERS_ASSIGNED_USER_ID.EMAIL1 is not null  </CommandText></Query><Fields></Fields></DataSet></DataSets></Report>', null;

	exec dbo.spWORKFLOWS_UpdateXOML @ID, null, 0, '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="E2618FDE-91CD-47D1-88E2-0323077CB11B" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
	<SequenceActivity x:Name="Sequence1" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:BugActivity x:Name="Bugs1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}">
			<crm:WorkflowLogActivity x:Name="Bugs1_Log" MODULE_TABLE="BUGS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

			<CodeActivity x:Name="Bugs1_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Bugs1,Path=LoadByAUDIT_ID}" />
		</crm:BugActivity>
		<crm:AlertActivity x:Name="Alert1" SUBJECT="SplendidCRM Bug - $bug_name" ALERT_TYPE="Notification" ALERT_TEXT="$bug_modified_by has assigned an Bug to $bug_assigned_to.&#xD;&#xA;&#xD;&#xA;Bug Number: $bug_bug_number&#xD;&#xA;&#xD;&#xA;Subject: $bug_name&#xD;&#xA;&#xD;&#xA;Type: $bug_type&#xD;&#xA;&#xD;&#xA;Priority: $bug_priority&#xD;&#xA;&#xD;&#xA;Status: $bug_status&#xD;&#xA;&#xD;&#xA;Resolution: $bug_resolution&#xD;&#xA;&#xD;&#xA;Release: $bug_found_in_release&#xD;&#xA;&#xD;&#xA;Description: $bug_description&#xD;&#xA;&#xD;&#xA;Work Log: $bug_work_log&#xD;&#xA;&#xD;&#xA;You may review this Bug at:&#xD;&#xA;&lt;a href=&quot;$view_url&quot;&gt;$view_url&lt;/a&gt;&#xD;&#xA;&#xD;&#xA;" SOURCE_TYPE="normal message" CUSTOM_TEMPLATE_ID="00000000-0000-0000-0000-000000000000" PARENT_TYPE="Bugs" PARENT_ACTIVITY="Bugs1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}">
			<crm:WorkflowLogActivity x:Name="Alert1_Log" MODULE_TABLE="EMAILS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />
			<crm:AddRecipientActivity x:Name="Alert1_Bugs1_AssignedUserID" ALERT_NAME="Alert1" RECIPIENT_NAME="" RECIPIENT_ID="{ActivityBind Bugs1,Path=ASSIGNED_USER_ID}" RECIPIENT_TYPE="User" SEND_TYPE="to" />

			<CodeActivity x:Name="Alert1_Send" ExecuteCode="{ActivityBind Alert1,Path=Send}" />
		</crm:AlertActivity>
	</SequenceActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_ALERT_SHELLS_InsertOnly null, @ID, 'SplendidCRM Bug - $bug_name', 'Email', 'normal message', null, '$bug_modified_by has assigned an Bug to $bug_assigned_to.

Bug Number: $bug_bug_number
Subject: $bug_name
Type: $bug_type
Priority: $bug_priority
Status: $bug_status
Resolution: $bug_resolution
Release: $bug_found_in_release
Description: $bug_description
Work Log: $bug_work_log

You may review this Bug at:
<a href="$view_url">$view_url</a>

', '<?xml version="1.0" encoding="UTF-8"?><Report Name="" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><Width>11in</Width><PageWidth>11in</PageWidth><PageHeight>8.5in</PageHeight><LeftMargin>.5in</LeftMargin><RightMargin>.5in</RightMargin><TopMargin>.5in</TopMargin><BottomMargin>.5in</BottomMargin><Description></Description><Author></Author><CustomProperties><CustomProperty><Name>crm:Module</Name><Value>Bugs</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:RelatedModules</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;bug_calls&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Bugs&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;BUGS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Calls&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;CALLS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;PARENT_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Calls CALLS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Calls CALLS] Calls&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;bug_emails&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Bugs&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;BUGS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Emails&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;EMAILS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;PARENT_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Emails EMAILS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Emails EMAILS] Emails&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;bug_tasks&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Bugs&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;BUGS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Tasks&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;TASKS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;PARENT_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Tasks TASKS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Tasks TASKS] Tasks&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;bug_meetings&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Bugs&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;BUGS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Meetings&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;MEETINGS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;PARENT_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Meetings MEETINGS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Meetings MEETINGS] Meetings&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;bug_notes&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Bugs&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;BUGS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Notes&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;NOTES&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;PARENT_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;Notes NOTES&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Notes NOTES] Notes&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Relationships</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;Bugs&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Bugs&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;BUGS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;BUGS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Bugs BUGS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Bugs BUGS] Bugs&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;bugs_audit_old&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Bugs&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;BUGS_AUDIT&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Bugs&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;BUGS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;BUGS_AUDIT_OLD&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Bugs BUGS_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Bugs BUGS_AUDIT_OLD] Bugs: Audit Old&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;users_all&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_ALL&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_ALL&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_ALL] Users All&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;teams&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Teams&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;TEAMS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;TEAMS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Teams TEAMS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Teams TEAMS] Teams&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;roles&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Roles&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;ACL_ROLES&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;ACL_ROLES&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Roles ACL_ROLES&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Roles ACL_ROLES] Roles&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;389adf62-420d-4e06-bd47-37a25ac473bc&lt;/ID&gt;&lt;ACTION_TYPE&gt;current_user&lt;/ACTION_TYPE&gt;&lt;RELATIONSHIP_NAME&gt;&lt;/RELATIONSHIP_NAME&gt;&lt;MODULE&gt;Bugs&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Bugs BUGS&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;BUGS&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;BUGS.ASSIGNED_USER_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;ASSIGNED_USER_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;to&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;RECIPIENT_NAME&gt;&lt;/RECIPIENT_NAME&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties><DataSources><DataSource Name="dataSource1"><ConnectionProperties><DataProvider>SQL</DataProvider><ConnectString></ConnectString></ConnectionProperties></DataSource></DataSources><DataSets><DataSet Name="dataSet"><Query><DataSourceName>dataSource1</DataSourceName><CommandText></CommandText></Query><Fields></Fields></DataSet></DataSets><Body><ReportItems><Table Name="table1"><DataSetName>dataSet</DataSetName><Header><RepeatOnNewPage>true</RepeatOnNewPage><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Header><Details><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Details><TableColumns></TableColumns></Table></ReportItems><Height>8.5in</Height></Body></Report>'
, '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="E2618FDE-91CD-47D1-88E2-0323077CB11B" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
	<crm:BugActivity x:Name="Bugs2" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="Bugs2_Log" MODULE_TABLE="BUGS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

		<CodeActivity x:Name="Bugs2_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Bugs2,Path=LoadByAUDIT_ID}" />
	</crm:BugActivity>
	<crm:AlertActivity x:Name="Alert2" SUBJECT="SplendidCRM Bug - $bug_name" ALERT_TYPE="Notification" ALERT_TEXT="$bug_modified_by has assigned an Bug to $bug_assigned_to.&#xD;&#xA;&#xD;&#xA;Bug Number: $bug_bug_number&#xD;&#xA;&#xD;&#xA;Subject: $bug_name&#xD;&#xA;&#xD;&#xA;Type: $bug_type&#xD;&#xA;&#xD;&#xA;Priority: $bug_priority&#xD;&#xA;&#xD;&#xA;Status: $bug_status&#xD;&#xA;&#xD;&#xA;Resolution: $bug_resolution&#xD;&#xA;&#xD;&#xA;Release: $bug_found_in_release&#xD;&#xA;&#xD;&#xA;Description: $bug_description&#xD;&#xA;&#xD;&#xA;Work Log: $bug_work_log&#xD;&#xA;&#xD;&#xA;You may review this Bug at:&#xD;&#xA;&lt;a href=&quot;$view_url&quot;&gt;$view_url&lt;/a&gt;&#xD;&#xA;&#xD;&#xA;" SOURCE_TYPE="normal message" CUSTOM_TEMPLATE_ID="00000000-0000-0000-0000-000000000000" PARENT_TYPE="Bugs" PARENT_ACTIVITY="Bugs2" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="Alert2_Log" MODULE_TABLE="EMAILS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />
		<crm:AddRecipientActivity x:Name="Alert2_Bugs2_AssignedUserID" ALERT_NAME="Alert2" RECIPIENT_NAME="" RECIPIENT_ID="{ActivityBind Bugs2,Path=ASSIGNED_USER_ID}" RECIPIENT_TYPE="User" SEND_TYPE="to" />

		<CodeActivity x:Name="Alert2_Send" ExecuteCode="{ActivityBind Alert2,Path=Send}" />
	</crm:AlertActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'RECEIVE_NOTIFICATIONS', 'compare_specific', 'Primary', 'equals'   , 0, 'Users'   , null, '1';
	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'EMAIL1'               , 'compare_specific', 'Primary', 'not_empty', 0, 'Users'   , null, null;
	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'ASSIGNED_USER_ID'     , 'compare_change'  , 'Primary', 'changed'  , 0, 'Bugs', null, null;
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

call dbo.spWORKFLOWS_Bugs_Notifications()
/

call dbo.spSqlDropProcedure('spWORKFLOWS_Bugs_Notifications')
/

-- #endif IBM_DB2 */
