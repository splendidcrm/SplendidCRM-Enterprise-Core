if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlPrintByLine' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlPrintByLine;
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
Create Procedure dbo.spSqlPrintByLine
	( @COMMAND nvarchar(max)
	)
as
  begin
	set nocount on

	declare @CurrentPosR  int;
	declare @NextPosR     int;
	declare @CRLF         nchar(2);
	declare @Line         nvarchar(4000);

	set @CRLF = char(13) + char(10);
	set @CurrentPosR = 1;
	while @CurrentPosR <= len(@COMMAND) begin -- do
		set @NextPosR = charindex(@CRLF, @COMMAND,  @CurrentPosR);
		if @NextPosR = 0 or @NextPosR is null begin -- then
			set @NextPosR = len(@COMMAND) + 1;
		end -- if;
		set @Line = substring(@COMMAND, @CurrentPosR, @NextPosR - @CurrentPosR);
		print @Line;
		set @CurrentPosR = @NextPosR + 2;
	end -- while;
  end
GO


Grant Execute on dbo.spSqlPrintByLine to public;
GO

