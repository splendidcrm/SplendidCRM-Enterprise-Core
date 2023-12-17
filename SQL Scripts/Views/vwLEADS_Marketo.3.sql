if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwLEADS_Marketo')
	Drop View dbo.vwLEADS_Marketo;
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
-- 04/28/2015 Paul.  Marketo will reject any contact without an email. 
-- 04/28/2015 Paul.  Marketo will reject duplicate contacts based on the email uniqueness. 
Create View dbo.vwLEADS_Marketo
as
select *
  from vwLEADS
 where NAME is not null
   and EMAIL1 is not null
   and EMAIL1 in (select EMAIL1
                    from vwLEADS
                   group by EMAIL1
                  having count(*) = 1
                 )

GO

Grant Select on dbo.vwLEADS_Marketo to public;
GO

