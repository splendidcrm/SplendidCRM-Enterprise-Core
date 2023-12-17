if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spUSERS_TEAM_MEMBERSHIPS_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spUSERS_TEAM_MEMBERSHIPS_Delete;
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
-- 05/28/2020 Paul.  Wrapper to simplify support for React Client. 
Create Procedure dbo.spUSERS_TEAM_MEMBERSHIPS_Delete
	( @MODIFIED_USER_ID  uniqueidentifier
	, @USER_ID           uniqueidentifier
	, @TEAM_ID           uniqueidentifier
	)
as
  begin
	set nocount on
	
	exec dbo.spTEAM_MEMBERSHIPS_Delete @MODIFIED_USER_ID, @TEAM_ID, @USER_ID;
  end
GO
 
Grant Execute on dbo.spUSERS_TEAM_MEMBERSHIPS_Delete to public;
GO
 
 
