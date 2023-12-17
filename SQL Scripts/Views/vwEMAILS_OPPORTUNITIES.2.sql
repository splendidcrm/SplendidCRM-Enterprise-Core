if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILS_OPPORTUNITIES')
	Drop View dbo.vwEMAILS_OPPORTUNITIES;
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
-- 10/28/2007 Paul.  The include the email parent, but not union all so that duplicates will get filtered. 
-- 09/09/2008 Paul.  Using a union causes a problem if there is an NTEXT custom field in the PROSPECTS_CSTM table. 
-- The text, ntext, or image data type cannot be selected as DISTINCT.
-- One solution would be to use UNION ALL, but then we would get duplicate records. 
-- So we still use UNION ALL, but also use an outer join to block duplicates. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwEMAILS_OPPORTUNITIES
as
select EMAILS.ID               as EMAIL_ID
     , EMAILS.NAME             as EMAIL_NAME
     , EMAILS.ASSIGNED_USER_ID as EMAIL_ASSIGNED_USER_ID
     , EMAILS.ASSIGNED_SET_ID  as EMAIL_ASSIGNED_SET_ID
     , vwOPPORTUNITIES.ID      as OPPORTUNITY_ID
     , vwOPPORTUNITIES.NAME    as OPPORTUNITY_NAME
     , vwOPPORTUNITIES.*
  from            EMAILS
       inner join EMAILS_OPPORTUNITIES
               on EMAILS_OPPORTUNITIES.EMAIL_ID = EMAILS.ID
              and EMAILS_OPPORTUNITIES.DELETED  = 0
       inner join vwOPPORTUNITIES
               on vwOPPORTUNITIES.ID            = EMAILS_OPPORTUNITIES.OPPORTUNITY_ID
 where EMAILS.DELETED = 0
union all
select EMAILS.ID               as EMAIL_ID
     , EMAILS.NAME             as EMAIL_NAME
     , EMAILS.ASSIGNED_USER_ID as EMAIL_ASSIGNED_USER_ID
     , EMAILS.ASSIGNED_SET_ID  as EMAIL_ASSIGNED_SET_ID
     , vwOPPORTUNITIES.ID      as OPPORTUNITY_ID
     , vwOPPORTUNITIES.NAME    as OPPORTUNITY_NAME
     , vwOPPORTUNITIES.*
  from            EMAILS
       inner join vwOPPORTUNITIES
               on vwOPPORTUNITIES.ID                  = EMAILS.PARENT_ID
  left outer join EMAILS_OPPORTUNITIES
               on EMAILS_OPPORTUNITIES.EMAIL_ID       = EMAILS.ID
              and EMAILS_OPPORTUNITIES.OPPORTUNITY_ID = vwOPPORTUNITIES.ID
              and EMAILS_OPPORTUNITIES.DELETED        = 0
 where EMAILS.DELETED     = 0
   and EMAILS.PARENT_TYPE = N'Opportunities'
   and EMAILS_OPPORTUNITIES.ID is null

GO

Grant Select on dbo.vwEMAILS_OPPORTUNITIES to public;
GO

