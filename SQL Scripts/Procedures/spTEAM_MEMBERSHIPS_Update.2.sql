if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTEAM_MEMBERSHIPS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTEAM_MEMBERSHIPS_Update;
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
Create Procedure dbo.spTEAM_MEMBERSHIPS_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @TEAM_ID           uniqueidentifier
	, @USER_ID           uniqueidentifier
	, @EXPLICIT_ASSIGN   bit
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	declare @IMPLICIT_ASSIGN bit;
	if @EXPLICIT_ASSIGN = 0 begin -- then
		set @IMPLICIT_ASSIGN = 1;
	end else begin
		set @IMPLICIT_ASSIGN = 0;
	end -- if;

	-- BEGIN Oracle Exception
		select @ID = ID
		  from TEAM_MEMBERSHIPS
		 where TEAM_ID        = @TEAM_ID
		   and USER_ID        = @USER_ID
		   and DELETED        = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into TEAM_MEMBERSHIPS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, TEAM_ID          
			, USER_ID          
			, EXPLICIT_ASSIGN  
			, IMPLICIT_ASSIGN  
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @TEAM_ID          
			, @USER_ID          
			, @EXPLICIT_ASSIGN  
			, @IMPLICIT_ASSIGN  
			);
	end else begin
		update TEAM_MEMBERSHIPS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , EXPLICIT_ASSIGN   = @EXPLICIT_ASSIGN  
		     , IMPLICIT_ASSIGN   = @IMPLICIT_ASSIGN  
		 where ID                = @ID               ;
	end -- if;

	-- 11/18/2006 Paul.  Refresh all the implicit assignments any time a member is added or updated. 
	-- Just make sure not to use spTEAM_MEMBERSHIPS_Update inside spTEAM_MEMBERSHIPS_UpdateImplicit. 
	-- The Global team and Private Teams work the same way, so no special coding is necessary. 
	if @EXPLICIT_ASSIGN = 1 begin -- then
		exec dbo.spTEAM_MEMBERSHIPS_UpdateImplicit @MODIFIED_USER_ID, @TEAM_ID;
	end -- if;
  end
GO
 
Grant Execute on dbo.spTEAM_MEMBERSHIPS_Update to public;
GO
 
