if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEMAIL_MARKETING_Duplicate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEMAIL_MARKETING_Duplicate;
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
-- 01/23/2013 Paul.  Add REPLY_TO_NAME and REPLY_TO_ADDR. 
Create Procedure dbo.spEMAIL_MARKETING_Duplicate
	( @ID                uniqueidentifier output
	, @MODIFIED_USER_ID  uniqueidentifier
	, @DUPLICATE_ID      uniqueidentifier
	, @CAMPAIGN_ID       uniqueidentifier
	)
as
  begin
	set nocount on
	
	set @ID = null;
	if not exists(select * from vwEMAIL_MARKETING where ID = @DUPLICATE_ID) begin -- then
		raiserror(N'Cannot duplicate non-existent email marketing.', 16, 1);
		return;
	end -- if;

	if dbo.fnIsEmptyGuid(@ID) = 1 begin -- then
		set @ID = newid();
	end -- if;
	insert into EMAIL_MARKETING
		( ID                
		, CREATED_BY        
		, DATE_ENTERED      
		, MODIFIED_USER_ID  
		, DATE_MODIFIED     
		, NAME              
		, FROM_ADDR         
		, FROM_NAME         
		, DATE_START        
		, TIME_START        
		, TEMPLATE_ID       
		, CAMPAIGN_ID       
		, INBOUND_EMAIL_ID  
		, STATUS            
		, ALL_PROSPECT_LISTS
		, REPLY_TO_NAME     
		, REPLY_TO_ADDR     
		)
	select	  @ID                
		, @MODIFIED_USER_ID  
		,  getdate()         
		, @MODIFIED_USER_ID  
		,  getdate()         
		,  NAME              
		,  FROM_ADDR         
		,  FROM_NAME         
		,  DATE_START        
		,  TIME_START        
		,  TEMPLATE_ID       
		, @CAMPAIGN_ID       
		,  INBOUND_EMAIL_ID  
		,  STATUS            
		,  ALL_PROSPECT_LISTS
		,  REPLY_TO_NAME     
		,  REPLY_TO_ADDR     
	  from EMAIL_MARKETING
	 where ID = @DUPLICATE_ID;

	insert into EMAIL_MARKETING_CSTM ( ID_C ) values ( @ID );
  end
GO
 
Grant Execute on dbo.spEMAIL_MARKETING_Duplicate to public;
GO

