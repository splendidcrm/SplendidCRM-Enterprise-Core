if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spFIELDS_META_DATA_DeleteByName' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spFIELDS_META_DATA_DeleteByName;
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
-- 03/29/2011 Paul.  Ease migration to Oracle. 
-- 04/18/2016 Paul.  Allow disable recompile so that we can do in the background. 
Create Procedure dbo.spFIELDS_META_DATA_DeleteByName
	( @MODIFIED_USER_ID  uniqueidentifier
	, @CUSTOM_MODULE     nvarchar(255)
	, @NAME              nvarchar(255)
	, @DISABLE_RECOMPILE bit = null
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from FIELDS_META_DATA
		 where @CUSTOM_MODULE = CUSTOM_MODULE
		   and @NAME          = NAME
		   and DELETED        = 0;
	-- END Oracle Exception

	if dbo.fnIsEmptyGuid(@ID) = 0 begin -- then
		exec dbo.spFIELDS_META_DATA_Delete @ID, @MODIFIED_USER_ID, @DISABLE_RECOMPILE;
	end -- if;
  end
GO

Grant Execute on dbo.spFIELDS_META_DATA_DeleteByName to public;
GO

