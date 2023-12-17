if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACL_FIELDS_Duplicate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACL_FIELDS_Duplicate;
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
Create Procedure dbo.spACL_FIELDS_Duplicate
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @DUPLICATE_ID      uniqueidentifier
	)
as
  begin
	set nocount on

	if not exists(select * from ACL_ROLES where ID = @ID and DELETED = 0) begin -- then
		raiserror(N'Cannot duplicate to non-existent role.  ', 16, 1);
		return;
	end -- if;

	if not exists(select * from ACL_ROLES where ID = @DUPLICATE_ID and DELETED = 0) begin -- then
		raiserror(N'Cannot duplicate non-existent role.  ', 16, 1);
		return;
	end -- if;

	insert into ACL_FIELDS
		( CREATED_BY        
		, DATE_ENTERED      
		, MODIFIED_USER_ID  
		, DATE_MODIFIED     
		, DATE_MODIFIED_UTC 
		, ROLE_ID           
		, NAME              
		, CATEGORY          
		, ACLACCESS         
		)
	select	  @MODIFIED_USER_ID 
		,  getdate()        
		, @MODIFIED_USER_ID 
		,  getdate()        
		,  getutcdate()     
		, @ID           
		,  NAME              
		,  CATEGORY          
		,  ACLACCESS         
	  from ACL_FIELDS
	 where ROLE_ID = @DUPLICATE_ID
	   and DELETED = 0;
  end
GO

Grant Execute on dbo.spACL_FIELDS_Duplicate to public;
GO

