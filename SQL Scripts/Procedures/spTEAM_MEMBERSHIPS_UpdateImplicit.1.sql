if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTEAM_MEMBERSHIPS_UpdateImplicit' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTEAM_MEMBERSHIPS_UpdateImplicit;
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
Create Procedure dbo.spTEAM_MEMBERSHIPS_UpdateImplicit
	( @MODIFIED_USER_ID  uniqueidentifier
	, @TEAM_ID           uniqueidentifier
	)
as
  begin
	set nocount on

	declare @ID              uniqueidentifier;
	declare @USER_ID         uniqueidentifier;
	declare @REPORTS_TO_ID   uniqueidentifier;
	declare @REPORTS_TO_KEY  varchar(37);
	declare @REPORTS_TO_LIST varchar(8000);

	declare member_cursor cursor for
	select USER_ID
	  from TEAM_MEMBERSHIPS
	 where TEAM_ID         = @TEAM_ID
	   and EXPLICIT_ASSIGN = 1
	   and DELETED         = 0
	 order by USER_ID;

/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set l_error ='00000';
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	-- 11/18/2006 Paul.  First delete all implicity assigned users. 
	update TEAM_MEMBERSHIPS
	   set DELETED         = 1
	 where TEAM_ID         = @TEAM_ID
	   and EXPLICIT_ASSIGN = 0
	   and DELETED         = 0;

	open member_cursor;
	fetch next from member_cursor into @USER_ID;
	-- 11/18/2006 Paul.  For every explicity assigned user in the team, 
	-- determine who they report to, and explicity add them.  
	while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
		-- 12/15/2006 Paul.  Make sure only to use REPORTS_TO_ID if it points to a valid user. 
		select @REPORTS_TO_ID = USERS.REPORTS_TO_ID
		  from      USERS
		 inner join USERS                      USERS_REPORTS_TO
		         on USERS_REPORTS_TO.ID      = USERS.REPORTS_TO_ID
		        and USERS_REPORTS_TO.DELETED = 0
		 where USERS.ID      = @USER_ID
		   and USERS.DELETED = 0;
		
		-- 11/19/2006 Paul.  We need a way to prevent a recursive loop. 
		-- A temporary table would work, but we need a high-performance and cross-platform solution. 
		-- We will use a simple varchar field that can hold up to 200 levels.
		-- It is not likely that a company with 200 levels in their organization would use this product. 
		-- 11/19/2006 Paul.  Make sure to reset the temp list for each user. 
		set @REPORTS_TO_LIST = '';
		
		-- 11/18/2006 Paul.  Walk up the reports-to chain. 
		-- 11/19/2006 Paul.  A user is not allowed to report to himself. 
		while dbo.fnIsEmptyGuid(@REPORTS_TO_ID) = 0 and @REPORTS_TO_ID <> @USER_ID begin -- do
			set @REPORTS_TO_KEY = cast(@REPORTS_TO_ID as varchar(36)) + ',';
			if charindex(@REPORTS_TO_KEY, @REPORTS_TO_LIST, 1) = 0 begin -- then
				set @REPORTS_TO_LIST = @REPORTS_TO_LIST + @REPORTS_TO_KEY;
				set @ID = null;
				-- BEGIN Oracle Exception
					select @ID = ID
					  from TEAM_MEMBERSHIPS
					 where TEAM_ID = @TEAM_ID
					   and USER_ID = @REPORTS_TO_ID
					   and DELETED = 0;
				-- END Oracle Exception
				-- 11/18/2006 Paul.  If the manager is not already assigned, then implicitly assign them to the team. 
				if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
					set @ID = newid();
					-- print @REPORTS_TO_ID;
					insert into TEAM_MEMBERSHIPS
						( ID               
						, CREATED_BY       
						, DATE_ENTERED     
						, MODIFIED_USER_ID 
						, DATE_MODIFIED    
						, TEAM_ID          
						, USER_ID          
						, EXPLICIT_ASSIGN  
						, IMPLICIT_ASSIGN  
						)
					values
						( @ID               
						, @MODIFIED_USER_ID 
						,  getdate()        
						, @MODIFIED_USER_ID 
						,  getdate()        
						, @TEAM_ID          
						, @REPORTS_TO_ID          
						, 0  
						, 1
						);
				end -- if;
	
				select @REPORTS_TO_ID = REPORTS_TO_ID
				  from USERS
				 where ID      = @REPORTS_TO_ID
				   and DELETED = 0;
			end else begin
				-- 11/19/2006 Paul.  When recursion is found, just exit the loop. 
				-- Don't throw an exception as it will prevent the user from saving. 
				-- raiserror(N'Recursive reports-to relationship discovered in user table.', 16, 1);
				-- break;
				-- 01/07/2007 Paul.  DB2 does not support break.  Setting @REPORTS_TO_ID to null should accomplish the same. 
				set @REPORTS_TO_ID = null;
			end -- if;
		end -- while;
		fetch next from member_cursor into @USER_ID;
	end -- while;
	close member_cursor;

	deallocate member_cursor;
  end
GO
 
Grant Execute on dbo.spTEAM_MEMBERSHIPS_UpdateImplicit to public;
GO
 

