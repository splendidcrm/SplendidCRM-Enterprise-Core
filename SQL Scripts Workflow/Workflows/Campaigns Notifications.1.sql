

print 'WORKFLOWS Campaigns Notifications';
GO

set nocount on;
GO

declare @ID uniqueidentifier;
set @ID = '39F594FB-D6CE-4DE3-80E9-DFE76A552304';
if not exists(select * from WORKFLOW where ID = @ID) begin -- then
	-- 07/19/2010 Paul.  Add PARENT_ID. 
	exec dbo.spWORKFLOWS_Update @ID, null, 'Campaigns Notification', 'Campaigns', 'CAMPAIGNS_AUDIT', 1, 'Normal', 'alerts_actions', 'All', null, 'select *
  from            CAMPAIGNS_AUDIT        CAMPAIGNS
  left outer join CAMPAIGNS_AUDIT        CAMPAIGNS_AUDIT_OLD
               on CAMPAIGNS_AUDIT_OLD.ID = CAMPAIGNS.ID
              and CAMPAIGNS_AUDIT_OLD.AUDIT_VERSION = (select max(CAMPAIGNS_AUDIT.AUDIT_VERSION)
                                                  from CAMPAIGNS_AUDIT
                                                 where CAMPAIGNS_AUDIT.ID            =  CAMPAIGNS.ID
                                                   and CAMPAIGNS_AUDIT.AUDIT_VERSION <  CAMPAIGNS.AUDIT_VERSION
                                                   and CAMPAIGNS_AUDIT.AUDIT_TOKEN   <> CAMPAIGNS.AUDIT_TOKEN
                                               )
  left outer join vwUSERS                     USERS_ASSIGNED_USER_ID
               on USERS_ASSIGNED_USER_ID.ID = CAMPAIGNS.ASSIGNED_USER_ID
 where CAMPAIGNS.AUDIT_ID = @AUDIT_ID
   and CAMPAIGNS.DELETED  = 0
   and (CAMPAIGNS_AUDIT_OLD.AUDIT_ID is null      or (not(CAMPAIGNS.ASSIGNED_USER_ID          is null     and CAMPAIGNS_AUDIT_OLD.ASSIGNED_USER_ID          is null    ) and (CAMPAIGNS.ASSIGNED_USER_ID          <> CAMPAIGNS_AUDIT_OLD.ASSIGNED_USER_ID          or CAMPAIGNS.ASSIGNED_USER_ID is null or CAMPAIGNS_AUDIT_OLD.ASSIGNED_USER_ID is null)))
   and USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS = 1
   and USERS_ASSIGNED_USER_ID.EMAIL1 is not null
