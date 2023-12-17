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
-- 01/11/2010 Paul.  Move to Tables folder. 
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'KBDOCUMENT_KBTAGS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Drop Table dbo.KBDOCUMENT_KBTAGS';
	insert into KBDOCUMENTS_KBTAGS
		( ID
		, DELETED
		, CREATED_BY
		, DATE_ENTERED
		, MODIFIED_USER_ID
		, DATE_MODIFIED
		, KBDOCUMENT_ID
		, KBTAG_ID
		)
	select	  ID
		, DELETED
		, CREATED_BY
		, DATE_ENTERED
		, MODIFIED_USER_ID
		, DATE_MODIFIED
		, KBDOCUMENT_ID
		, KBTAG_ID
	  from KBDOCUMENT_KBTAGS
	 where ID not in (select ID from KBDOCUMENTS_KBTAGS);
	Drop Table dbo.KBDOCUMENT_KBTAGS;
  end
GO

