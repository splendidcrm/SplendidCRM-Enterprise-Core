if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDASHLETS_USERS_AddReport' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDASHLETS_USERS_AddReport;
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
-- 04/09/2011 Paul.  Change type to Hidden so that the report cannot be edited. 
Create Procedure dbo.spDASHLETS_USERS_AddReport
	( @MODIFIED_USER_ID uniqueidentifier
	, @ASSIGNED_USER_ID uniqueidentifier
	, @DETAIL_NAME      nvarchar(50)
	, @REPORT_ID        uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @DASHLETS_USER_ID uniqueidentifier;
	declare @MODULE_NAME      nvarchar(50);
	declare @CONTROL_NAME     nvarchar(100);
	declare @DASHLET_ORDER    int;
	declare @TITLE            nvarchar(100);
	declare @SEARCH_MODULE    nvarchar(150);
	declare @CONTENTS         nvarchar(max);

	set @MODULE_NAME  = N'Reports';
	set @CONTROL_NAME = N'~/Reports/DashletReport';
	-- BEGIN Oracle Exception
		select @TITLE = NAME
		  from vwREPORTS
		 where ID = @REPORT_ID;
	-- END Oracle Exception

	select @DASHLET_ORDER = max(DASHLET_ORDER) + 1
	  from DASHLETS_USERS
	 where ASSIGNED_USER_ID = @ASSIGNED_USER_ID 
	   and DETAIL_NAME      = @DETAIL_NAME      
	   and DELETED          = 0;
	-- 09/29/2009 Paul.  If the list is empty, the order will be zero. 
	if @DASHLET_ORDER is null begin -- then
		set @DASHLET_ORDER = 0;
	end -- if;

	set @DASHLETS_USER_ID = newid();
	insert into DASHLETS_USERS
		( ID              
		, CREATED_BY      
		, DATE_ENTERED    
		, MODIFIED_USER_ID
		, DATE_MODIFIED   
		, DATE_MODIFIED_UTC
		, ASSIGNED_USER_ID
		, DETAIL_NAME     
		, MODULE_NAME     
		, CONTROL_NAME    
		, DASHLET_ORDER   
		, DASHLET_ENABLED 
		, TITLE           
		)
	values	( @DASHLETS_USER_ID
		, @MODIFIED_USER_ID
		,  getdate()       
		, @MODIFIED_USER_ID
		,  getdate()       
		,  getutcdate()    
		, @ASSIGNED_USER_ID
		, @DETAIL_NAME     
		, @MODULE_NAME     
		, @CONTROL_NAME    
		, @DASHLET_ORDER   
		, 1                
		, @TITLE           
		);
	set @SEARCH_MODULE = N'Reports.SearchDashlet.' + cast(@DASHLETS_USER_ID as char(36));
	-- 04/09/2011 Paul.  Change type to Hidden so that the report cannot be edited. 
	set @CONTENTS      = N'<?xml version="1.0" encoding="UTF-8"?><SavedSearch><SearchFields><Field Name="ID" Type="Hidden">' + lower(cast(@REPORT_ID as char(36))) + '</Field></SearchFields></SavedSearch>';
	insert into SAVED_SEARCH
		( ID               
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, DATE_MODIFIED_UTC
		, ASSIGNED_USER_ID 
		, NAME             
		, SEARCH_MODULE    
		, CONTENTS         
		, DESCRIPTION      
		)
	values 	( newid()           
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @MODIFIED_USER_ID 
		,  getdate()        
		,  getutcdate()     
		, @ASSIGNED_USER_ID 
		, null              
		, @SEARCH_MODULE    
		, @CONTENTS         
		, null              
		);
  end
GO

Grant Execute on dbo.spDASHLETS_USERS_AddReport to public;
GO

