if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCONTRACTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCONTRACTS_Update;
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
-- 11/10/2006 Paul.  OPPORTUNITY_ID is stored in a separate relationship table. 
-- 11/30/2007 Paul.  The type was changed to a GUID. 
-- 12/29/2007 Paul.  Add TEAM_ID so that it is not updated separately. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 08/23/2009 Paul.  Decrease set list so that index plus ID will be less than 900 bytes. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 04/03/2012 Paul.  When the name changes, update the favorites table. 
-- 05/01/2013 Paul.  Add Contacts field to support B2C. 
-- 05/12/2016 Paul.  Add Tags module. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spCONTRACTS_Update
	( @ID                   uniqueidentifier output
	, @MODIFIED_USER_ID     uniqueidentifier
	, @ASSIGNED_USER_ID     uniqueidentifier
	, @NAME                 nvarchar(255)
	, @REFERENCE_CODE       nvarchar(255)
	, @STATUS               nvarchar(25)
	, @TYPE_ID              uniqueidentifier
	, @ACCOUNT_ID           uniqueidentifier
	, @OPPORTUNITY_ID       uniqueidentifier
	, @START_DATE           datetime
	, @END_DATE             datetime
	, @COMPANY_SIGNED_DATE  datetime
	, @CUSTOMER_SIGNED_DATE datetime
	, @EXPIRATION_NOTICE    datetime
	, @CURRENCY_ID          uniqueidentifier
	, @TOTAL_CONTRACT_VALUE money
	, @DESCRIPTION          nvarchar(max)
	, @TEAM_ID              uniqueidentifier = null
	, @TEAM_SET_LIST        varchar(8000) = null
	, @B2C_CONTACT_ID       uniqueidentifier = null
	, @TAG_SET_NAME         nvarchar(4000) = null
	, @ASSIGNED_SET_LIST    varchar(8000) = null
	)
