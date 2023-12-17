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
-- 04/21/2006 Paul.  MORE_INFORMATION was added in SugarCRM 4.2.
-- 09/10/2007 Paul.  MARKETING_ID was added in SugarCRM 4.5.1.
-- 12/20/2007 Paul.  ACTIVITY_DATE should default to now. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CAMPAIGN_LOG' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CAMPAIGN_LOG';
	Create Table dbo.CAMPAIGN_LOG
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CAMPAIGN_LOG primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, CAMPAIGN_ID                        uniqueidentifier null
		, TARGET_TRACKER_KEY                 uniqueidentifier null
		, TARGET_ID                          uniqueidentifier null
		, TARGET_TYPE                        nvarchar(25) null
		, ACTIVITY_TYPE                      nvarchar(25) null
		, ACTIVITY_DATE                      datetime null default(getdate())
		, RELATED_ID                         uniqueidentifier null
		, RELATED_TYPE                       nvarchar(25) null
		, ARCHIVED                           bit null default(0)
		, HITS                               int null default(0)
		, LIST_ID                            uniqueidentifier null
		, MORE_INFORMATION                   nvarchar(100) null
		, MARKETING_ID                       uniqueidentifier null
		)

	create index IDX_CAMPAIGN_LOG_TARGET_TRACKER_KEY on dbo.CAMPAIGN_LOG (TARGET_TRACKER_KEY)
	create index IDX_CAMPAIGN_LOG_CAMPAIGN_ID        on dbo.CAMPAIGN_LOG (CAMPAIGN_ID       )
	create index IDX_CAMPAIGN_LOG_MORE_INFORMATION   on dbo.CAMPAIGN_LOG (RELATED_ID, MORE_INFORMATION, ID)
  end
GO


