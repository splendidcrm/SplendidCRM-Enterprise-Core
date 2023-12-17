if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPROJECT_RELATION_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPROJECT_RELATION_Update;
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
-- 11/13/2009 Paul.  Remove the unnecessary update as it will reduce offline client conflicts. 
-- 09/08/2012 Paul.  Project Relations data for Accounts, Bugs, Cases, Contacts, Opportunities and Quotes moved to separate tables. 
Create Procedure dbo.spPROJECT_RELATION_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @PROJECT_ID        uniqueidentifier
	, @RELATION_TYPE     nvarchar(25)
	, @RELATION_ID       uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	-- 11/13/2005 Paul.  Project tasks store their relationship in the PARENT_ID field. 
	if @RELATION_TYPE = N'ProjectTask' begin -- then
		update PROJECT_TASK
		   set PARENT_ID         = @ID               
		     , MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		 where ID                = @RELATION_ID
		   and DELETED           = 0;
	end else if @RELATION_TYPE = N'Accounts' begin -- then
		-- BEGIN Oracle Exception
			select @ID = ID
			  from PROJECTS_ACCOUNTS
			 where PROJECT_ID        = @PROJECT_ID
			   and ACCOUNT_ID        = @RELATION_ID
			   and DELETED           = 0;
		-- END Oracle Exception
		
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
			insert into PROJECTS_ACCOUNTS
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, PROJECT_ID       
				, ACCOUNT_ID       
				)
			values
				( @ID               
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @PROJECT_ID       
				, @RELATION_ID      
				);
		end -- if;
	end else if @RELATION_TYPE = N'Bugs' begin -- then
		-- BEGIN Oracle Exception
			select @ID = ID
			  from PROJECTS_BUGS
			 where PROJECT_ID        = @PROJECT_ID
			   and BUG_ID            = @RELATION_ID
			   and DELETED           = 0;
		-- END Oracle Exception
		
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
			insert into PROJECTS_BUGS
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, PROJECT_ID       
				, BUG_ID           
				)
			values
				( @ID               
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @PROJECT_ID       
				, @RELATION_ID      
				);
		end -- if;
	end else if @RELATION_TYPE = N'Cases' begin -- then
		-- BEGIN Oracle Exception
			select @ID = ID
			  from PROJECTS_CASES
			 where PROJECT_ID        = @PROJECT_ID
			   and CASE_ID           = @RELATION_ID
			   and DELETED           = 0;
		-- END Oracle Exception
		
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
			insert into PROJECTS_CASES
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, PROJECT_ID       
				, CASE_ID          
				)
			values
				( @ID               
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @PROJECT_ID       
				, @RELATION_ID      
				);
		end -- if;
	end else if @RELATION_TYPE = N'Contacts' begin -- then
		-- BEGIN Oracle Exception
			select @ID = ID
			  from PROJECTS_CONTACTS
			 where PROJECT_ID        = @PROJECT_ID
			   and CONTACT_ID        = @RELATION_ID
			   and DELETED           = 0;
		-- END Oracle Exception
		
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
			insert into PROJECTS_CONTACTS
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, PROJECT_ID       
				, CONTACT_ID       
				)
			values
				( @ID               
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @PROJECT_ID       
				, @RELATION_ID      
				);
		end -- if;
	end else if @RELATION_TYPE = N'Opportunities' begin -- then
		-- BEGIN Oracle Exception
			select @ID = ID
			  from PROJECTS_OPPORTUNITIES
			 where PROJECT_ID        = @PROJECT_ID
			   and OPPORTUNITY_ID    = @RELATION_ID
			   and DELETED           = 0;
		-- END Oracle Exception
		
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
			insert into PROJECTS_OPPORTUNITIES
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, PROJECT_ID       
				, OPPORTUNITY_ID   
				)
			values
				( @ID               
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @PROJECT_ID       
				, @RELATION_ID      
				);
		end -- if;
	end else if @RELATION_TYPE = N'Quotes' begin -- then
		-- BEGIN Oracle Exception
			select @ID = ID
			  from PROJECTS_QUOTES
			 where PROJECT_ID        = @PROJECT_ID
			   and QUOTE_ID          = @RELATION_ID
			   and DELETED           = 0;
		-- END Oracle Exception
		
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
			insert into PROJECTS_QUOTES
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, PROJECT_ID       
				, QUOTE_ID         
				)
			values
				( @ID               
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @PROJECT_ID       
				, @RELATION_ID      
				);
		end -- if;
	end else begin
		-- BEGIN Oracle Exception
			select @ID = ID
			  from PROJECT_RELATION
			 where PROJECT_ID        = @PROJECT_ID
			   and RELATION_ID       = @RELATION_ID
			   and DELETED           = 0;
		-- END Oracle Exception
		
		if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
			set @ID = newid();
			insert into PROJECT_RELATION
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, PROJECT_ID       
				, RELATION_TYPE    
				, RELATION_ID      
				)
			values
				( @ID               
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @PROJECT_ID       
				, @RELATION_TYPE    
				, @RELATION_ID      
				);
		end -- if;
	end -- if;
  end
GO
 
Grant Execute on dbo.spPROJECT_RELATION_Update to public;
GO
 
