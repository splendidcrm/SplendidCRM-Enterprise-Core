if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEXCHANGE_USERS_FOLDERS_Changed')
	Drop View dbo.vwEXCHANGE_USERS_FOLDERS_Changed;
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
-- 05/14/2010 Paul.  Include the module name in the filter even though it is not absolutely necessary. 
-- 04/16/2018 Paul.  Add SERVICE_NAME to separate Exchange Folders from Contacts Sync. 
-- 12/19/2020 Paul.  Office365 uses a DELTA_TOKEN for each folder. 
Create View dbo.vwEXCHANGE_USERS_FOLDERS_Changed
as
select vwACCOUNTS.ID
     , vwACCOUNTS_USERS.USER_ID
     , vwACCOUNTS.NAME
     , N'Accounts'     as MODULE_NAME
     , vwEXCHANGE_FOLDERS.REMOTE_KEY
     , vwEXCHANGE_FOLDERS.DELTA_TOKEN
     , (case when vwEXCHANGE_FOLDERS.ID is null or vwACCOUNTS.NAME = vwEXCHANGE_FOLDERS.PARENT_NAME then 0 else 1 end) as NAME_CHANGED
     , (case when vwEXCHANGE_FOLDERS.ID is null then 1 else 0 end) as NEW_FOLDER
  from            vwACCOUNTS
       inner join vwACCOUNTS_USERS
               on vwACCOUNTS_USERS.ACCOUNT_ID         = vwACCOUNTS.ID
  left outer join vwEXCHANGE_FOLDERS
               on vwEXCHANGE_FOLDERS.PARENT_ID        = vwACCOUNTS_USERS.ACCOUNT_ID
              and vwEXCHANGE_FOLDERS.ASSIGNED_USER_ID = vwACCOUNTS_USERS.USER_ID
              and vwEXCHANGE_FOLDERS.MODULE_NAME      = N'Accounts'
 where vwACCOUNTS.NAME is not null
   and (vwEXCHANGE_FOLDERS.ID is null or vwACCOUNTS.NAME < vwEXCHANGE_FOLDERS.PARENT_NAME or vwACCOUNTS.NAME > vwEXCHANGE_FOLDERS.PARENT_NAME)
 union all
select vwBUGS.ID
     , vwBUGS_USERS.USER_ID
     , vwBUGS.NAME
     , N'Bugs'         as MODULE_NAME
     , vwEXCHANGE_FOLDERS.REMOTE_KEY
     , vwEXCHANGE_FOLDERS.DELTA_TOKEN
     , (case when vwEXCHANGE_FOLDERS.ID is null or vwBUGS.NAME = vwEXCHANGE_FOLDERS.PARENT_NAME then 0 else 1 end) as NAME_CHANGED
     , (case when vwEXCHANGE_FOLDERS.ID is null then 1 else 0 end) as NEW_FOLDER
  from            vwBUGS
       inner join vwBUGS_USERS
               on vwBUGS_USERS.BUG_ID                 = vwBUGS.ID
  left outer join vwEXCHANGE_FOLDERS
               on vwEXCHANGE_FOLDERS.PARENT_ID        = vwBUGS_USERS.BUG_ID
              and vwEXCHANGE_FOLDERS.ASSIGNED_USER_ID = vwBUGS_USERS.USER_ID
              and vwEXCHANGE_FOLDERS.MODULE_NAME      = N'Bugs'
 where vwBUGS.NAME is not null
   and (vwEXCHANGE_FOLDERS.ID is null or vwBUGS.NAME < vwEXCHANGE_FOLDERS.PARENT_NAME or vwBUGS.NAME > vwEXCHANGE_FOLDERS.PARENT_NAME)
 union all
select vwCASES.ID
     , vwCASES_USERS.USER_ID
     , vwCASES.NAME
     , N'Cases'        as MODULE_NAME
     , vwEXCHANGE_FOLDERS.REMOTE_KEY
     , vwEXCHANGE_FOLDERS.DELTA_TOKEN
     , (case when vwEXCHANGE_FOLDERS.ID is null or vwCASES.NAME = vwEXCHANGE_FOLDERS.PARENT_NAME then 0 else 1 end) as NAME_CHANGED
     , (case when vwEXCHANGE_FOLDERS.ID is null then 1 else 0 end) as NEW_FOLDER
  from            vwCASES
       inner join vwCASES_USERS
               on vwCASES_USERS.CASE_ID               = vwCASES.ID
  left outer join vwEXCHANGE_FOLDERS
               on vwEXCHANGE_FOLDERS.PARENT_ID        = vwCASES_USERS.CASE_ID
              and vwEXCHANGE_FOLDERS.ASSIGNED_USER_ID = vwCASES_USERS.USER_ID
              and vwEXCHANGE_FOLDERS.MODULE_NAME      = N'Cases'
 where vwCASES.NAME is not null
   and (vwEXCHANGE_FOLDERS.ID is null or vwCASES.NAME < vwEXCHANGE_FOLDERS.PARENT_NAME or vwCASES.NAME > vwEXCHANGE_FOLDERS.PARENT_NAME)
 union all
