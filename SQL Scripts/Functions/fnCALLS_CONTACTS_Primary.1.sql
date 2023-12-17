if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'fnCALLS_CONTACTS_Primary' and ROUTINE_TYPE = 'FUNCTION')
	Drop Function dbo.fnCALLS_CONTACTS_Primary;
GO



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
Create Function dbo.fnCALLS_CONTACTS_Primary(@CALL_ID uniqueidentifier)
returns uniqueidentifier
as
  begin
	declare @CONTACT_ID uniqueidentifier;
	select top 1
	       @CONTACT_ID = CONTACT_ID 
	  from      CALLS_CONTACTS
	 inner join CONTACTS
	         on CONTACTS.ID      = CALLS_CONTACTS.CONTACT_ID
	        and CONTACTS.DELETED = 0
	 where CALLS_CONTACTS.CALL_ID = @CALL_ID
	   and CALLS_CONTACTS.DELETED = 0
	 order by rtrim(isnull(CONTACTS.LAST_NAME, N'') + N', ' + isnull(CONTACTS.FIRST_NAME, N''));
	return @CONTACT_ID;
  end
GO

Grant Execute on dbo.fnCALLS_CONTACTS_Primary to public
GO

