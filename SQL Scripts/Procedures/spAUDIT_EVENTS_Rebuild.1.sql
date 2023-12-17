if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spAUDIT_EVENTS_Rebuild' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spAUDIT_EVENTS_Rebuild;
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
Create Procedure dbo.spAUDIT_EVENTS_Rebuild
as
  begin
	set nocount on

	declare @COMMAND    nvarchar(1000);
	declare @TABLE_NAME nvarchar(50);
	declare module_cursor cursor for
	select TABLE_NAME
	  from vwMODULES
	 where TABLE_NAME is not null
	   and MODULE_ENABLED = 1
	 order by MODULE_NAME;
	
	open module_cursor;
	fetch next from module_cursor into @TABLE_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		if exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = @TABLE_NAME + '_AUDIT') begin -- then
			print @TABLE_NAME;
			select @COMMAND = 'insert into dbo.AUDIT_EVENTS
				( ID               
				, DELETED          
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, AUDIT_ID         
				, AUDIT_TABLE      
				, AUDIT_TOKEN      
				, AUDIT_ACTION     
				, AUDIT_PARENT_ID  
				)
			select	  AUDIT_ID               
				, 0                
				, CREATED_BY       
				, AUDIT_DATE       
				, MODIFIED_USER_ID 
				, AUDIT_DATE       
				, AUDIT_ID         
				, ''' + @TABLE_NAME + '_AUDIT''
				, AUDIT_TOKEN      
				, AUDIT_ACTION     
				, ID
			  from dbo.' + @TABLE_NAME + '_AUDIT
			 where AUDIT_ID not in (select ID from AUDIT_EVENTS)';
			exec(@COMMAND);
		end -- if;
		fetch next from module_cursor into @TABLE_NAME;
	end -- while;
	close module_cursor;
	
	deallocate module_cursor;
  end
GO


-- exec spAUDIT_EVENTS_Rebuild ;

Grant Execute on dbo.spAUDIT_EVENTS_Rebuild to public;
GO

