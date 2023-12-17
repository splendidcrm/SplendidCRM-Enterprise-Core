if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACL_ROLES_ACTIONS_Sync')
	Drop View dbo.vwACL_ROLES_ACTIONS_Sync;
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

-- 08/24/2014 Paul.  We need to reduce the role actions sent to the offline client. 
-- 12/21/2014 Paul.  Treat report designer as a separate module. 
Create View dbo.vwACL_ROLES_ACTIONS_Sync
as
select vwACL_ROLES_ACTIONS_Category.ID
     , vwACL_ROLES_ACTIONS_Category.DELETED
     , vwACL_ROLES_ACTIONS_Category.CREATED_BY
     , vwACL_ROLES_ACTIONS_Category.DATE_ENTERED
     , vwACL_ROLES_ACTIONS_Category.MODIFIED_USER_ID
     , vwACL_ROLES_ACTIONS_Category.DATE_MODIFIED
     , vwACL_ROLES_ACTIONS_Category.DATE_MODIFIED_UTC
     , vwACL_ROLES_ACTIONS_Category.ROLE_ID
     , vwACL_ROLES_ACTIONS_Category.ACTION_ID
     , vwACL_ROLES_ACTIONS_Category.ACCESS_OVERRIDE
     , vwACL_ROLES_ACTIONS_Category.CATEGORY
  from      vwACL_ROLES_ACTIONS_Category
 inner join vwMODULES
         on vwMODULES.MODULE_NAME = vwACL_ROLES_ACTIONS_Category.CATEGORY
 where vwMODULES.IS_ADMIN = 0
   and vwMODULES.TABLE_NAME is not null
   and vwMODULES.MODULE_NAME not in 
( 'CallMarketing'
, 'CampaignLog'
, 'Campaigns'
, 'CampaignTrackers'
, 'CreditCards'
, 'EmailMarketing'
, 'Employees'
, 'Feeds'
, 'Forums'
, 'iFrames'
, 'Images'
, 'KBDocuments'
, 'KBTags'
, 'Payments'
, 'Products'
, 'ReportRules'
, 'Reports'
, 'ReportDesigner'
, 'RulesWizard'
, 'UserSignatures'
)

GO

Grant Select on dbo.vwACL_ROLES_ACTIONS_Sync to public;
GO


