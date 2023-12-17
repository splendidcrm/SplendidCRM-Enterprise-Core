if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spNUMBER_SEQUENCES_Formatted' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spNUMBER_SEQUENCES_Formatted;
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
-- 08/19/2010 Paul.  We need to allow the alpha to be null. 
-- 06/21/2012 Paul.  We need to make sure that the Oracle table is locked between calls. 
-- http://bytes.com/topic/oracle/answers/65783-how-lock-row-over-select-followed-update
Create Procedure dbo.spNUMBER_SEQUENCES_Formatted
	( @NAME            nvarchar(60)
	, @SAVE_RESULT     bit
	, @CURRENT_NUMBER  nvarchar(30) output
	)
as
  begin
	set nocount on
	
	declare @ALPHA_PREFIX    nvarchar(10);
	declare @ALPHA_SUFFIX    nvarchar(10);
	declare @NUMERIC_PADDING int;
	declare @CURRENT_VALUE   int;

	select top 1
	       @ALPHA_PREFIX    = isnull(ALPHA_PREFIX, N'')
	     , @ALPHA_SUFFIX    = isnull(ALPHA_SUFFIX, N'')
	     , @NUMERIC_PADDING = NUMERIC_PADDING
	     , @CURRENT_VALUE   = CURRENT_VALUE + SEQUENCE_STEP
	  from vwNUMBER_SEQUENCES
	 where NAME             = @NAME;

	if @SAVE_RESULT = 1 begin -- then
-- #if SQL_Server /*
		update NUMBER_SEQUENCES
		   set CURRENT_VALUE = @CURRENT_VALUE
		 where NAME          = @NAME
		   and DELETED       = 0;
-- #endif SQL_Server */
	end -- if;

	set @CURRENT_NUMBER = cast(@CURRENT_VALUE as nvarchar(30));
	-- print @CURRENT_NUMBER;
	if @NUMERIC_PADDING > 0 and @NUMERIC_PADDING > len(@CURRENT_NUMBER) begin -- then
		if len(@ALPHA_PREFIX) + len(@CURRENT_NUMBER) + len(@ALPHA_SUFFIX) < 30 begin -- then
			set @CURRENT_NUMBER = replace(space(@NUMERIC_PADDING - len(@CURRENT_NUMBER)), N' ', N'0') + @CURRENT_NUMBER;
			-- print @CURRENT_NUMBER;
			if len(@ALPHA_PREFIX) + len(@CURRENT_NUMBER) + len(@ALPHA_SUFFIX) > 30 begin -- then
				set @CURRENT_NUMBER = substring(@CURRENT_NUMBER, len(@ALPHA_PREFIX) + len(@CURRENT_NUMBER) + len(@ALPHA_SUFFIX) + 1 - 30, 30);
				-- print @CURRENT_NUMBER;
			end -- if;
		end -- if;
	end -- if;
	set @CURRENT_NUMBER = @ALPHA_PREFIX + @CURRENT_NUMBER + @ALPHA_SUFFIX;
  end
GO

Grant Execute on dbo.spNUMBER_SEQUENCES_Formatted to public
GO

