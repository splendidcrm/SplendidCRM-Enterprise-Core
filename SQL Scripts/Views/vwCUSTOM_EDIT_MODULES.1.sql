if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCUSTOM_EDIT_MODULES')
	Drop View dbo.vwCUSTOM_EDIT_MODULES;
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
-- 09/09/2007 Paul.  Excluded deleted records.  This should have been done from the very beginning.
Create View dbo.vwCUSTOM_EDIT_MODULES
as
select MODULE_NAME as NAME
  from MODULES
 where MODULE_ENABLED = 1
   and CUSTOM_ENABLED = 1
   and DELETED        = 0
GO

Grant Select on dbo.vwCUSTOM_EDIT_MODULES to public;
GO


