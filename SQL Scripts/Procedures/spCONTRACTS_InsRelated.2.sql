if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCONTRACTS_InsRelated' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCONTRACTS_InsRelated;
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
Create Procedure dbo.spCONTRACTS_InsRelated
	( @MODIFIED_USER_ID  uniqueidentifier
	, @CONTRACT_ID       uniqueidentifier
	, @PARENT_TYPE       nvarchar(25)
	, @PARENT_ID         uniqueidentifier
	)
as
  begin
	set nocount on
	
	if dbo.fnIsEmptyGuid(@PARENT_ID) = 0 begin -- then
		if @PARENT_TYPE = N'Contacts' begin -- then
			exec dbo.spCONTRACTS_CONTACTS_Update      @MODIFIED_USER_ID, @CONTRACT_ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Documents' begin -- then
			exec dbo.spCONTRACTS_DOCUMENTS_Update     @MODIFIED_USER_ID, @CONTRACT_ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Opportunities' begin -- then
			exec dbo.spCONTRACTS_OPPORTUNITIES_Update @MODIFIED_USER_ID, @CONTRACT_ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Products' begin -- then
			exec dbo.spCONTRACTS_PRODUCTS_Update      @MODIFIED_USER_ID, @CONTRACT_ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'OrdersLineItems' begin -- then
			exec dbo.spCONTRACTS_PRODUCTS_Update      @MODIFIED_USER_ID, @CONTRACT_ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Quotes' begin -- then
			exec dbo.spCONTRACTS_QUOTES_Update        @MODIFIED_USER_ID, @CONTRACT_ID, @PARENT_ID;
		end else if @PARENT_TYPE = N'Emails' begin -- then
			exec dbo.spEMAILS_CONTRACTS_Update        @MODIFIED_USER_ID, @PARENT_ID  , @CONTRACT_ID;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spCONTRACTS_InsRelated to public;
GO

