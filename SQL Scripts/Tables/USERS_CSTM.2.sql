
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
-- 08/24/2013 Paul.  Add EXTENSION_C in preparation for Asterisk click-to-call. 
-- 09/20/2013 Paul.  Move EXTENSION to the main table. 
if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'USERS_CSTM' and COLUMN_NAME = 'EXTENSION_C') begin -- then
	print 'Remove USERS_CSTM.EXTENSION_C'
	-- exec dbo.spFIELDS_META_DATA_Insert null, null, 'EXTENSION', 'Extension:', 'EXTENSION', 'Users', 'varchar', 25, 0, 0, null, null, 0;
	exec dbo.spFIELDS_META_DATA_DeleteByName null, 'Users', 'EXTENSION_C';
end -- if;
GO

