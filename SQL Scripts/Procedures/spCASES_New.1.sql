if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCASES_New' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCASES_New;
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
-- 07/25/2009 Paul.  CASE_NUMBER is no longer an identity and must be formatted. 
-- 11/28/2009 Paul.  Add UTC date. 
-- 01/14/2010 Paul.  Add support for Team Sets. 
-- 01/16/2012 Paul.  Assigned User ID and Team ID are now parameters. 
-- 05/01/2013 Paul.  Add Contacts field to support B2C. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spCASES_New
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(150)
	, @ACCOUNT_NAME      nvarchar(100)
	, @ACCOUNT_ID        uniqueidentifier
	, @ASSIGNED_USER_ID  uniqueidentifier = null
	, @TEAM_ID           uniqueidentifier = null
	, @TEAM_SET_LIST     varchar(8000) = null
	, @B2C_CONTACT_ID    uniqueidentifier = null
	, @ASSIGNED_SET_LIST varchar(8000) = null
	)
as
  begin
	set nocount on
	
	declare @TEAM_SET_ID         uniqueidentifier;
	declare @ASSIGNED_SET_ID     uniqueidentifier;
	declare @TEMP_CASE_NUMBER nvarchar(30);

	-- 01/16/2012 Paul.  Normalize the team set by placing the primary ID first, then order list by ID and the name by team names. 
	-- 01/16/2012 Paul.  Use a team set so that team name changes can propagate. 
	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, @TEAM_SET_LIST;
	-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;

	exec dbo.spNUMBER_SEQUENCES_Formatted 'CASES.CASE_NUMBER', 1, @TEMP_CASE_NUMBER out;
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
	end -- if;
	insert into CASES
		( ID               
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, DATE_MODIFIED_UTC
		, ASSIGNED_USER_ID 
		, CASE_NUMBER      
		, NAME             
		, ACCOUNT_NAME     
		, ACCOUNT_ID       
		, B2C_CONTACT_ID   
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
		, @TEMP_CASE_NUMBER
		, @NAME            
		, @ACCOUNT_NAME    
		, @ACCOUNT_ID      
		, @B2C_CONTACT_ID  
		, @TEAM_ID         
		, @TEAM_SET_ID     
		, @ASSIGNED_SET_ID 
		);

	-- 03/04/2006 Paul.  Add record to custom table. 
	if not exists(select * from CASES_CSTM where ID_C = @ID) begin -- then
		insert into CASES_CSTM ( ID_C ) values ( @ID );
	end -- if;

  end
GO

Grant Execute on dbo.spCASES_New to public;
GO

