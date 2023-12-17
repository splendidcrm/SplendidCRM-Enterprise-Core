if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSURVEY_PAGES_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSURVEY_PAGES_Delete;
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
-- 08/07/2013 Paul.  Add Oracle Exception. 
Create Procedure dbo.spSURVEY_PAGES_Delete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @SURVEY_ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @SURVEY_ID = SURVEY_ID
		  from SURVEY_PAGES
		 where ID         = @ID
		   and DELETED    = 0;
	-- END Oracle Exception
	
	-- BEGIN Oracle Exception
		update SURVEY_PAGES
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where ID               = @ID
		   and DELETED          = 0;
	-- END Oracle Exception

	exec dbo.spSURVEYS_ReorderPages @SURVEY_ID, @MODIFIED_USER_ID;
  end
GO

Grant Execute on dbo.spSURVEY_PAGES_Delete to public;
GO

