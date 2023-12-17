if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACCOUNTS_ConvertContact' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACCOUNTS_ConvertContact;
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
Create Procedure dbo.spACCOUNTS_ConvertContact
	( @ID               uniqueidentifier output
	, @MODIFIED_USER_ID uniqueidentifier
	, @CONTACT_ID       uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ACCOUNT_NUMBER nvarchar(30);
	
	if exists(select * from vwCONTACTS_ConvertToAccount where CONTACT_ID = @CONTACT_ID) begin -- then
		if @ACCOUNT_NUMBER is null begin -- then
			exec dbo.spNUMBER_SEQUENCES_Formatted 'ACCOUNTS.ACCOUNT_NUMBER', 1, @ACCOUNT_NUMBER out;
		end -- if;
		set @ID = newid();
		-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
		insert into ACCOUNTS
			( ID                          
			, CREATED_BY                  
			, DATE_ENTERED                
			, MODIFIED_USER_ID            
			, DATE_MODIFIED               
			, DATE_MODIFIED_UTC           
			, ASSIGNED_USER_ID            
			, ACCOUNT_NUMBER              
			, NAME                        
			, ACCOUNT_TYPE                
			, PARENT_ID                   
			, INDUSTRY                    
			, ANNUAL_REVENUE              
			, PHONE_FAX                   
			, BILLING_ADDRESS_STREET      
			, BILLING_ADDRESS_CITY        
			, BILLING_ADDRESS_STATE       
			, BILLING_ADDRESS_POSTALCODE  
			, BILLING_ADDRESS_COUNTRY     
			, DESCRIPTION                 
			, RATING                      
			, PHONE_OFFICE                
			, PHONE_ALTERNATE             
			, EMAIL1                      
			, EMAIL2                      
			, WEBSITE                     
			, OWNERSHIP                   
			, EMPLOYEES                   
			, SIC_CODE                    
			, TICKER_SYMBOL               
			, SHIPPING_ADDRESS_STREET     
			, SHIPPING_ADDRESS_CITY       
			, SHIPPING_ADDRESS_STATE      
			, SHIPPING_ADDRESS_POSTALCODE 
			, SHIPPING_ADDRESS_COUNTRY    
			, TEAM_ID                     
			, TEAM_SET_ID                 
			, ASSIGNED_SET_ID             
			)
		select	  @ID                         
			, @MODIFIED_USER_ID           
			,  getdate()                  
			, @MODIFIED_USER_ID           
			,  getdate()                  
			,  getutcdate()               
			, ASSIGNED_USER_ID            
			, @ACCOUNT_NUMBER             
			, NAME                        
			, ACCOUNT_TYPE                
			, PARENT_ID                   
			, INDUSTRY                    
			, ANNUAL_REVENUE              
			, PHONE_FAX                   
			, BILLING_ADDRESS_STREET      
			, BILLING_ADDRESS_CITY        
			, BILLING_ADDRESS_STATE       
			, BILLING_ADDRESS_POSTALCODE  
			, BILLING_ADDRESS_COUNTRY     
			, DESCRIPTION                 
			, RATING                      
			, PHONE_OFFICE                
			, PHONE_ALTERNATE             
			, EMAIL1                      
			, EMAIL2                      
			, WEBSITE                     
			, OWNERSHIP                   
			, EMPLOYEES                   
			, SIC_CODE                    
			, TICKER_SYMBOL               
			, SHIPPING_ADDRESS_STREET     
			, SHIPPING_ADDRESS_CITY       
			, SHIPPING_ADDRESS_STATE      
			, SHIPPING_ADDRESS_POSTALCODE 
			, SHIPPING_ADDRESS_COUNTRY    
			, TEAM_ID                     
			, TEAM_SET_ID                 
			, ASSIGNED_SET_ID            
		  from vwCONTACTS_ConvertToAccount
		 where CONTACT_ID = @CONTACT_ID;

		if not exists(select * from ACCOUNTS_CSTM where ID_C = @ID) begin -- then
			insert into ACCOUNTS_CSTM ( ID_C ) values ( @ID );
		end -- if;

		exec dbo.spACCOUNTS_CONTACTS_Update @MODIFIED_USER_ID, @ID, @CONTACT_ID;
	end -- if;
  end
GO
 
Grant Execute on dbo.spACCOUNTS_ConvertContact to public;
GO
 
