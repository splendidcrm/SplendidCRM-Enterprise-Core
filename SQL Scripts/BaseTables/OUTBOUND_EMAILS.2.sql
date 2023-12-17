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
-- 07/16/2013 Paul.  USER_ID should be nullable so that table can contain system email accounts. 
-- 04/20/2016 Paul.  Add team management to Outbound Emails. 
-- 01/17/2017 Paul.  Increase size of @MAIL_SENDTYPE to fit office365. 
-- drop table dbo.OUTBOUND_EMAILS;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'OUTBOUND_EMAILS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.OUTBOUND_EMAILS';
	Create Table dbo.OUTBOUND_EMAILS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_OUTBOUND_EMAILS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, NAME                               nvarchar(50) null default('system')
		, TYPE                               nvarchar(15) null default('user')
		, USER_ID                            uniqueidentifier null
		, MAIL_SENDTYPE                      nvarchar(25) null default('smtp')
		, MAIL_SMTPTYPE                      nvarchar(20) null default('other')
		, MAIL_SMTPSERVER                    nvarchar(100) null
		, MAIL_SMTPPORT                      int null default(0)
		, MAIL_SMTPUSER                      nvarchar(100) null
		, MAIL_SMTPPASS                      nvarchar(100) null
		, MAIL_SMTPAUTH_REQ                  bit null default(0)
		, MAIL_SMTPSSL                       int null default(0)
		, FROM_NAME                          nvarchar(100) null
		, FROM_ADDR                          nvarchar(100) null
		, TEAM_ID                            uniqueidentifier null
		, TEAM_SET_ID                        uniqueidentifier null
		)

	create index IDX_OUTBOUND_EMAILS_USER_ID on dbo.OUTBOUND_EMAILS (USER_ID, TYPE, DELETED, ID)
  end
GO

