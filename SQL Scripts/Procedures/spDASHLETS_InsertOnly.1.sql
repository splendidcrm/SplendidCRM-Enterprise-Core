if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDASHLETS_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDASHLETS_InsertOnly;
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
-- 09/24/2009 Paul.  The new Silverlight charts exceeded the control name length of 50. 
-- 01/24/2010 Paul.  Allow multiple. 
Create Procedure dbo.spDASHLETS_InsertOnly
	( @CATEGORY            nvarchar(25)
	, @MODULE_NAME         nvarchar(50)
	, @CONTROL_NAME        nvarchar(100)
	, @TITLE               nvarchar(100)
	, @ALLOW_MULTIPLE      bit = null
	)
as
  begin
	if not exists(select * from DASHLETS where MODULE_NAME = @MODULE_NAME and CONTROL_NAME = @CONTROL_NAME and DELETED = 0) begin -- then
		insert into DASHLETS
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, CATEGORY           
			, MODULE_NAME        
			, CONTROL_NAME       
			, TITLE              
			, DASHLET_ENABLED    
			, ALLOW_MULTIPLE     
			)
		values 
			( newid()             
			, null                
			,  getdate()          
			, null                
			,  getdate()          
			, @CATEGORY           
			, @MODULE_NAME        
			, @CONTROL_NAME       
			, @TITLE              
			, 1                   
			, @ALLOW_MULTIPLE     
			);
	end -- if;
  end
GO
 
Grant Execute on dbo.spDASHLETS_InsertOnly to public;
GO
 
