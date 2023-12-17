if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCREDIT_MEMOS_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCREDIT_MEMOS_Update;
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
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create Procedure dbo.spCREDIT_MEMOS_Update
	( @ID                           uniqueidentifier output
	, @MODIFIED_USER_ID             uniqueidentifier
	, @ASSIGNED_USER_ID             uniqueidentifier
	, @ACCOUNT_ID                   uniqueidentifier
	, @PAYMENT_DATE                 datetime
	, @PAYMENT_TYPE                 nvarchar(25)
	, @CUSTOMER_REFERENCE           nvarchar(50)
	, @EXCHANGE_RATE                float
	, @CURRENCY_ID                  uniqueidentifier
	, @AMOUNT                       money
	, @DESCRIPTION                  nvarchar(max)
	, @CREDIT_CARD_ID               uniqueidentifier = null
	, @PAYMENT_NUM                  nvarchar(30) = null
	, @TEAM_ID                      uniqueidentifier = null
	, @TEAM_SET_LIST                varchar(8000) = null
	, @BANK_FEE                     money = null
	, @B2C_CONTACT_ID               uniqueidentifier = null
	, @ASSIGNED_SET_LIST            varchar(8000) = null
	)
as
  begin
	set nocount on
	
	exec dbo.spPAYMENTS_Update @ID out
		, @MODIFIED_USER_ID
		, @ASSIGNED_USER_ID
		, @ACCOUNT_ID
		, @PAYMENT_DATE
		, @PAYMENT_TYPE
		, @CUSTOMER_REFERENCE
		, @EXCHANGE_RATE
		, @CURRENCY_ID
		, @AMOUNT
		, @DESCRIPTION
		, @CREDIT_CARD_ID
		, @PAYMENT_NUM
		, @TEAM_ID
		, @TEAM_SET_LIST
		, @BANK_FEE
		, @B2C_CONTACT_ID
		, @ASSIGNED_SET_LIST
		;
  end
GO
 
Grant Execute on dbo.spCREDIT_MEMOS_Update to public;
GO
 
