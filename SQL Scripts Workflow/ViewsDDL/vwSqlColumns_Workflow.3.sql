if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSqlColumns_Workflow')
	Drop View dbo.vwSqlColumns_Workflow;
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
-- 07/23/2008 Paul.  Use a separate view for workflow so that we can filter the audting fields. 
-- 07/23/2008 Paul.  It makes little sense to trigger a workflow on any of the fields common to all modules. 
-- 07/23/2008 Paul.  We do want to include ID fields so that we can track changes in fields like ASSIGNED_USER_ID. 
-- 10/11/2008 Paul.  Allow ID so that we can send an email to a record. 
-- 02/18/2009 Paul.  We need to know if the column is an identity so the workflow engine can avoid updating it.
-- 09/10/2010 Paul.  Exclude AUDIT_VERSION. 
Create View dbo.vwSqlColumns_Workflow
as
select ObjectName
     , ColumnName
     , ColumnType
     , ColumnName as NAME
     , ColumnName as DISPLAY_NAME
     , SqlDbType
     , (case 
        when dbo.fnSqlColumns_IsEnum(ObjectName, ColumnName, CsType) = 1 then N'enum'
        else CsType
        end) as CsType
     , colid
     , IsIdentity
  from vwSqlColumns
 where ColumnName not in (N'DELETED', N'ID_C')
   and ColumnName not in (N'AUDIT_ID', N'AUDIT_ACTION', N'AUDIT_DATE', N'AUDIT_COLUMNS', N'AUDIT_TOKEN', N'AUDIT_VERSION')

GO

Grant Select on dbo.vwSqlColumns_Workflow to public;
GO


