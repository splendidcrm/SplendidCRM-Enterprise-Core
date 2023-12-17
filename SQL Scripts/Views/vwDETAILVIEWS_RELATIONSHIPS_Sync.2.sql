if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDETAILVIEWS_RELATIONSHIPS_Sync')
	Drop View dbo.vwDETAILVIEWS_RELATIONSHIPS_Sync;
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
-- 01/17/2015 Paul.  This file previously included the wrong view. 
-- 01/25/2015 Paul.  Include Mobile views for Offline Client for iOS. 
-- 03/30/2022 Paul.  Add Insight fields. 
Create View dbo.vwDETAILVIEWS_RELATIONSHIPS_Sync
as
select ID
     , DELETED
     , CREATED_BY
     , DATE_ENTERED
     , MODIFIED_USER_ID
     , DATE_MODIFIED
     , DATE_MODIFIED_UTC
     , DETAIL_NAME
     , MODULE_NAME
     , CONTROL_NAME
     , RELATIONSHIP_ORDER
     , RELATIONSHIP_ENABLED
     , TITLE
     , TABLE_NAME
     , PRIMARY_FIELD
     , SORT_FIELD
     , SORT_DIRECTION
     , INSIGHT_LABEL
     , INSIGHT_VIEW
     , INSIGHT_OPERATOR
  from DETAILVIEWS_RELATIONSHIPS
 where DETAIL_NAME like 'TabMenu'
    or DETAIL_NAME like '%.DetailView'
    or DETAIL_NAME like '%.DetailView.Mobile'

GO

Grant Select on dbo.vwDETAILVIEWS_RELATIONSHIPS_Sync to public;
GO

