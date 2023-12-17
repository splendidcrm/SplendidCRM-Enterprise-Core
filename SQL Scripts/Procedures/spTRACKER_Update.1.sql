if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTRACKER_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTRACKER_Update;
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
-- 07/14/2007 Paul.  Add support for DB2.
-- 05/07/2010 Paul.  Instead of trying to group the entries and limit by module,
-- 08/26/2010 Paul.  Restore max on a per-module basis. 
-- 03/08/2012 Paul.  Add ACTION to the tracker table so that we can create quick user activity reports. 
-- 05/05/2013 Paul.  Must include the ACTION in the oldest query. 
Create Procedure dbo.spTRACKER_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @USER_ID           uniqueidentifier
	, @MODULE_NAME       nvarchar(25)
	, @ITEM_ID           uniqueidentifier
	, @ITEM_SUMMARY      nvarchar(255)
	, @ACTION            nvarchar(25) = null
	)
as
  begin
	set nocount on
	
	declare @HistoryMax   int;
	declare @HistoryCount int;
	declare @OLDEST_ID    uniqueidentifier;

	-- 07/16/2005 Paul. SugarCRM only keeps one entry per USER_ID/ITEM_ID
	if @ACTION = N'detailview' begin -- then
		-- BEGIN Oracle Exception
			delete from TRACKER
			 where USER_ID = @USER_ID
			   and ITEM_ID = @ITEM_ID
			   and ACTION  = @ACTION
			   and DELETED = 0;
		-- END Oracle Exception
	end -- if;
	
	insert into TRACKER
		( ID               
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, USER_ID          
		, ACTION           
		, MODULE_NAME      
		, ITEM_ID          
		, ITEM_SUMMARY     
		)
	values
		(  newid()          
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @MODIFIED_USER_ID 
		,  getdate()        
		, @USER_ID          
		, @ACTION           
		, @MODULE_NAME      
		, @ITEM_ID          
		, @ITEM_SUMMARY     
		);

	-- Prune any excess tracker items. 
	set @HistoryMax = dbo.fnCONFIG_Int(N'history_max_viewed');
	if @HistoryMax is null or @HistoryMax = 0 begin -- then
		set @HistoryMax = 10;
	end -- if;
	-- 05/07/2010 Paul.  Instead of trying to group the entries and limit by module,
	-- we are simply going to limit the total to 100 and expect it to cover the most popular modules. 
	-- 08/26/2010 Paul.  Restore max on a per-module basis. 
	-- set @HistoryMax = 100;
	
-- #if SQL_Server /*
	if @ACTION = N'detailview' begin -- then
		select @HistoryCount = count(*)
		  from TRACKER
		 where USER_ID     = @USER_ID
		   and MODULE_NAME = @MODULE_NAME
		   and ACTION      = @ACTION
		   and DELETED     = 0;
	
		while @HistoryCount > @HistoryMax begin -- do
			-- 05/05/2013 Paul.  Must include the ACTION in the oldest query. 
			select top 1 @OLDEST_ID = ID
			  from TRACKER
			 where USER_ID     = @USER_ID
			   and MODULE_NAME = @MODULE_NAME
			   and ACTION      = @ACTION
			 order by DATE_ENTERED;
			
			delete from TRACKER
			  where ID = @OLDEST_ID;
			
			select @HistoryCount = count(*)
			  from TRACKER
			 where USER_ID     = @USER_ID
			   and MODULE_NAME = @MODULE_NAME
			   and ACTION      = @ACTION
			   and DELETED     = 0;
		end -- while;
	end -- if;
-- #endif SQL_Server */




  end
GO

Grant Execute on dbo.spTRACKER_Update to public;
GO

