if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOW_ALERT_TEMPLATES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOW_ALERT_TEMPLATES_InsertOnly;
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
Create Procedure dbo.spWORKFLOW_ALERT_TEMPLATES_InsertOnly
	( @MODIFIED_USER_ID  uniqueidentifier
	, @NAME              nvarchar(255)
	, @BASE_MODULE       nvarchar(100)
	, @FROM_ADDR         nvarchar(100)
	, @FROM_NAME         nvarchar(100)
	, @DESCRIPTION       nvarchar(max)
	, @SUBJECT           nvarchar(255)
	, @BODY              nvarchar(max)
	, @BODY_HTML         nvarchar(max)
	)
as
  begin
	set nocount on
	
	declare @ID uniqueidentifier;
	set @ID = newid();
	exec dbo.spWORKFLOW_ALERT_TEMPLATES_Update @ID out, @MODIFIED_USER_ID, @NAME, @BASE_MODULE, @FROM_ADDR, @FROM_NAME, @DESCRIPTION, @SUBJECT, @BODY, @BODY_HTML;

  end
GO

Grant Execute on dbo.spWORKFLOW_ALERT_TEMPLATES_InsertOnly to public;
GO

