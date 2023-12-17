

print 'WORKFLOWS Leads Changed Sync';
GO

set nocount on;
GO

declare @ID uniqueidentifier;
set @ID = 'd5fcaea0-09aa-4a04-bde4-5ddbf84be63f';
if not exists(select * from WORKFLOW where ID = @ID) begin -- then
	exec dbo.spWORKFLOWS_Update @ID, null, 'Leads Changed Sync', 'Leads', 'LEADS_AUDIT', 1, 'normal', 'alerts_actions', 'all', null, 'select *
  from            vwLEADS_AUDIT           LEADS
 where LEADS.AUDIT_ID = @AUDIT_ID
   and LEADS.DELETED  = 0
', '<?xml version="1.0" encoding="UTF-8"?><Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><Width>11in</Width><PageWidth>11in</PageWidth><PageHeight>8.5in</PageHeight><LeftMargin>.5in</LeftMargin><RightMargin>.5in</RightMargin><TopMargin>.5in</TopMargin><BottomMargin>.5in</BottomMargin><Description></Description><Author></Author><CustomProperties><CustomProperty><Name>crm:ReportName</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:Module</Name><Value>Leads</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:FrequencyValue</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:FrequencyInterval</Name><Value>day</Value></CustomProperty></CustomProperties><DataSources><DataSource Name="dataSource1"><ConnectionProperties><DataProvider>SQL</DataProvider><ConnectString></ConnectString></ConnectionProperties></DataSource></DataSources><DataSets><DataSet Name="dataSet"><Query><DataSourceName>dataSource1</DataSourceName><CommandText>select *
  from            vwLEADS_AUDIT           LEADS
 where LEADS.AUDIT_ID = @AUDIT_ID
   and LEADS.DELETED  = 0
</CommandText></Query><Fields></Fields></DataSet></DataSets><Body><ReportItems><Table Name="table1"><DataSetName>dataSet</DataSetName><Header><RepeatOnNewPage>true</RepeatOnNewPage><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Header><Details><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Details><TableColumns></TableColumns></Table></ReportItems><Height>8.5in</Height></Body></Report>', null;

	exec dbo.spWORKFLOWS_UpdateXOML @ID, null, 0, '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="d5fcaea0-09aa-4a04-bde4-5ddbf84be63f" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">

<SequenceActivity x:Name="Sequence1" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:LeadActivity x:Name="Leads1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}">
		<crm:WorkflowLogActivity x:Name="Leads1_Log" MODULE_TABLE="LEADS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

		<CodeActivity x:Name="Leads1_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Leads1,Path=LoadByAUDIT_ID}" />
	</crm:LeadActivity>
	<crm:LeadSyncActivity x:Name="LeadSyncActivity1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}">
		<crm:SetValueActivity x:Name="LeadSyncActivity1_AuditID" LVALUE="{ActivityBind LeadSyncActivity1,Path=AUDIT_ID}" RVALUE="{ActivityBind Workflow1,Path=AUDIT_ID}" OPERATOR="equals" />

		<CodeActivity x:Name="LeadSyncActivity1_CustomMethod" ExecuteCode="{ActivityBind LeadSyncActivity1,Path=CustomMethod}" />
	</crm:LeadSyncActivity>
</SequenceActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_ACTION_SHELLS_InsertOnly null, @ID, 'Lead Sync Activity Custom Method', 'custom_method', '<?xml version="1.0" encoding="UTF-8"?><Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><CustomProperties><CustomProperty><Name>crm:ReportName</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:Module</Name><Value>Leads</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:Relationships</Name><Value>&lt;Relationships /&gt;</Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;dacc4f93-4407-44c9-8317-eb0a096161c5&lt;/ID&gt;&lt;ACTION_TYPE&gt;custom_prop&lt;/ACTION_TYPE&gt;&lt;RELATIONSHIP_NAME&gt;LeadSyncActivity&lt;/RELATIONSHIP_NAME&gt;&lt;MODULE&gt;&lt;/MODULE&gt;&lt;MODULE_NAME&gt;&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;AUDIT_ID&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;AUDIT_ID&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;string&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;equals&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;{ActivityBind Workflow1,Path=AUDIT_ID}&lt;/SEARCH_TEXT&gt;&lt;SEARCH_TEXT_VALUES&gt;{ActivityBind Workflow1,Path=AUDIT_ID}&lt;/SEARCH_TEXT_VALUES&gt;&lt;/Filter&gt;&lt;Filter&gt;&lt;ID&gt;e72e0b46-a5c5-4c8e-a7af-d7547bed9a12&lt;/ID&gt;&lt;ACTION_TYPE&gt;custom_method&lt;/ACTION_TYPE&gt;&lt;RELATIONSHIP_NAME&gt;LeadSyncActivity&lt;/RELATIONSHIP_NAME&gt;&lt;MODULE&gt;&lt;/MODULE&gt;&lt;MODULE_NAME&gt;&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;CustomMethod&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;CustomMethod&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;string&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;equals&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;SEARCH_TEXT_VALUES&gt;&lt;/SEARCH_TEXT_VALUES&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties></Report>', '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="d5fcaea0-09aa-4a04-bde4-5ddbf84be63f" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
	<crm:LeadActivity x:Name="Leads1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="Leads1_Log" MODULE_TABLE="LEADS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

		<CodeActivity x:Name="Leads1_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Leads1,Path=LoadByAUDIT_ID}" />
	</crm:LeadActivity>
	<crm:LeadSyncActivity x:Name="LeadSyncActivity1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:SetValueActivity x:Name="LeadSyncActivity1_AuditID" LVALUE="{ActivityBind LeadSyncActivity1,Path=AUDIT_ID}" RVALUE="{ActivityBind Workflow1,Path=AUDIT_ID}" OPERATOR="equals" />

		<CodeActivity x:Name="LeadSyncActivity1_CustomMethod" ExecuteCode="{ActivityBind LeadSyncActivity1,Path=CustomMethod}" />
	</crm:LeadSyncActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_TRIGGER_SHELLS_InsertOnly null, @ID, null, 'trigger_record_change', 'Primary', null, 0, null, null, null;
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

call dbo.spWORKFLOWS_Leads_Changed_Sync()
/

call dbo.spSqlDropProcedure('spWORKFLOWS_Leads_Changed_Sync')
/

-- #endif IBM_DB2 */

