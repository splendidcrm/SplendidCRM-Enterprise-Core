if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPAYMENTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPAYMENTS_Update;
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
-- 12/29/2007 Paul.  Add TEAM_ID so that it is not updated separately. 
-- 02/13/2008 Paul.  Add CREDIT_CARD_ID. 
-- 08/27/2008 Paul.  PostgreSQL does not allow modifying input parameters.  Use a local temp variable. 
-- 07/25/2009 Paul.  PAYMENT_NUM is no longer an identity and must be formatted. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 08/23/2009 Paul.  Decrease set list so that index plus ID will be less than 900 bytes. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 08/26/2010 Paul.  We need a bank fee field to allow for a difference between allocated and received payment. 
-- 05/01/2013 Paul.  Add Contacts field to support B2C. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spPAYMENTS_Update
	( @ID                           uniqueidentifier output
	, @MODIFIED_USER_ID             uniqueidentifier
	, @ASSIGNED_USER_ID             uniqueidentifier
	, @ACCOUNT_ID                   uniqueidentifier
	, @PAYMENT_DATE                 datetime
	, @PAYMENT_TYPE                 nvarchar(25)
	, @CUSTOMER_REFERENCE           nvarchar(50)
	, @EXCHANGE_RATE                float
	, @CURRENCY_ID                  uniqueidentifier
	, @AMOUNT                       money
	, @DESCRIPTION                  nvarchar(max)
	, @CREDIT_CARD_ID               uniqueidentifier = null
	, @PAYMENT_NUM                  nvarchar(30) = null
	, @TEAM_ID                      uniqueidentifier = null
	, @TEAM_SET_LIST                varchar(8000) = null
	, @BANK_FEE                     money = null
	, @B2C_CONTACT_ID               uniqueidentifier = null
	, @ASSIGNED_SET_LIST            varchar(8000) = null
	)
