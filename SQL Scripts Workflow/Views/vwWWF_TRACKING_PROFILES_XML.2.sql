if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwWWF_TRACKING_PROFILES_XML')
	Drop View dbo.vwWWF_TRACKING_PROFILES_XML;
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
-- 07/12/2008 Paul.  Although we typically join to the base view, we will repeat the code here for performance reasons. 
Create View dbo.vwWWF_TRACKING_PROFILES_XML
as
select WWF_TRACKING_PROFILES.ID
     , WWF_TRACKING_PROFILES.VERSION
     , WWF_TRACKING_PROFILES.WORKFLOW_TYPE_ID
     , WWF_TYPES.TYPE_FULL_NAME
     , WWF_TYPES.ASSEMBLY_FULL_NAME
     , (case when TRACKING_PROFILE_XML is not null then TRACKING_PROFILE_XML
             else (select top 1 TRACKING_PROFILE_XML from WWF_TRACKING_PROFILE_DEF where DELETED = 0 order by DATE_ENTERED desc)
        end) as TRACKING_PROFILE_XML
  from      WWF_TRACKING_PROFILES
 inner join WWF_TYPES
         on WWF_TYPES.ID      = WWF_TRACKING_PROFILES.WORKFLOW_TYPE_ID
        and WWF_TYPES.DELETED = 0
 where WWF_TRACKING_PROFILES.DELETED = 0

GO

Grant Select on dbo.vwWWF_TRACKING_PROFILES_XML to public;
GO
