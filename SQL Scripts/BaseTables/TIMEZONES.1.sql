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
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 01/02/2012 Paul.  Add iCal TZID. 
-- 03/26/2013 Paul.  iCloud uses linked_timezone values from http://tzinfo.rubyforge.org/doc/. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TIMEZONES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.TIMEZONES';
	Create Table dbo.TIMEZONES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_TIMEZONES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, NAME                               nvarchar(100) not null
		, STANDARD_NAME                      nvarchar(100) null
		, STANDARD_ABBREVIATION              nvarchar( 10) null
		, DAYLIGHT_NAME                      nvarchar(100) null
		, DAYLIGHT_ABBREVIATION              nvarchar( 10) null
		, BIAS                               int null
		, STANDARD_BIAS                      int null
		, DAYLIGHT_BIAS                      int null

		, STANDARD_YEAR                      int null
		, STANDARD_MONTH                     int null
		, STANDARD_WEEK                      int null
		, STANDARD_DAYOFWEEK                 int null
		, STANDARD_HOUR                      int null
		, STANDARD_MINUTE                    int null

		, DAYLIGHT_YEAR                      int null
		, DAYLIGHT_MONTH                     int null
		, DAYLIGHT_WEEK                      int null
		, DAYLIGHT_DAYOFWEEK                 int null
		, DAYLIGHT_HOUR                      int null
		, DAYLIGHT_MINUTE                    int null
		, TZID                               nvarchar(50) null
		, LINKED_TIMEZONE                    nvarchar(50) null
		)

	create index IX_TIMEZONES_NAME on dbo.TIMEZONES(NAME)
  end
GO


