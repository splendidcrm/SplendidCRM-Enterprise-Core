if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spOPPORTUNITIES_CONTACTS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spOPPORTUNITIES_CONTACTS_Update;
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
Create Procedure dbo.spOPPORTUNITIES_CONTACTS_Update
	( @MODIFIED_USER_ID  uniqueidentifier
	, @OPPORTUNITY_ID    uniqueidentifier
	, @CONTACT_ID        uniqueidentifier
	, @CONTACT_ROLE      nvarchar(50)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @ID = ID
		  from OPPORTUNITIES_CONTACTS
		 where CONTACT_ID        = @CONTACT_ID
		   and OPPORTUNITY_ID    = @OPPORTUNITY_ID
		   and DELETED           = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
		insert into OPPORTUNITIES_CONTACTS
			( ID               
			, CREATED_BY       
			, DATE_ENTERED     
			, MODIFIED_USER_ID 
			, DATE_MODIFIED    
			, CONTACT_ID       
			, OPPORTUNITY_ID   
			, CONTACT_ROLE     
			)
		values
			( @ID               
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @MODIFIED_USER_ID 
			,  getdate()        
			, @CONTACT_ID       
			, @OPPORTUNITY_ID   
			, @CONTACT_ROLE     
			);
	end else begin
		update OPPORTUNITIES_CONTACTS
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()        
		     , DATE_MODIFIED_UTC =  getutcdate()     
		     , CONTACT_ROLE      = @CONTACT_ROLE     
		 where ID                = @ID               ;
	end -- if;
  end
GO
 
Grant Execute on dbo.spOPPORTUNITIES_CONTACTS_Update to public;
GO
 
