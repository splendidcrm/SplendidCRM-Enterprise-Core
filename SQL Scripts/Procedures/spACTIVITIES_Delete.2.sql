if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spACTIVITIES_Delete' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spACTIVITIES_Delete;
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
Create Procedure dbo.spACTIVITIES_Delete
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ACTIVITY_TYPE nvarchar(25);
	select @ACTIVITY_TYPE = ACTIVITY_TYPE
	  from vwACTIVITIES
	 where ID = @ID;

	if @ACTIVITY_TYPE = N'Tasks' begin -- then
		exec dbo.spTASKS_Delete @ID, @MODIFIED_USER_ID;
	end else if @ACTIVITY_TYPE = N'Meetings' begin -- then
		exec dbo.spMEETINGS_Delete @ID, @MODIFIED_USER_ID;
	end else if @ACTIVITY_TYPE = N'Calls' begin -- then
		exec dbo.spCALLS_Delete @ID, @MODIFIED_USER_ID;
	end else if @ACTIVITY_TYPE = N'Emails' begin -- then
		exec dbo.spEMAILS_Delete @ID, @MODIFIED_USER_ID;
	end else if @ACTIVITY_TYPE = N'Notes' begin -- then
		exec dbo.spNOTES_Delete @ID, @MODIFIED_USER_ID;
	end else begin
		-- 03/29/2006 Paul.  SQL Server 2005 Express error.
		-- Cannot specify uniqueidentifier data type (parameter 4) as a substitution parameter.
		raiserror(N'Could not find activity', 16, 1);
	end -- if;
  end
GO

Grant Execute on dbo.spACTIVITIES_Delete to public;
GO

