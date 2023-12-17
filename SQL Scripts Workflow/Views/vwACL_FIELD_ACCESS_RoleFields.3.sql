if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACL_FIELD_ACCESS_RoleFields')
	Drop View dbo.vwACL_FIELD_ACCESS_RoleFields;
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
Create View dbo.vwACL_FIELD_ACCESS_RoleFields
as
select vwMODULES_ACL_ROLES_Cross.ROLE_ID
     , vwMODULES_ACL_ROLES_Cross.MODULE_NAME
     , vwMODULES_ACL_ROLES_Cross.TABLE_NAME
     , vwSqlColumns.ObjectName               as VIEW_NAME
     , (case 
        when vwSqlColumns.ColumnName = N'CREATED_BY'        then N'.LBL_' + vwSqlColumns.ColumnName
        when vwSqlColumns.ColumnName = N'CREATED_BY_ID'     then N'.LBL_' + vwSqlColumns.ColumnName
        when vwSqlColumns.ColumnName = N'DATE_ENTERED'      then N'.LBL_' + vwSqlColumns.ColumnName
        when vwSqlColumns.ColumnName = N'MODIFIED_BY'       then N'.LBL_' + vwSqlColumns.ColumnName
        when vwSqlColumns.ColumnName = N'MODIFIED_USER_ID'  then N'.LBL_' + vwSqlColumns.ColumnName
        when vwSqlColumns.ColumnName = N'DATE_MODIFIED'     then N'.LBL_' + vwSqlColumns.ColumnName
        when vwSqlColumns.ColumnName = N'DATE_MODIFIED_UTC' then N'.LBL_' + vwSqlColumns.ColumnName
        when vwSqlColumns.ColumnName = N'ASSIGNED_TO'       then N'.LBL_' + vwSqlColumns.ColumnName
        when vwSqlColumns.ColumnName = N'ASSIGNED_USER_ID'  then N'.LBL_' + vwSqlColumns.ColumnName
        when vwSqlColumns.ColumnName = N'TEAM_ID'           then N'.LBL_' + vwSqlColumns.ColumnName
        when vwSqlColumns.ColumnName = N'TEAM_NAME'         then N'.LBL_' + vwSqlColumns.ColumnName
        else vwMODULES_ACL_ROLES_Cross.MODULE_NAME + N'.LBL_' + vwSqlColumns.ColumnName
        end)                                 as DISPLAY_NAME
     , vwSqlColumns.ColumnName               as FIELD_NAME
     , vwACL_ROLES_FIELDS.ACLACCESS
  from            vwMODULES_ACL_ROLES_Cross
       inner join vwSqlColumns
               on vwSqlColumns.ObjectType              = N'V'
              and vwSqlColumns.ObjectName              = N'vw' + vwMODULES_ACL_ROLES_Cross.TABLE_NAME + '_Edit'
  left outer join vwACL_ROLES_FIELDS
               on vwACL_ROLES_FIELDS.ROLE_ID           = vwMODULES_ACL_ROLES_Cross.ROLE_ID
              and vwACL_ROLES_FIELDS.MODULE_NAME       = vwMODULES_ACL_ROLES_Cross.MODULE_NAME
              and vwACL_ROLES_FIELDS.FIELD_NAME        = vwSqlColumns.ColumnName
  left outer join ACL_FIELDS_ALIASES
               on ACL_FIELDS_ALIASES.ALIAS_NAME        = vwSqlColumns.ColumnName
              and (ACL_FIELDS_ALIASES.ALIAS_MODULE_NAME = vwMODULES_ACL_ROLES_Cross.MODULE_NAME or ACL_FIELDS_ALIASES.ALIAS_MODULE_NAME is null)
              and ACL_FIELDS_ALIASES.DELETED           = 0
 where vwMODULES_ACL_ROLES_Cross.MODULE_ENABLED = 1
   and vwMODULES_ACL_ROLES_Cross.IS_ADMIN       = 0
   and vwSqlColumns.ColumnName not in (N'ID', N'DELETED', N'DATE_MODIFIED_UTC', N'ID_C', N'TEAM_SET_ID', N'TEAM_SET_NAME')
   and ACL_FIELDS_ALIASES.ID is null
GO

Grant Select on dbo.vwACL_FIELD_ACCESS_RoleFields to public;
GO


