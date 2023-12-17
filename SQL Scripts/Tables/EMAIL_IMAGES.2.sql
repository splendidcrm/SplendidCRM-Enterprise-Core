
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
-- 05/17/2017 Paul.  Need to optimize for Azure. CONTENT is null filter is not indexable, so index length field. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_IMAGES' and COLUMN_NAME = 'CONTENT_LENGTH') begin -- then
	print 'alter table EMAIL_IMAGES add CONTENT_LENGTH int null';
	alter table EMAIL_IMAGES add CONTENT_LENGTH int null;

	exec('update EMAIL_IMAGES
	   set CONTENT_LENGTH = datalength(CONTENT);
	create index IDX_EMAIL_IMAGES on dbo.EMAIL_IMAGES (ID, DELETED, CONTENT_LENGTH)');
end -- if;
GO

-- 05/12/2017 Paul.  Need to optimize for Azure. CONTENT is null filter is not indexable, so index length field. 
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EMAIL_IMAGES_AUDIT') begin -- then
	if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'EMAIL_IMAGES_AUDIT' and COLUMN_NAME = 'CONTENT_LENGTH') begin -- then
		print 'alter table EMAIL_IMAGES_AUDIT add CONTENT_LENGTH int null';
		alter table EMAIL_IMAGES_AUDIT add CONTENT_LENGTH int null;
	end -- if;
end -- if;
GO

