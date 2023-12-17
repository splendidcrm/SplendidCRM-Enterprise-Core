if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_COMPLETED_SCOPES_STATE_Update' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_COMPLETED_SCOPES_STATE_Update;
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
Create Procedure dbo.spWWF_COMPLETED_SCOPES_STATE_Update
	( @ID                   uniqueidentifier
	, @STATE                varbinary(max)
	)
as
  begin
	set nocount on

	update WWF_COMPLETED_SCOPES
	   set STATE = @STATE
	 where ID      = @ID;	
  end
GO

Grant Execute on dbo.spWWF_COMPLETED_SCOPES_STATE_Update to public;
GO



