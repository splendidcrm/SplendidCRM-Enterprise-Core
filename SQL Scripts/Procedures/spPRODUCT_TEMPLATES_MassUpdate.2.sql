if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPRODUCT_TEMPLATES_MassUpdate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPRODUCT_TEMPLATES_MassUpdate;
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
-- 05/21/2012 Paul.  Add QUICKBOOKS_ACCOUNT to support QuickBooks sync. 
-- 03/22/2017 Paul.  Update the custom field table so that the audit view will have macthing custom field values. 
Create Procedure dbo.spPRODUCT_TEMPLATES_MassUpdate
	( @ID_LIST             varchar(8000)
	, @MODIFIED_USER_ID    uniqueidentifier
	, @DATE_AVAILABLE      datetime
	, @DATE_COST_PRICE     datetime
	, @STATUS              nvarchar(25)
	, @TAX_CLASS           nvarchar(25)
	, @SUPPORT_TERM        nvarchar(25)
	, @ACCOUNT_ID          uniqueidentifier
	, @TEAM_ID             uniqueidentifier
	, @TEAM_SET_LIST       varchar(8000) = null
	, @TEAM_SET_ADD        bit = null
	, @CATEGORY_ID         uniqueidentifier = null
	, @TYPE_ID             uniqueidentifier = null
	, @QUICKBOOKS_ACCOUNT  nvarchar(50) = null
	)
as
  begin
	set nocount on
	
	declare @DATE_START   datetime;
	declare @ID           uniqueidentifier;
	declare @CurrentPosR  int;
	declare @NextPosR     int;
	declare @TEAM_SET_ID  uniqueidentifier;
	declare @OLD_SET_ID   uniqueidentifier;

	-- 08/29/2009 Paul.  Allow sets to be mass assigned. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;

	-- 07/09/2006 Paul.  SugarCRM 4.2 only updates the date, not the time. 
	set @DATE_START = dbo.fnDateOnly(@DATE_COST_PRICE);

	set @CurrentPosR = 1;
	while @CurrentPosR <= len(@ID_LIST) begin -- do
		-- 10/04/2006 Paul.  charindex should not use unicode parameters as it will limit all inputs to 4000 characters. 
		set @NextPosR = charindex(',', @ID_LIST,  @CurrentPosR);
		if @NextPosR = 0 or @NextPosR is null begin -- then
			set @NextPosR = len(@ID_LIST) + 1;
		end -- if;
		set @ID = cast(rtrim(ltrim(substring(@ID_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
		set @CurrentPosR = @NextPosR+1;

		-- 08/29/2009 Paul.  When adding a set, we need to start with the existing set of the current record. 
		if @TEAM_SET_ADD = 1 and @TEAM_SET_ID is not null begin -- then
			-- BEGIN Oracle Exception
				-- 08/29/2009 Paul.  If a primary team was not provided, then load the old primary team. 
				select @OLD_SET_ID = TEAM_SET_ID
				     , @TEAM_ID    = isnull(@TEAM_ID, TEAM_ID)
				  from PRODUCT_TEMPLATES
				 where ID                = @ID
				   and DELETED           = 0;
			-- END Oracle Exception
			if @OLD_SET_ID is not null begin -- then
				exec dbo.spTEAM_SETS_AddSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @OLD_SET_ID, @TEAM_ID, @TEAM_SET_ID;
			end -- if;
		end -- if;

		-- BEGIN Oracle Exception
			update PRODUCT_TEMPLATES
			   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
			     , DATE_MODIFIED     =  getdate()        
			     , DATE_MODIFIED_UTC =  getutcdate()     
			     , DATE_AVAILABLE    = @DATE_AVAILABLE   
			     , DATE_COST_PRICE   = @DATE_COST_PRICE  
			     , STATUS            = isnull(@STATUS            , STATUS            )
			     , TAX_CLASS         = isnull(@TAX_CLASS         , TAX_CLASS         )
			     , SUPPORT_TERM      = isnull(@SUPPORT_TERM      , SUPPORT_TERM      )
			     , ACCOUNT_ID        = isnull(@ACCOUNT_ID        , ACCOUNT_ID        )
			     , TEAM_ID           = isnull(@TEAM_ID           , TEAM_ID           )
			     , TEAM_SET_ID       = isnull(@TEAM_SET_ID       , TEAM_SET_ID       )
			     , CATEGORY_ID       = isnull(@CATEGORY_ID       , CATEGORY_ID       )
			     , TYPE_ID           = isnull(@TYPE_ID           , TYPE_ID           )
			     , QUICKBOOKS_ACCOUNT= isnull(@QUICKBOOKS_ACCOUNT, QUICKBOOKS_ACCOUNT)
			 where ID                = @ID
			   and DELETED           = 0;
		-- END Oracle Exception
		-- 03/22/2017 Paul.  Update the custom field table so that the audit view will have macthing custom field values. 
		-- BEGIN Oracle Exception
			update PRODUCT_TEMPLATES_CSTM
			   set ID_C              = ID_C
			 where ID_C              = @ID;
		-- END Oracle Exception

		-- 08/30/2009 Paul.  Make sure to update the module-specific team relationships. 
		-- 08/31/2009 Paul.  Instead of managing a separate teams relationship, we will leverage TEAM_SETS_TEAMS. 
		-- if @TEAM_SET_ID is not null begin -- then
		-- 	exec dbo.spPRODUCT_TEMPLATES_TEAMS_Update @ID, @MODIFIED_USER_ID, @TEAM_SET_ID;
		-- end -- if;
	end -- while;
  end
GO
 
Grant Execute on dbo.spPRODUCT_TEMPLATES_MassUpdate to public;
GO
 
 
