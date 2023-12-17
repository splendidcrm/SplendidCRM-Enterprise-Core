if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROCESSES_UpdateApproval' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROCESSES_UpdateApproval;
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
Create Procedure dbo.spPROCESSES_UpdateApproval
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @APPROVAL_USER_ID  uniqueidentifier
	, @APPROVAL_RESPONSE nvarchar(100)
	)
as
  begin
	set nocount on

	declare @STATUS                       nvarchar(50);
	declare @BOOKMARK_NAME                nvarchar(100);
	declare @BLOCKING_BOOKMARKS           nvarchar(max);
	declare @BUSINESS_PROCESS_INSTANCE_ID uniqueidentifier;

	-- Approve, Reject, Route, Claim, Cancel
	-- 08/01/2016 Paul.  Process not marked completed until end, but can be cancelled during approval or wait. 
	if @APPROVAL_RESPONSE = N'Cancel' begin -- then
		set @STATUS = N'Cancelled';
	end else if @APPROVAL_RESPONSE = N'Route' begin -- then
		set @STATUS = N'Routed';
	end else if @APPROVAL_RESPONSE = N'Claim' begin -- then
		set @STATUS = N'Claimed';
	end else if @APPROVAL_RESPONSE = N'Approve' begin -- then
		set @STATUS = N'Approved';
	end else if @APPROVAL_RESPONSE = N'Reject' begin -- then
		set @STATUS = N'Rejected';
	end -- if;

	-- BEGIN Oracle Exception
		select @BUSINESS_PROCESS_INSTANCE_ID = BUSINESS_PROCESS_INSTANCE_ID
		     , @BOOKMARK_NAME                = BOOKMARK_NAME
		  from PROCESSES
		 where ID = @ID;
	-- END Oracle Exception

	if @APPROVAL_RESPONSE = N'Claim' begin -- then
		update PROCESSES
		   set MODIFIED_USER_ID             = @MODIFIED_USER_ID 
		     , DATE_MODIFIED                =  getdate()        
		     , DATE_MODIFIED_UTC            =  getutcdate()     
		     , PROCESS_USER_ID              = @APPROVAL_USER_ID
		     , STATUS                       = @STATUS
		 where ID                           = @ID               
		   and DELETED                      = 0;
	end else if @APPROVAL_RESPONSE = N'Approve' or @APPROVAL_RESPONSE = N'Reject' or @APPROVAL_RESPONSE = N'Route' or @APPROVAL_RESPONSE = N'Cancel' begin -- then
		update PROCESSES
		   set MODIFIED_USER_ID             = @MODIFIED_USER_ID 
		     , DATE_MODIFIED                =  getdate()        
		     , DATE_MODIFIED_UTC            =  getutcdate()     
		     , APPROVAL_USER_ID             = @APPROVAL_USER_ID 
		     , APPROVAL_RESPONSE            = @APPROVAL_RESPONSE
		     , APPROVAL_DATE                =  getdate()        
		     , STATUS                       = @STATUS
		 where ID                           = @ID               
		   and DELETED                      = 0;

		set @BLOCKING_BOOKMARKS = '<?xml version="1.0" encoding="utf-8"?><Bookmarks><Bookmark BookmarkName="' + @BOOKMARK_NAME + '" USER_ID="' + cast(@APPROVAL_USER_ID as char(36))  + '">' + @APPROVAL_RESPONSE + '</Bookmark></Bookmarks>';
		update WF4_INSTANCES_RUNNABLE
		   set IS_READY_TO_RUN              = 1
		     , IS_SUSPENDED                 = 0
		     , DATE_MODIFIED_UTC            = getutcdate()
		     , DELETED                      = 0
		     , BLOCKING_BOOKMARKS           = @BLOCKING_BOOKMARKS
		 where ID                           = @BUSINESS_PROCESS_INSTANCE_ID;
	end -- if;

	exec dbo. spPROCESSES_HISTORY_InsertOnly @MODIFIED_USER_ID, @ID, @BUSINESS_PROCESS_INSTANCE_ID, @APPROVAL_RESPONSE, null, null, @APPROVAL_USER_ID, @STATUS;
  end
GO
 
Grant Execute on dbo.spPROCESSES_UpdateApproval to public;
GO
 
