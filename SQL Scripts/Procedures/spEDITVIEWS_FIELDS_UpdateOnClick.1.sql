if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spEDITVIEWS_FIELDS_UpdateOnClick' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spEDITVIEWS_FIELDS_UpdateOnClick;
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
-- 09/16/2012 Paul.  Increase ONCLICK_SCRIPT to nvarchar(max). 
Create Procedure dbo.spEDITVIEWS_FIELDS_UpdateOnClick
	( @MODIFIED_USER_ID            uniqueidentifier
	, @EDIT_NAME                   nvarchar(50)
	, @DATA_FIELD                  nvarchar(100)
	, @ONCLICK_SCRIPT              nvarchar(max)
	)
as
  begin
	update EDITVIEWS_FIELDS
	   set MODIFIED_USER_ID  = @MODIFIED_USER_ID
	     , DATE_MODIFIED     =  getdate()
	     , DATE_MODIFIED_UTC =  getutcdate()
	     , ONCLICK_SCRIPT    = @ONCLICK_SCRIPT
	 where EDIT_NAME         = @EDIT_NAME
	   and DATA_FIELD        = @DATA_FIELD
	   and DELETED           = 0            ;
  end
GO
 
Grant Execute on dbo.spEDITVIEWS_FIELDS_UpdateOnClick to public;
GO
 
