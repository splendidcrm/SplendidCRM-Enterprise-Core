if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTEAM_NOTICES_MassUpdate' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTEAM_NOTICES_MassUpdate;
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
-- 08/27/2008 Paul.  PostgreSQL does not allow modifying input parameters.  Use a local temp variable. 
Create Procedure dbo.spTEAM_NOTICES_MassUpdate
	( @ID_LIST           varchar(8000)
	, @MODIFIED_USER_ID  uniqueidentifier
	, @DATE_START        datetime
	, @DATE_END          datetime
	)
as
  begin
	set nocount on
	
	declare @ID              uniqueidentifier;
	declare @CurrentPosR     int;
	declare @NextPosR        int;
	declare @TEMP_DATE_START datetime;
	declare @TEMP_DATE_END   datetime;

	-- 07/09/2006 Paul.  SugarCRM 4.2 only updates the date, not the time. 
	set @TEMP_DATE_START = dbo.fnDateOnly(@DATE_START);
	set @TEMP_DATE_END   = dbo.fnDateOnly(@DATE_END  );

	set @CurrentPosR = 1;
	while @CurrentPosR <= len(@ID_LIST) begin -- do
		-- 10/04/2006 Paul.  charindex should not use unicode parameters as it will limit all inputs to 4000 characters. 
		set @NextPosR = charindex(',', @ID_LIST,  @CurrentPosR);
		if @NextPosR = 0 or @NextPosR is null begin -- then
			set @NextPosR = len(@ID_LIST) + 1;
		end -- if;
		set @ID = cast(rtrim(ltrim(substring(@ID_LIST, @CurrentPosR, @NextPosR - @CurrentPosR))) as uniqueidentifier);
		set @CurrentPosR = @NextPosR+1;

		-- 07/09/2006 Paul.  SugarCRM 4.2 only updates the date, not the time. 
		-- BEGIN Oracle Exception
			update CALLS
			   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
			     , DATE_MODIFIED     =  getdate()        
			     , DATE_MODIFIED_UTC =  getutcdate()     
			     , DATE_START        = isnull(dbo.fnDateAdd_Time(DATE_START, @TEMP_DATE_START), DATE_START)
			     , DATE_END          = isnull(dbo.fnDateAdd_Time(DATE_END  , @TEMP_DATE_END  ), DATE_END  )
			 where ID                = @ID
			   and DELETED           = 0;
		-- END Oracle Exception
	end -- while;
  end
GO
 
Grant Execute on dbo.spTEAM_NOTICES_MassUpdate to public;
GO
 
 
