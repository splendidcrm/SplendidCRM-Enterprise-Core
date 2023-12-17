

print 'WORKFLOWS Prospects Notifications';
GO

set nocount on;
GO

declare @ID uniqueidentifier;
set @ID = '57B08658-13ED-408F-8F6E-C0133D8D5535';
if not exists(select * from WORKFLOW where ID = @ID) begin -- then
	-- 07/19/2010 Paul.  Add PARENT_ID. 
	exec dbo.spWORKFLOWS_Update @ID, null, 'Prospects Notification', 'Prospects', 'PROSPECTS_AUDIT', 1, 'Normal', 'alerts_actions', 'All', null, 'select *
  from            PROSPECTS_AUDIT        PROSPECTS
  left outer join PROSPECTS_AUDIT        PROSPECTS_AUDIT_OLD
               on PROSPECTS_AUDIT_OLD.ID = PROSPECTS.ID
              and PROSPECTS_AUDIT_OLD.AUDIT_VERSION = (select max(PROSPECTS_AUDIT.AUDIT_VERSION)
                                                  from PROSPECTS_AUDIT
                                                 where PROSPECTS_AUDIT.ID            =  PROSPECTS.ID
                                                   and PROSPECTS_AUDIT.AUDIT_VERSION <  PROSPECTS.AUDIT_VERSION
                                                   and PROSPECTS_AUDIT.AUDIT_TOKEN   <> PROSPECTS.AUDIT_TOKEN
                                               )
  left outer join vwUSERS                     USERS_ASSIGNED_USER_ID
               on USERS_ASSIGNED_USER_ID.ID = PROSPECTS.ASSIGNED_USER_ID
 where PROSPECTS.AUDIT_ID = @AUDIT_ID
   and PROSPECTS.DELETED  = 0
   and (PROSPECTS_AUDIT_OLD.AUDIT_ID is null      or (not(PROSPECTS.ASSIGNED_USER_ID          is null     and PROSPECTS_AUDIT_OLD.ASSIGNED_USER_ID          is null    ) and (PROSPECTS.ASSIGNED_USER_ID          <> PROSPECTS_AUDIT_OLD.ASSIGNED_USER_ID          or PROSPECTS.ASSIGNED_USER_ID is null or PROSPECTS_AUDIT_OLD.ASSIGNED_USER_ID is null)))
   and USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS = 1
   and USERS_ASSIGNED_USER_ID.EMAIL1 is not null
