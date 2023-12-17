if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROSPECTS_Edit')
	Drop View dbo.vwPROSPECTS_Edit;
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
-- 08/12/2021 Paul.  Add Machine Learning prediction fields. 
Create View dbo.vwPROSPECTS_Edit
as
select vwPROSPECTS.*
     , dbo.fnFullAddressHtml(vwPROSPECTS.PRIMARY_ADDRESS_STREET, vwPROSPECTS.PRIMARY_ADDRESS_CITY, vwPROSPECTS.PRIMARY_ADDRESS_STATE, vwPROSPECTS.PRIMARY_ADDRESS_POSTALCODE, vwPROSPECTS.PRIMARY_ADDRESS_COUNTRY) as PRIMARY_ADDRESS_HTML
     , dbo.fnFullAddressHtml(vwPROSPECTS.ALT_ADDRESS_STREET    , vwPROSPECTS.ALT_ADDRESS_CITY    , vwPROSPECTS.ALT_ADDRESS_STATE    , vwPROSPECTS.ALT_ADDRESS_POSTALCODE    , vwPROSPECTS.ALT_ADDRESS_COUNTRY    ) as ALT_ADDRESS_HTML
     , PROSPECTS_PREDICTIONS.PROBABILITY
     , PROSPECTS_PREDICTIONS.SCORE
     , PROSPECTS_PREDICTIONS.PREDICTION
  from            vwPROSPECTS
  left outer join PROSPECTS
               on PROSPECTS.ID = vwPROSPECTS.ID
  left outer join PROSPECTS_PREDICTIONS
               on PROSPECTS_PREDICTIONS.PROSPECT_ID = vwPROSPECTS.ID
              and PROSPECTS_PREDICTIONS.DELETED     = 0

GO

Grant Select on dbo.vwPROSPECTS_Edit to public;
GO


