if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEDITVIEWS_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEDITVIEWS_InsertOnly;
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
-- 12/02/2007 Paul.  Add field for data columns. 
Create Procedure dbo.spEDITVIEWS_InsertOnly
	( @NAME              nvarchar(50)
	, @MODULE_NAME       nvarchar(25)
	, @VIEW_NAME         nvarchar(50)
	, @LABEL_WIDTH       nvarchar(10)
	, @FIELD_WIDTH       nvarchar(10)
	, @DATA_COLUMNS      int = null
	)
as
  begin
	if not exists(select * from EDITVIEWS where NAME = @NAME and DELETED = 0) begin -- then
		insert into EDITVIEWS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, NAME             
			, MODULE_NAME      
			, VIEW_NAME        
			, LABEL_WIDTH      
			, FIELD_WIDTH      
			, DATA_COLUMNS     
			)
		values 
			( newid()           
			, null              
			,  getdate()        
			, null              
			,  getdate()        
			, @NAME             
			, @MODULE_NAME      
			, @VIEW_NAME        
			, @LABEL_WIDTH      
			, @FIELD_WIDTH      
			, @DATA_COLUMNS     
			);
	end -- if;
  end
GO
 
Grant Execute on dbo.spEDITVIEWS_InsertOnly to public;
GO
 
