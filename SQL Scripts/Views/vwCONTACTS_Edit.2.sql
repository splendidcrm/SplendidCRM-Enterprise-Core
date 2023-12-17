if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_Edit')
	Drop View dbo.vwCONTACTS_Edit;
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
-- 02/09/2006 Paul.  SugarCRM uses the CONTACTS_USERS table to allow each user to 
-- choose the contacts they want sync'd with Outlook. 
-- This view requires that the USER_ID be set, otherwise too many records will be returned 
-- due to the CONTACTS_USERS join.
-- 03/06/2006 Paul.  The join to CONTACTS_USERS must occur external to the view. 
-- This is the only way to ensure that the record is always returned, with the sync flag set. 
-- 11/08/2008 Paul.  Move description to base view. 
-- 03/05/2009 Paul.  Add PORTAL_PASSWORD for Splendid Portal.  Sugar added it in 4.5.0. 
-- 08/19/2016 Paul.  Add support for Business Processes. 
-- 08/12/2021 Paul.  Add Machine Learning prediction fields. 
Create View dbo.vwCONTACTS_Edit
as
select vwCONTACTS.*
     , dbo.fnFullAddressHtml(vwCONTACTS.PRIMARY_ADDRESS_STREET, vwCONTACTS.PRIMARY_ADDRESS_CITY, vwCONTACTS.PRIMARY_ADDRESS_STATE, vwCONTACTS.PRIMARY_ADDRESS_POSTALCODE, vwCONTACTS.PRIMARY_ADDRESS_COUNTRY) as PRIMARY_ADDRESS_HTML
     , dbo.fnFullAddressHtml(vwCONTACTS.ALT_ADDRESS_STREET    , vwCONTACTS.ALT_ADDRESS_CITY    , vwCONTACTS.ALT_ADDRESS_STATE    , vwCONTACTS.ALT_ADDRESS_POSTALCODE    , vwCONTACTS.ALT_ADDRESS_COUNTRY    ) as ALT_ADDRESS_HTML
     , CONTACTS.PORTAL_PASSWORD
     , CONTACTS_PREDICTIONS.PROBABILITY
     , CONTACTS_PREDICTIONS.SCORE
     , CONTACTS_PREDICTIONS.PREDICTION
  from            vwCONTACTS
  left outer join CONTACTS
               on CONTACTS.ID               = vwCONTACTS.ID
  left outer join CONTACTS_PREDICTIONS
               on CONTACTS_PREDICTIONS.CONTACT_ID  = vwCONTACTS.ID
              and CONTACTS_PREDICTIONS.DELETED     = 0

GO

Grant Select on dbo.vwCONTACTS_Edit to public;
GO


