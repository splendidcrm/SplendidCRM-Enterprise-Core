if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spAPPOINTMENTS_RELATED_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spAPPOINTMENTS_RELATED_Update;
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
-- 01/10/2012 Paul.  iCloud can have contacts without an email. 
-- 01/10/2012 Paul.  Return the contact ID so that we can detect if a contact was found. 
-- 04/02/2012 Paul.  Add Calls/Leads relationship. 
Create Procedure dbo.spAPPOINTMENTS_RELATED_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @ID                uniqueidentifier
	, @EMAIL1            nvarchar(100)
	, @REQUIRED          bit
	, @ACCEPT_STATUS     nvarchar(25)
	, @CONTACT_NAME      nvarchar(100)
	, @CONTACT_ID        uniqueidentifier output
	)
as
  begin
	set nocount on
	
	declare @APPOINTMENT_TYPE nvarchar(25);
	declare @USER_ID          uniqueidentifier;
	declare @CONTACT_TYPE     nvarchar(25);

	set @CONTACT_TYPE = N'Contacts';
	-- BEGIN Oracle Exception
		select @APPOINTMENT_TYPE = APPOINTMENT_TYPE
		  from vwAPPOINTMENTS
		 where ID = @ID;
	-- END Oracle Exception

	-- 01/10/2012 Paul.  The contact ID will be provided if the contact has just been created. 
	if dbo.fnIsEmptyGuid(@CONTACT_ID) = 1 begin -- then
		-- BEGIN Oracle Exception
			select top 1 @CONTACT_ID = ID
			  from vwCONTACTS
			 where EMAIL1 = @EMAIL1;
		-- END Oracle Exception
		-- 04/02/2012 Paul.  First do Contacts email lookup, then Leads email lookup. 
		if dbo.fnIsEmptyGuid(@CONTACT_ID) = 1 begin -- then
			-- BEGIN Oracle Exception
				select top 1 @CONTACT_ID = ID
				  from vwLEADS
				 where NAME = @CONTACT_NAME;
			-- END Oracle Exception
			if dbo.fnIsEmptyGuid(@CONTACT_ID) = 0 begin -- then
				set @CONTACT_TYPE = N'Leads';
			end -- if;
		end -- if;
		if dbo.fnIsEmptyGuid(@CONTACT_ID) = 1 begin -- then
			-- BEGIN Oracle Exception
				select top 1 @CONTACT_ID = ID
				  from vwCONTACTS
				 where NAME = @CONTACT_NAME;
			-- END Oracle Exception
		end -- if;
		-- 04/02/2012 Paul.  Next do Contacts name lookup, then Leads name lookup. 
		if dbo.fnIsEmptyGuid(@CONTACT_ID) = 1 begin -- then
			-- BEGIN Oracle Exception
				select top 1 @CONTACT_ID = ID
				  from vwLEADS
				 where NAME = @CONTACT_NAME;
			-- END Oracle Exception
			if dbo.fnIsEmptyGuid(@CONTACT_ID) = 0 begin -- then
				set @CONTACT_TYPE = N'Leads';
			end -- if;
		end -- if;
	end -- if;

	-- print @EMAIL1;
	-- BEGIN Oracle Exception
		select top 1 @USER_ID = USER_ID
		  from vwAPPOINTMENTS_USER_EMAIL1
		 where EMAIL1 = @EMAIL1;
	-- END Oracle Exception

	-- 03/29/2010 Paul.  A new Appointment will be created as a Meeting. 
	if dbo.fnIsEmptyGuid(@CONTACT_ID) = 0 begin -- then
		if @CONTACT_TYPE = N'Leads' begin -- then
			-- print 'Lead: ' + cast(@CONTACT_ID as char(36));
			if @APPOINTMENT_TYPE = N'Meetings' or @APPOINTMENT_TYPE is null begin -- then
				exec dbo.spMEETINGS_LEADS_Update @MODIFIED_USER_ID, @ID, @CONTACT_ID, @REQUIRED, @ACCEPT_STATUS;
			end else begin
				exec dbo.spCALLS_LEADS_Update    @MODIFIED_USER_ID, @ID, @CONTACT_ID, @REQUIRED, @ACCEPT_STATUS;
			end -- if;
		end else begin
			-- print 'Contact: ' + cast(@CONTACT_ID as char(36));
			if @APPOINTMENT_TYPE = N'Meetings' or @APPOINTMENT_TYPE is null begin -- then
				exec dbo.spMEETINGS_CONTACTS_Update @MODIFIED_USER_ID, @ID, @CONTACT_ID, @REQUIRED, @ACCEPT_STATUS;
			end else begin
				exec dbo.spCALLS_CONTACTS_Update    @MODIFIED_USER_ID, @ID, @CONTACT_ID, @REQUIRED, @ACCEPT_STATUS;
			end -- if;
		end -- if;
	end -- if;
	if dbo.fnIsEmptyGuid(@USER_ID) = 0 begin -- then
		-- print 'User: ' + cast(@USER_ID as char(36));
		if @APPOINTMENT_TYPE = N'Meetings' or @APPOINTMENT_TYPE is null begin -- then
			exec dbo.spMEETINGS_USERS_Update @MODIFIED_USER_ID, @ID, @USER_ID, @REQUIRED, @ACCEPT_STATUS;
		end else begin
			exec dbo.spCALLS_USERS_Update    @MODIFIED_USER_ID, @ID, @USER_ID, @REQUIRED, @ACCEPT_STATUS;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spAPPOINTMENTS_RELATED_Update to public;
GO

