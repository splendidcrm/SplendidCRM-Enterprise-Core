if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spLANGUAGES_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spLANGUAGES_Delete;
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
-- 05/20/2008 Paul.  Delete using the NAME. 
-- 08/07/2013 Paul.  Add Oracle Exception. 
Create Procedure dbo.spLANGUAGES_Delete
	( @MODIFIED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(10)
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		update LANGUAGES
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where lower(NAME)      = lower(@NAME)
		   and DELETED          = 0;
	-- END Oracle Exception
	
	-- 05/20/2008 Paul.  When a language is deleted, so are all of its terms. 
	-- BEGIN Oracle Exception
		update TERMINOLOGY
		   set DELETED          = 1
		     , DATE_MODIFIED    = getdate()
		     , DATE_MODIFIED_UTC= getutcdate()
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		 where lower(LANG)      = lower(@NAME)
		   and DELETED          = 0;
	-- END Oracle Exception
  end
GO
 
Grant Execute on dbo.spLANGUAGES_Delete to public;
GO
 
 
