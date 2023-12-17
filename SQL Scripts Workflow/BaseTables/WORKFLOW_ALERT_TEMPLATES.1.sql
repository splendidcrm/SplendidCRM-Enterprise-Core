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
-- Drop Table dbo.WORKFLOW_ALERT_TEMPLATES;
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WORKFLOW_ALERT_TEMPLATES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WORKFLOW_ALERT_TEMPLATES';
	Create Table dbo.WORKFLOW_ALERT_TEMPLATES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WORKFLOW_ALERT_TEMPLATES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, NAME                               nvarchar(255) not null
		, BASE_MODULE                        nvarchar(100) not null
		, FROM_ADDR                          nvarchar(100) null
		, FROM_NAME                          nvarchar(100) null
		, DESCRIPTION                        nvarchar(max) null
		, SUBJECT                            nvarchar(255) null
		, BODY                               nvarchar(max) null
		, BODY_HTML                          nvarchar(max) null
		)
  end
GO


