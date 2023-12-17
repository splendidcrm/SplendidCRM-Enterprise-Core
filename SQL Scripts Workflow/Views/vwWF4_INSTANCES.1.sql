if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwWF4_INSTANCES')
	Drop View dbo.vwWF4_INSTANCES;
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
Create View dbo.vwWF4_INSTANCES
as
select WF4_INSTANCES.ID
     , WF4_INSTANCES.SURROGATE_IDENTITY_ID          -- CRM_ID 
     , WF4_INSTANCES.PENDING_TIMER                  -- PendingTimer
     , WF4_INSTANCES.BLOCKING_BOOKMARKS             -- ActiveBookmarks
     , WF4_INSTANCES.EXECUTION_STATUS               -- ExecutionStatus
     , WF4_INSTANCES.IS_INITIALIZED                 -- IsInitialized
     , WF4_INSTANCES.IS_SUSPENDED                   -- IsSuspended
     , WF4_INSTANCES.IS_COMPLETED                   -- IsCompleted
     , WF4_INSTANCES.IS_READY_TO_RUN                -- IsReadyToRun
     , WF4_INSTANCES.DATE_ENTERED                   -- CreationTime
     , WF4_INSTANCES.DATE_MODIFIED_UTC              -- LastUpdatedTime
     , WF4_INSTANCES.DEFINITION_IDENTITY_ID
     , WF4_INSTANCES.SUSPENSION_EXCEPTION_NAME      -- SuspensionExceptionName
     , WF4_INSTANCES.SUSPENSION_REASON              -- SuspensionReason
     , WF4_INSTANCES.PRIMITIVE_DATA_PROPERTIES      -- PrimitiveDataProperties
     , WF4_INSTANCES.WRITE_ONLY_PRIMITIVE_DATA_PROP
     , WF4_INSTANCES.COMPLEX_DATA_PROPERTIES        -- ComplexDataProperties
     , WF4_INSTANCES.WRITE_ONLY_COMPLEX_DATA_PROP
     , WF4_INSTANCES.METADATA_PROPERTIES            -- MetadataProperties
     , WF4_DEFINITION_IDENTITY.XAML
  from            WF4_INSTANCES
  left outer join WF4_DEFINITION_IDENTITY
               on WF4_DEFINITION_IDENTITY.ID = WF4_INSTANCES.DEFINITION_IDENTITY_ID

GO

Grant Select on dbo.vwWF4_INSTANCES to public;
GO

