if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROSPECT_LISTS_UpdateDynamic' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROSPECT_LISTS_UpdateDynamic;
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
Create Procedure dbo.spPROSPECT_LISTS_UpdateDynamic
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on

	declare @DYNAMIC_LIST    bit;
	declare @DYNAMIC_SQL     nvarchar(max);
	declare @COMMAND         nvarchar(max);
	declare @PARAM_DEFINTION nvarchar(200);
	-- 09/11/2013 Alvis.  ID LIST variable is replaced with ID LIST TABLE
	--declare @ID_LIST         nvarchar(max);	
	declare @PROSPECT_ID     uniqueidentifier;
	declare @CurrentPosR     int;
	declare @NextPosR        int;

-- #if SQL_Server /*
	-- 09/11/2013 Alvis.  Declare table to use instead of @ID_LIST
	declare @ID_LIST_TABLE TABLE
		( ID uniqueidentifier not null
		);
	
	-- 01/14/2010 Paul.  Can't use Table-Valued fields in exec(). 
	-- http://databases.aspfaq.com/database/should-i-use-a-temp-table-or-a-table-variable.html
	create table #TEMP_PROSPECTS
		( ID uniqueidentifier not null
		);
-- #endif SQL_Server */

	-- BEGIN Oracle Exception
		select @DYNAMIC_LIST = DYNAMIC_LIST
		     , @DYNAMIC_SQL  = DYNAMIC_SQL
		  from vwPROSPECT_LISTS_SQL
		 where ID            = @ID;
	-- END Oracle Exception

	if @DYNAMIC_LIST = 1 and @DYNAMIC_SQL is not null begin -- then
		-- 01/10/2010 Paul.  As a sanity check, make sure that the dynamic SQL starts with select. 
		if substring(@DYNAMIC_SQL, 1, 7) = 'select ' begin -- then
