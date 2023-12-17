if exists (select * from sys.objects where name = 'trWORKFLOW_EVENTS_Ins_AUDIT' and type = 'TR')
	Drop Trigger dbo.trWORKFLOW_EVENTS_Ins_AUDIT;
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
-- 01/22/2010 Paul.  Use the AUDIT_ID as the primary key in the AUDIT_EVENTS table. 
-- 02/08/2020 Paul.  Include Audit tables.  When recovering an archived audit table, don't recreate the audit event. 
Create Trigger dbo.trWORKFLOW_EVENTS_Ins_AUDIT on dbo.WORKFLOW_EVENTS
for insert
as
  begin
	insert into dbo.AUDIT_EVENTS
		( ID               
		, DELETED          
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, AUDIT_ID         
		, AUDIT_TABLE      
		, AUDIT_TOKEN      
		, AUDIT_ACTION     
		, AUDIT_PARENT_ID  
		)
	select	  AUDIT_ID         
		, DELETED          
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, AUDIT_ID         
		, AUDIT_TABLE      
		, AUDIT_TOKEN      
		, AUDIT_ACTION     
		, AUDIT_PARENT_ID  
	  from inserted
	 where not exists (select * from dbo.AUDIT_EVENTS where AUDIT_EVENTS.ID = inserted.AUDIT_ID);
  end
GO

