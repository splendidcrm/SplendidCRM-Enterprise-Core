if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEMAIL_IMAGE_WriteOffset' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEMAIL_IMAGE_WriteOffset;
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
-- 09/15/2009 Paul.  Convert data type to varbinary(max) to support Azure. 
-- 09/15/2009 Paul.  updatetext, readtext and textptr() have been deprecated in SQL Server and are not supported in Azure. 
-- http://msdn.microsoft.com/en-us/library/ms143729.aspx
Create Procedure dbo.spEMAIL_IMAGE_WriteOffset
	( @ID                   uniqueidentifier
	, @FILE_POINTER         binary(16)
	, @MODIFIED_USER_ID     uniqueidentifier
	, @FILE_OFFSET          int
	, @BYTES                varbinary(max)
	)
as
  begin
	set nocount on
	
	-- 10/22/2005 Paul.  @ID is used in Oracle and MySQL. 
-- #if SQL_Server /*
	raiserror(N'updatetext, readtext and textptr() have been deprecated. ', 16, 1);
	-- updatetext EMAIL_IMAGES.CONTENT
	--            @FILE_POINTER
	--            @FILE_OFFSET
	--            null -- 0 deletes no data, null deletes all data from insertion point. 
	--            @BYTES;
-- #endif SQL_Server */



  end
GO
 
Grant Execute on dbo.spEMAIL_IMAGE_WriteOffset to public;
GO



