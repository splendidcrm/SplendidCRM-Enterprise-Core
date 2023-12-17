if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEDITVIEWS_RELATIONSHIPS_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEDITVIEWS_RELATIONSHIPS_InsertOnly;
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
Create Procedure dbo.spEDITVIEWS_RELATIONSHIPS_InsertOnly
	( @EDIT_NAME               nvarchar(50)
	, @MODULE_NAME             nvarchar(50)
	, @CONTROL_NAME            nvarchar(100)
	, @RELATIONSHIP_ENABLED    bit
	, @RELATIONSHIP_ORDER      int
	, @NEW_RECORD_ENABLED      bit
	, @EXISTING_RECORD_ENABLED bit
	, @TITLE                   nvarchar(100)
	, @ALTERNATE_VIEW          nvarchar(50)
	)
as
  begin
	if not exists(select * from EDITVIEWS_RELATIONSHIPS where EDIT_NAME = @EDIT_NAME and CONTROL_NAME = @CONTROL_NAME and DELETED = 0) begin -- then
		insert into EDITVIEWS_RELATIONSHIPS
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, EDIT_NAME          
			, MODULE_NAME        
			, CONTROL_NAME       
			, RELATIONSHIP_ORDER 
			, RELATIONSHIP_ENABLED
			, NEW_RECORD_ENABLED     
			, EXISTING_RECORD_ENABLED
			, TITLE              
			, ALTERNATE_VIEW     
			)
		values 
			( newid()             
			, null                
			,  getdate()          
			, null                
			,  getdate()          
			, @EDIT_NAME          
			, @MODULE_NAME        
			, @CONTROL_NAME       
			, @RELATIONSHIP_ORDER 
			, @RELATIONSHIP_ENABLED
			, @NEW_RECORD_ENABLED     
			, @EXISTING_RECORD_ENABLED
			, @TITLE              
			, @ALTERNATE_VIEW     
			);
	end -- if;
  end
GO
 
Grant Execute on dbo.spEDITVIEWS_RELATIONSHIPS_InsertOnly to public;
GO
 
