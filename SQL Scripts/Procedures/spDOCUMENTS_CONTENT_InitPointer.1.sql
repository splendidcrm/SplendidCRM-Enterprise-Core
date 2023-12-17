if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDOCUMENTS_CONTENT_InitPointer' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDOCUMENTS_CONTENT_InitPointer;
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
-- 09/15/2009 Paul.  updatetext, readtext and textptr() have been deprecated in SQL Server and are not supported in Azure. 
-- http://msdn.microsoft.com/en-us/library/ms143729.aspx
Create Procedure dbo.spDOCUMENTS_CONTENT_InitPointer
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @FILE_POINTER      binary(16) output
	)
as
  begin
	set nocount on
	
	-- 10/20/2005 Paul.  Truncate the content column so that future write operations can simply append data. 
-- #if SQL_Server /*
	raiserror(N'updatetext, readtext and textptr() have been deprecated. ', 16, 1);
	-- update DOCUMENT_REVISIONS
	--    set CONTENT          = ''               
	--      , MODIFIED_USER_ID = @MODIFIED_USER_ID
	--      , DATE_MODIFIED    =  getdate()        
	--      , DATE_MODIFIED_UTC=  getutcdate()     
	--  where ID               = @ID              ;
	
	-- 10/20/2005 Paul.  in_FILE_POINTER is not used in MySQL. 
	-- select @FILE_POINTER = textptr(CONTENT)
	--   from DOCUMENT_REVISIONS
	--  where ID               = @ID;
-- #endif SQL_Server */



  end
GO
 
Grant Execute on dbo.spDOCUMENTS_CONTENT_InitPointer to public;
GO



