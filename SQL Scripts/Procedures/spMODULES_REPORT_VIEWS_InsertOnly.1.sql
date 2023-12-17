if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_REPORT_VIEWS_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_REPORT_VIEWS_InsertOnly;
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
-- 01/31/2019 Paul.  Fix formatting to ease conversion to Oracle. 
Create Procedure dbo.spMODULES_REPORT_VIEWS_InsertOnly
	( @NAME               nvarchar(100)
	, @MODULE_NAME        nvarchar(25)
	, @VIEW_NAME          nvarchar(50)
	, @PRIMARY_FIELD      nvarchar(50)
	)
as
  begin
	set nocount on
	
	declare @ID                 uniqueidentifier;
	declare @MODIFIED_USER_ID   uniqueidentifier;
	
	if not exists(select * from MODULES_REPORT_VIEWS where VIEW_NAME = @VIEW_NAME) begin -- then
		set @ID = newid();
		insert into MODULES_REPORT_VIEWS
			( ID                
			, CREATED_BY        
			, DATE_ENTERED      
			, MODIFIED_USER_ID  
			, DATE_MODIFIED     
			, DATE_MODIFIED_UTC 
			, NAME              
			, MODULE_NAME       
			, VIEW_NAME         
			, PRIMARY_FIELD     
			)
		values 	( @ID                
			, @MODIFIED_USER_ID  
			,  getdate()         
			, @MODIFIED_USER_ID  
			,  getdate()         
			,  getutcdate()      
			, @NAME              
			, @MODULE_NAME       
			, @VIEW_NAME         
			, @PRIMARY_FIELD     
			);
	end -- if;
  end
GO

Grant Execute on dbo.spMODULES_REPORT_VIEWS_InsertOnly to public;
GO

