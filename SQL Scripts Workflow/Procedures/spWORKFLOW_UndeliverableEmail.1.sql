if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOW_UndeliverableEmail' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOW_UndeliverableEmail;
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
Create Procedure dbo.spWORKFLOW_UndeliverableEmail
	( @AUDIT_ID           uniqueidentifier
	, @ID                 uniqueidentifier
	, @MODULE_NAME        nvarchar(50)
	)
as
  begin
	set nocount on
	
	declare @TEMP_ID     uniqueidentifier;
	declare @TARGET_ID   uniqueidentifier;
	declare @TARGET_TYPE nvarchar(25);
	set @TEMP_ID = @ID;
	if @MODULE_NAME = N'Emails' begin -- then
		if @TEMP_ID is null and @AUDIT_ID is not null begin -- then
			-- BEGIN Oracle Exception
				select @TEMP_ID = ID
				  from EMAILS_AUDIT
				 where AUDIT_ID = @AUDIT_ID;
			-- END Oracle Exception
		end -- if;
		if @TEMP_ID is not null begin -- then
			exec dbo.spEMAILS_UndeliverableEmail @TEMP_ID, null, @TARGET_ID out, @TARGET_TYPE out;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spWORKFLOW_UndeliverableEmail to public;
GO

