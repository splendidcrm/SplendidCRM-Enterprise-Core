if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOW_EVENTS_ProcessAll' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOW_EVENTS_ProcessAll;
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
-- 12/30/2007 Paul.  We are not ready to do any workflow processing, so just delete the records. 	
-- 01/18/2008 Paul.  Oracle requires from keyword. 
-- 06/02/2009 Paul.  Add this procedure for testing purposes. 
Create Procedure dbo.spWORKFLOW_EVENTS_ProcessAll
as
  begin
	set nocount on
	
	declare @ID              uniqueidentifier;
	declare @AUDIT_ID        uniqueidentifier;
	declare @AUDIT_TABLE     nvarchar(50);
	declare @AUDIT_ACTION    int;
	declare @AUDIT_TOKEN     varchar(255);
	declare @AUDIT_PARENT_ID uniqueidentifier;
	declare @AUDIT_VERSION   rowversion;

-- #if SQL_Server /*
	declare event_cursor cursor static for
	select ID                  
	     , AUDIT_ID            
	     , AUDIT_TABLE         
	     , AUDIT_ACTION        
	     , AUDIT_TOKEN         
	     , AUDIT_PARENT_ID     
	     , AUDIT_VERSION       
	  from vwWORKFLOW_EVENTS   
	 order by AUDIT_VERSION asc;
-- #endif SQL_Server */


/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	open event_cursor;
	fetch next from event_cursor into @ID, @AUDIT_ID, @AUDIT_TABLE, @AUDIT_ACTION, @AUDIT_TOKEN, @AUDIT_PARENT_ID, @AUDIT_VERSION;
	while @@FETCH_STATUS = 0 begin -- do
		exec dbo.spWORKFLOW_EVENTS_ProcessEvent @AUDIT_ID, @AUDIT_TABLE, @AUDIT_ACTION, @AUDIT_TOKEN;

		delete from WORKFLOW_EVENTS
		 where ID = @ID;
		fetch next from event_cursor into @ID, @AUDIT_ID, @AUDIT_TABLE, @AUDIT_ACTION, @AUDIT_TOKEN, @AUDIT_PARENT_ID, @AUDIT_VERSION;
/* -- #if Oracle
		IF event_cursor%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close event_cursor;

	deallocate event_cursor;
  end
GO

Grant Execute on dbo.spWORKFLOW_EVENTS_ProcessAll to public;
GO

