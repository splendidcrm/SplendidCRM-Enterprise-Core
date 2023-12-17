if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOW_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOW_Update;
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
-- 06/21/2021 Paul.  Create spWORKFLOW_Update procedure as procedure must match the table name. 
Create Procedure dbo.spWORKFLOW_Update
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(100)
	, @BASE_MODULE       nvarchar(100)
	, @AUDIT_TABLE       nvarchar(50)
	, @STATUS            bit
	, @TYPE              nvarchar(25)
	, @FIRE_ORDER        nvarchar(25)
	, @RECORD_TYPE       nvarchar(25)
	, @DESCRIPTION       nvarchar(max)
	, @FILTER_SQL        nvarchar(max)
	, @FILTER_XML        nvarchar(max)
	, @JOB_INTERVAL      nvarchar(100) = null
	, @PARENT_ID         uniqueidentifier = null
	)
as
  begin
	set nocount on
	
	exec dbo.spWORKFLOWS_Update
	  @ID out
	, @MODIFIED_USER_ID  
	, @NAME              
	, @BASE_MODULE       
	, @AUDIT_TABLE       
	, @STATUS            
	, @TYPE              
	, @FIRE_ORDER        
	, @RECORD_TYPE       
	, @DESCRIPTION       
	, @FILTER_SQL        
	, @FILTER_XML        
	, @JOB_INTERVAL      
	, @PARENT_ID         
	;
  end
GO

Grant Execute on dbo.spWORKFLOW_Update to public;
GO