', '<?xml version="1.0" encoding="UTF-8"?><Report Name="" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><CustomProperties><CustomProperty><Name>crm:Module</Name><Value>Prospects</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:RelatedModules</Name><Value>&lt;Relationships /&gt;</Value></CustomProperty><CustomProperty><Name>crm:Relationships</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;Prospects&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Prospects&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROSPECTS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;PROSPECTS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Prospects PROSPECTS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Prospects PROSPECTS] Prospects&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;prospects_assigned_user&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Prospects&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;PROSPECTS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ASSIGNED_USER_ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;one-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_ASSIGNED_USER_ID&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_ASSIGNED_USER_ID] Targets: Assigned to User&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;prospects_created_by&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Prospects&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;PROSPECTS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;CREATED_BY_ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;one-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_CREATED_BY_ID&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_CREATED_BY_ID&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_CREATED_BY_ID] Targets: Created by User&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;prospects_modified_user&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Prospects&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;PROSPECTS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;MODIFIED_USER_ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;one-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_MODIFIED_USER_ID&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_MODIFIED_USER_ID&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_MODIFIED_USER_ID] Targets: Modified by User&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;prospects_audit_old&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Prospects&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROSPECTS_AUDIT&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Prospects&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;PROSPECTS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;PROSPECTS_AUDIT_OLD&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Prospects PROSPECTS_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Prospects PROSPECTS_AUDIT_OLD] Prospects: Audit Old&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;981c429b-45f9-4c83-a98b-b412c693dae4&lt;/ID&gt;&lt;MODULE&gt;Prospects&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Prospects PROSPECTS_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;PROSPECTS_AUDIT_OLD&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;PROSPECTS_AUDIT_OLD.ASSIGNED_USER_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;ASSIGNED_USER_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;guid&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;changed&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;cc0879d1-59b6-466e-8916-e7b954f7326f&lt;/ID&gt;&lt;MODULE&gt;Users&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;USERS_ASSIGNED_USER_ID&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;RECEIVE_NOTIFICATIONS&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;bool&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;equals&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;1&lt;/SEARCH_TEXT&gt;&lt;SEARCH_TEXT_VALUES&gt;1&lt;/SEARCH_TEXT_VALUES&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;aa3ec99b-7fe7-458f-8b60-ae37c4e6adc4&lt;/ID&gt;&lt;MODULE&gt;Users&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;USERS_ASSIGNED_USER_ID&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;USERS_ASSIGNED_USER_ID.EMAIL1&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;EMAIL1&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;string&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;not_empty&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties><DataSets><DataSet><Query><CommandText>select *    from            PROSPECTS_AUDIT       PROSPECTS    left outer join vwUSERS                     USERS_ASSIGNED_USER_ID                 on USERS_ASSIGNED_USER_ID.ID = PROSPECTS.ASSIGNED_USER_ID    left outer join PROSPECTS_AUDIT           PROSPECTS_AUDIT_OLD                 on PROSPECTS_AUDIT_OLD.ID    = PROSPECTS.ID                and PROSPECTS_AUDIT_OLD.AUDIT_VERSION = (select max(PROSPECTS_AUDIT.AUDIT_VERSION)                                                    from PROSPECTS_AUDIT                                                   where PROSPECTS_AUDIT.ID            =  PROSPECTS.ID                                                     and PROSPECTS_AUDIT.AUDIT_VERSION &lt;  PROSPECTS.AUDIT_VERSION                                                     and PROSPECTS_AUDIT.AUDIT_TOKEN   &lt;&gt; PROSPECTS.AUDIT_TOKEN                                                 )   where PROSPECTS.AUDIT_ID = @AUDIT_ID     and PROSPECTS.DELETED  = 0     and (PROSPECTS_AUDIT_OLD.AUDIT_ID is null      or (not(PROSPECTS.ASSIGNED_USER_ID         is null     and PROSPECTS_AUDIT_OLD.ASSIGNED_USER_ID         is null    ) and (PROSPECTS.ASSIGNED_USER_ID         &lt;&gt; PROSPECTS_AUDIT_OLD.ASSIGNED_USER_ID         or PROSPECTS.ASSIGNED_USER_ID is null or PROSPECTS_AUDIT_OLD.ASSIGNED_USER_ID is null)))     and USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS = 1     and USERS_ASSIGNED_USER_ID.EMAIL1 is not null  </CommandText></Query><Fields></Fields></DataSet></DataSets></Report>', null;

	exec dbo.spWORKFLOWS_UpdateXOML @ID, null, 0, '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="57B08658-13ED-408F-8F6E-C0133D8D5535" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
	<SequenceActivity x:Name="Sequence1" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:ProspectActivity x:Name="Prospects1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}">
			<crm:WorkflowLogActivity x:Name="Prospects1_Log" MODULE_TABLE="PROSPECTS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

			<CodeActivity x:Name="Prospects1_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Prospects1,Path=LoadByAUDIT_ID}" />
		</crm:ProspectActivity>
		<crm:AlertActivity x:Name="Alert1" SUBJECT="SplendidCRM Prospect - $prospect_name" ALERT_TYPE="Notification" ALERT_TEXT="$prospect_modified_by has assigned an Prospect to $prospect_assigned_to.&#xD;&#xA;&#xD;&#xA;Name: $prospect_name&#xD;&#xA;Type: $prospect_prospect_type&#xD;&#xA;Description: $prospect_description&#xD;&#xA;&#xD;&#xA;You may review this Prospect at:&#xD;&#xA;&lt;a href=&quot;$view_url&quot;&gt;$view_url&lt;/a&gt;&#xD;&#xA;&#xD;&#xA;" SOURCE_TYPE="normal message" CUSTOM_TEMPLATE_ID="00000000-0000-0000-0000-000000000000" PARENT_TYPE="Prospects" PARENT_ACTIVITY="Prospects1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}">
			<crm:WorkflowLogActivity x:Name="Alert1_Log" MODULE_TABLE="EMAILS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />
			<crm:AddRecipientActivity x:Name="Alert1_Prospects1_AssignedUserID" ALERT_NAME="Alert1" RECIPIENT_NAME="" RECIPIENT_ID="{ActivityBind Prospects1,Path=ASSIGNED_USER_ID}" RECIPIENT_TYPE="User" SEND_TYPE="to" />

			<CodeActivity x:Name="Alert1_Send" ExecuteCode="{ActivityBind Alert1,Path=Send}" />
		</crm:AlertActivity>
	</SequenceActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_ALERT_SHELLS_InsertOnly null, @ID, 'SplendidCRM Prospect - $prospect_name', 'Email', 'normal message', null, '$prospect_modified_by has assigned an Prospect to $prospect_assigned_to.

Name: $prospect_name
Type: $prospect_prospect_type
Description: $prospect_description

You may review this Prospect at:
<a href="$view_url">$view_url</a>

