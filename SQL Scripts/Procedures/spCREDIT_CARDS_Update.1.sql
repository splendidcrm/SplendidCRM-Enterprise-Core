if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCREDIT_CARDS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCREDIT_CARDS_Update;
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
-- 02/25/2008 Paul.  We need to get the last 4 digits before the card number is encrypted. 
-- 08/16/2015 Paul.  Add CARD_TOKEN for use with PayPal REST API. 
-- 12/16/2015 Paul.  Add EMAIL and PHONE for Authorize.Net. 
Create Procedure dbo.spCREDIT_CARDS_Update
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @ACCOUNT_ID           uniqueidentifier
	, @NAME                 nvarchar(150)
	, @CARD_TYPE            nvarchar( 25)
	, @CARD_NUMBER          nvarchar(100)
	, @CARD_NUMBER_DISPLAY  nvarchar( 10)
	, @SECURITY_CODE        nvarchar( 10)
	, @EXPIRATION_DATE      datetime
	, @BANK_NAME            nvarchar(150)
	, @BANK_ROUTING_NUMBER  nvarchar(100)
	, @IS_PRIMARY           bit
	, @IS_ENCRYPTED         bit
	, @ADDRESS_STREET       nvarchar(150)
	, @ADDRESS_CITY         nvarchar(100)
	, @ADDRESS_STATE        nvarchar(100)
	, @ADDRESS_POSTALCODE   nvarchar( 20)
	, @ADDRESS_COUNTRY      nvarchar(100)
	, @CONTACT_ID           uniqueidentifier = null
	, @CARD_TOKEN           nvarchar( 50) = null
	, @EMAIL                nvarchar(100) = null
	, @PHONE                nvarchar( 25) = null
	)
as
  begin
	set nocount on
	
	if not exists(select * from CREDIT_CARDS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into CREDIT_CARDS
			( ID                  
			, CREATED_BY          
			, DATE_ENTERED        
			, MODIFIED_USER_ID    
			, DATE_MODIFIED       
			, ACCOUNT_ID          
			, CONTACT_ID          
			, NAME                
			, CARD_TYPE           
			, CARD_NUMBER         
			, CARD_NUMBER_DISPLAY 
			, SECURITY_CODE       
			, EXPIRATION_DATE     
			, BANK_NAME           
			, BANK_ROUTING_NUMBER 
			, IS_PRIMARY          
			, IS_ENCRYPTED        
			, ADDRESS_STREET      
			, ADDRESS_CITY        
			, ADDRESS_STATE       
			, ADDRESS_POSTALCODE  
			, ADDRESS_COUNTRY     
			, CARD_TOKEN          
			, EMAIL               
			, PHONE               
			)
		values 	( @ID                  
			, @MODIFIED_USER_ID    
			,  getdate()           
			, @MODIFIED_USER_ID    
			,  getdate()           
			, @ACCOUNT_ID          
			, @CONTACT_ID          
			, @NAME                
			, @CARD_TYPE           
			, @CARD_NUMBER         
			, @CARD_NUMBER_DISPLAY 
			, @SECURITY_CODE       
			, @EXPIRATION_DATE     
			, @BANK_NAME           
			, @BANK_ROUTING_NUMBER 
			, @IS_PRIMARY          
			, @IS_ENCRYPTED        
			, @ADDRESS_STREET      
			, @ADDRESS_CITY        
			, @ADDRESS_STATE       
			, @ADDRESS_POSTALCODE  
			, @ADDRESS_COUNTRY     
			, @CARD_TOKEN          
			, @EMAIL               
			, @PHONE               
			);
	end else begin
		update CREDIT_CARDS
		   set MODIFIED_USER_ID     = @MODIFIED_USER_ID    
		     , DATE_MODIFIED        =  getdate()           
		     , DATE_MODIFIED_UTC    =  getutcdate()        
		     , NAME                 = @NAME                
		     , CARD_TYPE            = @CARD_TYPE           
		     , CARD_NUMBER          = @CARD_NUMBER         
		     , CARD_NUMBER_DISPLAY  = @CARD_NUMBER_DISPLAY 
		     , SECURITY_CODE        = @SECURITY_CODE       
		     , EXPIRATION_DATE      = @EXPIRATION_DATE     
		     , BANK_NAME            = @BANK_NAME           
		     , BANK_ROUTING_NUMBER  = @BANK_ROUTING_NUMBER 
		     , IS_PRIMARY           = @IS_PRIMARY          
		     , IS_ENCRYPTED         = @IS_ENCRYPTED        
		     , ADDRESS_STREET       = @ADDRESS_STREET      
		     , ADDRESS_CITY         = @ADDRESS_CITY        
		     , ADDRESS_STATE        = @ADDRESS_STATE       
		     , ADDRESS_POSTALCODE   = @ADDRESS_POSTALCODE  
		     , ADDRESS_COUNTRY      = @ADDRESS_COUNTRY     
		     , CARD_TOKEN           = @CARD_TOKEN          
		     , EMAIL                = @EMAIL               
		     , PHONE                = @PHONE               
		 where ID                   = @ID                  ;
	end -- if;

	if not exists(select * from CREDIT_CARDS_CSTM where ID_C = @ID) begin -- then
		insert into CREDIT_CARDS_CSTM ( ID_C ) values ( @ID );
	end -- if;
  end
GO
 
Grant Execute on dbo.spCREDIT_CARDS_Update to public;
GO
 
