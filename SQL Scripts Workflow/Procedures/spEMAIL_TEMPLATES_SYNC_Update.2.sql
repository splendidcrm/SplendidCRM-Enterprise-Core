if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEMAIL_TEMPLATES_SYNC_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEMAIL_TEMPLATES_SYNC_Update;
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
Create Procedure dbo.spEMAIL_TEMPLATES_SYNC_Update
	( @MODIFIED_USER_ID         uniqueidentifier
	, @ASSIGNED_USER_ID         uniqueidentifier
	, @LOCAL_ID                 uniqueidentifier
	, @REMOTE_KEY               varchar(800)
	, @REMOTE_DATE_MODIFIED     datetime
	, @REMOTE_DATE_MODIFIED_UTC datetime
	, @SERVICE_NAME             nvarchar(25) = null
	, @RAW_CONTENT              nvarchar(max) = null
	)
as
  begin
	set nocount on

	declare @ID                      uniqueidentifier;
	-- 06/03/2010 Paul.  Place the larger field name first to ease Oracle conversion. 
	declare @LOCAL_DATE_MODIFIED_UTC datetime;
	declare @LOCAL_DATE_MODIFIED     datetime;

	-- BEGIN Oracle Exception
		select @LOCAL_DATE_MODIFIED     = DATE_MODIFIED
		     , @LOCAL_DATE_MODIFIED_UTC = DATE_MODIFIED_UTC
		  from vwEMAIL_TEMPLATES
		 where ID = @LOCAL_ID;
	-- END Oracle Exception
	-- BEGIN Oracle Exception
		select @ID = ID
		  from EMAIL_TEMPLATES_SYNC
		 where ASSIGNED_USER_ID = @ASSIGNED_USER_ID 
		   and REMOTE_KEY       = @REMOTE_KEY 
		   and LOCAL_ID         = @LOCAL_ID 
		   and SERVICE_NAME     = @SERVICE_NAME
		   and DELETED          = 0;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into EMAIL_TEMPLATES_SYNC
			( ID                      
			, CREATED_BY              
			, DATE_ENTERED            
			, MODIFIED_USER_ID        
			, DATE_MODIFIED           
			, DATE_MODIFIED_UTC       
			, ASSIGNED_USER_ID        
			, LOCAL_ID                
			, REMOTE_KEY              
			, LOCAL_DATE_MODIFIED     
			, REMOTE_DATE_MODIFIED    
			, LOCAL_DATE_MODIFIED_UTC 
			, REMOTE_DATE_MODIFIED_UTC
			, SERVICE_NAME            
			, RAW_CONTENT             
			)
		values
			( @ID                      
			, @MODIFIED_USER_ID        
			,  getdate()               
			, @MODIFIED_USER_ID        
			,  getdate()               
			,  getutcdate()            
			, @ASSIGNED_USER_ID        
			, @LOCAL_ID                
			, @REMOTE_KEY              
			, @LOCAL_DATE_MODIFIED     
			, @REMOTE_DATE_MODIFIED    
			, @LOCAL_DATE_MODIFIED_UTC 
			, @REMOTE_DATE_MODIFIED_UTC
			, @SERVICE_NAME            
			, @RAW_CONTENT             
			);
	end else begin
		update EMAIL_TEMPLATES_SYNC
		   set MODIFIED_USER_ID         = @MODIFIED_USER_ID        
		     , DATE_MODIFIED            =  getdate()               
		     , DATE_MODIFIED_UTC        =  getutcdate()            
		     , LOCAL_DATE_MODIFIED      = @LOCAL_DATE_MODIFIED     
		     , REMOTE_DATE_MODIFIED     = @REMOTE_DATE_MODIFIED    
		     , LOCAL_DATE_MODIFIED_UTC  = @LOCAL_DATE_MODIFIED_UTC 
		     , REMOTE_DATE_MODIFIED_UTC = @REMOTE_DATE_MODIFIED_UTC
		     , RAW_CONTENT              = @RAW_CONTENT             
		 where ID                       = @ID                      ;
	end -- if;
  end
GO

Grant Execute on dbo.spEMAIL_TEMPLATES_SYNC_Update to public;
GO


