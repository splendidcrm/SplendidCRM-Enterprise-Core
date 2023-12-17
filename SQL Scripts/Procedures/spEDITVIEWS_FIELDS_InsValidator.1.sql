if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEDITVIEWS_FIELDS_InsValidator' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEDITVIEWS_FIELDS_InsValidator;
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
-- 02/21/2017 Paul.  Allow a field to be added to the end using an index of -1. 
-- 03/19/2020 Paul.  The FIELD_INDEX is not needed, so remove from update statement. 
Create Procedure dbo.spEDITVIEWS_FIELDS_InsValidator
	( @EDIT_NAME                   nvarchar(50)
	, @FIELD_INDEX                 int
	, @FIELD_VALIDATOR_NAME        nvarchar(50)
	, @DATA_FIELD                  nvarchar(100)
	, @FIELD_VALIDATOR_MESSAGE     nvarchar(150)
	)
as
  begin
	set nocount on
	
	declare @FIELD_VALIDATOR_ID uniqueidentifier;
	-- BEGIN Oracle Exception
		select @FIELD_VALIDATOR_ID = ID
		  from FIELD_VALIDATORS
		 where NAME    = @FIELD_VALIDATOR_NAME
		   and DELETED = 0;
	-- END Oracle Exception
	
	if dbo.fnIsEmptyGuid(@FIELD_VALIDATOR_ID) = 1 begin -- then
		raiserror(N'spEDITVIEWS_FIELDS_InsValidator: Could not find validator %s.', 16, 1, @FIELD_VALIDATOR_NAME);
	end else begin
		update EDITVIEWS_FIELDS
		   set DATE_MODIFIED               =  getdate()        
		     , DATE_MODIFIED_UTC           =  getutcdate()     
		     , FIELD_VALIDATOR_ID          = @FIELD_VALIDATOR_ID
		     , FIELD_VALIDATOR_MESSAGE     = @FIELD_VALIDATOR_MESSAGE
		 where EDIT_NAME                   = @EDIT_NAME
		   and DATA_FIELD                  = @DATA_FIELD
		   and DELETED                     = 0
		   and DEFAULT_VIEW                = 0
		   and FIELD_VALIDATOR_ID is null;
	end -- if;
  end
GO

Grant Execute on dbo.spEDITVIEWS_FIELDS_InsValidator to public;
GO

