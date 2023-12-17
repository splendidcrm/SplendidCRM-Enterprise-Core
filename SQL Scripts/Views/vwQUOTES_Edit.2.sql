if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwQUOTES_Edit')
	Drop View dbo.vwQUOTES_Edit;
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
Create View dbo.vwQUOTES_Edit
as
select vwQUOTES.*
     , dbo.fnFullAddressHtml(vwQUOTES.BILLING_ADDRESS_STREET , vwQUOTES.BILLING_ADDRESS_CITY , vwQUOTES.BILLING_ADDRESS_STATE , vwQUOTES.BILLING_ADDRESS_POSTALCODE , vwQUOTES.BILLING_ADDRESS_COUNTRY ) as BILLING_ADDRESS_HTML
     , dbo.fnFullAddressHtml(vwQUOTES.SHIPPING_ADDRESS_STREET, vwQUOTES.SHIPPING_ADDRESS_CITY, vwQUOTES.SHIPPING_ADDRESS_STATE, vwQUOTES.SHIPPING_ADDRESS_POSTALCODE, vwQUOTES.SHIPPING_ADDRESS_COUNTRY) as SHIPPING_ADDRESS_HTML
  from            vwQUOTES
  left outer join QUOTES
               on QUOTES.ID = vwQUOTES.ID

GO

Grant Select on dbo.vwQUOTES_Edit to public;
GO


