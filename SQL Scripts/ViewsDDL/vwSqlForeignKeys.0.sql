if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSqlForeignKeys')
	Drop View dbo.vwSqlForeignKeys;
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
Create View dbo.vwSqlForeignKeys
as
select TABLE_CONSTRAINTS.CONSTRAINT_NAME    as CONSTRAINT_NAME
     , TABLE_CONSTRAINTS.TABLE_SCHEMA       as TABLE_SCHEMA
     , TABLE_CONSTRAINTS.TABLE_NAME         as TABLE_NAME 
     , CONSTRAINT_COLUMN_USAGE.COLUMN_NAME  as COLUMN_NAME
     , PRIMARY_KEYS.TABLE_SCHEMA            as REFERENCED_TABLE_SCHEMA
     , PRIMARY_KEYS.TABLE_NAME              as REFERENCED_TABLE_NAME
     , PRIMARY_COLUMN_USAGE.COLUMN_NAME     as REFERENCED_COLUMN_NAME
  from      INFORMATION_SCHEMA.TABLE_CONSTRAINTS         TABLE_CONSTRAINTS
 inner join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE   CONSTRAINT_COLUMN_USAGE
         on CONSTRAINT_COLUMN_USAGE.CONSTRAINT_NAME    = TABLE_CONSTRAINTS.CONSTRAINT_NAME
 inner join INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS   REFERENTIAL_CONSTRAINTS
         on REFERENTIAL_CONSTRAINTS.CONSTRAINT_NAME    = TABLE_CONSTRAINTS.CONSTRAINT_NAME
 inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS         PRIMARY_KEYS
         on PRIMARY_KEYS.CONSTRAINT_NAME               = REFERENTIAL_CONSTRAINTS.UNIQUE_CONSTRAINT_NAME
        and PRIMARY_KEYS.CONSTRAINT_TYPE               = 'PRIMARY KEY'
 inner join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE   PRIMARY_COLUMN_USAGE
         on PRIMARY_COLUMN_USAGE.CONSTRAINT_NAME       = PRIMARY_KEYS.CONSTRAINT_NAME
 where TABLE_CONSTRAINTS.CONSTRAINT_TYPE = 'FOREIGN KEY'



GO


Grant Select on dbo.vwSqlForeignKeys to public;
GO

