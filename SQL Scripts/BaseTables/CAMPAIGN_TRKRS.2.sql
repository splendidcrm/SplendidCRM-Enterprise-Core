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
-- 04/21/2006 Paul.  Added in SugarCRM 4.2.
-- 07/25/2009 Paul.  TRACKER_KEY is now a string. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CAMPAIGN_TRKRS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CAMPAIGN_TRKRS';
	Create Table dbo.CAMPAIGN_TRKRS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CAMPAIGN_TRKRS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, TRACKER_NAME                       nvarchar( 30) null
		, TRACKER_URL                        nvarchar(255) null default('http://')
		, TRACKER_KEY                        nvarchar( 30) null
		, CAMPAIGN_ID                        uniqueidentifier null
		, IS_OPTOUT                          bit null default(0)
		)

	create index IDX_CAMPAIGN_TRKRS_TRACKER_KEY on dbo.CAMPAIGN_TRKRS (TRACKER_KEY, ID, DELETED)

	alter table dbo.CAMPAIGN_TRKRS add constraint FK_CAMPAIGN_TRKRS_CAMPAIGN_ID foreign key ( CAMPAIGN_ID) references dbo.CAMPAIGNS ( ID )
  end
GO


