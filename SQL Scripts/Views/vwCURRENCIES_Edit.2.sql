if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCURRENCIES_Edit')
	Drop View dbo.vwCURRENCIES_Edit;
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
Create View dbo.vwCURRENCIES_Edit
as
select vwCURRENCIES.*
     , (case when cast(vwCURRENCIES.ID as char(36)) = dbo.fnCONFIG_String('base_currency'   ) or (vwCURRENCIES.ID = 'e340202e-6291-4071-b327-a34cb4df239b' and dbo.fnCONFIG_String('base_currency'   ) is null) then 1 else 0 end) as IS_BASE
     , (case when cast(vwCURRENCIES.ID as char(36)) = dbo.fnCONFIG_String('default_currency') or (vwCURRENCIES.ID = 'e340202e-6291-4071-b327-a34cb4df239b' and dbo.fnCONFIG_String('default_currency') is null) then 1 else 0 end) as IS_DEFAULT
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
  from            vwCURRENCIES
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = vwCURRENCIES.MODIFIED_USER_ID

GO

Grant Select on dbo.vwCURRENCIES_Edit to public;
GO

 
