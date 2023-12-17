if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwWORKFLOW_ALERTS')
	Drop View dbo.vwWORKFLOW_ALERTS;
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
Create View dbo.vwWORKFLOW_ALERTS
as
select ID
     , FIELD_VALUE
     , REL_EMAIL_VALUE
     , REL_MODULE1
     , REL_MODULE2
     , REL_MODULE1_TYPE
     , REL_MODULE2_TYPE
     , WHERE_FILTER
     , USER_TYPE
     , ARRAY_TYPE
     , RELATE_TYPE
     , ADDRESS_TYPE
     , PARENT_ID
     , USER_DISPLAY_TYPE
  from WORKFLOW_ALERTS
 where DELETED = 0

GO

Grant Select on dbo.vwWORKFLOW_ALERTS to public;
GO

