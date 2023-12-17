if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSYSTEM_SYNC_LOG_Cleanup' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSYSTEM_SYNC_LOG_Cleanup;
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
Create Procedure dbo.spSYSTEM_SYNC_LOG_Cleanup
as
  begin
	set nocount on
	
	-- 03/27/2010 Paul.  We want to be selective on the entries that we delete
	-- so that we don't delete useful bug tracking or auditing information. 
	-- 04/26/2010 Paul.  Exchange can get into a loop and repeat a notification every second. 
	-- This would make our log table grow very large. 
	-- The current solution is to delete warning records after 7 days. 
	delete from SYSTEM_SYNC_LOG
	 where DATE_ENTERED < dbo.fnDateAdd('day', -7, getdate())
	   and ERROR_TYPE = N'Warning';

	-- 01/25/2015 Paul.  The SYSTEM_SYNC_LOG table is getting very big. Lets keep 3 months of data. 
	delete from SYSTEM_SYNC_LOG
	 where DATE_ENTERED < dbo.fnDateAdd('month', -3, getdate());
  end
GO

Grant Execute on dbo.spSYSTEM_SYNC_LOG_Cleanup to public;
GO

