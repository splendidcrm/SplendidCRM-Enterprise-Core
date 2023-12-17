
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
-- 09/08/2012 Paul.  Project Relations data for QUOTEs moved to PROJECTS_QUOTES. 
if exists (select * from PROJECT_RELATION where RELATION_TYPE = 'Quotes') begin -- then
	print 'migrate data from PROJECT_RELATION to PROJECTS_QUOTES';
	insert into PROJECTS_QUOTES
		( ID               
		, DELETED          
		, CREATED_BY       
		, DATE_ENTERED     
		, MODIFIED_USER_ID 
		, DATE_MODIFIED    
		, DATE_MODIFIED_UTC
		, PROJECT_ID       
		, QUOTE_ID         
		)
	select ID               
	     , DELETED          
	     , CREATED_BY       
	     , DATE_ENTERED     
	     , MODIFIED_USER_ID 
	     , DATE_MODIFIED    
	     , DATE_MODIFIED_UTC
	     , PROJECT_ID       
	     , RELATION_ID      
	  from PROJECT_RELATION
	 where RELATION_TYPE = N'Quotes';

	delete from PROJECT_RELATION
	 where RELATION_TYPE = N'Quotes';
end -- if;
GO

