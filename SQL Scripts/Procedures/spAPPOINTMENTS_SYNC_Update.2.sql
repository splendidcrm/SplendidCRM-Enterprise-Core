if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spAPPOINTMENTS_SYNC_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spAPPOINTMENTS_SYNC_Update;
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
-- 03/28/2010 Paul.  Exchange Web Services returns dates in local time, so lets store both local time and UTC time. 
-- 03/28/2010 Paul.  REMOTE_KEY does not need to be an nvarchar.  
-- 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
-- 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
-- 12/25/2020 Paul.  There can only be one appointment sync record, otherwise all users would see multiple entries in Outlook. (Should have been fixed on 06/22/2018). 
Create Procedure dbo.spAPPOINTMENTS_SYNC_Update
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
	declare @APPOINTMENT_TYPE        nvarchar(25);
	declare @REQUIRED                bit;
	declare @ACCEPT_STATUS           nvarchar(25);

	-- BEGIN Oracle Exception
		select @APPOINTMENT_TYPE = APPOINTMENT_TYPE
		  from vwAPPOINTMENTS
		 where ID = @LOCAL_ID;
	-- END Oracle Exception

	if @APPOINTMENT_TYPE = N'Meetings' begin -- then
		-- BEGIN Oracle Exception
			select @REQUIRED      = REQUIRED
			     , @ACCEPT_STATUS = ACCEPT_STATUS
			  from MEETINGS_USERS
			 where MEETING_ID     = @LOCAL_ID
			   and USER_ID        = @ASSIGNED_USER_ID
			   and DELETED        = 0;
		-- END Oracle Exception
		-- 03/29/2010 Paul.  Make sure to set the Sync flag. 
		exec dbo.spMEETINGS_USERS_Update @MODIFIED_USER_ID, @LOCAL_ID, @ASSIGNED_USER_ID, @REQUIRED, @ACCEPT_STATUS;
		-- BEGIN Oracle Exception
			select @LOCAL_DATE_MODIFIED     = DATE_MODIFIED
			     , @LOCAL_DATE_MODIFIED_UTC = DATE_MODIFIED_UTC
			  from vwMEETINGS
			 where ID = @LOCAL_ID;
		-- END Oracle Exception
	end else begin
		-- BEGIN Oracle Exception
			select @REQUIRED      = REQUIRED
			     , @ACCEPT_STATUS = ACCEPT_STATUS
			  from CALLS_USERS
			 where CALL_ID        = @LOCAL_ID
			   and USER_ID        = @ASSIGNED_USER_ID
			   and DELETED        = 0;
		-- END Oracle Exception
		-- 03/29/2010 Paul.  Make sure to set the Sync flag. 
		exec dbo.spCALLS_USERS_Update @MODIFIED_USER_ID, @LOCAL_ID, @ASSIGNED_USER_ID, @REQUIRED, @ACCEPT_STATUS;
		-- BEGIN Oracle Exception
			select @LOCAL_DATE_MODIFIED     = DATE_MODIFIED
			     , @LOCAL_DATE_MODIFIED_UTC = DATE_MODIFIED_UTC
			  from vwCALLS
			 where ID = @LOCAL_ID;
		-- END Oracle Exception
	end -- if;

	-- 12/25/2020 Paul.  We should have removed @ASSIGNED_USER_ID from the lookup on 06/22/2018. 
	-- Now we need to delete any potential duplicate entries.  Duplicates are craeted when to users are assigned to same call/meeting. 
	if exists(select REMOTE_KEY
		  from APPOINTMENTS_SYNC
		 where REMOTE_KEY       = @REMOTE_KEY 
		   and LOCAL_ID         = @LOCAL_ID 
		   and SERVICE_NAME     = @SERVICE_NAME
		   and DELETED          = 0
	         group by REMOTE_KEY
	         having count(*) > 1
	         ) begin -- then
		update APPOINTMENTS_SYNC
		   set DELETED          = 1
		     , DATE_MODIFIED_UTC= getutcdate()
		 where REMOTE_KEY       = @REMOTE_KEY 
		   and LOCAL_ID         = @LOCAL_ID 
		   and SERVICE_NAME     = @SERVICE_NAME
		   and DELETED          = 0;
	end -- if;

	-- BEGIN Oracle Exception
		select @ID = ID
		  from APPOINTMENTS_SYNC
		 where REMOTE_KEY       = @REMOTE_KEY 
		--   and ASSIGNED_USER_ID = @ASSIGNED_USER_ID 
		   and LOCAL_ID         = @LOCAL_ID 
		   and SERVICE_NAME     = @SERVICE_NAME
		   and DELETED          = 0;
	-- END Oracle Exception
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into APPOINTMENTS_SYNC
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
		update APPOINTMENTS_SYNC
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

Grant Execute on dbo.spAPPOINTMENTS_SYNC_Update to public;
GO


