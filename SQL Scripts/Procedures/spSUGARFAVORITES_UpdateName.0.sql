if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSUGARFAVORITES_UpdateName' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSUGARFAVORITES_UpdateName;
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
Create Procedure dbo.spSUGARFAVORITES_UpdateName
	( @MODIFIED_USER_ID   uniqueidentifier
	, @RECORD_ID          uniqueidentifier
	, @NAME               nvarchar(255)
	)
as
  begin
	set nocount on
	
	-- BEGIN Oracle Exception
		update SUGARFAVORITES
		   set NAME              = @NAME
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		 where RECORD_ID         = @RECORD_ID
		   and DELETED           = 0
		   and (@NAME < NAME or @NAME > NAME);
	-- END Oracle Exception
  end
GO

Grant Execute on dbo.spSUGARFAVORITES_UpdateName to public;
GO

