if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwUSERS_ASSIGNED_TO_List')
	Drop View dbo.vwUSERS_ASSIGNED_TO_List;
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
-- 12/04/2006 Paul.  Only include active users. 
-- 12/05/2006 Paul.  New users created via NTLM will have a status of NULL. 
-- 04/15/2008 Paul.  Use vwUSERS_ASSIGNED_TO as the base to be similar to vwTEAMS_ASSIGNED_TO_List. 
Create View dbo.vwUSERS_ASSIGNED_TO_List
as
select vwUSERS_List.*
  from      vwUSERS_ASSIGNED_TO
 inner join vwUSERS_List
         on vwUSERS_List.ID = vwUSERS_ASSIGNED_TO.ID

GO

Grant Select on dbo.vwUSERS_ASSIGNED_TO_List to public;
GO


