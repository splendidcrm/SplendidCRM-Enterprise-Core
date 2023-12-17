if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSCHEDULERS_UpdateLastRun' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSCHEDULERS_UpdateLastRun;
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
-- 12/31/2007 Paul.  The LAST_RUN will likely be computed and rounded down to the 5 minute interval. 
Create Procedure dbo.spSCHEDULERS_UpdateLastRun
	( @ID                uniqueidentifier
	, @MODIFIED_USER_ID  uniqueidentifier
	, @LAST_RUN          datetime
	)
as
  begin
	set nocount on
	
	update SCHEDULERS
	   set LAST_RUN = @LAST_RUN
	 where ID      = @ID
	   and DELETED = 0;
  end
GO

Grant Execute on dbo.spSCHEDULERS_UpdateLastRun to public;
GO

