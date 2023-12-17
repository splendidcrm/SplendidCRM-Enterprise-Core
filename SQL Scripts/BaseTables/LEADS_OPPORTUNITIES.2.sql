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
-- 08/08/2015 Paul.  Separate relationship for Leads/Opportunities. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'LEADS_OPPORTUNITIES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.LEADS_OPPORTUNITIES';
	Create Table dbo.LEADS_OPPORTUNITIES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_LEADS_OPPORTUNITIES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, OPPORTUNITY_ID                     uniqueidentifier not null
		, LEAD_ID                            uniqueidentifier not null
		)

	create index IDX_LEADS_OPP_LEAD_ID        on dbo.LEADS_OPPORTUNITIES (LEAD_ID       , DELETED, OPPORTUNITY_ID)
	create index IDX_LEADS_OPP_OPPORTUNITY_ID on dbo.LEADS_OPPORTUNITIES (OPPORTUNITY_ID, DELETED, LEAD_ID       )

	alter table dbo.LEADS_OPPORTUNITIES add constraint FK_LEADS_OPP_LEAD_ID        foreign key ( LEAD_ID        ) references dbo.LEADS         ( ID )
	alter table dbo.LEADS_OPPORTUNITIES add constraint FK_LEADS_OPP_OPPORTUNITY_ID foreign key ( OPPORTUNITY_ID ) references dbo.OPPORTUNITIES ( ID )
  end
GO


