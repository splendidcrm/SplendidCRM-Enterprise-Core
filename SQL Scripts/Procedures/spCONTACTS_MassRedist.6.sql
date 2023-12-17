if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCONTACTS_MassRedist' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCONTACTS_MassRedist;
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
-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
Create Procedure dbo.spCONTACTS_MassRedist
	( @ID_LIST           varchar(max)
	, @MODIFIED_USER_ID  uniqueidentifier
	, @ASSIGNED_USER_ID  uniqueidentifier
	, @TEAM_ID           uniqueidentifier
	, @EXISTING_USER_ID  uniqueidentifier
	, @PARENT_MODULE     nvarchar(25)
	)
as
  begin
	set nocount on
	
	declare @ID            uniqueidentifier;
	declare @TEAM_SET_ID   uniqueidentifier;
	declare @TEAM_SET_LIST varchar(8000);
	declare @RELATED_LIST  varchar(max);
	declare @CurrentPosR   int;
	declare @NextPosR      int;
	set @CurrentPosR = 1;
	while @CurrentPosR <= len(@ID_LIST) begin -- do
		-- 10/04/2006 Paul.  charindex should not use unicode parameters as it will limit all inputs to 4000 characters. 
		set @NextPosR = charindex(',', @ID_LIST,  @CurrentPosR);
		if @NextPosR = 0 or @NextPosR is null begin -- then
			set @NextPosR = len(@ID_LIST) + 1;
		end -- if;
		set @ID = cast(rtrim(ltrim(substring(@ID_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
		set @CurrentPosR = @NextPosR+1;

		if @TEAM_ID is not null begin -- then
			select @TEAM_SET_LIST = TEAM_SET_LIST
			  from            CONTACTS
			  left outer join TEAM_SETS
			               on TEAM_SETS.ID      = CONTACTS.TEAM_SET_ID
			              and TEAM_SETS.DELETED = 0
			 where CONTACTS.ID = @ID;
			exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
		end -- if;
		-- BEGIN Oracle Exception
			update CONTACTS
			   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
			     , DATE_MODIFIED     =  getdate()        
			     , DATE_MODIFIED_UTC =  getutcdate()     
			     , ASSIGNED_USER_ID  = @ASSIGNED_USER_ID
			     , TEAM_ID           = isnull(@TEAM_ID, TEAM_ID)
			     , TEAM_SET_ID       = isnull(@TEAM_SET_ID, TEAM_SET_ID)
			 where ID                = @ID
			   and DELETED           = 0;

			-- 01/30/2019 Paul.  We should be creating the matching custom audit record. 
			update CONTACTS_CSTM
			   set ID_C              = ID_C
			 where ID_C              = @ID;
		-- END Oracle Exception

		-- 04/17/2013 Paul.  Reassign related Opportunities that were assigned to the old user. 
		if @PARENT_MODULE is null begin -- then
			set @RELATED_LIST = '';
			-- BEGIN Oracle Exception
				select @RELATED_LIST = @RELATED_LIST + (case when len(@RELATED_LIST) > 0 then  ',' else  '' end) + cast(ID as char(36))
				  from OPPORTUNITIES
				 where ID               in (select OPPORTUNITY_ID from OPPORTUNITIES_CONTACTS where CONTACT_ID = @ID and DELETED = 0)
				   and ASSIGNED_USER_ID = @EXISTING_USER_ID
				   and DELETED          = 0;
			-- END Oracle Exception
			if len(@RELATED_LIST) > 0 begin -- then
				exec dbo.spOPPORTUNITIES_MassRedist @RELATED_LIST, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @TEAM_ID, @EXISTING_USER_ID, N'Contacts';
			end -- if;
		end -- if;

		-- 04/17/2013 Paul.  Reassign related Cases that were assigned to the old user. 
		if @PARENT_MODULE is null begin -- then
			set @RELATED_LIST = '';
			-- BEGIN Oracle Exception
				select @RELATED_LIST = @RELATED_LIST + (case when len(@RELATED_LIST) > 0 then  ',' else  '' end) + cast(ID as char(36))
				  from CASES
				 where ID               in (select CASE_ID from CONTACTS_CASES where CONTACT_ID = @ID and DELETED = 0)
				   and ASSIGNED_USER_ID = @EXISTING_USER_ID
				   and DELETED          = 0;
			-- END Oracle Exception
			if len(@RELATED_LIST) > 0 begin -- then
				exec dbo.spCASES_MassRedist @RELATED_LIST, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @TEAM_ID, @EXISTING_USER_ID, N'Contacts';
			end -- if;
		end -- if;

		-- 04/17/2013 Paul.  Reassign related Bugs that were assigned to the old user. 
		set @RELATED_LIST = '';
		-- BEGIN Oracle Exception
			select @RELATED_LIST = @RELATED_LIST + (case when len(@RELATED_LIST) > 0 then  ',' else  '' end) + cast(ID as char(36))
			  from BUGS
			 where ID               in (select BUG_ID from CONTACTS_BUGS where CONTACT_ID = @ID and DELETED = 0)
			   and ASSIGNED_USER_ID = @EXISTING_USER_ID
			   and DELETED          = 0;
		-- END Oracle Exception
		if len(@RELATED_LIST) > 0 begin -- then
			exec dbo.spBUGS_MassRedist @RELATED_LIST, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @TEAM_ID, @EXISTING_USER_ID, N'Contacts';
		end -- if;

		-- 04/17/2013 Paul.  Reassign related Documents that were assigned to the old user. 
		set @RELATED_LIST = '';
		-- BEGIN Oracle Exception
			select @RELATED_LIST = @RELATED_LIST + (case when len(@RELATED_LIST) > 0 then  ',' else  '' end) + cast(ID as char(36))
			  from DOCUMENTS
			 where ID                in (select DOCUMENT_ID from CONTACTS_DOCUMENTS where CONTACT_ID = @ID and DELETED = 0)
			   and ASSIGNED_USER_ID  = @EXISTING_USER_ID
			   and DELETED           = 0;
		-- END Oracle Exception
		if len(@RELATED_LIST) > 0 begin -- then
			exec dbo.spDOCUMENTS_MassRedist @RELATED_LIST, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @TEAM_ID, @EXISTING_USER_ID, N'Contacts';
		end -- if;

		-- 04/17/2013 Paul.  Reassign related Projects that were assigned to the old user. 
		set @RELATED_LIST = '';
		-- BEGIN Oracle Exception
			select @RELATED_LIST = @RELATED_LIST + (case when len(@RELATED_LIST) > 0 then  ',' else  '' end) + cast(ID as char(36))
			  from PROJECT
			 where ID                in (select PROJECT_ID from PROJECTS_CONTACTS where CONTACT_ID = @ID and DELETED = 0)
			   and ASSIGNED_USER_ID  = @EXISTING_USER_ID
			   and DELETED           = 0;
		-- END Oracle Exception
		if len(@RELATED_LIST) > 0 begin -- then
			exec dbo.spPROJECT_MassRedist @RELATED_LIST, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @TEAM_ID, @EXISTING_USER_ID, N'Contacts';
		end -- if;

		-- 04/17/2013 Paul.  Calls, Emails, Meetings, Notes and Tasks all follow the parent. 
		exec dbo.spPARENT_Redistribute @ID, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @TEAM_ID, @TEAM_SET_ID, @EXISTING_USER_ID;
	end -- while;
  end
GO
 
Grant Execute on dbo.spCONTACTS_MassRedist to public;
GO
 
 
