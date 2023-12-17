if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDETAILVIEWS_RELATIONSHIPS_La')
	Drop View dbo.vwDETAILVIEWS_RELATIONSHIPS_La;
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
-- 09/08/2007 Paul.  vwDETAILVIEWS_RELATIONSHIPS_Layout is too long for Oracle, so reduce to 30 characters. 
-- 09/08/2007 Paul.  We need a title when we migrate to WebParts. 
-- 01/27/2010 Paul.  Remove the join to DETAILVIEWS so that we can use this table for EditView Relationships. 
-- 10/13/2012 Paul.  Add table info for HTML5 Offline Client. 
-- 02/14/2013 Paul.  Add CONTROL_NAME to make it easy to copy. 
-- 03/30/2022 Paul.  Add Insight fields. 
Create View dbo.vwDETAILVIEWS_RELATIONSHIPS_La
as
select DETAILVIEWS_RELATIONSHIPS.ID
     , DETAILVIEWS_RELATIONSHIPS.DETAIL_NAME
     , DETAILVIEWS_RELATIONSHIPS.MODULE_NAME
     , DETAILVIEWS_RELATIONSHIPS.TITLE
     , DETAILVIEWS_RELATIONSHIPS.CONTROL_NAME
     , DETAILVIEWS_RELATIONSHIPS.RELATIONSHIP_ORDER
     , DETAILVIEWS_RELATIONSHIPS.RELATIONSHIP_ENABLED
     , DETAILVIEWS_RELATIONSHIPS.TABLE_NAME
     , DETAILVIEWS_RELATIONSHIPS.PRIMARY_FIELD
     , DETAILVIEWS_RELATIONSHIPS.SORT_FIELD
     , DETAILVIEWS_RELATIONSHIPS.SORT_DIRECTION
     , DETAILVIEWS_RELATIONSHIPS.INSIGHT_LABEL
     , DETAILVIEWS_RELATIONSHIPS.INSIGHT_VIEW
     , DETAILVIEWS_RELATIONSHIPS.INSIGHT_OPERATOR
  from      DETAILVIEWS_RELATIONSHIPS
 inner join MODULES
         on MODULES.MODULE_NAME    = DETAILVIEWS_RELATIONSHIPS.MODULE_NAME
        and MODULES.DELETED        = 0
        and MODULES.MODULE_ENABLED = 1
 where DETAILVIEWS_RELATIONSHIPS.DELETED = 0

GO

Grant Select on dbo.vwDETAILVIEWS_RELATIONSHIPS_La to public;
GO