-- #if SQL_Server /*
			-- 01/14/2010 Paul.  To prevent SQL Injection from a the Dynamic SQL, wrap the execute in a transaction and always roll the transaction back. 
			-- The rollback will not affect the value stored in @TEMP_PROSPECTS. 
			-- 01/14/2010 Paul.  Cannot roll back SplendidWorkflow. No transaction or savepoint of that name was found. 
			-- Transaction count after EXECUTE indicates that a COMMIT or ROLLBACK TRANSACTION statement is missing
			begin transaction DynamicProspects;
			save transaction DynamicProspects;

			-- http://sqldev.wordpress.com/2008/05/06/insert-into-temporary-table-from-stored-procedure/
			insert into #TEMP_PROSPECTS
			exec sp_executesql @DYNAMIC_SQL;
			-- 01/14/2010 Paul.  The rollback transaction will clear the temp table, so convert to a variable. 
			--select @ID_LIST = cast(ID as char(36)) + (case when len(@ID_LIST) > 0 then ',' + @ID_LIST else '' end)
			-- from #TEMP_PROSPECTS;

			-- 09/11/2013 Alvis.  Insert into ID LIST TABLE instead of @ID_LIST variable
			insert into @ID_LIST_TABLE (ID)
			select ID from #TEMP_PROSPECTS;

			rollback transaction DynamicProspects;
			commit transaction DynamicProspects;

			-- 01/14/2010 Paul.  Now we need to parse the comma-separated list and insert back into the temp table. 
			--set @CurrentPosR = 1;
			--while @CurrentPosR <= len(@ID_LIST) begin -- do
			--	set @NextPosR = charindex(',', @ID_LIST,  @CurrentPosR);
			--	if @NextPosR = 0 or @NextPosR is null begin -- then
			--		set @NextPosR = len(@ID_LIST) + 1;
			--	end -- if;
			--	set @PROSPECT_ID = cast(rtrim(ltrim(substring(@ID_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
			--	set @CurrentPosR = @NextPosR+1;
			--	insert into #TEMP_PROSPECTS ( ID )
			--	values ( @PROSPECT_ID );
			--end -- while;
			
			-- 09/11/2013 Alvis.  Insert back into temp table
			insert into #TEMP_PROSPECTS ( ID )
			select ID from @ID_LIST_TABLE;
			
			-- 01/14/2010 Paul.  The rest of the code can now use the temp table. 
			set @DYNAMIC_SQL = 'select ID from #TEMP_PROSPECTS';
-- #endif SQL_Server */

			set @COMMAND = 'insert into PROSPECT_LISTS_PROSPECTS
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, PROSPECT_LIST_ID 
				, RELATED_ID       
				, RELATED_TYPE     
				)
			select	  newid()
				, @MODIFIED_USER_ID
				,  getdate()
				, @MODIFIED_USER_ID
				,  getdate()
				, @PROSPECT_LIST_ID
				, vwPROSPECT_LISTS_Dynamic.RELATED_ID
				, vwPROSPECT_LISTS_Dynamic.RELATED_TYPE
			  from            vwPROSPECT_LISTS_Dynamic
			  left outer join PROSPECT_LISTS_PROSPECTS
			               on PROSPECT_LISTS_PROSPECTS.PROSPECT_LIST_ID = @PROSPECT_LIST_ID
			              and PROSPECT_LISTS_PROSPECTS.RELATED_ID       = vwPROSPECT_LISTS_Dynamic.RELATED_ID
			              and PROSPECT_LISTS_PROSPECTS.DELETED          = 0
			 where PROSPECT_LISTS_PROSPECTS.ID is null
			   and vwPROSPECT_LISTS_Dynamic.RELATED_ID in (' + @DYNAMIC_SQL + ')';
-- #if SQL_Server /*
			set @PARAM_DEFINTION = N'@PROSPECT_LIST_ID uniqueidentifier, @MODIFIED_USER_ID uniqueidentifier';
			exec sp_executesql @COMMAND, @PARAM_DEFINTION, @PROSPECT_LIST_ID = @ID, @MODIFIED_USER_ID = @MODIFIED_USER_ID;
-- #endif SQL_Server */
	
			set @COMMAND = 'update PROSPECT_LISTS_PROSPECTS
			   set DELETED          = 1
			     , DATE_MODIFIED    = getdate()
			     , MODIFIED_USER_ID = @MODIFIED_USER_ID
			 where PROSPECT_LIST_ID = @PROSPECT_LIST_ID
			   and DELETED          = 0
			   and RELATED_ID not in (' + @DYNAMIC_SQL + ')';
-- #if SQL_Server /*
			exec sp_executesql @COMMAND, @PARAM_DEFINTION, @PROSPECT_LIST_ID = @ID, @MODIFIED_USER_ID = @MODIFIED_USER_ID;
-- #endif SQL_Server */
/* -- #if Oracle
			-- http://download.oracle.com/docs/cd/B19306_01/appdev.102/b14261/dynamic.htm#sthref1557
			@COMMAND := replace(@COMMAND, '@PROSPECT_LIST_ID', ':1');
			@COMMAND := replace(@COMMAND, '@MODIFIED_USER_ID', ':2');
			EXECUTE IMMEDIATE @COMMAND USING @ID, @MODIFIED_USER_ID;
-- #endif Oracle */
		end -- if;
	end -- if;
-- #if SQL_Server /*
	drop table #TEMP_PROSPECTS;
-- #endif SQL_Server */
  end
GO
 
-- select * from prospect_lists where dynamic_list = 1 and deleted = 0
-- delete from PROSPECT_LISTS_PROSPECTS where PROSPECT_LIST_ID = '1DE659B7-2B09-4F3C-A049-DB40A47F4193';

-- begin tran;
-- exec spPROSPECT_LISTS_UpdateDynamic '1DE659B7-2B09-4F3C-A049-DB40A47F4193', null;
-- select * from PROSPECT_LISTS_PROSPECTS where PROSPECT_LIST_ID = '1DE659B7-2B09-4F3C-A049-DB40A47F4193' and DELETED = 0;
-- rollback tran;


Grant Execute on dbo.spPROSPECT_LISTS_UpdateDynamic to public;
GO

