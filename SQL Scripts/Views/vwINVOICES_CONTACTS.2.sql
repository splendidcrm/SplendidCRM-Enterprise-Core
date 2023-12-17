if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwINVOICES_CONTACTS')
	Drop View dbo.vwINVOICES_CONTACTS;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwINVOICES_CONTACTS
as
select INVOICES.ID                    as INVOICE_ID
     , INVOICES.ASSIGNED_USER_ID      as INVOICE_ASSIGNED_USER_ID
     , INVOICES.ASSIGNED_SET_ID       as INVOICE_ASSIGNED_SET_ID
     , INVOICES.NAME                  as INVOICE_NAME
     , INVOICES_CONTACTS.CONTACT_ROLE as CONTACT_ROLE
     , vwCONTACTS.ID                  as CONTACT_ID
     , vwCONTACTS.NAME                as CONTACT_NAME
     , vwCONTACTS.*
  from           INVOICES
      inner join INVOICES_CONTACTS
              on INVOICES_CONTACTS.INVOICE_ID = INVOICES.ID
             and INVOICES_CONTACTS.DELETED    = 0
      inner join vwCONTACTS
              on vwCONTACTS.ID                = INVOICES_CONTACTS.CONTACT_ID
 where INVOICES.DELETED = 0

GO

Grant Select on dbo.vwINVOICES_CONTACTS to public;
GO


