if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDOCUMENTS_QUOTES_GetLatest' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDOCUMENTS_QUOTES_GetLatest;
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
Create Procedure dbo.spDOCUMENTS_QUOTES_GetLatest
	( @MODIFIED_USER_ID uniqueidentifier
	, @QUOTE_ID         uniqueidentifier
	, @DOCUMENT_ID      uniqueidentifier
	)
as
  begin
	set nocount on

	declare @DOCUMENT_REVISION_ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @DOCUMENT_REVISION_ID = DOCUMENT_REVISION_ID
		  from DOCUMENTS
		 where ID      = @DOCUMENT_ID
		   and DELETED = 0;
	-- END Oracle Exception

	if dbo.fnIsEmptyGuid(@DOCUMENT_REVISION_ID) = 0 begin -- then
		update DOCUMENTS_QUOTES
		   set DOCUMENT_REVISION_ID = @DOCUMENT_REVISION_ID
		     , DATE_MODIFIED        = getdate()
		     , DATE_MODIFIED_UTC    = getutcdate()
		     , MODIFIED_USER_ID     = @MODIFIED_USER_ID
		 where QUOTE_ID             = @QUOTE_ID
		   and DOCUMENT_ID          = @DOCUMENT_ID
		   and DELETED              = 0;
	end -- if;
  end
GO

Grant Execute on dbo.spDOCUMENTS_QUOTES_GetLatest to public;
GO
