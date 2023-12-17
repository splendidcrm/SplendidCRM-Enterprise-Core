
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
-- 10/26/2009 Paul.  Attachment content will be stored in the EMAIL_IMAGES table. 
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'KBDOCUMENTS_IMAGES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Drop Table dbo.KBDOCUMENTS_IMAGES';
	Drop Table dbo.KBDOCUMENTS_IMAGES;
  end
GO

if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'KBDOCUMENT_IMAGES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Drop Table dbo.KBDOCUMENT_IMAGES';
	Drop Table dbo.KBDOCUMENT_IMAGES;
  end
GO

-- 12/22/2015 Paul.  We also need to delete the audit table. 
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'KBDOCUMENTS_IMAGES_AUDIT' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Drop Table dbo.KBDOCUMENTS_IMAGES_AUDIT';
	Drop Table dbo.KBDOCUMENTS_IMAGES_AUDIT;
  end
GO

