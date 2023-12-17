if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSURVEY_PAGES_RESULTS')
	Drop View dbo.vwSURVEY_PAGES_RESULTS;
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
Create View dbo.vwSURVEY_PAGES_RESULTS
as
select SURVEY_PAGES_RESULTS.ID
     , SURVEY_PAGES_RESULTS.SURVEY_RESULT_ID
     , SURVEY_PAGES_RESULTS.SURVEY_ID
     , SURVEY_PAGES_RESULTS.SURVEY_PAGE_ID
     , SURVEY_PAGES_RESULTS.DATE_MODIFIED
     , SURVEY_PAGES_RESULTS.RAW_CONTENT
     , SURVEY_PAGES.PAGE_NUMBER
  from      SURVEY_PAGES_RESULTS
 inner join SURVEY_PAGES
         on SURVEY_PAGES.ID = SURVEY_PAGES_RESULTS.SURVEY_PAGE_ID
 where SURVEY_PAGES_RESULTS.DELETED = 0

GO

Grant Select on dbo.vwSURVEY_PAGES_RESULTS to public;
GO

