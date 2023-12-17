if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_TAB_Rename' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_TAB_Rename;
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
Create Procedure dbo.spMODULES_TAB_Rename
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(50)
	, @LANG              nvarchar(10)
	, @DISPLAY_NAME      nvarchar(2000)
	)
as
  begin
	set nocount on
	
	declare @LIST_NAME   nvarchar(50);
	set @LIST_NAME = N'moduleList';
	exec dbo.spTERMINOLOGY_LIST_Insert @ID out, @MODIFIED_USER_ID, @NAME, @LANG, null, @LIST_NAME, 1, @DISPLAY_NAME;
  end
GO

Grant Execute on dbo.spMODULES_TAB_Rename to public;
GO

