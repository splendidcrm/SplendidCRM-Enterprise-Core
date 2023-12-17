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
-- 04/21/2006 Paul.  Added in SugarCRM 4.0.
-- 01/13/2008 Paul.  Change index to include the date so that it will be a covered index. 
-- 01/13/2008 Paul.  Add the reply name so that this lis can be used by the email manager. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'INBOUND_EMAIL_AUTOREPLY' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.INBOUND_EMAIL_AUTOREPLY';
	Create Table dbo.INBOUND_EMAIL_AUTOREPLY
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_INBOUND_EMAIL_AUTOREPLY primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, AUTOREPLIED_TO                     nvarchar(100) null
		, AUTOREPLIED_NAME                   nvarchar(100) null
		)

	create index IDX_INBOUND_EMAIL on dbo.INBOUND_EMAIL_AUTOREPLY (AUTOREPLIED_TO, DATE_ENTERED, DELETED, AUTOREPLIED_NAME)
  end
GO

