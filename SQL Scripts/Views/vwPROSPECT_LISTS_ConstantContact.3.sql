if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROSPECT_LISTS_ConstantContact')
	Drop View dbo.vwPROSPECT_LISTS_ConstantContact;
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
-- 08/15/2018 Paul.  The STATUS field is used in the code but does not exist in the table.  Adding here is a quick fix. 
-- 01/30/2019 Paul.  Ease conversion to Oracle. 
Create View dbo.vwPROSPECT_LISTS_ConstantContact
as
select vwPROSPECT_LISTS.*
     , null as STATUS
  from vwPROSPECT_LISTS
 where LIST_TYPE = N'ConstantContact'

GO

Grant Select on dbo.vwPROSPECT_LISTS_ConstantContact to public;
GO

