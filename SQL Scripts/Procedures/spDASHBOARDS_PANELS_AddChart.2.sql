if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDASHBOARDS_PANELS_AddChart' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDASHBOARDS_PANELS_AddChart;
GO

/**********************************************************************************************************************
 * SplendidCRM is a Customer Relationship Management program created by SplendidCRM Software, Inc. 
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 * SplendidCRM owns all proprietary rights, including all copyrights, patents, trade secrets, and 
 * trademarks, in and to the contents of this file.  You will not link to or in any way combine the 
 * contents of this file or any derivatives with any Open Source Code in any manner that would require 
 * the contents of this file to be made available to any third party. 
 * 
 *********************************************************************************************************************/
Create Procedure dbo.spDASHBOARDS_PANELS_AddChart
	( @MODIFIED_USER_ID   uniqueidentifier
	, @ASSIGNED_USER_ID   uniqueidentifier
	, @TEAM_ID            uniqueidentifier
	, @DASHBOARD_ID       uniqueidentifier
	, @DASHBOARD_CATEGORY nvarchar(50)
	, @CHART_ID           uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID                  uniqueidentifier;
	declare @TEAM_SET_ID         uniqueidentifier;
	declare @TEAM_SET_LIST       varchar(8000);
	declare @DASHBOARD_APP_ID    uniqueidentifier;
	declare @NAME                nvarchar(150);
	declare @CATEGORY            nvarchar( 25);
	declare @MODULE_NAME         nvarchar( 50);
	declare @TITLE               nvarchar(100);
	declare @SETTINGS_EDITVIEW   nvarchar( 50);
	declare @SCRIPT_URL          nvarchar(2083);
	declare @DEFAULT_SETTINGS    nvarchar(max);
	declare @PANEL_ORDER         int;
	declare @ROW_INDEX           int;
	declare @COLUMN_WIDTH        int;

	set @NAME              = N'Chart: ' + cast(@CHART_ID as char(36));
	set @CATEGORY          = N'Chart';
	set @MODULE_NAME       = N'Charts';
	set @TITLE             = null;
	set @SETTINGS_EDITVIEW = null;
	set @SCRIPT_URL        = N'~/html5/Dashlets/ChartViewerFrame.js';
	set @DEFAULT_SETTINGS  = N'CHART_ID=' + cast(@CHART_ID as char(36));

	select @TITLE = substring(NAME, 1, 100)
	  from CHARTS
	 where ID     = @CHART_ID;

	set @DASHBOARD_APP_ID = newid();
	insert into DASHBOARD_APPS
		( ID                 
		, CREATED_BY         
		, DATE_ENTERED       
		, MODIFIED_USER_ID   
		, DATE_MODIFIED      
		, NAME               
		, CATEGORY           
		, MODULE_NAME        
		, TITLE              
		, SETTINGS_EDITVIEW  
		, SCRIPT_URL         
		, IS_ADMIN           
		, APP_ENABLED        
		, DEFAULT_SETTINGS   
		)
	values 
		( @DASHBOARD_APP_ID   
		,  null               
		,  getdate()          
		,  null               
		,  getdate()          
		, @NAME               
		, @CATEGORY           
		, @MODULE_NAME        
		, @TITLE              
		, @SETTINGS_EDITVIEW  
		, @SCRIPT_URL         
		, 0                   
		, 1                   
		, @DEFAULT_SETTINGS   
		);

	if not exists(select * from DASHBOARDS where ID = @DASHBOARD_ID and DELETED = 0) begin -- then
		exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
		set @DASHBOARD_ID = newid();
		insert into DASHBOARDS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, ASSIGNED_USER_ID 
			, TEAM_ID          
			, TEAM_SET_ID      
			, NAME             
			, CATEGORY         
			, DESCRIPTION      
			, CONTENT          
			)
		values 	( @DASHBOARD_ID     
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @ASSIGNED_USER_ID 
			, @TEAM_ID          
			, @TEAM_SET_ID      
			, @TITLE            
			, @DASHBOARD_CATEGORY
			, null              
			, null              
			);
	end -- if;

	set @COLUMN_WIDTH = 12;
	select @PANEL_ORDER = isnull(max(PANEL_ORDER), 0) + 1
	     , @ROW_INDEX   = isnull(max(ROW_INDEX  ), 0) + 1
	  from DASHBOARDS_PANELS
	 where DASHBOARD_ID = @DASHBOARD_ID
	   and DELETED      = 0;

	set @ID = newid();
	insert into DASHBOARDS_PANELS
		( ID                
		, CREATED_BY        
		, DATE_ENTERED      
		, MODIFIED_USER_ID  
		, DATE_MODIFIED     
		, DATE_MODIFIED_UTC 
		, DASHBOARD_ID      
		, DASHBOARD_APP_ID  
		, PANEL_ORDER       
		, ROW_INDEX         
		, COLUMN_WIDTH      
		)
	values 	( @ID                
		, @MODIFIED_USER_ID  
		,  getdate()         
		, @MODIFIED_USER_ID  
		,  getdate()         
		,  getutcdate()      
		, @DASHBOARD_ID      
		, @DASHBOARD_APP_ID  
		, @PANEL_ORDER       
		, @ROW_INDEX         
		, @COLUMN_WIDTH      
		);
  end
GO

Grant Execute on dbo.spDASHBOARDS_PANELS_AddChart to public;
GO