as
  begin
	set nocount on
	
	-- 06/07/2006 Paul.  Convert currency to USD. 
	declare @AMOUNT_USDOLLAR     money;
	declare @BANK_FEE_USDOLLAR   money;
	declare @TEMP_EXCHANGE_RATE  float;
	declare @TEMP_PAYMENT_NUM    nvarchar(30);
	declare @TEAM_SET_ID         uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;

	set @TEMP_EXCHANGE_RATE = @EXCHANGE_RATE;
	if @TEMP_EXCHANGE_RATE = 0.0 begin -- then
		set @TEMP_EXCHANGE_RATE = 1.0;
	end -- if;

	-- 03/31/2007 Paul.  The exchange rate is stored in the object. 
	set @AMOUNT_USDOLLAR   = @AMOUNT   / @TEMP_EXCHANGE_RATE;
	set @BANK_FEE_USDOLLAR = @BANK_FEE / @TEMP_EXCHANGE_RATE;
	set @TEMP_PAYMENT_NUM  = @PAYMENT_NUM;

	-- 08/22/2009 Paul.  Normalize the team set by placing the primary ID first, then order list by ID and the name by team names. 
	-- 08/23/2009 Paul.  Use a team set so that team name changes can propagate. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;

	if not exists(select * from PAYMENTS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		-- 07/25/2009 Paul.  Allow the PAYMENT_NUM to be imported. 
		if @TEMP_PAYMENT_NUM is null begin -- then
			exec dbo.spNUMBER_SEQUENCES_Formatted 'PAYMENTS.PAYMENT_NUM', 1, @TEMP_PAYMENT_NUM out;
		end -- if;
		insert into PAYMENTS
			( ID                          
			, CREATED_BY                  
			, DATE_ENTERED                
			, MODIFIED_USER_ID            
			, DATE_MODIFIED               
			, DATE_MODIFIED_UTC           
			, ASSIGNED_USER_ID            
			, ACCOUNT_ID                  
			, B2C_CONTACT_ID              
			, PAYMENT_NUM                 
			, PAYMENT_DATE                
			, PAYMENT_TYPE                
			, CUSTOMER_REFERENCE          
			, EXCHANGE_RATE               
			, CURRENCY_ID                 
			, AMOUNT                      
			, AMOUNT_USDOLLAR             
			, BANK_FEE                    
			, BANK_FEE_USDOLLAR           
			, CREDIT_CARD_ID              
			, DESCRIPTION                 
			, TEAM_ID                     
			, TEAM_SET_ID                 
			, ASSIGNED_SET_ID             
			)
		values 
			( @ID                          
			, @MODIFIED_USER_ID            
			,  getdate()                   
			, @MODIFIED_USER_ID            
			,  getdate()                   
			,  getutcdate()                
			, @ASSIGNED_USER_ID            
			, @ACCOUNT_ID                  
			, @B2C_CONTACT_ID              
			, @TEMP_PAYMENT_NUM            
			, @PAYMENT_DATE                
			, @PAYMENT_TYPE                
			, @CUSTOMER_REFERENCE          
			, @TEMP_EXCHANGE_RATE          
			, @CURRENCY_ID                 
			, @AMOUNT                      
			, @AMOUNT_USDOLLAR             
			, @BANK_FEE                    
			, @BANK_FEE_USDOLLAR           
			, @CREDIT_CARD_ID              
			, @DESCRIPTION                 
			, @TEAM_ID                     
			, @TEAM_SET_ID                 
			, @ASSIGNED_SET_ID             
			);
	end else begin
		update PAYMENTS
		   set MODIFIED_USER_ID             = @MODIFIED_USER_ID            
		     , DATE_MODIFIED                =  getdate()                   
		     , DATE_MODIFIED_UTC            =  getutcdate()                
		     , ASSIGNED_USER_ID             = @ASSIGNED_USER_ID            
		     , ACCOUNT_ID                   = @ACCOUNT_ID                  
		     , B2C_CONTACT_ID               = @B2C_CONTACT_ID              
		     , PAYMENT_NUM                  = isnull(@TEMP_PAYMENT_NUM, PAYMENT_NUM)
		     , PAYMENT_DATE                 = @PAYMENT_DATE                
		     , PAYMENT_TYPE                 = @PAYMENT_TYPE                
		     , CUSTOMER_REFERENCE           = @CUSTOMER_REFERENCE          
		     , EXCHANGE_RATE                = @TEMP_EXCHANGE_RATE          
		     , CURRENCY_ID                  = @CURRENCY_ID                 
		     , AMOUNT                       = @AMOUNT                      
		     , AMOUNT_USDOLLAR              = @AMOUNT_USDOLLAR             
		     , BANK_FEE                     = @BANK_FEE                    
		     , BANK_FEE_USDOLLAR            = @BANK_FEE_USDOLLAR           
		     , CREDIT_CARD_ID               = @CREDIT_CARD_ID              
		     , DESCRIPTION                  = @DESCRIPTION                 
		     , TEAM_ID                      = @TEAM_ID                     
		     , TEAM_SET_ID                  = @TEAM_SET_ID                 
		     , ASSIGNED_SET_ID              = @ASSIGNED_SET_ID             
		 where ID                           = @ID                          ;
	end -- if;

	-- 08/22/2009 Paul.  If insert fails, then the rest will as well. Just display the one error. 
	if @@ERROR = 0 begin -- then
		if not exists(select * from PAYMENTS_CSTM where ID_C = @ID) begin -- then
			insert into PAYMENTS_CSTM ( ID_C ) values ( @ID );
		end -- if;
		
		-- 08/21/2009 Paul.  Add or remove the team relationship records. 
		-- 08/30/2009 Paul.  Instead of using @TEAM_SET_LIST, use the @TEAM_SET_ID to build the module-specific team relationships. 
		-- 08/31/2009 Paul.  Instead of managing a separate teams relationship, we will leverage TEAM_SETS_TEAMS. 
		-- exec dbo.spPAYMENTS_TEAMS_Update @ID, @MODIFIED_USER_ID, @TEAM_SET_ID;
	end -- if;

  end
GO
 
Grant Execute on dbo.spPAYMENTS_Update to public;
GO
 