', '<?xml version="1.0" encoding="UTF-8"?><Report Name="" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><Width>11in</Width><PageWidth>11in</PageWidth><PageHeight>8.5in</PageHeight><LeftMargin>.5in</LeftMargin><RightMargin>.5in</RightMargin><TopMargin>.5in</TopMargin><BottomMargin>.5in</BottomMargin><Description></Description><Author></Author><CustomProperties><CustomProperty><Name>crm:Module</Name><Value>Prospects</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:RelatedModules</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;prospect_campaign_log&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Prospects&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROSPECTS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;CampaignLog&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;CAMPAIGN_LOG&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;TARGET_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;CampaignLog CAMPAIGN_LOG&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[CampaignLog CAMPAIGN_LOG] .moduleList.CampaignLog&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Relationships</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;Prospects&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Prospects&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROSPECTS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;PROSPECTS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Prospects PROSPECTS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Prospects PROSPECTS] Prospects&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;prospects_audit_old&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Prospects&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;PROSPECTS_AUDIT&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Prospects&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;PROSPECTS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;PROSPECTS_AUDIT_OLD&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Prospects PROSPECTS_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Prospects PROSPECTS_AUDIT_OLD] Prospects: Audit Old&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;users_all&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_ALL&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_ALL&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_ALL] Users All&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;teams&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Teams&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;TEAMS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;TEAMS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Teams TEAMS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Teams TEAMS] Teams&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;roles&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Roles&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;ACL_ROLES&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;ACL_ROLES&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Roles ACL_ROLES&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Roles ACL_ROLES] Roles&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;1cffbe11-bc04-49aa-a3b0-6b30873e1cc5&lt;/ID&gt;&lt;ACTION_TYPE&gt;current_user&lt;/ACTION_TYPE&gt;&lt;RELATIONSHIP_NAME&gt;&lt;/RELATIONSHIP_NAME&gt;&lt;MODULE&gt;Prospects&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Prospects PROSPECTS&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;PROSPECTS&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;PROSPECTS.ASSIGNED_USER_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;ASSIGNED_USER_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;to&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;RECIPIENT_NAME&gt;&lt;/RECIPIENT_NAME&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties><DataSources><DataSource Name="dataSource1"><ConnectionProperties><DataProvider>SQL</DataProvider><ConnectString></ConnectString></ConnectionProperties></DataSource></DataSources><DataSets><DataSet Name="dataSet"><Query><DataSourceName>dataSource1</DataSourceName><CommandText></CommandText></Query><Fields></Fields></DataSet></DataSets><Body><ReportItems><Table Name="table1"><DataSetName>dataSet</DataSetName><Header><RepeatOnNewPage>true</RepeatOnNewPage><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Header><Details><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Details><TableColumns></TableColumns></Table></ReportItems><Height>8.5in</Height></Body></Report>'
, '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="57B08658-13ED-408F-8F6E-C0133D8D5535" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
	<crm:ProspectActivity x:Name="Prospects2" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="Prospects2_Log" MODULE_TABLE="PROSPECTS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

		<CodeActivity x:Name="Prospects2_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Prospects2,Path=LoadByAUDIT_ID}" />
	</crm:ProspectActivity>
	<crm:AlertActivity x:Name="Alert2" SUBJECT="SplendidCRM Prospect - $prospect_name" ALERT_TYPE="Notification" ALERT_TEXT="$prospect_modified_by has assigned an Prospect to $prospect_assigned_to.&#xD;&#xA;&#xD;&#xA;Name: $prospect_name&#xD;&#xA;Type: $prospect_prospect_type&#xD;&#xA;Description: $prospect_description&#xD;&#xA;&#xD;&#xA;You may review this Prospect at:&#xD;&#xA;&lt;a href=&quot;$view_url&quot;&gt;$view_url&lt;/a&gt;&#xD;&#xA;&#xD;&#xA;" SOURCE_TYPE="normal message" CUSTOM_TEMPLATE_ID="00000000-0000-0000-0000-000000000000" PARENT_TYPE="Prospects" PARENT_ACTIVITY="Prospects2" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="Alert2_Log" MODULE_TABLE="EMAILS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />
		<crm:AddRecipientActivity x:Name="Alert2_Prospects2_AssignedUserID" ALERT_NAME="Alert2" RECIPIENT_NAME="" RECIPIENT_ID="{ActivityBind Prospects2,Path=ASSIGNED_USER_ID}" RECIPIENT_TYPE="User" SEND_TYPE="to" />

		<CodeActivity x:Name="Alert2_Send" ExecuteCode="{ActivityBind Alert2,Path=Send}" />
	</crm:AlertActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'RECEIVE_NOTIFICATIONS', 'compare_specific', 'Primary', 'equals'   , 0, 'Users'   , null, '1';
	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'EMAIL1'               , 'compare_specific', 'Primary', 'not_empty', 0, 'Users'   , null, null;
	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'ASSIGNED_USER_ID'     , 'compare_change'  , 'Primary', 'changed'  , 0, 'Prospects', null, null;
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

call dbo.spWORKFLOWS_Prospects_Notifications()
/

call dbo.spSqlDropProcedure('spWORKFLOWS_Prospects_Notifications')
/

-- #endif IBM_DB2 */

