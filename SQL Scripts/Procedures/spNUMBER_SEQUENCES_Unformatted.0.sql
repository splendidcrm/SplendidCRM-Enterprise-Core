if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spNUMBER_SEQUENCES_Unformatted' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spNUMBER_SEQUENCES_Unformatted;
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
Create Procedure dbo.spNUMBER_SEQUENCES_Unformatted
	( @NAME            nvarchar(60)
	, @SAVE_RESULT     bit
	, @CURRENT_VALUE   int output
	)
as
  begin
	set nocount on
	
	declare @NUMERIC_PADDING int;

	select top 1
	       @NUMERIC_PADDING = NUMERIC_PADDING
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
  end
GO

Grant Execute on dbo.spNUMBER_SEQUENCES_Unformatted to public
GO

