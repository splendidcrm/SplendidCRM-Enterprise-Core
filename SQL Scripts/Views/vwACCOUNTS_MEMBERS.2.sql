if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_MEMBERS')
	Drop View dbo.vwACCOUNTS_MEMBERS;
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
-- 11/27/2006 Paul.  Add TEAM_ID.
-- 11/27/2006 Paul.  Return TEAM.ID so that a deleted team will return NULL even if a value remains in the related record. 
-- 03/01/2007 Paul.  The CITY and PHONE we return needs to be of the account, not of the parent. 
-- 08/30/2009 Paul.  All module views must have a TEAM_SET_ID, so use the ACCOUNTS value. 
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 11/11/2012 Paul.  Return all account fields. 
-- 12/04/2012 Paul.  Change the view to make ACCOUNT_ID to be the PARENT_ID, which is consistent with all other relationship views. 
-- 12/04/2012 Paul.  It may seem odd to use ACCOUNT_ID as the name of the Parent ID, but that is the convention for relationship views. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwACCOUNTS_MEMBERS
as
select vwACCOUNTS.PARENT_ID        as ACCOUNT_ID
     , vwACCOUNTS.NAME             as ACCOUNT_NAME
     , vwACCOUNTS.ASSIGNED_USER_ID as ACCOUNT_ASSIGNED_USER_ID
     , vwACCOUNTS.ASSIGNED_SET_ID  as ACCOUNT_ASSIGNED_SET_ID
     , vwACCOUNTS.*
  from vwACCOUNTS
GO

Grant Select on dbo.vwACCOUNTS_MEMBERS to public;
GO


