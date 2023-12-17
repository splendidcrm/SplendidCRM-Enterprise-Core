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
-- Drop Table dbo.OPPORTUNITIES_PREDICTIONS;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'OPPORTUNITIES_PREDICTIONS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.OPPORTUNITIES_PREDICTIONS';
	Create Table dbo.OPPORTUNITIES_PREDICTIONS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_OPPORTUNITIES_PREDICTIONS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, OPPORTUNITY_ID                     uniqueidentifier not null
		, MACHINE_LEARNING_MODEL_ID          uniqueidentifier not null
		, PROBABILITY                        float null
		, SCORE                              float null
		, PREDICTED_LABEL                    bit null
		, PREDICTION                         nvarchar(50) null
		)

	create index IDX_OPPORTUNITIES_PREDICTIONS_OPPORTUNITY_ID on dbo.OPPORTUNITIES_PREDICTIONS (OPPORTUNITY_ID, DELETED) include (PROBABILITY, SCORE, PREDICTION)
  end
GO


