if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spQUOTES_MassUpdate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spQUOTES_MassUpdate;
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
-- 09/11/2007 Paul.  Add TEAM_ID.
-- 05/13/2016 Paul.  Add Tags module. 
-- 03/22/2017 Paul.  Update the custom field table so that the audit view will have macthing custom field values. 
-- 05/31/2018 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spQUOTES_MassUpdate
	( @ID_LIST                      varchar(8000)
	, @MODIFIED_USER_ID             uniqueidentifier
	, @ASSIGNED_USER_ID             uniqueidentifier
	, @PAYMENT_TERMS                nvarchar(25)
	, @QUOTE_STAGE                  nvarchar(25)
	, @ORIGINAL_PO_DATE             datetime
	, @DATE_QUOTE_EXPECTED_CLOSED   datetime
	, @BILLING_ACCOUNT_ID           uniqueidentifier
	, @BILLING_CONTACT_ID           uniqueidentifier
	, @SHIPPING_ACCOUNT_ID          uniqueidentifier
	, @SHIPPING_CONTACT_ID          uniqueidentifier
	, @TEAM_ID                      uniqueidentifier = null
	, @TEAM_SET_LIST                varchar(8000) = null
	, @TEAM_SET_ADD                 bit = null
	, @TAG_SET_NAME                 nvarchar(4000) = null
	, @TAG_SET_ADD                  bit = null
	, @ASSIGNED_SET_LIST            varchar(8000) = null
	, @ASSIGNED_SET_ADD             bit = null
	)
