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
-- 08/08/2015 Paul.  Separate relationship for Leads/Opportunities. 
if not exists (select * from LEADS_OPPORTUNITIES) begin -- then
	if exists (select * from LEADS where OPPORTUNITY_ID is not null and DELETED = 0) begin -- then
		insert into LEADS_OPPORTUNITIES
			( CREATED_BY
			, MODIFIED_USER_ID
			, DATE_MODIFIED
			, DATE_MODIFIED_UTC
			, LEAD_ID
			, OPPORTUNITY_ID
			)
		select MODIFIED_USER_ID
		     , MODIFIED_USER_ID
		     , DATE_MODIFIED
		     , getutcdate()
		     , ID
		     , OPPORTUNITY_ID
		  from LEADS
		 where OPPORTUNITY_ID is not null
		   and DELETED = 0;
	end -- if;
end -- if;
GO


