if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPAYMENTS_TRANSACTIONS_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPAYMENTS_TRANSACTIONS_InsertOnly;
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 12/12/2015 Paul.  Need to increase PAYMENT_GATEWAY to allow for combined Gateway and Login. 
Create Procedure dbo.spPAYMENTS_TRANSACTIONS_InsertOnly
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @PAYMENT_ID           uniqueidentifier
	, @PAYMENT_GATEWAY      nvarchar(100)
	, @TRANSACTION_TYPE     nvarchar(25)
	, @AMOUNT               money
	, @CURRENCY_ID          uniqueidentifier
	, @INVOICE_NUMBER       nvarchar(400)
	, @DESCRIPTION          nvarchar(max)
	, @CREDIT_CARD_ID       uniqueidentifier
	, @ACCOUNT_ID           uniqueidentifier
	, @STATUS               nvarchar(25)
	)
as
  begin
	set nocount on

	declare @CARD_NAME            nvarchar(150);
	declare @CARD_TYPE            nvarchar( 25);
	declare @CARD_NUMBER_DISPLAY  nvarchar( 10);
	declare @BANK_NAME            nvarchar(150);
	declare @ADDRESS_STREET       nvarchar(150);
	declare @ADDRESS_CITY         nvarchar(100);
	declare @ADDRESS_STATE        nvarchar(100);
	declare @ADDRESS_POSTALCODE   nvarchar( 20);
	declare @ADDRESS_COUNTRY      nvarchar(100);
	declare @EMAIL                nvarchar(100);
	declare @PHONE                nvarchar( 25);

	select @CARD_NAME           = NAME
	     , @CARD_TYPE           = CARD_TYPE
	     , @CARD_NUMBER_DISPLAY = CARD_NUMBER_DISPLAY
	     , @BANK_NAME           = BANK_NAME
	     , @ADDRESS_STREET      = ADDRESS_STREET
	     , @ADDRESS_CITY        = ADDRESS_CITY
	     , @ADDRESS_STATE       = ADDRESS_STATE
	     , @ADDRESS_POSTALCODE  = ADDRESS_POSTALCODE
	     , @ADDRESS_COUNTRY     = ADDRESS_COUNTRY
	  from vwCREDIT_CARDS
	 where ID                   = @CREDIT_CARD_ID;
	
	select @EMAIL               = EMAIL1
	     , @PHONE               = PHONE
	  from vwACCOUNTS
	 where ID                   = @ACCOUNT_ID;
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
	end -- if;
	insert into PAYMENTS_TRANSACTIONS
		( ID                  
		, CREATED_BY          
		, DATE_ENTERED        
		, MODIFIED_USER_ID    
		, DATE_MODIFIED       
		, PAYMENT_ID          
		, PAYMENT_GATEWAY     
		, TRANSACTION_TYPE    
		, AMOUNT              
		, CURRENCY_ID         
		, INVOICE_NUMBER      
		, DESCRIPTION         
		, CREDIT_CARD_ID      
		, CARD_NAME           
		, CARD_TYPE           
		, CARD_NUMBER_DISPLAY 
		, BANK_NAME           
		, ACCOUNT_ID          
		, ADDRESS_STREET      
		, ADDRESS_CITY        
		, ADDRESS_STATE       
		, ADDRESS_POSTALCODE  
		, ADDRESS_COUNTRY     
		, EMAIL               
		, PHONE               
		, STATUS              
		)
	values 	( @ID                  
		, @MODIFIED_USER_ID          
		,  getdate()           
		, @MODIFIED_USER_ID    
		,  getdate()           
		, @PAYMENT_ID          
		, @PAYMENT_GATEWAY     
		, @TRANSACTION_TYPE    
		, @AMOUNT              
		, @CURRENCY_ID         
		, @INVOICE_NUMBER      
		, @DESCRIPTION         
		, @CREDIT_CARD_ID      
		, @CARD_NAME           
		, @CARD_TYPE           
		, @CARD_NUMBER_DISPLAY 
		, @BANK_NAME           
		, @ACCOUNT_ID          
		, @ADDRESS_STREET      
		, @ADDRESS_CITY        
		, @ADDRESS_STATE       
		, @ADDRESS_POSTALCODE  
		, @ADDRESS_COUNTRY     
		, @EMAIL               
		, @PHONE               
		, @STATUS              
		);
  end
GO

Grant Execute on dbo.spPAYMENTS_TRANSACTIONS_InsertOnly to public;
GO

