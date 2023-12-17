if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spFORUMS_UpdateThreadCount' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spFORUMS_UpdateThreadCount;
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
Create Procedure dbo.spFORUMS_UpdateThreadCount
	( @ID                  uniqueidentifier
	, @MODIFIED_USER_ID    uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @THREADCOUNT int;
	declare @POSTCOUNT   int;

	select @THREADCOUNT = count(*)
	  from THREADS
	 where FORUM_ID = @ID
	   and DELETED  = 0;

	-- 07/14/2007 Paul.  Separate the two counts to simplify migration to other platforms. 
	select @POSTCOUNT = sum(POSTCOUNT)
	  from THREADS
	 where FORUM_ID = @ID
	   and DELETED  = 0;
/*
	select @POSTCOUNT = count(*)
	  from      POSTS
	 inner join THREADS
	         on THREADS.ID      = POSTS.THREAD_ID
	        and THREADS.DELETED = 0
	 where THREADS.FORUM_ID = @ID
	   and POSTS.DELETED    = 0;
*/

	update FORUMS
	   set THREADCOUNT        = @THREADCOUNT
	     , THREADANDPOSTCOUNT = @THREADCOUNT + @POSTCOUNT
	 where ID                 = @ID
	   and DELETED            = 0;
  end
GO

Grant Execute on dbo.spFORUMS_UpdateThreadCount to public;
GO

