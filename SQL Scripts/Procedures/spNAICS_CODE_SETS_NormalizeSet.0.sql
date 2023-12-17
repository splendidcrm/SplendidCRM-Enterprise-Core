if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spNAICS_CODE_SETS_NormalizeSet' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spNAICS_CODE_SETS_NormalizeSet;
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
Create Procedure dbo.spNAICS_CODE_SETS_NormalizeSet
	( @MODIFIED_USER_ID     uniqueidentifier
	, @PARENT_ID            uniqueidentifier
	, @PARENT_MODULE        nvarchar(50)
	, @NAICS_SET_NAME       nvarchar(4000)
	)
as
  begin
	set nocount on
	
	declare @NAICS_SET_ID           uniqueidentifier;
	declare @NORMAL_NAICS_SET_LIST  varchar(851);
	declare @NORMAL_NAICS_SET_NAME  varchar(851);
	declare @NAICS_CODE_ID          uniqueidentifier;
	declare @NAICS_CODE_NAME        nvarchar(10);
	declare @CurrentPosR            int;
	declare @NextPosR               int;
-- #if SQL_Server /*
	declare @TEMP_NAICS_CODES table
		( ID           uniqueidentifier not null primary key
		, NAME         nvarchar(10) not null
		);
-- #endif SQL_Server */

	if @NAICS_SET_NAME is not null and len(@NAICS_SET_NAME) > 0 begin -- then
		set @CurrentPosR = 1;
		-- 05/10/2016 Paul.  Add any new TAGs to the relationship table. 
		while @CurrentPosR <= len(@NAICS_SET_NAME) begin -- do
			set @NextPosR = charindex(',', @NAICS_SET_NAME,  @CurrentPosR);
			if @NextPosR = 0 or @NextPosR is null begin -- then
				set @NextPosR = len(@NAICS_SET_NAME) + 1;
			end -- if;
			set @NAICS_CODE_NAME = rtrim(ltrim(substring(@NAICS_SET_NAME, @CurrentPosR, @NextPosR - @CurrentPosR)));
			set @CurrentPosR = @NextPosR+1;
			
			-- 05/10/2016 Paul.  Prevent duplicates by inserting unique TAGs into the temp table. 
			if not exists(select * from @TEMP_NAICS_CODES where NAME = @NAICS_CODE_NAME) begin -- then
				set @NAICS_CODE_ID = null;
				-- BEGIN Oracle Exception
					select @NAICS_CODE_ID = ID
					  from NAICS_CODES
					 where NAME       = @NAICS_CODE_NAME
					   and DELETED    = 0;
				-- END Oracle Exception
				if @NAICS_CODE_ID is not null begin -- then
					insert into @TEMP_NAICS_CODES  (  ID           ,  NAME           )
					                        values ( @NAICS_CODE_ID, @NAICS_CODE_NAME);
				-- 06/07/2017 Paul.  We do not add codes if they do not exist. 
				end -- if;
			end -- if;
		end -- while;
	end -- if;

	set @NAICS_SET_ID = null;
	if exists(select * from @TEMP_NAICS_CODES) begin -- then
		set @NORMAL_NAICS_SET_LIST =  '';
		set @NORMAL_NAICS_SET_NAME = N'';
		
		-- 05/10/2016 Paul.  Order the ID list by the IDs of the TAGs.
		-- 05/10/2016 Paul.  There is no space separator after the comma as we want to be efficient with space. 
		select @NORMAL_NAICS_SET_LIST = substring(@NORMAL_NAICS_SET_LIST + (case when len(@NORMAL_NAICS_SET_LIST) > 0 then  ',' else  '' end) + cast(ID as char(36)), 1, 851)
		  from @TEMP_NAICS_CODES
		 order by ID asc;
		
		-- 05/10/2016 Paul.  Order the set name by the names of the TAGs. 
		-- 05/10/2016 Paul.  Use a space after the comma so that the TAG names are readable in the GridView or DetailView. 
		-- 05/11/2016 Paul.  Don't need substring because set name is nvarchar(max). TEAM_SETS does have a size of 200. 
		select @NORMAL_NAICS_SET_NAME = substring(@NORMAL_NAICS_SET_NAME + (case when len(@NORMAL_NAICS_SET_NAME) > 0 then  ',' else  '' end) + NAME, 1, 851)
		  from @TEMP_NAICS_CODES
		 order by NAME asc;

		-- 05/10/2016 Paul.  If a TAG set already exists with the same normalized list, then return it.
		-- The TAG set does not need to be identical, it just needs to have the same display list, so we use the id list as the key. 
		-- 05/10/2016 Paul.  We have to make sure to get the top item as there may be more than one entry. 
		-- As much as we would want to prevent this, it is possible for the offline client to create duplicate TAG sets. 
		-- BEGIN Oracle Exception
			select top 1 @NAICS_SET_ID = ID
			  from NAICS_CODE_SETS
			 where PARENT_ID     = @PARENT_ID
			   and DELETED       = 0
			  order by DATE_ENTERED;
		-- END Oracle Exception
		if @NAICS_SET_ID is null begin -- then
			set @NAICS_SET_ID = newid();
			insert into NAICS_CODE_SETS
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, PARENT_ID           
				, PARENT_MODULE       
				, NAICS_SET_LIST    
				, NAICS_SET_NAME    
				)
			values
				( @NAICS_SET_ID                  
				, @MODIFIED_USER_ID    
				,  getdate()           
				, @MODIFIED_USER_ID    
				,  getdate()           
				, @PARENT_ID           
				, @PARENT_MODULE       
				, @NORMAL_NAICS_SET_LIST
				, @NORMAL_NAICS_SET_NAME
				);
		end else begin
			update NAICS_CODE_SETS
			   set NAICS_SET_LIST    = @NORMAL_NAICS_SET_LIST
			     , NAICS_SET_NAME    = @NORMAL_NAICS_SET_NAME
			     , DATE_MODIFIED     = getdate()
			     , DATE_MODIFIED_UTC = getutcdate()
			     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
			 where PARENT_ID         = @PARENT_ID
			   and DELETED           = 0;
		end -- if;
		
		update NAICS_CODES_RELATED
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where PARENT_ID           = @PARENT_ID
		   and DELETED           = 0
		   and NAICS_CODE_ID            not in (select ID from @TEMP_NAICS_CODES);
		-- 05/10/2016 Paul.  We would normally use a cursor to be common across platforms. 
		-- Instead, lets use insert into so that we are fast. 
		insert into NAICS_CODES_RELATED
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, NAICS_CODE_ID           
			, PARENT_ID          
			, PARENT_MODULE      
			)
		select  newid()          
		     , @MODIFIED_USER_ID 
		     ,  getdate()        
		     , @MODIFIED_USER_ID 
		     ,  getdate()        
		     ,  ID               
		     , @PARENT_ID          
		     , @PARENT_MODULE      
		  from @TEMP_NAICS_CODES
		 where ID not in (select NAICS_CODE_ID from NAICS_CODES_RELATED where DELETED = 0 and PARENT_ID = @PARENT_ID);
	end else begin
		-- 05/12/2016 Paul.  If the new list is empty, delete all existing records. 
		update NAICS_CODE_SETS
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where PARENT_ID         = @PARENT_ID
		   and DELETED           = 0;
		
		update NAICS_CODES_RELATED
		   set DELETED           = 1
		     , DATE_MODIFIED     = getdate()
		     , DATE_MODIFIED_UTC = getutcdate()
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
		 where PARENT_ID         = @PARENT_ID
		   and DELETED           = 0;
	end -- if;
  end
GO

Grant Execute on dbo.spNAICS_CODE_SETS_NormalizeSet to public;
GO

