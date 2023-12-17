
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
-- 01/02/2012 Paul.  Add iCal TZID. 
if not exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TIMEZONES' and COLUMN_NAME = 'TZID') begin -- then
	print 'alter table TIMEZONES add TZID nvarchar(50) null';
	alter table TIMEZONES add TZID nvarchar(50) null;
end -- if;
GO

-- 03/26/2013 Paul.  iCloud uses linked_timezone values from http://tzinfo.rubyforge.org/doc/. 
if not exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'TIMEZONES' and COLUMN_NAME = 'LINKED_TIMEZONE') begin -- then
	print 'alter table TIMEZONES add LINKED_TIMEZONE nvarchar(50) null';
	alter table TIMEZONES add LINKED_TIMEZONE nvarchar(50) null;
end -- if;
GO


