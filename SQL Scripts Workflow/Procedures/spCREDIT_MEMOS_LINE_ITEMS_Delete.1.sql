if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spCREDIT_MEMOS_LINE_ITEMS_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spCREDIT_MEMOS_LINE_ITEMS_Delete;
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
Create Procedure dbo.spCREDIT_MEMOS_LINE_ITEMS_Delete
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	-- 02/24/2015 Paul.  The CreditMemo is like a Payment, but uses Invoice line items. 
	-- We will not be matching line items to memos. 
	return;
  end
GO

Grant Execute on dbo.spCREDIT_MEMOS_LINE_ITEMS_Delete to public;
GO


