if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDETAILVIEWS_FIELDS_UpdateTip' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDETAILVIEWS_FIELDS_UpdateTip;
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
Create Procedure dbo.spDETAILVIEWS_FIELDS_UpdateTip
	( @MODIFIED_USER_ID            uniqueidentifier
	, @DETAIL_NAME                 nvarchar(50)
	, @FIELD_INDEX                 int
	, @TOOL_TIP                    nvarchar(150)
	)
as
  begin
	update DETAILVIEWS_FIELDS
	   set MODIFIED_USER_ID = @MODIFIED_USER_ID
	     , DATE_MODIFIED    =  getdate()        
	     , DATE_MODIFIED_UTC=  getutcdate()     
	     , TOOL_TIP         = @TOOL_TIP    
	 where DETAIL_NAME      = @DETAIL_NAME 
	   and FIELD_INDEX      = @FIELD_INDEX 
	   and DELETED          = 0            
	   and DEFAULT_VIEW     = 0            ;
  end
GO
 
Grant Execute on dbo.spDETAILVIEWS_FIELDS_UpdateTip to public;
GO
 
