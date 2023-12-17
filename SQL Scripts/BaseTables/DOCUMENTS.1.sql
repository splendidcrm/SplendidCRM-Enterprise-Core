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
-- 04/21/2006 Paul.  MAIL_MERGE_DOCUMENT was added in SugarCRM 4.0.
-- 04/21/2006 Paul.  RELATED_DOC_ID was added in SugarCRM 4.2.
-- 04/21/2006 Paul.  RELATED_DOC_REV_ID was added in SugarCRM 4.2.
-- 04/21/2006 Paul.  IS_TEMPLATE was added in SugarCRM 4.2.
-- 04/21/2006 Paul.  TEMPLATE_TYPE was added in SugarCRM 4.2.
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 05/15/2011 Paul.  We need to include the Master and Secondary so that the user selects the correct template. 
-- 04/02/2012 Paul.  Add ASSIGNED_USER_ID. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'DOCUMENTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.DOCUMENTS';
	Create Table dbo.DOCUMENTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_DOCUMENTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, DOCUMENT_NAME                      nvarchar(255) not null
		, ACTIVE_DATE                        datetime null
		, EXP_DATE                           datetime null
		, DESCRIPTION                        nvarchar(max) null
		, CATEGORY_ID                        nvarchar(25) null
		, SUBCATEGORY_ID                     nvarchar(25) null
		, STATUS_ID                          nvarchar(25) null
		, DOCUMENT_REVISION_ID               uniqueidentifier null
		, MAIL_MERGE_DOCUMENT                bit null default(0)
		, RELATED_DOC_ID                     uniqueidentifier null
		, RELATED_DOC_REV_ID                 uniqueidentifier null
		, IS_TEMPLATE                        bit null default(0)
		, TEMPLATE_TYPE                      nvarchar(25) null
		, PRIMARY_MODULE                     nvarchar(25) null
		, SECONDARY_MODULE                   nvarchar(25) null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		)

	create index IDX_DOCUMENTS_TEAM_ID          on dbo.DOCUMENTS (TEAM_ID, DELETED, ID)
	create index IDX_DOCUMENTS_ASSIGNED_USER_ID on dbo.DOCUMENTS (ASSIGNED_USER_ID, DELETED, ID)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_DOCUMENTS_TEAM_SET_ID      on dbo.DOCUMENTS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_DOCUMENTS_ASSIGNED_SET_ID  on dbo.DOCUMENTS (ASSIGNED_SET_ID, DELETED, ID)
  end
GO

