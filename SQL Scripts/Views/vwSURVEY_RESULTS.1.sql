if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSURVEY_RESULTS')
	Drop View dbo.vwSURVEY_RESULTS;
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
-- 12/30/2015 Paul.  Change to vwSURVEY_RESULTS as it is needed for Query Builder. 
-- 04/10/2021 Paul.  React client requires NAME in all modules. 
-- 04/14/2021 Paul.  React client requires DATE_ENTERED in all modules. 
Create View dbo.vwSURVEY_RESULTS
as
select SURVEYS.ID                  as SURVEY_ID
     , SURVEYS.NAME                as SURVEY_NAME
     , SURVEYS.NAME                as NAME
     , vwPARENTS_EMAIL_ADDRESS.PARENT_ID
     , vwPARENTS_EMAIL_ADDRESS.PARENT_NAME
     , vwPARENTS_EMAIL_ADDRESS.PARENT_TYPE
     , SURVEY_RESULTS.ID
     , SURVEY_RESULTS.ID           as SURVEY_RESULT_ID
     , SURVEY_RESULTS.DATE_MODIFIED
     , SURVEY_RESULTS.START_DATE
     , SURVEY_RESULTS.SUBMIT_DATE
     , SURVEY_RESULTS.IS_COMPLETE
     , SURVEY_RESULTS.IP_ADDRESS
     , SURVEY_RESULTS.USER_AGENT
     , SURVEY_RESULTS.DATE_ENTERED
  from            SURVEY_RESULTS
       inner join SURVEYS
               on SURVEYS.ID                                = SURVEY_RESULTS.SURVEY_ID
              and SURVEYS.DELETED                           = 0
  left outer join vwPARENTS_EMAIL_ADDRESS
               on vwPARENTS_EMAIL_ADDRESS.PARENT_ID         = SURVEY_RESULTS.PARENT_ID
 where SURVEY_RESULTS.DELETED = 0

GO

Grant Select on dbo.vwSURVEY_RESULTS to public;
GO


