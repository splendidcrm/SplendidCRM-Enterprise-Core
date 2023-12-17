if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spOUTBOUND_EMAILS_UpdateUser' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spOUTBOUND_EMAILS_UpdateUser;
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
-- 07/16/2013 Paul.  spOUTBOUND_EMAILS_Update now returns the ID. 
-- 04/20/2016 Paul.  Provide a way to allow each user to have their own SMTP server. 
-- 02/01/2017 Paul.  Add support for Exchange using Username/Password. 
Create Procedure dbo.spOUTBOUND_EMAILS_UpdateUser
	( @MODIFIED_USER_ID   uniqueidentifier
	, @USER_ID            uniqueidentifier
	, @MAIL_SMTPUSER      nvarchar(100)
	, @MAIL_SMTPPASS      nvarchar(100)
	, @MAIL_SMTPSERVER    nvarchar(100) = null
	, @MAIL_SMTPPORT      int = null
	, @MAIL_SMTPAUTH_REQ  bit = null
	, @MAIL_SMTPSSL       int = null
	, @MAIL_SENDTYPE      nvarchar(25) = null
	)
as
  begin
	set nocount on
	
	-- 07/11/2010 Paul.  Make sure to call the base Update procedure. 
	declare @ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from OUTBOUND_EMAILS
		 where USER_ID = @USER_ID 
		   and TYPE    = N'system-override'
		   and DELETED = 0;
	-- END Oracle Exception
	exec dbo.spOUTBOUND_EMAILS_Update @ID out, @MODIFIED_USER_ID, N'system', N'system-override', @USER_ID, @MAIL_SENDTYPE, null, @MAIL_SMTPSERVER, @MAIL_SMTPPORT, @MAIL_SMTPUSER, @MAIL_SMTPPASS, @MAIL_SMTPAUTH_REQ, @MAIL_SMTPSSL, null, null, null, null;
  end
GO

Grant Execute on dbo.spOUTBOUND_EMAILS_UpdateUser to public;
GO

