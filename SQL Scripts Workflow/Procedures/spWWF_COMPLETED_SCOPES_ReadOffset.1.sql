if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_COMPLETED_SCOPES_ReadOffset' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_COMPLETED_SCOPES_ReadOffset;
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
Create Procedure dbo.spWWF_COMPLETED_SCOPES_ReadOffset
	( @ID                   uniqueidentifier
	, @FILE_OFFSET          int
	, @READ_SIZE            int
	, @BYTES                varbinary(max) output
	)
as
  begin
	set nocount on
	
	-- 08/12/2005 Paul.  Oracle returns its data in the @BYTES field. 
	-- 10/22/2005 Paul.  MySQL can also return data in @BYTES, but using a recordset has fewer limitations. 
	-- 01/25/2007 Paul.  Protect against a read error by ensuring that the file size is zero if no STATE. 
-- #if SQL_Server /*
	raiserror(N'updatetext, readtext and textptr() have been deprecated. ', 16, 1);
	-- declare @FILE_SIZE    bigint;
	-- declare @FILE_POINTER binary(16);
	-- select @FILE_SIZE    = isnull(datalength(STATE), 0)
	--      , @FILE_POINTER = textptr(STATE)
	--   from WWF_COMPLETED_SCOPES
	--  where ID            = @ID;
	-- if @FILE_OFFSET + @READ_SIZE > @FILE_SIZE begin -- then
	-- 	set @READ_SIZE = @FILE_SIZE - @FILE_OFFSET;
	-- end -- if;
	-- if @READ_SIZE > 0 begin -- then
	-- 	readtext WWF_COMPLETED_SCOPES.STATE @FILE_POINTER @FILE_OFFSET @READ_SIZE;
	-- end -- if;
-- #endif SQL_Server */



  end
GO
 
Grant Execute on dbo.spWWF_COMPLETED_SCOPES_ReadOffset to public;
GO