select vwCONTACTS.ID
     , vwCONTACTS_USERS.USER_ID
     , vwCONTACTS.NAME
     , N'Contacts'     as MODULE_NAME
     , vwEXCHANGE_FOLDERS.REMOTE_KEY
     , vwEXCHANGE_FOLDERS.DELTA_TOKEN
     , (case when vwEXCHANGE_FOLDERS.ID is null or vwCONTACTS.NAME = vwEXCHANGE_FOLDERS.PARENT_NAME then 0 else 1 end) as NAME_CHANGED
     , (case when vwEXCHANGE_FOLDERS.ID is null then 1 else 0 end) as NEW_FOLDER
  from            vwCONTACTS
       inner join vwCONTACTS_USERS
               on vwCONTACTS_USERS.CONTACT_ID         = vwCONTACTS.ID
              and vwCONTACTS_USERS.SERVICE_NAME = N'Exchange'             
  left outer join vwEXCHANGE_FOLDERS
               on vwEXCHANGE_FOLDERS.PARENT_ID        = vwCONTACTS_USERS.CONTACT_ID
              and vwEXCHANGE_FOLDERS.ASSIGNED_USER_ID = vwCONTACTS_USERS.USER_ID
              and vwEXCHANGE_FOLDERS.MODULE_NAME      = N'Contacts'
 where vwCONTACTS.NAME is not null
   and (vwEXCHANGE_FOLDERS.ID is null or vwCONTACTS.NAME < vwEXCHANGE_FOLDERS.PARENT_NAME or vwCONTACTS.NAME > vwEXCHANGE_FOLDERS.PARENT_NAME)
 union all
select vwLEADS.ID
     , vwLEADS_USERS.USER_ID
     , vwLEADS.NAME
     , N'Leads'        as MODULE_NAME
     , vwEXCHANGE_FOLDERS.REMOTE_KEY
     , vwEXCHANGE_FOLDERS.DELTA_TOKEN
     , (case when vwEXCHANGE_FOLDERS.ID is null or vwLEADS.NAME = vwEXCHANGE_FOLDERS.PARENT_NAME then 0 else 1 end) as NAME_CHANGED
     , (case when vwEXCHANGE_FOLDERS.ID is null then 1 else 0 end) as NEW_FOLDER
  from            vwLEADS
       inner join vwLEADS_USERS
               on vwLEADS_USERS.LEAD_ID               = vwLEADS.ID
  left outer join vwEXCHANGE_FOLDERS
               on vwEXCHANGE_FOLDERS.PARENT_ID        = vwLEADS_USERS.LEAD_ID
              and vwEXCHANGE_FOLDERS.ASSIGNED_USER_ID = vwLEADS_USERS.USER_ID
              and vwEXCHANGE_FOLDERS.MODULE_NAME      = N'Leads'
 where vwLEADS.NAME is not null
   and (vwEXCHANGE_FOLDERS.ID is null or vwLEADS.NAME < vwEXCHANGE_FOLDERS.PARENT_NAME or vwLEADS.NAME > vwEXCHANGE_FOLDERS.PARENT_NAME)
 union all
select vwOPPORTUNITIES.ID
     , vwOPPORTUNITIES_USERS.USER_ID
     , vwOPPORTUNITIES.NAME
     , N'Opportunities' as MODULE_NAME
     , vwEXCHANGE_FOLDERS.REMOTE_KEY
     , vwEXCHANGE_FOLDERS.DELTA_TOKEN
     , (case when vwEXCHANGE_FOLDERS.ID is null or vwOPPORTUNITIES.NAME = vwEXCHANGE_FOLDERS.PARENT_NAME then 0 else 1 end) as NAME_CHANGED
     , (case when vwEXCHANGE_FOLDERS.ID is null then 1 else 0 end) as NEW_FOLDER
  from            vwOPPORTUNITIES
       inner join vwOPPORTUNITIES_USERS
               on vwOPPORTUNITIES_USERS.OPPORTUNITY_ID = vwOPPORTUNITIES.ID
  left outer join vwEXCHANGE_FOLDERS
               on vwEXCHANGE_FOLDERS.PARENT_ID         = vwOPPORTUNITIES_USERS.OPPORTUNITY_ID
              and vwEXCHANGE_FOLDERS.ASSIGNED_USER_ID  = vwOPPORTUNITIES_USERS.USER_ID
              and vwEXCHANGE_FOLDERS.MODULE_NAME       = N'Opportunities'
 where vwOPPORTUNITIES.NAME is not null
   and (vwEXCHANGE_FOLDERS.ID is null or vwOPPORTUNITIES.NAME < vwEXCHANGE_FOLDERS.PARENT_NAME or vwOPPORTUNITIES.NAME > vwEXCHANGE_FOLDERS.PARENT_NAME)
 union all
select vwPROJECTS.ID
     , vwPROJECT_USERS.USER_ID
     , vwPROJECTS.NAME
     , N'Project'      as MODULE_NAME
     , vwEXCHANGE_FOLDERS.REMOTE_KEY
     , vwEXCHANGE_FOLDERS.DELTA_TOKEN
     , (case when vwEXCHANGE_FOLDERS.ID is null or vwPROJECTS.NAME = vwEXCHANGE_FOLDERS.PARENT_NAME then 0 else 1 end) as NAME_CHANGED
     , (case when vwEXCHANGE_FOLDERS.ID is null then 1 else 0 end) as NEW_FOLDER
  from            vwPROJECTS
       inner join vwPROJECT_USERS
               on vwPROJECT_USERS.PROJECT_ID          = vwPROJECTS.ID
  left outer join vwEXCHANGE_FOLDERS
               on vwEXCHANGE_FOLDERS.PARENT_ID        = vwPROJECT_USERS.PROJECT_ID
              and vwEXCHANGE_FOLDERS.ASSIGNED_USER_ID = vwPROJECT_USERS.USER_ID
              and vwEXCHANGE_FOLDERS.MODULE_NAME      = N'Project'
 where vwPROJECTS.NAME is not null
   and (vwEXCHANGE_FOLDERS.ID is null or vwPROJECTS.NAME < vwEXCHANGE_FOLDERS.PARENT_NAME or vwPROJECTS.NAME > vwEXCHANGE_FOLDERS.PARENT_NAME)

GO

Grant Select on dbo.vwEXCHANGE_USERS_FOLDERS_Changed to public;
GO

