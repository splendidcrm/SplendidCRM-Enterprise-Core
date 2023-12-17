if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROSPECT_LISTS_RELATED_CHNG')
	Drop View dbo.vwPROSPECT_LISTS_RELATED_CHNG;
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
-- 08/17/2016 Paul.  Treat the contact as changed if it was added or removed from a prospect list. 
-- That means that we cannot filter on the deleted flag. 
Create View dbo.vwPROSPECT_LISTS_RELATED_CHNG
as
select PROSPECT_LISTS.ID                                         as PROSPECT_LIST_ID
     , PROSPECT_LISTS.NAME                                       as PROSPECT_LIST_NAME
     , PROSPECT_LISTS.LIST_TYPE                                  as PROSPECT_LIST_TYPE
     , PROSPECT_LISTS_PROSPECTS.DATE_MODIFIED                    as RELATED_DATE_MODIFIED
     , PROSPECT_LISTS_PROSPECTS.DATE_MODIFIED_UTC                as RELATED_DATE_MODIFIED_UTC
     , PROSPECT_LISTS_PROSPECTS.RELATED_TYPE
     , PROSPECT_LISTS_PROSPECTS.ID
     , PROSPECT_LISTS_PROSPECTS.RELATED_ID
  from            PROSPECT_LISTS
       inner join PROSPECT_LISTS_PROSPECTS
               on PROSPECT_LISTS_PROSPECTS.PROSPECT_LIST_ID = PROSPECT_LISTS.ID
--              and PROSPECT_LISTS_PROSPECTS.DELETED          = 0
 where PROSPECT_LISTS.DELETED = 0

GO

Grant Select on dbo.vwPROSPECT_LISTS_RELATED_CHNG to public;
GO

