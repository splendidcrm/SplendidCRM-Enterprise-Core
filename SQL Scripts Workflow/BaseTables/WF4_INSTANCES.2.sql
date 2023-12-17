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
-- 06/13/2016 Paul.  Similar to InstancesTable.
-- drop table WF4_INSTANCES;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WF4_INSTANCES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WF4_INSTANCES';
	Create Table dbo.WF4_INSTANCES
		( ID                                 uniqueidentifier not null constraint PK_WF4_INSTANCES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())     -- CreationTime
		, DATE_MODIFIED_UTC                  datetime not null default(getutcdate())  -- LastUpdated

		, SURROGATE_INSTANCE_ID              uniqueidentifier null      -- SurrogateInstanceId             
		, SURROGATE_LOCK_OWNER_ID            uniqueidentifier null      -- SurrogateLockOwnerId            
		, PRIMITIVE_DATA_PROPERTIES          varbinary(max) null        -- PrimitiveDataProperties         
		, COMPLEX_DATA_PROPERTIES            varbinary(max) null        -- ComplexDataProperties           
		, WRITE_ONLY_PRIMITIVE_DATA_PROP     varbinary(max) null        -- WriteOnlyPrimitiveDataProperties
		, WRITE_ONLY_COMPLEX_DATA_PROP       varbinary(max) null        -- WriteOnlyComplexDataProperties  
		, METADATA_PROPERTIES                varbinary(max) null        -- MetadataProperties              
		, DATA_ENCODING_OPTION               tinyint null default(0)    -- DataEncodingOption              
		, METADATA_ENCODING_OPTION           tinyint null default(0)    -- MetadataEncodingOption          
		, VERSION                            bigint null                -- Version                         
		, PENDING_TIMER                      datetime null              -- PendingTimer                    
		, WORKFLOW_HOST_TYPE                 uniqueidentifier null      -- WorkflowHostType                
		, SERVICE_DEPLOYMENT_ID              uniqueidentifier null      -- ServiceDeploymentId             
		, SUSPENSION_EXCEPTION_NAME          nvarchar(450) null         -- SuspensionExceptionName         
		, SUSPENSION_REASON                  nvarchar(max) null         -- SuspensionReason                
		, BLOCKING_BOOKMARKS                 nvarchar(max) null         -- BlockingBookmarks               
		, LAST_MACHINE_RUN_ON                nvarchar(450) null         -- LastMachineRunOn                
		, EXECUTION_STATUS                   nvarchar(450) null         -- ExecutionStatus                 
		, IS_INITIALIZED                     bit null default(0)        -- IsInitialized                   
		, IS_SUSPENDED                       bit null default(0)        -- IsSuspended                     
		, IS_READY_TO_RUN                    bit null default(0)        -- IsReadyToRun                    
		, IS_COMPLETED                       bit null default(0)        -- IsCompleted                     
		, SURROGATE_IDENTITY_ID              uniqueidentifier null      -- SurrogateIdentityId             
		, DEFINITION_IDENTITY_ID             uniqueidentifier null
		)

	create index IDX_WF4_INSTANCES_DATE_ENTERED  on dbo.WF4_INSTANCES (DATE_ENTERED)
	create index IDX_WF4_INSTANCES_DATE_MODIFIED on dbo.WF4_INSTANCES (DATE_MODIFIED_UTC)
	create index IDX_WF4_INSTANCES_PENDING       on dbo.WF4_INSTANCES (IS_READY_TO_RUN, PENDING_TIMER, IS_COMPLETED, IS_SUSPENDED)
  end
GO

