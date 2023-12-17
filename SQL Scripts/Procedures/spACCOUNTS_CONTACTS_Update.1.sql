if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACCOUNTS_CONTACTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACCOUNTS_CONTACTS_Update;
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
-- 02/19/2008 Paul.  Move relationship management to spACCOUNTS_CONTACTS_Update. 
-- There should only be one active relationship, but don't update if nothing changed. 
-- 08/26/2008 Paul.  When @ACCOUNT_ID is null, we will clear the existing relationship. 
-- Make sure that this procedure gets called from spCONTACTS_Update. 
-- 02/19/2008 Paul.  Now that we are using triggers, we need to minimize unnecessary updates.
-- 11/13/2009 Paul.  Remove the unnecessary update as it will reduce offline client conflicts. 
-- 02/15/2011 Paul.  Duplicate records may have been created.  Use spACCOUNTS_CONTACTS_Update to remove duplicate records. 
Create Procedure dbo.spACCOUNTS_CONTACTS_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @ACCOUNT_ID        uniqueidentifier
	, @CONTACT_ID        uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	declare @COUNT int;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from ACCOUNTS_CONTACTS
		 where CONTACT_ID        = @CONTACT_ID
		   and ACCOUNT_ID        = @ACCOUNT_ID
		   and DELETED           = 0;
	-- END Oracle Exception

	-- 02/15/2011 Paul.  If a relationship exists, check and see if there are multiple account assignments. 
	if dbo.fnIsEmptyGuid(@ID) = 0 begin -- then
		-- BEGIN Oracle Exception
			select @COUNT = count(*)
			  from ACCOUNTS_CONTACTS
			 where CONTACT_ID        = @CONTACT_ID
			   and DELETED           = 0;
		-- END Oracle Exception
		if @COUNT > 1 begin -- then
			set @ID = null;
		end -- if;
	end -- if;

	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		-- 02/19/2008 Paul.  A contact can only have one account, so delete if any others exist. 
		if exists(select * from ACCOUNTS_CONTACTS where DELETED = 0 and CONTACT_ID = @CONTACT_ID) begin -- then
			update ACCOUNTS_CONTACTS
			   set DELETED          = 1
			     , MODIFIED_USER_ID = @MODIFIED_USER_ID
			     , DATE_MODIFIED    =  getdate()       
			     , DATE_MODIFIED_UTC=  getutcdate()    
			 where DELETED          = 0
			   and CONTACT_ID       = @CONTACT_ID;
		end -- if;
		-- 08/26/2008 Paul.  Only insert account if it exists. 
		if dbo.fnIsEmptyGuid(@ACCOUNT_ID) = 0 begin -- then
			set @ID = newid();
			insert into ACCOUNTS_CONTACTS
				( ID               
				, CREATED_BY       
				, DATE_ENTERED     
				, MODIFIED_USER_ID 
				, DATE_MODIFIED    
				, CONTACT_ID       
				, ACCOUNT_ID       
				)
			values
				( @ID               
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @MODIFIED_USER_ID 
				,  getdate()        
				, @CONTACT_ID       
				, @ACCOUNT_ID       
				);
		end -- if;
	end -- if;
  end
GO
 
Grant Execute on dbo.spACCOUNTS_CONTACTS_Update to public;
GO
 
