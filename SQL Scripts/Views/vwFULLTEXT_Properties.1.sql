if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwFULLTEXT_Properties')
	Drop View dbo.vwFULLTEXT_Properties;
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
Create View dbo.vwFULLTEXT_Properties
as
select substring(@@version, 1, charindex(char(10), @@version)) as SQL_SERVER_VERSION
     , ServerProperty('Edition')             as SQL_SERVER_EDITION
     , db_name()                             as DATABASE_NAME
     , ServerProperty('IsFullTextInstalled') as FULLTEXT_INSTALLED
     , (select fulltext_catalog_id from sys.fulltext_catalogs where name = db_name() + 'Catalog') as FULLTEXT_CATALOG_ID
     , (select 1 from sys.fulltext_document_types where document_type = '.pptx') as OFFICE_DOCUMENT_TYPE
     , (select 1 from sys.fulltext_document_types where document_type = '.pdf' ) as PDF_DOCUMENT_TYPE
GO

Grant Select on dbo.vwFULLTEXT_Properties to public;
GO

-- select * from vwFULLTEXT_Properties