', '<?xml version="1.0" encoding="UTF-8"?><Report Name="" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><CustomProperties><CustomProperty><Name>crm:Module</Name><Value>Campaigns</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:RelatedModules</Name><Value>&lt;Relationships /&gt;</Value></CustomProperty><CustomProperty><Name>crm:Relationships</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;Campaigns&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Campaigns&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CAMPAIGNS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;CAMPAIGNS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Campaigns CAMPAIGNS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Campaigns CAMPAIGNS] Campaigns&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;campaigns_assigned_user&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Campaigns&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;CAMPAIGNS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ASSIGNED_USER_ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;one-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_ASSIGNED_USER_ID&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_ASSIGNED_USER_ID] Campaigns: Assigned to User&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;campaigns_audit_old&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Campaigns&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CAMPAIGNS_AUDIT&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Campaigns&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;CAMPAIGNS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;CAMPAIGNS_AUDIT_OLD&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Campaigns CAMPAIGNS_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Campaigns CAMPAIGNS_AUDIT_OLD] Campaigns: Audit Old&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;520baacf-fe97-43c6-bf36-a92af5c63a83&lt;/ID&gt;&lt;MODULE&gt;Campaigns&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Campaigns CAMPAIGNS_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;CAMPAIGNS_AUDIT_OLD&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;CAMPAIGNS_AUDIT_OLD.ASSIGNED_USER_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;ASSIGNED_USER_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;guid&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;changed&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;41cb78c5-a584-47a5-9cd6-2ad815b5ef00&lt;/ID&gt;&lt;MODULE&gt;Users&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;USERS_ASSIGNED_USER_ID&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;RECEIVE_NOTIFICATIONS&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;bool&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;equals&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;1&lt;/SEARCH_TEXT&gt;&lt;SEARCH_TEXT_VALUES&gt;1&lt;/SEARCH_TEXT_VALUES&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;3b03f00d-0cfd-4160-9ebe-47ba82317b03&lt;/ID&gt;&lt;MODULE&gt;Users&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Users USERS_ASSIGNED_USER_ID&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;USERS_ASSIGNED_USER_ID&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;USERS_ASSIGNED_USER_ID.EMAIL1&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;EMAIL1&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;string&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;not_empty&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties><DataSets><DataSet><Query><CommandText>select *    from            CAMPAIGNS_AUDIT       CAMPAIGNS    left outer join vwUSERS                     USERS_ASSIGNED_USER_ID                 on USERS_ASSIGNED_USER_ID.ID = CAMPAIGNS.ASSIGNED_USER_ID    left outer join CAMPAIGNS_AUDIT           CAMPAIGNS_AUDIT_OLD                 on CAMPAIGNS_AUDIT_OLD.ID    = CAMPAIGNS.ID                and CAMPAIGNS_AUDIT_OLD.AUDIT_VERSION = (select max(CAMPAIGNS_AUDIT.AUDIT_VERSION)                                                    from CAMPAIGNS_AUDIT                                                   where CAMPAIGNS_AUDIT.ID            =  CAMPAIGNS.ID                                                     and CAMPAIGNS_AUDIT.AUDIT_VERSION &lt;  CAMPAIGNS.AUDIT_VERSION                                                     and CAMPAIGNS_AUDIT.AUDIT_TOKEN   &lt;&gt; CAMPAIGNS.AUDIT_TOKEN                                                 )   where CAMPAIGNS.AUDIT_ID = @AUDIT_ID     and CAMPAIGNS.DELETED  = 0     and (CAMPAIGNS_AUDIT_OLD.AUDIT_ID is null      or (not(CAMPAIGNS.ASSIGNED_USER_ID         is null     and CAMPAIGNS_AUDIT_OLD.ASSIGNED_USER_ID         is null    ) and (CAMPAIGNS.ASSIGNED_USER_ID         &lt;&gt; CAMPAIGNS_AUDIT_OLD.ASSIGNED_USER_ID         or CAMPAIGNS.ASSIGNED_USER_ID is null or CAMPAIGNS_AUDIT_OLD.ASSIGNED_USER_ID is null)))     and USERS_ASSIGNED_USER_ID.RECEIVE_NOTIFICATIONS = 1     and USERS_ASSIGNED_USER_ID.EMAIL1 is not null  </CommandText></Query><Fields></Fields></DataSet></DataSets></Report>', null;

	exec dbo.spWORKFLOWS_UpdateXOML @ID, null, 0, '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="39F594FB-D6CE-4DE3-80E9-DFE76A552304" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
	<SequenceActivity x:Name="Sequence1" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:CampaignActivity x:Name="Campaigns1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}">
			<crm:WorkflowLogActivity x:Name="Campaigns1_Log" MODULE_TABLE="CAMPAIGNS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

			<CodeActivity x:Name="Campaigns1_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Campaigns1,Path=LoadByAUDIT_ID}" />
		</crm:CampaignActivity>
		<crm:AlertActivity x:Name="Alert1" SUBJECT="SplendidCRM Campaign - $campaign_name" ALERT_TYPE="Notification" ALERT_TEXT="$campaign_modified_by has assigned an Campaign to $campaign_assigned_to.&#xD;&#xA;&#xD;&#xA;Name: $campaign_name&#xD;&#xA;&#xD;&#xA;Expected Cost: $campaign_expected_cost&#xD;&#xA;&#xD;&#xA;Close Date: $campaign_end_date&#xD;&#xA;&#xD;&#xA;Status: $campaign_status&#xD;&#xA;&#xD;&#xA;Objective: $campaign_objective&#xD;&#xA;&#xD;&#xA;You may review this Campaign at:&#xD;&#xA;&lt;a href=&quot;$view_url&quot;&gt;$view_url&lt;/a&gt;&#xD;&#xA;&#xD;&#xA;" SOURCE_TYPE="normal message" CUSTOM_TEMPLATE_ID="00000000-0000-0000-0000-000000000000" PARENT_TYPE="Campaigns" PARENT_ACTIVITY="Campaigns1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}">
			<crm:WorkflowLogActivity x:Name="Alert1_Log" MODULE_TABLE="EMAILS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />
			<crm:AddRecipientActivity x:Name="Alert1_Campaigns1_AssignedUserID" ALERT_NAME="Alert1" RECIPIENT_NAME="" RECIPIENT_ID="{ActivityBind Campaigns1,Path=ASSIGNED_USER_ID}" RECIPIENT_TYPE="User" SEND_TYPE="to" />

			<CodeActivity x:Name="Alert1_Send" ExecuteCode="{ActivityBind Alert1,Path=Send}" />
		</crm:AlertActivity>
	</SequenceActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_ALERT_SHELLS_InsertOnly null, @ID, 'SplendidCRM Campaign - $campaign_name', 'Email', 'normal message', null, '$campaign_modified_by has assigned an Campaign to $campaign_assigned_to.

