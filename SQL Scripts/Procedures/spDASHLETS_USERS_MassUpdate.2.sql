if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDASHLETS_USERS_MassUpdate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDASHLETS_USERS_MassUpdate;
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
-- 09/24/2009 Paul.  The new Silverlight charts exceeded the control name length of 50. 
-- 01/24/2010 Paul.  Allow multiple. 
Create Procedure dbo.spDASHLETS_USERS_MassUpdate
	( @ID_LIST          varchar(8000)
	, @MODIFIED_USER_ID uniqueidentifier
	, @ASSIGNED_USER_ID uniqueidentifier
	, @DETAIL_NAME      nvarchar(50)
	)
as
  begin
	set nocount on
	
	declare @ID             uniqueidentifier;
	declare @CurrentPosR    int;
	declare @NextPosR       int;
	declare @MODULE_NAME    nvarchar(50);
	declare @CONTROL_NAME   nvarchar(100);
	declare @DASHLET_ORDER  int;
	declare @TITLE          nvarchar(100);
	declare @ALLOW_MULTIPLE bit;

	set @CurrentPosR = 1;
	while @CurrentPosR <= len(@ID_LIST) begin -- do
		set @NextPosR = charindex(',', @ID_LIST,  @CurrentPosR);
		if @NextPosR = 0 or @NextPosR is null begin -- then
			set @NextPosR = len(@ID_LIST) + 1;
		end -- if;
		set @ID = cast(rtrim(ltrim(substring(@ID_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
		set @CurrentPosR = @NextPosR+1;
		
		select @MODULE_NAME    = MODULE_NAME
		     , @CONTROL_NAME   = CONTROL_NAME
		     , @TITLE          = TITLE
		     , @ALLOW_MULTIPLE = ALLOW_MULTIPLE
		  from DASHLETS
		 where ID              = @ID
		   and DELETED         = 0;

		if @CONTROL_NAME is not null begin -- then		
			-- 07/28/2009 Paul.  Make sure to check the DELETED flag. 
			-- 01/24/2010 Paul.  We only need the filter if Allow Multiple is false. 
			if not exists(select * from DASHLETS_USERS where @ALLOW_MULTIPLE = 0 and ASSIGNED_USER_ID = @ASSIGNED_USER_ID and DETAIL_NAME = @DETAIL_NAME and CONTROL_NAME = @CONTROL_NAME and DELETED = 0) begin -- then
				select @DASHLET_ORDER = max(DASHLET_ORDER) + 1
				  from DASHLETS_USERS
				 where ASSIGNED_USER_ID = @ASSIGNED_USER_ID 
				   and DETAIL_NAME      = @DETAIL_NAME      
				   and DELETED          = 0;
				-- 09/29/2009 Paul.  If the list is empty, the order will be zero. 
				if @DASHLET_ORDER is null begin -- then
					set @DASHLET_ORDER = 0;
				end -- if;
				insert into DASHLETS_USERS
					( CREATED_BY          
					, DATE_ENTERED        
					, MODIFIED_USER_ID    
					, DATE_MODIFIED       
					, ASSIGNED_USER_ID    
					, DETAIL_NAME         
					, MODULE_NAME         
					, CONTROL_NAME        
					, DASHLET_ORDER  
					, DASHLET_ENABLED
					, TITLE               
					)
				values	( @MODIFIED_USER_ID   
					, getdate()           
					, @MODIFIED_USER_ID   
					, getdate()           
					, @ASSIGNED_USER_ID   
					, @DETAIL_NAME         
					, @MODULE_NAME         
					, @CONTROL_NAME        
					, @DASHLET_ORDER  
					, 1
					, @TITLE               
					);
			end -- if;
		end -- if;
	end -- while;
  end
GO

Grant Execute on dbo.spDASHLETS_USERS_MassUpdate to public;
GO

