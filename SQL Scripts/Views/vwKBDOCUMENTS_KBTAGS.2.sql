if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwKBDOCUMENTS_KBTAGS')
	Drop View dbo.vwKBDOCUMENTS_KBTAGS;
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
Create View dbo.vwKBDOCUMENTS_KBTAGS
as
select KBDOCUMENTS.ID               as KBDOCUMENT_ID
     , vwKBTAGS.ID                  as KBTAG_ID
     , vwKBTAGS.FULL_TAG_NAME       as KBTAG_NAME
     , vwKBTAGS.NAME
     , vwKBTAGS.FULL_TAG_NAME
  from           KBDOCUMENTS
      inner join KBDOCUMENTS_KBTAGS
              on KBDOCUMENTS_KBTAGS.KBDOCUMENT_ID = KBDOCUMENTS.ID
             and KBDOCUMENTS_KBTAGS.DELETED       = 0
      inner join vwKBTAGS
              on vwKBTAGS.ID                      = KBDOCUMENTS_KBTAGS.KBTAG_ID
 where KBDOCUMENTS.DELETED = 0

GO

Grant Select on dbo.vwKBDOCUMENTS_KBTAGS to public;
GO


