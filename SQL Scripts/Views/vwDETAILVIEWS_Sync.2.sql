if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDETAILVIEWS_Sync')
	Drop View dbo.vwDETAILVIEWS_Sync;
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
-- 01/25/2015 Paul.  Include Mobile views for Offline Client for iOS. 
Create View dbo.vwDETAILVIEWS_Sync
as
select ID
     , DELETED
     , CREATED_BY
     , DATE_ENTERED
     , MODIFIED_USER_ID
     , DATE_MODIFIED
     , DATE_MODIFIED_UTC
     , NAME
     , MODULE_NAME
     , VIEW_NAME
     , LABEL_WIDTH
     , FIELD_WIDTH
     , DATA_COLUMNS
     , PRE_LOAD_EVENT_ID
     , POST_LOAD_EVENT_ID
     , SCRIPT
  from DETAILVIEWS
 where NAME like '%.DetailView'
    or NAME like '%.DetailView.Mobile'

GO

Grant Select on dbo.vwDETAILVIEWS_Sync to public;
GO

