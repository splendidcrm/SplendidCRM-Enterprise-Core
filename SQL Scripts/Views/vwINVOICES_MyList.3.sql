if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwINVOICES_MyList')
	Drop View dbo.vwINVOICES_MyList;
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
-- 11/04/2010 Paul.  Only show invoices that are due, or was cancelled in the last month. 
-- 04/05/2013 Paul.  Include Paid so that the records will appear on the portal. 
-- 05/13/2014 Paul.  Allow customers to pay when Under Review. 
-- 03/31/2016 Paul.  Signed stage used after signature has been acquired. 
Create View dbo.vwINVOICES_MyList
as
select *
  from vwINVOICES_List
 where  INVOICE_STAGE is null
    or  INVOICE_STAGE like N'Due%'
    or  INVOICE_STAGE like N'Net%'
    or  INVOICE_STAGE in (N'Paid', N'Under Review', N'Pending Signature')
    or (INVOICE_STAGE in (N'Cancelled', N'Refunded') and dbo.fnDateAdd('month', 1, DATE_MODIFIED) > getdate())
GO

Grant Select on dbo.vwINVOICES_MyList to public;
GO

