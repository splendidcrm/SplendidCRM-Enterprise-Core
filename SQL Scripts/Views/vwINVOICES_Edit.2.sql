if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwINVOICES_Edit')
	Drop View dbo.vwINVOICES_Edit;
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
Create View dbo.vwINVOICES_Edit
as
select vwINVOICES.*
     , dbo.fnFullAddressHtml(vwINVOICES.BILLING_ADDRESS_STREET , vwINVOICES.BILLING_ADDRESS_CITY , vwINVOICES.BILLING_ADDRESS_STATE , vwINVOICES.BILLING_ADDRESS_POSTALCODE , vwINVOICES.BILLING_ADDRESS_COUNTRY ) as BILLING_ADDRESS_HTML
     , dbo.fnFullAddressHtml(vwINVOICES.SHIPPING_ADDRESS_STREET, vwINVOICES.SHIPPING_ADDRESS_CITY, vwINVOICES.SHIPPING_ADDRESS_STATE, vwINVOICES.SHIPPING_ADDRESS_POSTALCODE, vwINVOICES.SHIPPING_ADDRESS_COUNTRY) as SHIPPING_ADDRESS_HTML
  from            vwINVOICES
  left outer join INVOICES
               on INVOICES.ID = vwINVOICES.ID

GO

Grant Select on dbo.vwINVOICES_Edit to public;
GO


