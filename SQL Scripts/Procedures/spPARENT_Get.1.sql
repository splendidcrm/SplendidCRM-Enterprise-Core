if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spPARENT_Get' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spPARENT_Get;
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
-- 12/01/2011 Paul.  Add ordering by PARENT_TYPE so that Contacts get selected before Users. 
-- This is an issue when dealing with portal users where the Contact ID matches the User ID. 
Create Procedure dbo.spPARENT_Get
	( @ID                uniqueidentifier output
	, @MODULE            nvarchar( 25) output
	, @PARENT_TYPE       nvarchar( 25) output
	, @PARENT_NAME       nvarchar(150) output
	)
as
  begin
	set nocount on
	
	declare @PARENT_ID uniqueidentifier;
	select top 1 @PARENT_ID   = PARENT_ID
	     , @MODULE      = MODULE
	     , @PARENT_TYPE = PARENT_TYPE
	     , @PARENT_NAME = PARENT_NAME
	  from vwPARENTS
	 where PARENT_ID    = @ID
	 order by PARENT_TYPE;

	-- Return NULL if not found. 
	set @ID = @PARENT_ID;
  end
GO

Grant Execute on dbo.spPARENT_Get to public;
GO

