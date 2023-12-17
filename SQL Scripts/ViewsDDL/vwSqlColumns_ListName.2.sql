if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSqlColumns_ListName')
	Drop View dbo.vwSqlColumns_ListName;
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
-- 02/09/2007 Paul.  Use the EDITVIEWS_FIELDS to determine if a column is an enum. 
Create View dbo.vwSqlColumns_ListName
as
select ObjectName
     , ColumnName                  as DATA_FIELD
     , EDITVIEWS_FIELDS.CACHE_NAME as LIST_NAME
  from      vwSqlColumns
 inner join EDITVIEWS_FIELDS
         on EDITVIEWS_FIELDS.DATA_FIELD   = vwSqlColumns.ColumnName
        and EDITVIEWS_FIELDS.DELETED      = 0
        and EDITVIEWS_FIELDS.FIELD_TYPE   = N'ListBox'
        and EDITVIEWS_FIELDS.DEFAULT_VIEW = 0
        and EDITVIEWS_FIELDS.CACHE_NAME is not null
 inner join EDITVIEWS
         on EDITVIEWS.NAME                = EDITVIEWS_FIELDS.EDIT_NAME
        and EDITVIEWS.VIEW_NAME           = vwSqlColumns.ObjectName + N'_Edit'
        and EDITVIEWS.DELETED             = 0
 where CsType in(N'string', N'ansistring')

GO

Grant Select on dbo.vwSqlColumns_ListName to public;
GO


