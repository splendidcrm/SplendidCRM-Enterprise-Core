if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCREDIT_CARDS_Edit')
	Drop View dbo.vwCREDIT_CARDS_Edit;
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
-- 08/16/2015 Paul.  Add CARD_TOKEN for use with PayPal REST API. 
Create View dbo.vwCREDIT_CARDS_Edit
as
select vwCREDIT_CARDS.*
     , CREDIT_CARDS.CARD_NUMBER
     , CREDIT_CARDS.CARD_TOKEN
  from      vwCREDIT_CARDS
 inner join CREDIT_CARDS
         on CREDIT_CARDS.ID = vwCREDIT_CARDS.ID

GO

Grant Select on dbo.vwCREDIT_CARDS_Edit to public;
GO


