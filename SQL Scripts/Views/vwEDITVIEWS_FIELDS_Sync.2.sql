if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEDITVIEWS_FIELDS_Sync')
	Drop View dbo.vwEDITVIEWS_FIELDS_Sync;
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
Create View dbo.vwEDITVIEWS_FIELDS_Sync
as
select ID
     , DELETED
     , CREATED_BY
     , DATE_ENTERED
     , MODIFIED_USER_ID
     , DATE_MODIFIED
     , DATE_MODIFIED_UTC
     , EDIT_NAME
     , FIELD_INDEX
     , FIELD_TYPE
     , DEFAULT_VIEW
     , DATA_LABEL
     , DATA_FIELD
     , DATA_FORMAT
     , DISPLAY_FIELD
     , CACHE_NAME
     , DATA_REQUIRED
     , UI_REQUIRED
     , ONCLICK_SCRIPT
     , FORMAT_SCRIPT
     , FORMAT_TAB_INDEX
     , FORMAT_MAX_LENGTH
     , FORMAT_SIZE
     , FORMAT_ROWS
     , FORMAT_COLUMNS
     , COLSPAN
     , ROWSPAN
     , FIELD_VALIDATOR_ID
     , FIELD_VALIDATOR_MESSAGE
     , MODULE_TYPE
     , TOOL_TIP
     , RELATED_SOURCE_MODULE_NAME
     , RELATED_SOURCE_VIEW_NAME
     , RELATED_SOURCE_ID_FIELD
     , RELATED_SOURCE_NAME_FIELD
     , RELATED_VIEW_NAME
     , RELATED_ID_FIELD
     , RELATED_NAME_FIELD
     , RELATED_JOIN_FIELD
     , PARENT_FIELD
  from EDITVIEWS_FIELDS
 where DEFAULT_VIEW = 0
   and (   EDIT_NAME like '%.EditView'
        or EDIT_NAME like '%.EditView.Mobile'
        or EDIT_NAME like '%.SearchBasic'
        or EDIT_NAME like '%.SearchBasic.Mobile'
        or EDIT_NAME like '%.SearchPopup'
       )

GO

Grant Select on dbo.vwEDITVIEWS_FIELDS_Sync to public;
GO

