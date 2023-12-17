if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spREPORTS_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spREPORTS_InsertOnly;
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 03/10/2012 Paul.  Add support for teams. 
Create Procedure dbo.spREPORTS_InsertOnly
	( @ID                uniqueidentifier
	, @NAME              nvarchar(150)
	, @MODULE_NAME       nvarchar(25)
	, @REPORT_TYPE       nvarchar(25)
	, @RDL               nvarchar(max)
	, @TEAM_ID           uniqueidentifier = null
	)
as
  begin
	set nocount on
	
	declare @MODIFIED_USER_ID  uniqueidentifier;
	declare @ASSIGNED_USER_ID  uniqueidentifier;
	declare @TEAM_SET_ID       uniqueidentifier;
	declare @TEAM_SET_LIST     varchar(8000);

	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;

	if not exists(select * from REPORTS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into REPORTS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, ASSIGNED_USER_ID 
			, NAME             
			, MODULE_NAME      
			, REPORT_TYPE      
			, RDL              
			, TEAM_ID          
			, TEAM_SET_ID      
			)
		values 	( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @ASSIGNED_USER_ID 
			, @NAME             
			, @MODULE_NAME      
			, @REPORT_TYPE      
			, @RDL              
			, @TEAM_ID          
			, @TEAM_SET_ID      
			);
	end -- if;
  end
GO

Grant Execute on dbo.spREPORTS_InsertOnly to public;
GO

