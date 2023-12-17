if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spUSERS_WizardUpdate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spUSERS_WizardUpdate;
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
-- 12/15/2012 Paul.  Move USER_PREFERENCES to separate fields for easier access on Surface RT. 
Create Procedure dbo.spUSERS_WizardUpdate
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @DATE_FORMAT      nvarchar(25)
	, @TIME_FORMAT      nvarchar(25)
	, @LANG             nvarchar(10)
	, @CURRENCY_ID      uniqueidentifier
	, @TIMEZONE_ID      uniqueidentifier
	)
as
  begin
	set nocount on

	update USERS
	   set DATE_FORMAT      = @DATE_FORMAT              
	     , TIME_FORMAT      = @TIME_FORMAT              
	     , LANG             = @LANG                     
	     , CURRENCY_ID      = @CURRENCY_ID              
	     , TIMEZONE_ID      = @TIMEZONE_ID              
	     , DATE_MODIFIED    = getdate()
	     , DATE_MODIFIED_UTC= getutcdate()
	     , MODIFIED_USER_ID = @MODIFIED_USER_ID
	 where ID               = @ID
	   and DELETED          = 0;
  end
GO

Grant Execute on dbo.spUSERS_WizardUpdate to public;
GO


