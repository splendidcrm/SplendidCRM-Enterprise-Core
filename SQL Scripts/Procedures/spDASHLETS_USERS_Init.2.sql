if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDASHLETS_USERS_Init' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDASHLETS_USERS_Init;
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
Create Procedure dbo.spDASHLETS_USERS_Init
	( @MODIFIED_USER_ID uniqueidentifier
	, @ASSIGNED_USER_ID uniqueidentifier
	, @DETAIL_NAME      nvarchar(50)
	)
as
  begin
	set nocount on

	-- 07/10/2009 Paul.  If there are no relationships, then copy the default relationships. 	
	-- 08/01/2009 Paul.  Make sure to ignore deleted records. 
	if not exists(select * from DASHLETS_USERS where ASSIGNED_USER_ID = @ASSIGNED_USER_ID and DETAIL_NAME = @DETAIL_NAME and DELETED = 0) begin -- then
		insert into DASHLETS_USERS
			( CREATED_BY          
			, DATE_ENTERED        
			, MODIFIED_USER_ID    
			, DATE_MODIFIED       
			, ASSIGNED_USER_ID    
			, DETAIL_NAME         
			, MODULE_NAME         
			, CONTROL_NAME        
			, DASHLET_ORDER       
			, DASHLET_ENABLED     
			, TITLE               
			)
		select	  MODIFIED_USER_ID    
			, DATE_MODIFIED       
			, @MODIFIED_USER_ID   
			, getdate()           
			, @ASSIGNED_USER_ID   
			, DETAIL_NAME         
			, MODULE_NAME         
			, CONTROL_NAME        
			, RELATIONSHIP_ORDER  
			, RELATIONSHIP_ENABLED
			, TITLE               
		  from DETAILVIEWS_RELATIONSHIPS
		 where DETAIL_NAME = @DETAIL_NAME
		   and DELETED     = 0;
	end -- if;

	exec dbo.spDASHLETS_USERS_Reorder @MODIFIED_USER_ID, @ASSIGNED_USER_ID, @DETAIL_NAME;
  end
GO

Grant Execute on dbo.spDASHLETS_USERS_Init to public;
GO

