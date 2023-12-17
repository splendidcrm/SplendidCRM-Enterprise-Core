if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACCOUNTS_CONTACTS_CopyAddress' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACCOUNTS_CONTACTS_CopyAddress;
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
Create Procedure dbo.spACCOUNTS_CONTACTS_CopyAddress
	( @ID_LIST          varchar(8000)
	, @MODIFIED_USER_ID uniqueidentifier
	, @ACCOUNT_ID       uniqueidentifier
	, @ADDRESS_TYPE     nvarchar(25)
	)
as
  begin
	set nocount on
	
	declare @ID                 uniqueidentifier;
	declare @CurrentPosR        int;
	declare @NextPosR           int;
	declare @ADDRESS_STREET     nvarchar(150);
	declare @ADDRESS_CITY       nvarchar(100);
	declare @ADDRESS_STATE      nvarchar(100);
	declare @ADDRESS_POSTALCODE nvarchar( 20);
	declare @ADDRESS_COUNTRY    nvarchar(100);

	-- BEGIN Oracle Exception
		if @ADDRESS_TYPE = N'Shipping' begin -- then
			select @ADDRESS_STREET     = SHIPPING_ADDRESS_STREET
			     , @ADDRESS_CITY       = SHIPPING_ADDRESS_CITY
			     , @ADDRESS_STATE      = SHIPPING_ADDRESS_STATE
			     , @ADDRESS_POSTALCODE = SHIPPING_ADDRESS_POSTALCODE
			     , @ADDRESS_COUNTRY    = SHIPPING_ADDRESS_COUNTRY
			  from vwACCOUNTS
			 where ID                  = @ACCOUNT_ID;
		end else begin
			select @ADDRESS_STREET     = BILLING_ADDRESS_STREET
			     , @ADDRESS_CITY       = BILLING_ADDRESS_CITY
			     , @ADDRESS_STATE      = BILLING_ADDRESS_STATE
			     , @ADDRESS_POSTALCODE = BILLING_ADDRESS_POSTALCODE
			     , @ADDRESS_COUNTRY    = BILLING_ADDRESS_COUNTRY
			  from vwACCOUNTS
			 where ID                  = @ACCOUNT_ID;
		end -- if;
	-- END Oracle Exception

	set @CurrentPosR = 1;
	while @CurrentPosR <= len(@ID_LIST) begin -- do
		-- 10/04/2006 Paul.  charindex should not use unicode parameters as it will limit all inputs to 4000 characters. 
		set @NextPosR = charindex(',', @ID_LIST,  @CurrentPosR);
		if @NextPosR = 0 or @NextPosR is null begin -- then
			set @NextPosR = len(@ID_LIST) + 1;
		end -- if;
		set @ID = cast(rtrim(ltrim(substring(@ID_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
		set @CurrentPosR = @NextPosR+1;
		if @ADDRESS_TYPE = N'Shipping' begin -- then
			update CONTACTS
			   set MODIFIED_USER_ID            = @MODIFIED_USER_ID  
			     , DATE_MODIFIED               =  getdate()         
			     , DATE_MODIFIED_UTC           =  getutcdate()      
			     , ALT_ADDRESS_STREET          = @ADDRESS_STREET    
			     , ALT_ADDRESS_CITY            = @ADDRESS_CITY      
			     , ALT_ADDRESS_STATE           = @ADDRESS_STATE     
			     , ALT_ADDRESS_POSTALCODE      = @ADDRESS_POSTALCODE
			     , ALT_ADDRESS_COUNTRY         = @ADDRESS_COUNTRY   
			 where ID                          = @ID                
			   and DELETED                     = 0                  ;
		end else begin
			update CONTACTS
			   set MODIFIED_USER_ID            = @MODIFIED_USER_ID  
			     , DATE_MODIFIED               =  getdate()         
			     , DATE_MODIFIED_UTC           =  getutcdate()      
			     , PRIMARY_ADDRESS_STREET      = @ADDRESS_STREET    
			     , PRIMARY_ADDRESS_CITY        = @ADDRESS_CITY      
			     , PRIMARY_ADDRESS_STATE       = @ADDRESS_STATE     
			     , PRIMARY_ADDRESS_POSTALCODE  = @ADDRESS_POSTALCODE
			     , PRIMARY_ADDRESS_COUNTRY     = @ADDRESS_COUNTRY   
			 where ID                          = @ID                
			   and DELETED                     = 0                  ;
		end -- if;
	end -- while;
  end
GO
 
Grant Execute on dbo.spACCOUNTS_CONTACTS_CopyAddress to public;
GO

