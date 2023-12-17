if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spAPPOINTMENTS_CONTACTS_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spAPPOINTMENTS_CONTACTS_Delete;
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
Create Procedure dbo.spAPPOINTMENTS_CONTACTS_Delete
	( @MODIFIED_USER_ID uniqueidentifier
	, @ID               uniqueidentifier
	, @CONTACT_ID       uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @APPOINTMENT_TYPE nvarchar(25);

	-- BEGIN Oracle Exception
		select @APPOINTMENT_TYPE = APPOINTMENT_TYPE
		  from vwAPPOINTMENTS
		 where ID = @ID;
	-- END Oracle Exception

	-- 03/29/2010 Paul.  A new Appointment will be created as a Meeting. 
	if @APPOINTMENT_TYPE = N'Meetings' or @APPOINTMENT_TYPE is null begin -- then
		exec dbo.spMEETINGS_CONTACTS_Delete @MODIFIED_USER_ID, @ID, @CONTACT_ID;
	end else begin
		exec dbo.spCALLS_CONTACTS_Delete    @MODIFIED_USER_ID, @ID, @CONTACT_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spAPPOINTMENTS_CONTACTS_Delete to public;
GO

