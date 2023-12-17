if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTAX_RATES_ChangeOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTAX_RATES_ChangeOnly;
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
-- 02/24/2015 Paul.  Add state for lookup. 
-- 04/07/2016 Paul.  Tax rates per team. 
Create Procedure dbo.spTAX_RATES_ChangeOnly
	( @ID                    uniqueidentifier output
	, @MODIFIED_USER_ID      uniqueidentifier
	, @NAME                  nvarchar(50)
	, @VALUE                 money
	, @DESCRIPTION           nvarchar(max)
	, @ADDRESS_STATE         nvarchar(100) = null
	, @TEAM_ID               uniqueidentifier = null
	, @TEAM_SET_LIST         varchar(8000) = null
	)
as
  begin
	set nocount on

	-- 04/07/2016 Paul.  Tax rates per team. 
	declare @TEAM_SET_ID           uniqueidentifier;
	declare @OLD_VALUE             money;
	declare @STATUS                nvarchar(25);
	declare @LIST_ORDER            int;
	declare @QUICKBOOKS_TAX_VENDOR nvarchar(50);
	set @STATUS = N'Active';

	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;

	if exists(select * from TAX_RATES where NAME = @NAME and STATUS = N'Active' and DELETED = 0) begin -- then
		select top 1 @OLD_VALUE = VALUE
		     , @LIST_ORDER = LIST_ORDER
		     , @QUICKBOOKS_TAX_VENDOR = QUICKBOOKS_TAX_VENDOR
		  from TAX_RATES
		 where NAME    = @NAME
		   and STATUS  = N'Active'
		   and DELETED = 0;

		if @OLD_VALUE <> @VALUE begin -- then
			update TAX_RATES
			   set STATUS            = N'Inactive'
			     , MODIFIED_USER_ID  = @MODIFIED_USER_ID
			     , DATE_MODIFIED     =  getdate()
			     , DATE_MODIFIED_UTC =  getutcdate()
			 where NAME              = @NAME
			   and STATUS            = N'Active'
			   and DELETED           = 0;

			set @ID = newid();
			insert into TAX_RATES
				( ID                   
				, CREATED_BY           
				, DATE_ENTERED         
				, MODIFIED_USER_ID     
				, DATE_MODIFIED        
				, NAME                 
				, STATUS               
				, VALUE                
				, LIST_ORDER           
				, QUICKBOOKS_TAX_VENDOR
				, DESCRIPTION          
				, ADDRESS_STATE        
				, TEAM_ID              
				, TEAM_SET_ID          
				)
			values 	( @ID                   
				, @MODIFIED_USER_ID     
				,  getdate()            
				, @MODIFIED_USER_ID     
				,  getdate()            
				, @NAME                 
				, @STATUS               
				, @VALUE                
				, @LIST_ORDER           
				, @QUICKBOOKS_TAX_VENDOR
				, @DESCRIPTION          
				, @ADDRESS_STATE        
				, @TEAM_ID              
				, @TEAM_SET_ID          
				);
		end -- if;
	end else begin
		-- BEGIN Oracle Exception
			select @LIST_ORDER = isnull(max(LIST_ORDER) + 1, 0)
			  from vwTAX_RATES;
		-- END Oracle Exception
		set @ID = newid();
		insert into TAX_RATES
			( ID                   
			, CREATED_BY           
			, DATE_ENTERED         
			, MODIFIED_USER_ID     
			, DATE_MODIFIED        
			, NAME                 
			, STATUS               
			, VALUE                
			, LIST_ORDER           
			, QUICKBOOKS_TAX_VENDOR
			, DESCRIPTION          
			, ADDRESS_STATE        
			, TEAM_ID              
			, TEAM_SET_ID          
			)
		values 	( @ID                   
			, @MODIFIED_USER_ID     
			,  getdate()            
			, @MODIFIED_USER_ID     
			,  getdate()            
			, @NAME                 
			, @STATUS               
			, @VALUE                
			, @LIST_ORDER           
			, @QUICKBOOKS_TAX_VENDOR
			, @DESCRIPTION          
			, @ADDRESS_STATE        
			, @TEAM_ID              
			, @TEAM_SET_ID          
			);
	end -- if;



	if @LIST_ORDER is null begin -- then
		-- BEGIN Oracle Exception
			select @LIST_ORDER = isnull(max(LIST_ORDER) + 1, 0)
			  from vwTAX_RATES;
		-- END Oracle Exception
	end -- if;
  end
GO

Grant Execute on dbo.spTAX_RATES_ChangeOnly to public;
GO

