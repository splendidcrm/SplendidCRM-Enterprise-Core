if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACCOUNTS_New' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACCOUNTS_New;
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
-- 06/20/2009 Paul.  We need to get and assign the default team otherwise the new record 
-- will not be displayed if the Team Required flag is set. 
-- 07/26/2009 Paul.  Enough customers requested ACCOUNT_NUMBER that it makes sense to add it now. 
-- 11/28/2009 Paul.  Add UTC date. 
-- 01/14/2010 Paul.  Add support for Team Sets. 
-- 01/16/2012 Paul.  Assigned User ID and Team ID are now parameters. 
-- 07/05/2012 Paul.  Create normalized and indexed phone fields for fast call center lookups. 
-- 11/24/2017 Paul.  Provide a way to format phone numbers.  
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spACCOUNTS_New
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(150)
	, @PHONE_OFFICE      nvarchar(25)
	, @WEBSITE           nvarchar(255)
	, @ASSIGNED_USER_ID  uniqueidentifier = null
	, @TEAM_ID           uniqueidentifier = null
	, @TEAM_SET_LIST     varchar(8000) = null
	, @ASSIGNED_SET_LIST varchar(8000) = null
	)
as
  begin
	set nocount on

	declare @TEAM_SET_ID         uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;
	declare @TEMP_ACCOUNT_NUMBER nvarchar(30);
	-- 11/24/2017 Paul.  Provide a way to format phone numbers.  
	declare @TEMP_PHONE_OFFICE   nvarchar(25);
	set @TEMP_PHONE_OFFICE = dbo.fnFormatPhone(@PHONE_OFFICE);
	
	-- 01/16/2012 Paul.  Normalize the team set by placing the primary ID first, then order list by ID and the name by team names. 
	-- 01/16/2012 Paul.  Use a team set so that team name changes can propagate. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;

	exec dbo.spNUMBER_SEQUENCES_Formatted 'ACCOUNTS.ACCOUNT_NUMBER', 1, @TEMP_ACCOUNT_NUMBER out;

	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
	end -- if;
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
		, PHONE_OFFICE                
		, WEBSITE                     
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
		, @TEMP_ACCOUNT_NUMBER         
		, @NAME                        
		, @TEMP_PHONE_OFFICE           
		, @WEBSITE                     
		, @TEAM_ID                     
		, @TEAM_SET_ID                 
		, @ASSIGNED_SET_ID             
		);

	-- 03/04/2006 Paul.  Add record to custom table. 
	if not exists(select * from ACCOUNTS_CSTM where ID_C = @ID) begin -- then
		insert into ACCOUNTS_CSTM ( ID_C ) values ( @ID );
	end -- if;

	-- 07/05/2012 Paul.  Create normalized and indexed phone fields for fast call center lookups. 
	if @@ERROR = 0 begin -- then
		exec dbo.spPHONE_NUMBERS_Update @MODIFIED_USER_ID, @ID, N'Accounts', N'Office'   , @PHONE_OFFICE;
	end -- if;
  end
GO

Grant Execute on dbo.spACCOUNTS_New to public;
GO

