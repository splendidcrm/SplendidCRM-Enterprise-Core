if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTEAMS_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTEAMS_InsertOnly;
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
-- 11/18/2006 Paul.  This procedure will be used to create the Global team which will have a hard-coded ID. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 04/28/2016 Paul.  Make sure that the custom field table exists. 
-- 04/28/2016 Paul.  PRIVATE flag should not be null. 
-- 07/24/2019 Paul.  Prevent duplicates. 
Create Procedure dbo.spTEAMS_InsertOnly
	( @ID                uniqueidentifier
	, @NAME              nvarchar(128)
	, @DESCRIPTION       nvarchar(max)
	)
as
  begin
	set nocount on
	
	if dbo.fnTEAMS_IsValidName(@ID, @NAME) = 0 begin -- then
		raiserror(N'spTEAMS_InsertOnly: The name %s already exists.  Duplicate names are not allowed. ', 16, 1, @NAME);
	end else begin
		if not exists(select * from TEAMS where ID = @ID) begin -- then
			if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
				set @ID = newid();
			end -- if;
			insert into TEAMS
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, NAME             
				, DESCRIPTION      
				, PRIVATE          
				)
			values 	( @ID               
				, null       
				,  getdate()        
				, null 
				,  getdate()        
				, @NAME             
				, @DESCRIPTION      
				, 0                 
				);
			-- 04/28/2016 Paul.  Make sure that the custom field table exists. 
			if @@ERROR = 0 begin -- then
				if not exists(select * from TEAMS_CSTM where ID_C = @ID) begin -- then
					insert into TEAMS_CSTM ( ID_C ) values ( @ID );
				end -- if;
			end -- if;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spTEAMS_InsertOnly to public;
GO

