if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCAMPAIGNS_UpdateDynamic' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCAMPAIGNS_UpdateDynamic;
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
Create Procedure dbo.spCAMPAIGNS_UpdateDynamic
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @PROSPECT_LIST_ID uniqueidentifier;

-- #if SQL_Server /*
	declare prospect_list_cursor cursor for
	select PROSPECT_LIST_ID
	  from vwCAMPAIGNS_PROSPECT_LISTS
	 where CAMPAIGN_ID  = @ID
	   and DYNAMIC_LIST = 1;
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

	open prospect_list_cursor;
	fetch next from prospect_list_cursor into @PROSPECT_LIST_ID;
	while @@FETCH_STATUS = 0 begin -- do
		exec dbo.spPROSPECT_LISTS_UpdateDynamic @PROSPECT_LIST_ID, @MODIFIED_USER_ID;
		fetch next from prospect_list_cursor into @PROSPECT_LIST_ID;
/* -- #if Oracle
		IF prospect_list_cursor%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close prospect_list_cursor;

	deallocate prospect_list_cursor;
  end
GO
 
Grant Execute on dbo.spCAMPAIGNS_UpdateDynamic to public;
GO
 