as
  begin
	set nocount on
	
	-- 06/03/2005 Paul.  Convert currency to USD. 
	declare @TOTAL_CONTRACT_VALUE_USDOLLAR money;
	declare @TEAM_SET_ID                   uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;
	set @TOTAL_CONTRACT_VALUE_USDOLLAR = @TOTAL_CONTRACT_VALUE;
	-- 09/18/2008 Paul.  Catch Oracle no-data exception. 
	-- BEGIN Oracle Exception
		select @TOTAL_CONTRACT_VALUE_USDOLLAR = @TOTAL_CONTRACT_VALUE / CONVERSION_RATE
		  from CURRENCIES
		 where ID = @CURRENCY_ID;
	-- END Oracle Exception

	-- 08/22/2009 Paul.  Normalize the team set by placing the primary ID first, then order list by ID and the name by team names. 
	-- 08/23/2009 Paul.  Use a team set so that team name changes can propagate. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;

	if not exists(select * from CONTRACTS where ID = @ID) begin -- then
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
		end -- if;
		insert into CONTRACTS
			( ID                            
			, CREATED_BY                    
			, DATE_ENTERED                  
			, MODIFIED_USER_ID              
			, DATE_MODIFIED                 
			, DATE_MODIFIED_UTC             
			, ASSIGNED_USER_ID              
			, NAME                          
			, REFERENCE_CODE                
			, STATUS                        
			, TYPE_ID                       
			, ACCOUNT_ID                    
			, B2C_CONTACT_ID                
			, START_DATE                    
			, END_DATE                      
			, COMPANY_SIGNED_DATE           
			, CUSTOMER_SIGNED_DATE          
			, EXPIRATION_NOTICE             
			, CURRENCY_ID                   
			, TOTAL_CONTRACT_VALUE          
			, TOTAL_CONTRACT_VALUE_USDOLLAR 
			, DESCRIPTION                   
			, TEAM_ID                       
			, TEAM_SET_ID                   
			, ASSIGNED_SET_ID               
			)
		values 	( @ID                            
			, @MODIFIED_USER_ID              
			,  getdate()                     
			, @MODIFIED_USER_ID              
			,  getdate()                     
			,  getutcdate()                  
			, @ASSIGNED_USER_ID              
			, @NAME                          
			, @REFERENCE_CODE                
			, @STATUS                        
			, @TYPE_ID                       
			, @ACCOUNT_ID                    
			, @B2C_CONTACT_ID                
			, @START_DATE                    
			, @END_DATE                      
			, @COMPANY_SIGNED_DATE           
			, @CUSTOMER_SIGNED_DATE          
			, @EXPIRATION_NOTICE             
			, @CURRENCY_ID                   
			, @TOTAL_CONTRACT_VALUE          
			, @TOTAL_CONTRACT_VALUE_USDOLLAR 
			, @DESCRIPTION                   
			, @TEAM_ID                       
			, @TEAM_SET_ID                   
			, @ASSIGNED_SET_ID               
			);
	end else begin
		update CONTRACTS
		   set MODIFIED_USER_ID               = @MODIFIED_USER_ID              
		     , DATE_MODIFIED                  =  getdate()                     
		     , DATE_MODIFIED_UTC              =  getutcdate()                  
		     , ASSIGNED_USER_ID               = @ASSIGNED_USER_ID              
		     , NAME                           = @NAME                          
		     , REFERENCE_CODE                 = @REFERENCE_CODE                
		     , STATUS                         = @STATUS                        
		     , TYPE_ID                        = @TYPE_ID                       
		     , ACCOUNT_ID                     = @ACCOUNT_ID                    
		     , B2C_CONTACT_ID                 = @B2C_CONTACT_ID                
		     , START_DATE                     = @START_DATE                    
		     , END_DATE                       = @END_DATE                      
		     , COMPANY_SIGNED_DATE            = @COMPANY_SIGNED_DATE           
		     , CUSTOMER_SIGNED_DATE           = @CUSTOMER_SIGNED_DATE          
		     , EXPIRATION_NOTICE              = @EXPIRATION_NOTICE             
		     , CURRENCY_ID                    = @CURRENCY_ID                   
		     , TOTAL_CONTRACT_VALUE           = @TOTAL_CONTRACT_VALUE          
		     , TOTAL_CONTRACT_VALUE_USDOLLAR  = @TOTAL_CONTRACT_VALUE_USDOLLAR 
		     , DESCRIPTION                    = @DESCRIPTION                   
		     , TEAM_ID                        = @TEAM_ID                       
		     , TEAM_SET_ID                    = @TEAM_SET_ID                   
		     , ASSIGNED_SET_ID                = @ASSIGNED_SET_ID               
		 where ID                             = @ID                            ;

		-- BEGIN Oracle Exception
			update CONTRACTS_OPPORTUNITIES
			   set DELETED          = 1
			     , DATE_MODIFIED    = getdate()
			     , DATE_MODIFIED_UTC= getutcdate()
			     , MODIFIED_USER_ID = @MODIFIED_USER_ID
			 where CONTRACT_ID      = @ID
			   and DELETED          = 0;
		-- END Oracle Exception
		
		-- 04/03/2012 Paul.  When the name changes, update the favorites table. 
		exec dbo.spSUGARFAVORITES_UpdateName @MODIFIED_USER_ID, @ID, @NAME;
	end -- if;

	-- 08/22/2009 Paul.  If insert fails, then the rest will as well. Just display the one error. 
	if @@ERROR = 0 begin -- then
		if not exists(select * from CONTRACTS_CSTM where ID_C = @ID) begin -- then
			insert into CONTRACTS_CSTM ( ID_C ) values ( @ID );
		end -- if;
		
		-- 08/21/2009 Paul.  Add or remove the team relationship records. 
		-- 08/30/2009 Paul.  Instead of using @TEAM_SET_LIST, use the @TEAM_SET_ID to build the module-specific team relationships. 
		-- 08/31/2009 Paul.  Instead of managing a separate teams relationship, we will leverage TEAM_SETS_TEAMS. 
		-- exec dbo.spCONTRACTS_TEAMS_Update @ID, @MODIFIED_USER_ID, @TEAM_SET_ID;
		
		if dbo.fnIsEmptyGuid(@OPPORTUNITY_ID) = 0 begin -- then
			exec dbo.spCONTRACTS_OPPORTUNITIES_Update @MODIFIED_USER_ID, @ID, @OPPORTUNITY_ID;
		end -- if;
	end -- if;
	-- 05/12/2016 Paul.  Add Tags module. Must add after @ID is set. 
	if @@ERROR = 0 begin -- then
		exec dbo.spTAG_SETS_NormalizeSet @MODIFIED_USER_ID, @ID, N'Contracts', @TAG_SET_NAME;
	end -- if;
  end
GO
 
Grant Execute on dbo.spCONTRACTS_Update to public;
GO
 
