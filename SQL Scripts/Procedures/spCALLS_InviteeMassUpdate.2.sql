if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCALLS_InviteeMassUpdate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCALLS_InviteeMassUpdate;
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
-- 01/24/2009 Paul.  The current user is accepted by default. 
-- 04/01/2012 Paul.  Add Calls/Leads relationship. 
Create Procedure dbo.spCALLS_InviteeMassUpdate
	( @MODIFIED_USER_ID  uniqueidentifier
	, @CALL_ID           uniqueidentifier
	, @ID_LIST           varchar(8000)
	, @REQUIRED          bit
	)
as
  begin
	set nocount on
	
	declare @ID           uniqueidentifier;
	declare @CurrentPosR  int;
	declare @NextPosR     int;
	-- 02/02/2006 Paul.  Should be nvarchar. Caught when testing DB2.
	declare @INVITEE_TYPE nvarchar(25);

	set @CurrentPosR = 1;
	while @CurrentPosR <= len(@ID_LIST) begin -- do
		-- 10/04/2006 Paul.  charindex should not use unicode parameters as it will limit all inputs to 4000 characters. 
		set @NextPosR = charindex(',', @ID_LIST,  @CurrentPosR);
		if @NextPosR = 0 or @NextPosR is null begin -- then
			set @NextPosR = len(@ID_LIST) + 1;
		end -- if;
		set @ID = cast(rtrim(ltrim(substring(@ID_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
		set @CurrentPosR = @NextPosR+1;

		select @INVITEE_TYPE = INVITEE_TYPE
		  from vwINVITEES
		 where ID = @ID;
		if @INVITEE_TYPE = N'Users' begin -- then
			-- 01/24/2009 Paul.  The current user is accepted by default. 
			if @MODIFIED_USER_ID = @ID begin -- then
				exec dbo.spCALLS_USERS_Update    @MODIFIED_USER_ID, @CALL_ID, @ID, @REQUIRED, N'accept';
			end else begin
				exec dbo.spCALLS_USERS_Update    @MODIFIED_USER_ID, @CALL_ID, @ID, @REQUIRED, null;
			end -- if;
		end else if @INVITEE_TYPE = N'Contacts' begin -- then
			exec dbo.spCALLS_CONTACTS_Update @MODIFIED_USER_ID, @CALL_ID, @ID, @REQUIRED, null;
		-- 04/01/2012 Paul.  Add Calls/Leads relationship. 
		end else if @INVITEE_TYPE = N'Leads' begin -- then
			exec dbo.spCALLS_LEADS_Update @MODIFIED_USER_ID, @CALL_ID, @ID, @REQUIRED, null;
		end -- if;
	end -- while;
  end
GO
 
Grant Execute on dbo.spCALLS_InviteeMassUpdate to public;
GO
 
 
