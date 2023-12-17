if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spWWF_TRACKING_PROFILES_InsertOnly' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spWWF_TRACKING_PROFILES_InsertOnly;
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
Create Procedure dbo.spWWF_TRACKING_PROFILES_InsertOnly
	( @ID                             uniqueidentifier output
	, @MODIFIED_USER_ID               uniqueidentifier
	, @TYPE_FULL_NAME                 nvarchar(128)
	, @ASSEMBLY_FULL_NAME             nvarchar(256)
	)
as
  begin
	set nocount on

	if not exists(select * from vwWWF_TRACKING_PROFILES where TYPE_FULL_NAME = @TYPE_FULL_NAME and ASSEMBLY_FULL_NAME = @ASSEMBLY_FULL_NAME) begin -- then
		exec dbo.spWWF_TRACKING_PROFILES_InsertDefault @ID out, @MODIFIED_USER_ID, @TYPE_FULL_NAME, @ASSEMBLY_FULL_NAME;
	end -- if;
  end
GO
 
Grant Execute on dbo.spWWF_TRACKING_PROFILES_InsertOnly to public;
GO

