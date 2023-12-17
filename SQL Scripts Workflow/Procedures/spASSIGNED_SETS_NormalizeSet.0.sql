if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spASSIGNED_SETS_NormalizeSet' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spASSIGNED_SETS_NormalizeSet;
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
-- 01/22/2018 Paul.  We need to check the enable_dynamic_assignment flag. 
Create Procedure dbo.spASSIGNED_SETS_NormalizeSet
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @PRIMARY_USER_ID      uniqueidentifier
	, @ASSIGNED_SET_LIST    varchar(8000)
	)
as
  begin
	set nocount on
	
	declare @NORMAL_ASSIGNED_SET_LIST varchar(851);
	declare @NORMAL_ASSIGNED_SET_NAME nvarchar(200);
	declare @ASSIGNED_SET_ID          uniqueidentifier;
	declare @USER_ID                  uniqueidentifier;
	declare @USER_NAME                nvarchar(128);
	declare @CurrentPosR              int;
	declare @NextPosR                 int;
-- #if SQL_Server /*
	declare @TEMP_USERS table
		( ID           uniqueidentifier not null primary key
		, PRIMARY_USER bit not null default(0)
		, NAME         nvarchar(128) not null
		);
-- #endif SQL_Server */

	-- 01/22/2018 Paul.  We need to check the enable_dynamic_assignment flag. 
	if dbo.fnCONFIG_Boolean('enable_dynamic_assignment') = 1 begin -- then
		if @PRIMARY_USER_ID is not null begin -- then
			-- BEGIN Oracle Exception
				select @USER_NAME = USER_NAME
				  from USERS
				 where ID         = @PRIMARY_USER_ID
				   and DELETED    = 0;
			-- END Oracle Exception
			if @USER_NAME is not null begin -- then
				insert into @TEMP_USERS ( ID              , PRIMARY_USER, NAME      )
				                 values ( @PRIMARY_USER_ID, 1           , @USER_NAME);
			end -- if;
		end -- if;
	
		if @ASSIGNED_SET_LIST is not null and len(@ASSIGNED_SET_LIST) > 0 begin -- then
			set @CurrentPosR = 1;
			-- 11/30/2017 Paul.  Add any new USERS to the relationship table. 
			while @CurrentPosR <= len(@ASSIGNED_SET_LIST) begin -- do
				set @NextPosR = charindex(',', @ASSIGNED_SET_LIST,  @CurrentPosR);
				if @NextPosR = 0 or @NextPosR is null begin -- then
					set @NextPosR = len(@ASSIGNED_SET_LIST) + 1;
				end -- if;
				set @USER_ID = cast(rtrim(ltrim(substring(@ASSIGNED_SET_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
				set @CurrentPosR = @NextPosR+1;
				
				-- 11/30/2017 Paul.  Prevent duplicates by inserting unique USERS into the temp table. 
				if not exists(select * from @TEMP_USERS where ID = @USER_ID) begin -- then
					-- BEGIN Oracle Exception
						select @USER_NAME = USER_NAME
						  from USERS
						 where ID         = @USER_ID
						   and DELETED    = 0;
					-- END Oracle Exception
					if @USER_NAME is not null begin -- then
						insert into @TEMP_USERS ( ID      , PRIMARY_USER, NAME      )
						                 values ( @USER_ID, 0           , @USER_NAME);
					end -- if;
				end -- if;
			end -- while;
		end -- if;
	
		set @ID = null;
		if exists(select * from @TEMP_USERS) begin -- then
			set @NORMAL_ASSIGNED_SET_LIST =  '';
			set @NORMAL_ASSIGNED_SET_NAME = N'';
			
			-- 11/30/2017 Paul.  Order the ID list by the IDs of the USERS, with the primary going first.
			-- 11/30/2017 Paul.  There is no space separator after the comma as we want to be efficient with space. 
			select @NORMAL_ASSIGNED_SET_LIST = substring(@NORMAL_ASSIGNED_SET_LIST + (case when len(@NORMAL_ASSIGNED_SET_LIST) > 0 then  ',' else  '' end) + cast(ID as char(36)), 1, 851)
			  from @TEMP_USERS
			 order by PRIMARY_USER desc, ID asc;
			
			-- 11/30/2017 Paul.  Order the set name by the names of the USERS, with the primary going first. 
			-- 11/30/2017 Paul.  Use a space after the comma so that the ASSIGNED names are readable in the GridView or DetailView. 
			select @NORMAL_ASSIGNED_SET_NAME = substring(@NORMAL_ASSIGNED_SET_NAME + (case when len(@NORMAL_ASSIGNED_SET_NAME) > 0 then N', ' else N'' end) + NAME, 1, 200)
			  from @TEMP_USERS
			 order by PRIMARY_USER desc, NAME asc;
	
			-- 11/30/2017 Paul.  If a ASSIGNED set already exists with the same normalized list, then return it.
			-- The ASSIGNED set does not need to be identical, it just needs to have the same display list, so we use the id list as the key. 
			-- 11/30/2017 Paul.  We have to make sure to get the top item as there may be more than one entry. 
			-- As much as we would want to prevent this, it is possible for the offline client to create duplicate ASSIGNED sets. 
			-- BEGIN Oracle Exception
				select top 1 @ID = ID
				  from ASSIGNED_SETS
				 where ASSIGNED_SET_LIST = @NORMAL_ASSIGNED_SET_LIST
				   and DELETED       = 0
				  order by DATE_ENTERED;
			-- END Oracle Exception
			if @ID is null begin -- then
				set @ID = newid();
				-- 11/30/2017 Paul.  Use a duplicate variable for clarity. 
				set @ASSIGNED_SET_ID = @ID;
				insert into ASSIGNED_SETS
					( ID               
					, CREATED_BY       
					, DATE_ENTERED     
					, MODIFIED_USER_ID 
					, DATE_MODIFIED    
					, ASSIGNED_SET_LIST
					, ASSIGNED_SET_NAME
					)
				values
					( @ID                  
					, @MODIFIED_USER_ID    
					,  getdate()           
					, @MODIFIED_USER_ID    
					,  getdate()           
					, @NORMAL_ASSIGNED_SET_LIST
					, @NORMAL_ASSIGNED_SET_NAME
					);
				
				-- 11/30/2017 Paul.  We would normally use a cursor to be common across platforms. 
				-- Instead, lets use insert into so that we are fast. 
				insert into ASSIGNED_SETS_USERS
					( ID               
					, CREATED_BY       
					, DATE_ENTERED     
					, MODIFIED_USER_ID 
					, DATE_MODIFIED    
					, ASSIGNED_SET_ID  
					, USER_ID          
					, PRIMARY_USER     
					)
				select  newid()             
				     , @MODIFIED_USER_ID    
				     ,  getdate()           
				     , @MODIFIED_USER_ID    
				     ,  getdate()           
				     , @ASSIGNED_SET_ID     
				     ,  ID                  
				     ,  PRIMARY_USER        
				  from @TEMP_USERS;
			end -- if;
		end -- if;
	end -- if;
  end
GO
 
Grant Execute on dbo.spASSIGNED_SETS_NormalizeSet to public;
GO
 
 
