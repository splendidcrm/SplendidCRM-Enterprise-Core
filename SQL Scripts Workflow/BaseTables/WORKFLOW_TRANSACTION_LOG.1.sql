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
-- Drop Table WORKFLOW_TRANSACTION_LOG;
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WORKFLOW_TRANSACTION_LOG' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WORKFLOW_TRANSACTION_LOG';
	Create Table dbo.WORKFLOW_TRANSACTION_LOG
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WORKFLOW_TRANSACTION_LOG primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, AUDIT_TABLE                        nvarchar(50) null
		, AUDIT_TOKEN                        varchar(255) null
		, WORKFLOW_ID                        uniqueidentifier null
		, WORKFLOW_INSTANCE_ID               uniqueidentifier null
		)

	create index IDX_WORKFLOW_TRANS_LOG_TOKEN    on WORKFLOW_TRANSACTION_LOG (AUDIT_TOKEN, AUDIT_TABLE, WORKFLOW_ID, WORKFLOW_INSTANCE_ID)
	create index IDX_WORKFLOW_TRANS_LOG_INSTANCE on WORKFLOW_TRANSACTION_LOG (WORKFLOW_INSTANCE_ID, WORKFLOW_ID, AUDIT_TABLE, AUDIT_TOKEN)
  end
GO

