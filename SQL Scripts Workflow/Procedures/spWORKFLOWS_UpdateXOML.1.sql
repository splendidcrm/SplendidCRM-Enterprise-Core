if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWORKFLOWS_UpdateXOML' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWORKFLOWS_UpdateXOML;
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
Create Procedure dbo.spWORKFLOWS_UpdateXOML
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @CUSTOM_XOML       bit
	, @XOML              nvarchar(max)
	)
as
  begin
	set nocount on
	
	if exists(select * from WORKFLOW where ID = @ID) begin -- then
		update WORKFLOW
		   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
		     , DATE_MODIFIED     =  getdate()       
		     , DATE_MODIFIED_UTC =  getutcdate()    
		     , CUSTOM_XOML       = @CUSTOM_XOML      
		     , XOML              = @XOML             
		 where ID                = @ID               ;
	end -- if;
  end
GO

Grant Execute on dbo.spWORKFLOWS_UpdateXOML to public;
GO

