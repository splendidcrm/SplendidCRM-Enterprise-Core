if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwRELATIONSHIPS_Workflow')
	Drop View dbo.vwRELATIONSHIPS_Workflow;
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
-- 11/25/2008 Paul.  The many flag should only be true for many-to-many. 
Create View dbo.vwRELATIONSHIPS_Workflow
as
select cast(1 as bit)                     as RELATIONSHIP_MANY
     , vwRELATIONSHIPS.LHS_MODULE         as BASE_MODULE
     , vwMODULES.MODULE_NAME
     , vwMODULES.DISPLAY_NAME
  from      vwRELATIONSHIPS
 inner join vwMODULES
         on vwMODULES.MODULE_NAME = vwRELATIONSHIPS.RHS_MODULE
 where RELATIONSHIP_TYPE = 'many-to-many'
union
select cast(1 as bit)                     as RELATIONSHIP_MANY
     , vwRELATIONSHIPS.RHS_MODULE         as BASE_MODULE
     , vwMODULES.MODULE_NAME
     , vwMODULES.DISPLAY_NAME
  from      vwRELATIONSHIPS
 inner join vwMODULES
         on vwMODULES.MODULE_NAME = vwRELATIONSHIPS.LHS_MODULE
 where RELATIONSHIP_TYPE = 'many-to-many'
union
select cast(0 as bit)                     as RELATIONSHIP_MANY
     , vwRELATIONSHIPS.LHS_MODULE         as BASE_MODULE
     , vwMODULES.MODULE_NAME
     , vwMODULES.DISPLAY_NAME
  from      vwRELATIONSHIPS
 inner join vwMODULES
         on vwMODULES.MODULE_NAME = vwRELATIONSHIPS.RHS_MODULE
 where RELATIONSHIP_TYPE = 'one-to-many'
union
select cast(0 as bit)                     as RELATIONSHIP_MANY
     , vwRELATIONSHIPS.RHS_MODULE         as BASE_MODULE
     , vwMODULES.MODULE_NAME
     , vwMODULES.DISPLAY_NAME
  from      vwRELATIONSHIPS
 inner join vwMODULES
         on vwMODULES.MODULE_NAME = vwRELATIONSHIPS.LHS_MODULE
 where RELATIONSHIP_TYPE = 'one-to-many'

GO

Grant Select on dbo.vwRELATIONSHIPS_Workflow to public;
GO


