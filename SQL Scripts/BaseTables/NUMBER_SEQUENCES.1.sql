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
-- 07/25/2009 Paul.  We need the number sequences table to be high-performance, 
-- so make sure that nothing is nullable so that we never have to check. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 01/12/2010 Paul.  Oracle does not like allowing an empty string in a not null field. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'NUMBER_SEQUENCES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.NUMBER_SEQUENCES';
	Create Table dbo.NUMBER_SEQUENCES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_NUMBER_SEQUENCES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, NAME                               nvarchar(60) not null
		, ALPHA_PREFIX                       nvarchar(10) null default('')
		, ALPHA_SUFFIX                       nvarchar(10) null default('')
		, SEQUENCE_STEP                      int not null default(1)
		, NUMERIC_PADDING                    int not null default(0)
		, CURRENT_VALUE                      int not null default(0)
		)

	create index IDX_NUMBER_SEQUENCES_NAME on dbo.NUMBER_SEQUENCES (NAME, DELETED)
  end
GO

