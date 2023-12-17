if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spICLOUD_USERS_ContactsCTAG' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spICLOUD_USERS_ContactsCTAG;
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
Create Procedure dbo.spICLOUD_USERS_ContactsCTAG
	( @MODIFIED_USER_ID   uniqueidentifier
	, @USER_ID            uniqueidentifier
	, @ICLOUD_CTAG        varchar(100)
	)
as
  begin
	set nocount on
	
	update USERS
	   set ICLOUD_CTAG_CONTACTS = @ICLOUD_CTAG
	     , DATE_MODIFIED        = getdate()
	     , DATE_MODIFIED_UTC    = getutcdate()
	     , MODIFIED_USER_ID     = @MODIFIED_USER_ID
	 where ID                   = @USER_ID
	   and (ICLOUD_CTAG_CONTACTS is null or @ICLOUD_CTAG is null or ICLOUD_CTAG_CONTACTS <> @ICLOUD_CTAG)
	   and DELETED              = 0;
  end
GO

Grant Execute on dbo.spICLOUD_USERS_ContactsCTAG to public;
GO

