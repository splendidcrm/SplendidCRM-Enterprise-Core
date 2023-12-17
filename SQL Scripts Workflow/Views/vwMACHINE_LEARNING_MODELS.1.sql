if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMACHINE_LEARNING_MODELS')
	Drop View dbo.vwMACHINE_LEARNING_MODELS;
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
Create View dbo.vwMACHINE_LEARNING_MODELS
as
select MACHINE_LEARNING_MODELS.ID
     , MACHINE_LEARNING_MODELS.NAME
     , MACHINE_LEARNING_MODELS.BASE_MODULE
     , MACHINE_LEARNING_MODELS.STATUS
     , MACHINE_LEARNING_MODELS.SCENARIO
     , MACHINE_LEARNING_MODELS.TRAIN_SQL_VIEW
     , MACHINE_LEARNING_MODELS.EVALUATE_SQL_VIEW
     , MACHINE_LEARNING_MODELS.GOOD_FIELD_NAME
     , MACHINE_LEARNING_MODELS.USE_CROSS_VALIDATION
     , MACHINE_LEARNING_MODELS.DESCRIPTION
     , MACHINE_LEARNING_MODELS.LAST_TRAINING_DATE
     , MACHINE_LEARNING_MODELS.LAST_TRAINING_COUNT
     , MACHINE_LEARNING_MODELS.LAST_TRAINING_STATUS
     , MACHINE_LEARNING_MODELS.EVALUATION_DATA
     , MACHINE_LEARNING_MODELS.EVALUATION_STATUS
     , MACHINE_LEARNING_MODELS.DATE_ENTERED
     , MACHINE_LEARNING_MODELS.DATE_MODIFIED
     , MACHINE_LEARNING_MODELS.DATE_MODIFIED_UTC
     , USERS_CREATED_BY.USER_NAME             as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME            as MODIFIED_BY
     , MACHINE_LEARNING_MODELS.CREATED_BY     as CREATED_BY_ID
     , MACHINE_LEARNING_MODELS.MODIFIED_USER_ID
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , (case when CONTENT is not null then 1 else 0 end) as IS_MODEL_READY
  from            MACHINE_LEARNING_MODELS
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = MACHINE_LEARNING_MODELS.CREATED_BY
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = MACHINE_LEARNING_MODELS.MODIFIED_USER_ID
 where MACHINE_LEARNING_MODELS.DELETED = 0

GO

Grant Select on dbo.vwMACHINE_LEARNING_MODELS to public;
GO

if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMACHINE_LEARNING_MODELS_Edit')
	exec sp_refreshview vwMACHINE_LEARNING_MODELS_Edit
GO

if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMACHINE_LEARNING_MODELS_List')
	exec sp_refreshview vwMACHINE_LEARNING_MODELS_List
GO

