if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spKBDOCUMENTS_KBTAGS_NormalizeSet' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spKBDOCUMENTS_KBTAGS_NormalizeSet;
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
Create Procedure dbo.spKBDOCUMENTS_KBTAGS_NormalizeSet
	( @MODIFIED_USER_ID      uniqueidentifier
	, @KBDOCUMENT_ID         uniqueidentifier
	, @KBTAG_SET_LIST        nvarchar(max)
	, @NORMAL_KBTAG_SET_LIST nvarchar(max) output
	)
as
  begin
	set nocount on
	
	declare @KBTAG_ID             uniqueidentifier;
	declare @TAG_NAME             nvarchar(128);
	declare @CurrentPosR          int;
	declare @NextPosR             int;
-- #if SQL_Server /*
	declare @TEMP_KBTAGS table
		( KBTAG_ID     uniqueidentifier not null primary key
		);
-- #endif SQL_Server */

	if @KBTAG_SET_LIST is not null and len(@KBTAG_SET_LIST) > 0 begin -- then
		set @CurrentPosR = 1;
		-- 08/21/2009 Paul.  Add any new KBTAGS to the relationship table. 
		while @CurrentPosR <= len(@KBTAG_SET_LIST) begin -- do
			set @NextPosR = charindex(',', @KBTAG_SET_LIST,  @CurrentPosR);
			if @NextPosR = 0 or @NextPosR is null begin -- then
				set @NextPosR = len(@KBTAG_SET_LIST) + 1;
			end -- if;
			set @KBTAG_ID = cast(rtrim(ltrim(substring(@KBTAG_SET_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
			set @CurrentPosR = @NextPosR+1;
			
			-- 08/22/2009 Paul.  Prevent duplicates by inserting unique KBTAGS into the temp table. 
			if not exists(select * from @TEMP_KBTAGS where KBTAG_ID = @KBTAG_ID) begin -- then
				-- BEGIN Oracle Exception
					select @TAG_NAME = TAG_NAME
					  from KBTAGS
					 where ID          = @KBTAG_ID
					   and DELETED     = 0;
				-- END Oracle Exception
				if @TAG_NAME is not null begin -- then
					insert into @TEMP_KBTAGS ( KBTAG_ID)
					                 values ( @KBTAG_ID);
				end -- if;
			end -- if;
		end -- while;
	end -- if;

	if @KBDOCUMENT_ID is not null begin -- then
		-- 10/21/2009 Paul.  Insert any new tags. 
		insert into KBDOCUMENTS_KBTAGS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, KBDOCUMENT_ID    
			, KBTAG_ID         
			)
		select  newid()             
		     , @MODIFIED_USER_ID    
		     ,  getdate()           
		     , @MODIFIED_USER_ID    
		     ,  getdate()           
		     , @KBDOCUMENT_ID       
		     , TEMP_KBTAGS.KBTAG_ID 
		  from            @TEMP_KBTAGS                       TEMP_KBTAGS
		  left outer join KBDOCUMENTS_KBTAGS
		               on KBDOCUMENTS_KBTAGS.KBTAG_ID      = TEMP_KBTAGS.KBTAG_ID
		              and KBDOCUMENTS_KBTAGS.KBDOCUMENT_ID = @KBDOCUMENT_ID
		              and KBDOCUMENTS_KBTAGS.DELETED       = 0
		 where KBDOCUMENTS_KBTAGS.ID is null;
	
		-- 10/21/2009 Paul.  Remove any missing tags. 
		update KBDOCUMENTS_KBTAGS
		   set DELETED          = 1
		     , MODIFIED_USER_ID = @MODIFIED_USER_ID
		     , DATE_MODIFIED    =  getdate()        
		     , DATE_MODIFIED_UTC=  getutcdate()     
		 where KBDOCUMENT_ID    = @KBDOCUMENT_ID
		   and DELETED          = 0
		   and KBTAG_ID not in (select KBTAG_ID from @TEMP_KBTAGS);
	
	end -- if;

	set @NORMAL_KBTAG_SET_LIST = null;
	if exists(select * from @TEMP_KBTAGS) begin -- then
		set @NORMAL_KBTAG_SET_LIST = N'';
		
		-- 08/22/2009 Paul.  Order the ID list by the IDs of the teams, with the primary going first.
		-- 08/23/2009 Paul.  There is no space separator after the comma as we want to be efficient with space. 
		select @NORMAL_KBTAG_SET_LIST = @NORMAL_KBTAG_SET_LIST + (case when len(@NORMAL_KBTAG_SET_LIST) > 0 then  ',' else  '' end) + cast(KBTAG_ID as char(36))
		  from @TEMP_KBTAGS
		 order by KBTAG_ID asc;
	end -- if;
  end
GO
 
Grant Execute on dbo.spKBDOCUMENTS_KBTAGS_NormalizeSet to public;
GO
 
 
