if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSEMANTIC_MODEL_ROLES_Related')
	Drop View dbo.vwSEMANTIC_MODEL_ROLES_Related;
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
Create View dbo.vwSEMANTIC_MODEL_ROLES_Related
as
select vwSEMANTIC_MODEL_ROLES.ID
     , vwSEMANTIC_MODEL_ROLES.LHS_TABLE
     , vwSEMANTIC_MODEL_ROLES.LHS_KEY
     , vwSEMANTIC_MODEL_ROLES.RHS_TABLE
     , vwSEMANTIC_MODEL_ROLES.RHS_KEY
     , vwSEMANTIC_MODEL_ROLES.CARDINALITY
     , vwSEMANTIC_MODEL_ROLES.NAME
     , RELATED_ROLE.ID                    as RELATED_ID
     , RELATED_ROLE.NAME                  as RELATED_NAME
  from      vwSEMANTIC_MODEL_ROLES
 inner join vwSEMANTIC_MODEL_ROLES   RELATED_ROLE
         on RELATED_ROLE.LHS_TABLE = vwSEMANTIC_MODEL_ROLES.RHS_TABLE
        and RELATED_ROLE.LHS_KEY   = vwSEMANTIC_MODEL_ROLES.RHS_KEY
        and RELATED_ROLE.RHS_TABLE = vwSEMANTIC_MODEL_ROLES.LHS_TABLE
        and RELATED_ROLE.RHS_KEY   = vwSEMANTIC_MODEL_ROLES.LHS_KEY

GO

/*
select *
  from vwSEMANTIC_MODEL_ROLES_Related
 where LHS_TABLE = 'ACCOUNTS'
 order by RHS_TABLE, RHS_KEY
*/

Grant Select on dbo.vwSEMANTIC_MODEL_ROLES_Related to public;
GO

