if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCAMPAIGNS_GenerateCalls' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCAMPAIGNS_GenerateCalls;
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
Create Procedure dbo.spCAMPAIGNS_GenerateCalls
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on

	declare @TEMP_TEST          bit;
	declare @CALL_MARKETING_ID  uniqueidentifier;


-- #if SQL_Server /*
	declare CAMPAIGN_CALL_MKTG_CURSOR cursor for
	select ID
	  from vwCAMPAIGNS_CALL_MARKETING
	 where CAMPAIGN_ID = @ID
	   and STATUS  = N'active'
	 order by DATE_START, NAME;
-- #endif SQL_Server */

/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	set @TEMP_TEST = 0;
	exec dbo.spCAMPAIGNS_UpdateDynamic @ID, @MODIFIED_USER_ID;

	open CAMPAIGN_CALL_MKTG_CURSOR;
	fetch next from CAMPAIGN_CALL_MKTG_CURSOR into @CALL_MARKETING_ID;
	while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
		exec dbo.spCALL_MARKETING_GenerateCalls @CALL_MARKETING_ID, @MODIFIED_USER_ID;
		fetch next from CAMPAIGN_CALL_MKTG_CURSOR into @CALL_MARKETING_ID;
/* -- #if Oracle
		IF CAMPAIGN_CALL_MKTG_CURSOR%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close CAMPAIGN_CALL_MKTG_CURSOR;
	deallocate CAMPAIGN_CALL_MKTG_CURSOR;

	if @TEMP_TEST = 0 begin -- then
		insert into CAMPAIGN_LOG
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, CAMPAIGN_ID        
--			, TARGET_TRACKER_KEY 
			, TARGET_ID          
			, TARGET_TYPE        
			, ACTIVITY_TYPE      
			, ACTIVITY_DATE      
--			, RELATED_ID         
--			, RELATED_TYPE       
			, MARKETING_ID       
			, LIST_ID            
			, MORE_INFORMATION   
			)
		select	  newid()             
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			,  CAMPAIGN_ID        
--			,  null               
			,  RELATED_ID         
			,  RELATED_TYPE       
			, N'invalid email'    
			,  getdate()          
--			,  null               
--			,  null               
			,  CALL_MARKETING_ID  
			,  PROSPECT_LIST_ID   
			,  PHONE_WORK         
		  from vwCAMPAIGNS_InvalidPhones
		 where CAMPAIGN_ID = @ID;
		
		insert into CAMPAIGN_LOG
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, CAMPAIGN_ID        
--			, TARGET_TRACKER_KEY 
			, TARGET_ID          
			, TARGET_TYPE        
			, ACTIVITY_TYPE      
			, ACTIVITY_DATE      
--			, RELATED_ID         
--			, RELATED_TYPE       
			, MARKETING_ID       
			, LIST_ID            
			, MORE_INFORMATION   
			)
		select	  newid()             
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			,  CAMPAIGN_ID        
--			,  null               
			,  RELATED_ID         
			,  RELATED_TYPE       
			, N'removed'          
			,  getdate()          
--			,  null               
--			,  null               
			,  CALL_MARKETING_ID  
			,  PROSPECT_LIST_ID   
			,  PHONE_WORK         
		  from vwCAMPAIGNS_DoNotCall
		 where CAMPAIGN_ID = @ID;
		
		insert into CAMPAIGN_LOG
			( ID                 
			, CREATED_BY         
			, DATE_ENTERED       
			, MODIFIED_USER_ID   
			, DATE_MODIFIED      
			, CAMPAIGN_ID        
--			, TARGET_TRACKER_KEY 
			, TARGET_ID          
			, TARGET_TYPE        
			, ACTIVITY_TYPE      
			, ACTIVITY_DATE      
--			, RELATED_ID         
--			, RELATED_TYPE       
			, MARKETING_ID       
			, LIST_ID            
			, MORE_INFORMATION   
			)
		select	  newid()             
			, @MODIFIED_USER_ID   
			,  getdate()          
			, @MODIFIED_USER_ID   
			,  getdate()          
			,  CAMPAIGN_ID        
--			,  null               
			,  RELATED_ID         
			,  RELATED_TYPE       
			, N'blocked'          
			,  getdate()          
--			,  null               
--			,  null               
			,  CALL_MARKETING_ID  
			,  PROSPECT_LIST_ID   
			,  PHONE_WORK         
		  from vwCAMPAIGNS_ExemptPhones
		 where CAMPAIGN_ID = @ID;
	end -- if;
  end
GO

Grant Execute on dbo.spCAMPAIGNS_GenerateCalls to public;
GO

