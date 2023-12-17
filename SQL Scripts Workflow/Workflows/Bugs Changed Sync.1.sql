

print 'WORKFLOWS Bugs Changed Sync';
GO

set nocount on;
GO

declare @ID uniqueidentifier;
set @ID = '2a35889e-c2b1-4d72-8b54-70a7497d0e9a';
if not exists(select * from WORKFLOW where ID = @ID) begin -- then
	exec dbo.spWORKFLOWS_Update @ID, null, 'Bugs Changed Sync', 'Bugs', 'BUGS_AUDIT', 1, 'normal', 'alerts_actions', 'all', null, 'select *
  from            vwBUGS_AUDIT            BUGS
 where BUGS.AUDIT_ID = @AUDIT_ID
   and BUGS.DELETED  = 0
', '<?xml version="1.0" encoding="UTF-8"?><Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><Width>11in</Width><PageWidth>11in</PageWidth><PageHeight>8.5in</PageHeight><LeftMargin>.5in</LeftMargin><RightMargin>.5in</RightMargin><TopMargin>.5in</TopMargin><BottomMargin>.5in</BottomMargin><Description></Description><Author></Author><CustomProperties><CustomProperty><Name>crm:ReportName</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:Module</Name><Value>Bugs</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:FrequencyValue</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:FrequencyInterval</Name><Value>day</Value></CustomProperty></CustomProperties><DataSources><DataSource Name="dataSource1"><ConnectionProperties><DataProvider>SQL</DataProvider><ConnectString></ConnectString></ConnectionProperties></DataSource></DataSources><DataSets><DataSet Name="dataSet"><Query><DataSourceName>dataSource1</DataSourceName><CommandText>select *
  from            vwBUGS_AUDIT            BUGS
 where BUGS.AUDIT_ID = @AUDIT_ID
   and BUGS.DELETED  = 0
</CommandText></Query><Fields></Fields></DataSet></DataSets><Body><ReportItems><Table Name="table1"><DataSetName>dataSet</DataSetName><Header><RepeatOnNewPage>true</RepeatOnNewPage><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Header><Details><TableRows><TableRow><Height>0.21in</Height><TableCells></TableCells></TableRow></TableRows></Details><TableColumns></TableColumns></Table></ReportItems><Height>8.5in</Height></Body></Report>', null;

	exec dbo.spWORKFLOWS_UpdateXOML @ID, null, 0, '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="2a35889e-c2b1-4d72-8b54-70a7497d0e9a" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">

<SequenceActivity x:Name="Sequence1" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:BugActivity x:Name="Bugs1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}">
		<crm:WorkflowLogActivity x:Name="Bugs1_Log" MODULE_TABLE="BUGS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

		<CodeActivity x:Name="Bugs1_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Bugs1,Path=LoadByAUDIT_ID}" />
	</crm:BugActivity>
	<crm:BugSyncActivity x:Name="BugSyncActivity1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}">

		<CodeActivity x:Name="BugSyncActivity1_CustomMethod" ExecuteCode="{ActivityBind BugSyncActivity1,Path=CustomMethod}" />
	</crm:BugSyncActivity>
</SequenceActivity>
</crm:SplendidSequentialWorkflow>';

	exec dbo.spWORKFLOW_ACTION_SHELLS_InsertOnly null, @ID, 'Bug Sync Activity Custom Method', 'custom_method', '<?xml version="1.0" encoding="UTF-8"?><Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition"><CustomProperties><CustomProperty><Name>crm:ReportName</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:Module</Name><Value>Bugs</Value></CustomProperty><CustomProperty><Name>crm:Related</Name><Value></Value></CustomProperty><CustomProperty><Name>crm:Relationships</Name><Value>&lt;Relationships /&gt;</Value></CustomProperty><CustomProperty><Name>crm:Filters</Name><Value>&lt;Filters&gt;&lt;Filter&gt;&lt;ID&gt;5e894a20-fcae-4c2d-a7ec-e2b8beff9ec9&lt;/ID&gt;&lt;ACTION_TYPE&gt;custom_method&lt;/ACTION_TYPE&gt;&lt;RELATIONSHIP_NAME&gt;BugSyncActivity&lt;/RELATIONSHIP_NAME&gt;&lt;MODULE&gt;&lt;/MODULE&gt;&lt;MODULE_NAME&gt;&lt;/MODULE_NAME&gt;&lt;TABLE_NAME&gt;&lt;/TABLE_NAME&gt;&lt;DATA_FIELD&gt;CustomMethod&lt;/DATA_FIELD&gt;&lt;FIELD_NAME&gt;CustomMethod&lt;/FIELD_NAME&gt;&lt;DATA_TYPE&gt;string&lt;/DATA_TYPE&gt;&lt;OPERATOR&gt;equals&lt;/OPERATOR&gt;&lt;SEARCH_TEXT&gt;&lt;/SEARCH_TEXT&gt;&lt;SEARCH_TEXT_VALUES&gt;&lt;/SEARCH_TEXT_VALUES&gt;&lt;/Filter&gt;&lt;/Filters&gt;</Value></CustomProperty></CustomProperties></Report>', '<crm:SplendidSequentialWorkflow x:Name="Workflow1" WORKFLOW_ID="2a35889e-c2b1-4d72-8b54-70a7497d0e9a" xmlns:crm="clr-namespace:SplendidCRM;Assembly=SplendidCRM" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
	<crm:BugActivity x:Name="Bugs1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" AUDIT_ID="{ActivityBind Workflow1,Path=AUDIT_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">
		<crm:WorkflowLogActivity x:Name="Bugs1_Log" MODULE_TABLE="BUGS" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" />

		<CodeActivity x:Name="Bugs1_LoadByAUDIT_ID" ExecuteCode="{ActivityBind Bugs1,Path=LoadByAUDIT_ID}" />
	</crm:BugActivity>
	<crm:BugSyncActivity x:Name="BugSyncActivity1" WORKFLOW_ID="{ActivityBind Workflow1,Path=WORKFLOW_ID}" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml/workflow">

		<CodeActivity x:Name="BugSyncActivity1_CustomMethod" ExecuteCode="{ActivityBind BugSyncActivity1,Path=CustomMethod}" />
	</crm:BugSyncActivity>
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

call dbo.spWORKFLOWS_Bugs_Changed_Sync()
/

call dbo.spSqlDropProcedure('spWORKFLOWS_Bugs_Changed_Sync')
/

-- #endif IBM_DB2 */

