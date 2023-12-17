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
-- 04/21/2006 Paul.  SERVICE increased to nvarchar(50) in SugarCRM 4.0.1.
-- 12/24/2007 Paul.  Sugar uses STORED_OPTIONS for options, but return address is too important to place there. 
-- 01/08/2008 Paul.  Separate out MAILBOX_SSL for ease of coding. Sugar combines it an TLS into the SERVICE field. 
-- 01/13/2008 Paul.  Move MAILBOX_SSL as it is associated with the PORT. 
-- 01/13/2008 Paul.  ONLY_SINCE will not be stored in STORED_OPTIONS because we need high-performance access. 
-- 01/13/2008 Paul.  Correct spelling of DELETE_SEEN, which is the reverse of MARK_READ. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 04/19/2011 Paul.  Add IS_PERSONAL to exclude EmailClient inbound from being included in monitored list. 
-- 01/23/2013 Paul.  Add REPLY_TO_NAME and REPLY_TO_ADDR. 
-- 05/24/2014 Paul.  We need to track the Last Email UID in order to support Only Since flag. 
-- 01/26/2017 Paul.  LAST_EMAIL_UID needs to be a bigint to support Gmail API internalDate value. 
-- 01/28/2017 Paul.  EXCHANGE_WATERMARK for support of Exchange and Office365.
-- 01/28/2017 Paul.  GROUP_TEAM_ID for inbound emails. 
-- 03/29/2017 Paul.  SERVER_URL, EMAIL_USER, EMAIL_PASSWORD, PORT are all nullable. 
-- 07/19/2023 Paul.  Increase size of EXCHANGE_WATERMARK to 1000.  Badly formed token. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'INBOUND_EMAILS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.INBOUND_EMAILS';
	Create Table dbo.INBOUND_EMAILS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_INBOUND_EMAILS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, NAME                               nvarchar(255) null
		, STATUS                             nvarchar(25) not null default('Active')
		, SERVER_URL                         nvarchar(100) null
		, EMAIL_USER                         nvarchar(100) null
		, EMAIL_PASSWORD                     nvarchar(100) null
		, PORT                               int null
		, MAILBOX_SSL                        bit null
		, SERVICE                            nvarchar(50) not null
		, MAILBOX                            nvarchar(50) not null
		, DELETE_SEEN                        bit null default(0)
		, ONLY_SINCE                         bit null default(0)
		, MAILBOX_TYPE                       nvarchar(10) null
		, TEMPLATE_ID                        uniqueidentifier null
		, STORED_OPTIONS                     nvarchar(max) null
		, GROUP_ID                           uniqueidentifier null
		, GROUP_TEAM_ID                      uniqueidentifier null
		, FROM_NAME                          nvarchar(100) null
		, FROM_ADDR                          nvarchar(100) null
		, FILTER_DOMAIN                      nvarchar(100) null
		, IS_PERSONAL                        bit null default(0)
		, REPLY_TO_NAME                      nvarchar(100) null
		, REPLY_TO_ADDR                      nvarchar(100) null
		, LAST_EMAIL_UID                     bigint null default(0)
		, EXCHANGE_WATERMARK                 varchar(1000) null
		)

	create index IDX_INBOUND_EMAILS on dbo.INBOUND_EMAILS (DELETED, STATUS, MAILBOX_TYPE, IS_PERSONAL, ID)
  end
GO


