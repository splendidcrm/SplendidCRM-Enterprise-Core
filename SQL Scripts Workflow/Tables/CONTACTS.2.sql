
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
-- 03/05/2009 Paul.  Add PORTAL_PASSWORD for Splendid Portal.  Sugar added it in 4.5.0. 
if not exists(select *
                from      sysobjects
               inner join syscolumns
                       on syscolumns.id = sysobjects.id
               where sysobjects.name = 'CONTACTS'
                 and syscolumns.name = 'PORTAL_PASSWORD')
  begin -- then
	print 'alter table CONTACTS add PORTAL_PASSWORD nvarchar(32) null';
	alter table CONTACTS add PORTAL_PASSWORD nvarchar(32) null;

	create index IDX_CONTACTS_PORTAL on dbo.CONTACTS (DELETED, PORTAL_ACTIVE, PORTAL_NAME, PORTAL_PASSWORD, ID)
  end -- if;
GO

