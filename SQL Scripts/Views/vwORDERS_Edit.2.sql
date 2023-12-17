if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwORDERS_Edit')
	Drop View dbo.vwORDERS_Edit;
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
-- 11/08/2008 Paul.  Move description to base view. 
Create View dbo.vwORDERS_Edit
as
select vwORDERS.*
     , dbo.fnFullAddressHtml(vwORDERS.BILLING_ADDRESS_STREET , vwORDERS.BILLING_ADDRESS_CITY , vwORDERS.BILLING_ADDRESS_STATE , vwORDERS.BILLING_ADDRESS_POSTALCODE , vwORDERS.BILLING_ADDRESS_COUNTRY ) as BILLING_ADDRESS_HTML
     , dbo.fnFullAddressHtml(vwORDERS.SHIPPING_ADDRESS_STREET, vwORDERS.SHIPPING_ADDRESS_CITY, vwORDERS.SHIPPING_ADDRESS_STATE, vwORDERS.SHIPPING_ADDRESS_POSTALCODE, vwORDERS.SHIPPING_ADDRESS_COUNTRY) as SHIPPING_ADDRESS_HTML
  from            vwORDERS
  left outer join ORDERS
               on ORDERS.ID = vwORDERS.ID

GO

Grant Select on dbo.vwORDERS_Edit to public;
GO


