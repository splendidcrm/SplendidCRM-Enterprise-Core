if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDETAILVIEWS_FIELDS_UpdateUrl' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDETAILVIEWS_FIELDS_UpdateUrl;
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
-- 08/18/2010 Paul.  Fix problem with updating URL fields. 
-- 10/30/2013 Paul.  Increase size of URL_TARGET. 
-- 02/25/2015 Paul.  Increase size of DATA_FIELD and DATA_FORMAT for OfficeAddin. 
Create Procedure dbo.spDETAILVIEWS_FIELDS_UpdateUrl
	( @MODIFIED_USER_ID            uniqueidentifier
	, @DETAIL_NAME                 nvarchar(50)
	, @DATA_FIELD                  nvarchar(1000)
	, @URL_FIELD                   nvarchar(max)
	, @URL_FORMAT                  nvarchar(max)
	, @URL_TARGET                  nvarchar( 60)
	)
as
  begin
	update DETAILVIEWS_FIELDS
	   set MODIFIED_USER_ID  = @MODIFIED_USER_ID
	     , DATE_MODIFIED     =  getdate()   
	     , DATE_MODIFIED_UTC =  getutcdate()
	     , URL_FIELD         = @URL_FIELD   
	     , URL_FORMAT        = @URL_FORMAT  
	     , URL_TARGET        = @URL_TARGET  
	 where DETAIL_NAME       = @DETAIL_NAME 
	   and DATA_FIELD        = @DATA_FIELD  
	   and DELETED           = 0            
	   and DEFAULT_VIEW      = 0            ;
  end
GO
 
Grant Execute on dbo.spDETAILVIEWS_FIELDS_UpdateUrl to public;
GO
 
