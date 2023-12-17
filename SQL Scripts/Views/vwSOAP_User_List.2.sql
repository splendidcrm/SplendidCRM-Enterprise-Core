if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSOAP_User_List')
	Drop View dbo.vwSOAP_User_List;
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
-- 03/06/2006 Paul.  Oracle does not like <> ''.  Use len() > 0 instead. 
Create View dbo.vwSOAP_User_List
as
select ID
     , FIRST_NAME
     , LAST_NAME
     , USER_NAME
     , DEPARTMENT
     , EMAIL1      as EMAIL_ADDRESS
     , TITLE
  from vwUSERS
 where USER_NAME is not null
   and len(USER_NAME) > 0

GO

Grant Select on dbo.vwSOAP_User_List to public;
GO