as
  begin
	set nocount on
	
	declare @ID                          uniqueidentifier;
	declare @CurrentPosR                 int;
	declare @NextPosR                    int;
	declare @BILLING_ADDRESS_STREET      nvarchar(150);
	declare @BILLING_ADDRESS_CITY        nvarchar(100);
	declare @BILLING_ADDRESS_STATE       nvarchar(100);
	declare @BILLING_ADDRESS_POSTALCODE  nvarchar( 20);
	declare @BILLING_ADDRESS_COUNTRY     nvarchar(100);
	declare @SHIPPING_ADDRESS_STREET     nvarchar(150);
	declare @SHIPPING_ADDRESS_CITY       nvarchar(100);
	declare @SHIPPING_ADDRESS_STATE      nvarchar(100);
	declare @SHIPPING_ADDRESS_POSTALCODE nvarchar( 20);
	declare @SHIPPING_ADDRESS_COUNTRY    nvarchar(100);
	declare @TEAM_SET_ID                 uniqueidentifier;
	declare @OLD_SET_ID                  uniqueidentifier;
	declare @ASSIGNED_SET_ID             uniqueidentifier;

	-- 08/29/2009 Paul.  Allow sets to be mass assigned. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;

	-- 06/20/2007 Paul.  Fix updating local variables. 
	if @BILLING_ACCOUNT_ID is not null begin -- then
		-- BEGIN Oracle Exception
		select @BILLING_ADDRESS_STREET     = BILLING_ADDRESS_STREET     
		     , @BILLING_ADDRESS_CITY       = BILLING_ADDRESS_CITY       
		     , @BILLING_ADDRESS_STATE      = BILLING_ADDRESS_STATE      
		     , @BILLING_ADDRESS_POSTALCODE = BILLING_ADDRESS_POSTALCODE 
		     , @BILLING_ADDRESS_COUNTRY    = BILLING_ADDRESS_COUNTRY    
		  from ACCOUNTS
		 where ID                          = @BILLING_ACCOUNT_ID
		   and DELETED                     = 0;
		-- END Oracle Exception
	end -- if;

	if @BILLING_CONTACT_ID is not null begin -- then
		-- BEGIN Oracle Exception
		select @BILLING_ADDRESS_STREET     = PRIMARY_ADDRESS_STREET     
		     , @BILLING_ADDRESS_CITY       = PRIMARY_ADDRESS_CITY       
		     , @BILLING_ADDRESS_STATE      = PRIMARY_ADDRESS_STATE      
		     , @BILLING_ADDRESS_POSTALCODE = PRIMARY_ADDRESS_POSTALCODE 
		     , @BILLING_ADDRESS_COUNTRY    = PRIMARY_ADDRESS_COUNTRY    
		  from CONTACTS
		 where ID                          = @BILLING_CONTACT_ID
		   and DELETED                     = 0;
		-- END Oracle Exception
	end -- if;

	if @SHIPPING_ACCOUNT_ID is not null begin -- then
		-- BEGIN Oracle Exception
		select @SHIPPING_ADDRESS_STREET     = SHIPPING_ADDRESS_STREET     
		     , @SHIPPING_ADDRESS_CITY       = SHIPPING_ADDRESS_CITY       
		     , @SHIPPING_ADDRESS_STATE      = SHIPPING_ADDRESS_STATE      
		     , @SHIPPING_ADDRESS_POSTALCODE = SHIPPING_ADDRESS_POSTALCODE 
		     , @SHIPPING_ADDRESS_COUNTRY    = SHIPPING_ADDRESS_COUNTRY    
		  from ACCOUNTS
		 where ID                           = @SHIPPING_ACCOUNT_ID
		   and DELETED                      = 0;
		-- END Oracle Exception
	end -- if;

	if @SHIPPING_CONTACT_ID is not null begin -- then
		-- BEGIN Oracle Exception
		select @SHIPPING_ADDRESS_STREET     = PRIMARY_ADDRESS_STREET     
		     , @SHIPPING_ADDRESS_CITY       = PRIMARY_ADDRESS_CITY       
		     , @SHIPPING_ADDRESS_STATE      = PRIMARY_ADDRESS_STATE      
		     , @SHIPPING_ADDRESS_POSTALCODE = PRIMARY_ADDRESS_POSTALCODE 
		     , @SHIPPING_ADDRESS_COUNTRY    = PRIMARY_ADDRESS_COUNTRY    
		  from CONTACTS
		 where ID                           = @SHIPPING_CONTACT_ID
		   and DELETED                      = 0;
		-- END Oracle Exception
	end -- if;

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
				  from QUOTES
				 where ID                = @ID
				   and DELETED           = 0;
			-- END Oracle Exception
			if @OLD_SET_ID is not null begin -- then
				exec dbo.spTEAM_SETS_AddSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @OLD_SET_ID, @TEAM_ID, @TEAM_SET_ID;
			end -- if;
		end -- if;

		-- 05/13/2016 Paul.  Add Tags module. 
		if @TAG_SET_NAME is not null and len(@TAG_SET_NAME) > 0 begin -- then
			if @TAG_SET_ADD = 1 begin -- then
				exec dbo.spTAG_SETS_AddSet       @MODIFIED_USER_ID, @ID, N'Quotes', @TAG_SET_NAME;
			end else begin
				exec dbo.spTAG_SETS_NormalizeSet @MODIFIED_USER_ID, @ID, N'Quotes', @TAG_SET_NAME;
			end -- if;
		end -- if;

		-- BEGIN Oracle Exception
			update QUOTES
			   set MODIFIED_USER_ID            = @MODIFIED_USER_ID 
			     , DATE_MODIFIED               =  getdate()        
			     , DATE_MODIFIED_UTC           =  getutcdate()     
			     , ASSIGNED_USER_ID            = isnull(@ASSIGNED_USER_ID           , ASSIGNED_USER_ID           )
			     , PAYMENT_TERMS               = isnull(@PAYMENT_TERMS              , PAYMENT_TERMS              )
			     , QUOTE_STAGE                 = isnull(@QUOTE_STAGE                , QUOTE_STAGE                )
			     , ORIGINAL_PO_DATE            = isnull(@ORIGINAL_PO_DATE           , ORIGINAL_PO_DATE           )
			     , DATE_QUOTE_EXPECTED_CLOSED  = isnull(@DATE_QUOTE_EXPECTED_CLOSED , DATE_QUOTE_EXPECTED_CLOSED )
			     , BILLING_ADDRESS_STREET      = isnull(@BILLING_ADDRESS_STREET     , BILLING_ADDRESS_STREET     )
			     , BILLING_ADDRESS_CITY        = isnull(@BILLING_ADDRESS_CITY       , BILLING_ADDRESS_CITY       )
			     , BILLING_ADDRESS_STATE       = isnull(@BILLING_ADDRESS_STATE      , BILLING_ADDRESS_STATE      )
			     , BILLING_ADDRESS_POSTALCODE  = isnull(@BILLING_ADDRESS_POSTALCODE , BILLING_ADDRESS_POSTALCODE )
			     , BILLING_ADDRESS_COUNTRY     = isnull(@BILLING_ADDRESS_COUNTRY    , BILLING_ADDRESS_COUNTRY    )
			     , SHIPPING_ADDRESS_STREET     = isnull(@SHIPPING_ADDRESS_STREET    , SHIPPING_ADDRESS_STREET    )
			     , SHIPPING_ADDRESS_CITY       = isnull(@SHIPPING_ADDRESS_CITY      , SHIPPING_ADDRESS_CITY      )
			     , SHIPPING_ADDRESS_STATE      = isnull(@SHIPPING_ADDRESS_STATE     , SHIPPING_ADDRESS_STATE     )
			     , SHIPPING_ADDRESS_POSTALCODE = isnull(@SHIPPING_ADDRESS_POSTALCODE, SHIPPING_ADDRESS_POSTALCODE)
			     , SHIPPING_ADDRESS_COUNTRY    = isnull(@SHIPPING_ADDRESS_COUNTRY   , SHIPPING_ADDRESS_COUNTRY   )
			     , TEAM_ID                     = isnull(@TEAM_ID                    , TEAM_ID                    )
			     , TEAM_SET_ID                 = isnull(@TEAM_SET_ID                , TEAM_SET_ID                )
			 where ID                          = @ID
			   and DELETED                     = 0;
		-- END Oracle Exception
		-- 03/22/2017 Paul.  Update the custom field table so that the audit view will have macthing custom field values. 
		-- BEGIN Oracle Exception
			update QUOTES_CSTM
			   set ID_C              = ID_C
			 where ID_C              = @ID;
		-- END Oracle Exception

		-- 08/30/2009 Paul.  Make sure to update the module-specific team relationships. 
		-- 08/31/2009 Paul.  Instead of managing a separate teams relationship, we will leverage TEAM_SETS_TEAMS. 
		-- if @TEAM_SET_ID is not null begin -- then
		-- 	exec dbo.spQUOTES_TEAMS_Update @ID, @MODIFIED_USER_ID, @TEAM_SET_ID;
		-- end -- if;

		if dbo.fnIsEmptyGuid(@BILLING_ACCOUNT_ID) = 0 begin -- then
			exec dbo.spQUOTES_ACCOUNTS_Update @MODIFIED_USER_ID, @ID, @BILLING_ACCOUNT_ID , N'Bill To';
		end -- if;
		if dbo.fnIsEmptyGuid(@SHIPPING_ACCOUNT_ID) = 0 begin -- then
			exec dbo.spQUOTES_ACCOUNTS_Update @MODIFIED_USER_ID, @ID, @SHIPPING_ACCOUNT_ID, N'Ship To';
		end -- if;

		if dbo.fnIsEmptyGuid(@BILLING_CONTACT_ID) = 0 begin -- then
			exec dbo.spQUOTES_CONTACTS_Update @MODIFIED_USER_ID, @ID, @BILLING_CONTACT_ID , N'Bill To';
		end -- if;
		if dbo.fnIsEmptyGuid(@SHIPPING_CONTACT_ID) = 0 begin -- then
			exec dbo.spQUOTES_CONTACTS_Update @MODIFIED_USER_ID, @ID, @SHIPPING_CONTACT_ID, N'Ship To';
		end -- if;
	end -- while;
  end
GO
 
Grant Execute on dbo.spQUOTES_MassUpdate to public;
GO
 
 