Name: $campaign_name
Expected Cost: $campaign_expected_cost
Close Date: $campaign_end_date
Status: $campaign_status
Objective: $campaign_objective

You may review this Campaign at:
<a href="$view_url">$view_url</a>

', '<?xml version="1.0" encoding="UTF-8"?><Report Name="" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><Width>11in</Width><PageWidth>11in</PageWidth><PageHeight>8.5in</PageHeight><LeftMargin>.5in</LeftMargin><RightMargin>.5in</RightMargin><TopMargin>.5in</TopMargin><BottomMargin>.5in</BottomMargin><Description></Description><Author></Author><CustomProperties><CustomProperty><Name>crm:Module</Name><Value>Campaigns</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:RelatedModules</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;campaign_emailman&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Campaigns&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CAMPAIGNS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;EmailMan&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;EMAILMAN&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;CAMPAIGN_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;EmailMan EMAILMAN&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[EmailMan EMAILMAN] Email Manager&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;campaign_email_marketing&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Campaigns&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CAMPAIGNS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;EmailMarketing&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;EMAIL_MARKETING&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;CAMPAIGN_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;EmailMarketing EMAIL_MARKETING&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[EmailMarketing EMAIL_MARKETING] Email Marketing&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;campaign_campaignlog&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Campaigns&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CAMPAIGNS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;CampaignLog&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;CAMPAIGN_LOG&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;CAMPAIGN_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;CampaignLog CAMPAIGN_LOG&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[CampaignLog CAMPAIGN_LOG] .moduleList.CampaignLog&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;campaign_campaigntrakers&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Campaigns&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CAMPAIGNS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;CampaignTrackers&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;CAMPAIGN_TRKRS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;CAMPAIGN_ID&lt;/RHS_KEY&gt;&lt;JOIN_TABLE&gt;&lt;/JOIN_TABLE&gt;&lt;JOIN_KEY_LHS&gt;&lt;/JOIN_KEY_LHS&gt;&lt;JOIN_KEY_RHS&gt;&lt;/JOIN_KEY_RHS&gt;&lt;RELATIONSHIP_TYPE&gt;many-to-many&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_NAME&gt;CampaignTrackers CAMPAIGN_TRKRS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[CampaignTrackers CAMPAIGN_TRKRS] Campaign Trackers&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Relationships</Name><Value>&lt;Relationships&gt;&lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;Campaigns&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Campaigns&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CAMPAIGNS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;CAMPAIGNS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Campaigns CAMPAIGNS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Campaigns CAMPAIGNS] Campaigns&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;campaigns_audit_old&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Campaigns&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;CAMPAIGNS_AUDIT&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;ID&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;Campaigns&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;CAMPAIGNS&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;ID&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;CAMPAIGNS_AUDIT_OLD&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Campaigns CAMPAIGNS_AUDIT_OLD&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Campaigns CAMPAIGNS_AUDIT_OLD] Campaigns: Audit Old&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;users_all&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Users&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;USERS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;USERS_ALL&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Users USERS_ALL&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Users USERS_ALL] Users All&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;teams&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Teams&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;TEAMS&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;TEAMS&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Teams TEAMS&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Teams TEAMS] Teams&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;Relationship&gt;&lt;RELATIONSHIP_NAME&gt;roles&lt;/RELATIONSHIP_NAME&gt;&lt;LHS_MODULE&gt;Roles&lt;/LHS_MODULE&gt;&lt;LHS_TABLE&gt;ACL_ROLES&lt;/LHS_TABLE&gt;&lt;LHS_KEY&gt;&lt;/LHS_KEY&gt;&lt;RHS_MODULE&gt;&lt;/RHS_MODULE&gt;&lt;RHS_TABLE&gt;&lt;/RHS_TABLE&gt;&lt;RHS_KEY&gt;&lt;/RHS_KEY&gt;&lt;RELATIONSHIP_TYPE&gt;&lt;/RELATIONSHIP_TYPE&gt;&lt;MODULE_ALIAS&gt;ACL_ROLES&lt;/MODULE_ALIAS&gt;&lt;MODULE_NAME&gt;Roles ACL_ROLES&lt;/MODULE_NAME&gt;&lt;DISPLAY_NAME&gt;[Roles ACL_ROLES] Roles&lt;/DISPLAY_NAME&gt;&lt;/Relationship&gt;  &lt;/Relationships&gt;</Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;b1d0dcec-18d2-48ed-8343-1de9978071c3&lt;/ID&gt;&lt;ACTION_TYPE&gt;current_user&lt;/ACTION_TYPE&gt;&lt;RELATIONSHIP_NAME&gt;&lt;/RELATIONSHIP_NAME&gt;&lt;MODULE&gt;Campaigns&lt;/MODULE&gt;&lt;MODULE_NAME&gt;Campaigns CAMPAIGNS&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;CAMPAIGNS&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;CAMPAIGNS.ASSIGNED_USER_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;ASSIGNED_USER_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;to&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;RECIPIENT_NAME&gt;&lt;/RECIPIENT_NAME&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties><DataSources><DataSource Name="dataSource1"><ConnectionProperties><DataProvider>SQL</DataProvider><ConnectString></ConnectString></ConnectionProperties></DataSource></DataSources><DataSets><DataSet Name="dataSet"><Query><DataSourceName>dataSource1</DataSourceName><CommandText></CommandText></Query><Fields></Fields></DataSet></DataSets><Body><ReportItems><Table Name="table1"><DataSetName>dataSet</DataSetName><Header><RepeatOnNewPage>true</RepeatOnNewPage><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Header><Details><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Details><TableColumns></TableColumns></Table></ReportItems><Height>8.5in</Height></Body></Report>'
, '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="39F594FB-D6CE-4DE3-80E9-DFE76A552304" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
	<crm:CampaignActivity x:Name="Campaigns2" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="Campaigns2_Log" MODULE_TABLE="CAMPAIGNS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

		<CodeActivity x:Name="Campaigns2_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Campaigns2,Path=LoadByAUDIT_ID}" />
	</crm:CampaignActivity>
	<crm:AlertActivity x:Name="Alert2" SUBJECT="SplendidCRM Campaign - $campaign_name" ALERT_TYPE="Notification" ALERT_TEXT="$campaign_modified_by has assigned an Campaign to $campaign_assigned_to.&#xD;&#xA;&#xD;&#xA;Name: $campaign_name&#xD;&#xA;&#xD;&#xA;Expected Cost: $campaign_expected_cost&#xD;&#xA;&#xD;&#xA;Close Date: $campaign_end_date&#xD;&#xA;&#xD;&#xA;Status: $campaign_status&#xD;&#xA;&#xD;&#xA;Objective: $campaign_objective&#xD;&#xA;&#xD;&#xA;You may review this Campaign at:&#xD;&#xA;&lt;a href=&quot;$view_url&quot;&gt;$view_url&lt;/a&gt;&#xD;&#xA;&#xD;&#xA;" SOURCE_TYPE="normal message" CUSTOM_TEMPLATE_ID="00000000-0000-0000-0000-000000000000" PARENT_TYPE="Campaigns" PARENT_ACTIVITY="Campaigns2" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="Alert2_Log" MODULE_TABLE="EMAILS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />
		<crm:AddRecipientActivity x:Name="Alert2_Campaigns2_AssignedUserID" ALERT_NAME="Alert2" RECIPIENT_NAME="" RECIPIENT_ID="{ActivityBind Campaigns2,Path=ASSIGNED_USER_ID}" RECIPIENT_TYPE="User" SEND_TYPE="to" />

		<CodeActivity x:Name="Alert2_Send" ExecuteCode="{ActivityBind Alert2,Path=Send}" />
	</crm:AlertActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'RECEIVE_NOTIFICATIONS', 'compare_specific', 'Primary', 'equals'   , 0, 'Users'   , null, '1';
	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'EMAIL1'               , 'compare_specific', 'Primary', 'not_empty', 0, 'Users'   , null, null;
	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, 'ASSIGNED_USER_ID'     , 'compare_change'  , 'Primary', 'changed'  , 0, 'Campaigns', null, null;
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

call dbo.spWORKFLOWS_Campaigns_Notifications()
/

call dbo.spSqlDropProcedure('spWORKFLOWS_Campaigns_Notifications')
/

-- #endif IBM_DB2 */

